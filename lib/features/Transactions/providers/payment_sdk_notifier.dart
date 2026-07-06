
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

/// Explicit status flags tracking the native platform checkout flow
enum PaymentSDKStatus { initial, processingSDK, paymentSuccess, paymentFailed, dbSyncing, completed }

class PaymentSDKState {
  final PaymentSDKStatus status;
  final String? transactionId;
  final String? errorMessage;

  PaymentSDKState({required this.status, this.transactionId, this.errorMessage});

  PaymentSDKState copyWith({PaymentSDKStatus? status, String? transactionId, String? errorMessage}) {
    return PaymentSDKState(
      status: status ?? this.status,
      transactionId: transactionId ?? this.transactionId,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

class PaymentSDKNotifier extends StateNotifier<PaymentSDKState> {
  late final Razorpay _razorpay;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Cache variables to persist context data during native SDK transitions
  Map<String, dynamic> _pendingTxData = {};

  PaymentSDKNotifier() : super(PaymentSDKState(status: PaymentSDKStatus.initial)) {
    _initSDKListeners();
  }

  /// Initialize secure hardware listener channels bound to native event emitters
  void _initSDKListeners() {
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handleNativePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handleNativePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWalletFallback);
  }

  /// Entry point to trigger the native payment sheet overlay frame securely
  Future<void> launchSecureCheckoutSession({
    required String recipientName,
    required String upiId,
    required double numericAmount,
  }) async {
    state = PaymentSDKState(status: PaymentSDKStatus.processingSDK);

    final User? user = _auth.currentUser;
    if (user == null) {
      state = PaymentSDKState(status: PaymentSDKStatus.paymentFailed, errorMessage: "User session expired.");
      return;
    }

    // Cache parameters locally to write them to your database after verification
    _pendingTxData = {
      'senderId': user.uid,
      'receiverName': recipientName,
      'receiverPhone': upiId.split('@')[0],
      'combinedRoomId': [user.uid, upiId.split('@')[0]],
      'amount': numericAmount,
      'type': 'sent',
    };

    // Construct the standard payment configuration object
    var options = {
      'key': dotenv.env['RAZORPAY_KEY_ID'], 
      'amount': (numericAmount * 100).toInt(), 
      'name': 'Payment App Inc.',
      'description': 'Secure Transfer to $recipientName',
      'timeout': 300, // Session time limit in seconds
      'prefill': {
        'contact': user.phoneNumber ?? '',
        'email': user.email ?? 'user@paymentapp.com',
      },
      'external': {
        'wallets': ['paytm'] // Support third-party app bindings natively
      }
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      state = PaymentSDKState(status: PaymentSDKStatus.paymentFailed, errorMessage: "SDK Initialization fault.");
    }
  }

  /// Event handler triggered automatically on successful signature generation
  void _handleNativePaymentSuccess(PaymentSuccessResponse response) async {
    state = state.copyWith(status: PaymentSDKStatus.dbSyncing);

    try {
      final txRef = _firestore.collection('transactions').doc();
      
      // Merge cached transaction data with official, verified gateway token signatures
      final finalPayload = {
        ..._pendingTxData,
        'transactionId': txRef.id,
        'gatewayPaymentId': response.paymentId,
        'gatewaySignature': response.signature,
        'gatewayOrderId': response.orderId,
        'timestamp': FieldValue.serverTimestamp(),
      };

      await txRef.set(finalPayload);
      
      state = PaymentSDKState(
        status: PaymentSDKStatus.completed,
        transactionId: txRef.id,
      );
    } catch (e) {
      state = PaymentSDKState(status: PaymentSDKStatus.paymentFailed, errorMessage: "Database failed to log verified receipt.");
    }
  }

  void _handleNativePaymentError(PaymentFailureResponse response) {
    state = PaymentSDKState(
      status: PaymentSDKStatus.paymentFailed,
      errorMessage: response.message ?? "Transaction aborted by user.",
    );
  }

  void _handleExternalWalletFallback(ExternalWalletResponse response) {
    state = PaymentSDKState(
      status: PaymentSDKStatus.paymentFailed,
      errorMessage: "External checkout via ${response.walletName} suspended.",
    );
  }

  @override
  void dispose() {
    _razorpay.clear(); // Safely clear out event listener bridges to avoid memory leaks
    super.dispose();
  }
}

// ➔ GLOBAL EXPOSED RECTIVE STATE INTERFACE PROVIDER
final paymentSDKProvider = StateNotifierProvider<PaymentSDKNotifier, PaymentSDKState>((ref) {
  return PaymentSDKNotifier();
});