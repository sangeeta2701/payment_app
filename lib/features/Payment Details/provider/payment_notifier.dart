import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

final chatHistoryStreamProvider = StreamProvider.autoDispose.family<List<Map<String, dynamic>>, String>((ref, targetPhone) {
  final User? user = FirebaseAuth.instance.currentUser;
  if (user == null) return Stream.value([]);

  return FirebaseFirestore.instance
      .collection('transactions')
      .where('combinedRoomId', arrayContains: user.uid) 
      .snapshots()
      .map((snapshot) {
        return snapshot.docs
            .map((doc) => doc.data())
            .where((data) => data['receiverPhone'] == targetPhone || data['senderId'] == targetPhone)
            .toList();
      });
});

// Class managing mutations and input processing
class PaymentService {
  static Future<void> executeSecureTransaction({
    required String targetPhone,
    required double paymentAmount,
    required String transactionType,
  }) async {
    final User? user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    await FirebaseFirestore.instance.collection('transactions').add({
      'senderId': user.uid,
      'receiverPhone': targetPhone,
      'combinedRoomId': [user.uid, targetPhone],
      'amount': paymentAmount,
      'type': transactionType, // 'sent' or 'received'
      'timestamp': FieldValue.serverTimestamp(),
    });
  }
}