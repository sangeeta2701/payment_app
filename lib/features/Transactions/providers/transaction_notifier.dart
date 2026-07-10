import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/legacy.dart';

enum WalletTransactionStatus { initial, loading, success, failure }

class WalletTransactionState {
  final WalletTransactionStatus status;
  final String? transactionId;
  final String? errorMessage;

  WalletTransactionState({
    required this.status,
    this.transactionId,
    this.errorMessage,
  });
}

class TransactionNotifier extends StateNotifier<WalletTransactionState> {
  TransactionNotifier() : super(WalletTransactionState(status: WalletTransactionStatus.initial));

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// Validates user credentials natively and logs transaction blocks instantly
  Future<bool> processDirectWalletPayment({
    required String receiverName,
    required double amount,
    required String upiId,
    required String enteredPin,
  }) async {
    state = WalletTransactionState(status: WalletTransactionStatus.loading);

    try {
      final User? currentUser = _auth.currentUser;
      
      // Development Fallback: If you are testing locally without Auth, uncomment the line below and comment the auth check:
      // final String senderUid = currentUser?.uid ?? "mock_developer_user_uid";
      
      if (currentUser == null) {
        state = WalletTransactionState(status: WalletTransactionStatus.failure, errorMessage: "Session Expired. Please log in again.");
        return false;
      }
      final String senderUid = currentUser.uid;

      // 1. Fetch Sender Data Profiles
      final userSnapshot = await _firestore.collection('users').doc(senderUid).get();
      if (!userSnapshot.exists) {
        state = WalletTransactionState(status: WalletTransactionStatus.failure, errorMessage: "User Profile Missing.");
        return false;
      }
      
      final userData = userSnapshot.data() ?? {};
      
      // 2. Validate UPI PIN Securely (Falls back to 123456 if none is set in DB)
      final String savedPin = userData['upiPin'] ?? "123456"; 
      if (enteredPin != savedPin) {
        state = WalletTransactionState(status: WalletTransactionStatus.failure, errorMessage: "Incorrect UPI PIN entered. Please try again.");
        return false;
      }

      String senderName = userData['displayName'] ?? userData['phoneNumber'] ?? "Self";
      final String bankName = userData['activeBankName'] ?? "State Bank Of India";
      final String receiverPhone = upiId.split('@')[0];

      // 3. Atomically Write Transaction Records & Update Balances Using a Batch
      final txRef = _firestore.collection('transactions').doc();
      final batch = _firestore.batch();

      // Create the transaction receipt
      final txData = {
        'transactionId': txRef.id,
        'senderId': senderUid,
        'senderName': senderName, 
        'bankName': bankName,
        'receiverName': receiverName,
        'receiverPhone': receiverPhone,
        'combinedRoomId': [senderUid, receiverPhone],
        'amount': amount,
        'type': 'sent',
        'status': 'SUCCESS',
        'timestamp': FieldValue.serverTimestamp(),
      };
      batch.set(txRef, txData);

      // Deduct amount from sender's wallet
      final senderRef = _firestore.collection('users').doc(senderUid);
      batch.set(senderRef, {
        'walletBalance': FieldValue.increment(-amount)
      }, SetOptions(merge: true));

      // Add amount to receiver's wallet (if they exist in the DB by phone number)
      final receiverQuery = await _firestore
          .collection('users')
          .where('phoneNumber', isEqualTo: receiverPhone)
          .limit(1)
          .get();

      if (receiverQuery.docs.isNotEmpty) {
        final receiverRef = receiverQuery.docs.first.reference;
        batch.set(receiverRef, {
          'walletBalance': FieldValue.increment(amount)
        }, SetOptions(merge: true));
      }

      // Commit the batch so everything happens exactly at the same time
      await batch.commit();

      state = WalletTransactionState(status: WalletTransactionStatus.success, transactionId: txRef.id);
      return true;

    } catch (e) {
      state = WalletTransactionState(status: WalletTransactionStatus.failure, errorMessage: "Network lookup failure. Try again.");
      return false;
    }
  }

  void resetState() {
    state = WalletTransactionState(status: WalletTransactionStatus.initial);
  }
}

// Global Provider Registration
final transactionProvider = StateNotifierProvider<TransactionNotifier, WalletTransactionState>((ref) {
  return TransactionNotifier();
});