import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/legacy.dart';

class TransactionNotifier extends StateNotifier<AsyncValue<String?>> {
  TransactionNotifier() : super(const AsyncValue.data(null));

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Inside your transaction_notifier.dart file:

Future<String?> executePayment({
  required String receiverName,
  required double amount,
  required String upiId,
}) async {
  state = const AsyncValue.loading();
  try {
    final User? currentUser = _auth.currentUser;
    if (currentUser == null) throw Exception("User session missing.");

    final userSnapshot = await _firestore.collection('users').doc(currentUser.uid).get();
    final userData = userSnapshot.data() ?? {};
    
    String senderName = userData['displayName'] ?? "";
    if (senderName.trim().isEmpty) {
      senderName = userData['phoneNumber'] ?? "Self"; 
    }

    final String bankName = userData['activeBankName'] ?? "State Bank Of India";

    final txRef = _firestore.collection('transactions').doc();
    final txData = {
      'transactionId': txRef.id,
      'senderId': currentUser.uid,
      'senderName': senderName, 
      'bankName': bankName,
      'receiverName': receiverName,
      'receiverPhone': upiId.split('@')[0],
      'combinedRoomId': [currentUser.uid, upiId.split('@')[0]],
      'amount': amount,
      'type': 'sent',
      'timestamp': FieldValue.serverTimestamp(),
    };

    await txRef.set(txData);
    state = AsyncValue.data(txRef.id);
    return txRef.id;
  } catch (e, stack) {
    state = AsyncValue.error(e, stack);
    return null;
  }
}
}

final transactionProvider = StateNotifierProvider<TransactionNotifier, AsyncValue<String?>>((ref) {
  return TransactionNotifier();
});