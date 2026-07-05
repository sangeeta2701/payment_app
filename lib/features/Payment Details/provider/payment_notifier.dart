import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

final chatHistoryStreamProvider = StreamProvider.autoDispose.family<List<Map<String, dynamic>>, String>((ref, targetPhone) {
  final User? user = FirebaseAuth.instance.currentUser;
  if (user == null) return Stream.value([]);

  // and then client-side filter for my identity, or vice versa, to guarantee a locked structural index scope.
  return FirebaseFirestore.instance
      .collection('transactions')
      .where('combinedRoomId', arrayContains: targetPhone) 
      .orderBy('timestamp', descending: true) 
      .snapshots()
      .map((snapshot) {
        return snapshot.docs
            .map((doc) => doc.data())
            .where((data) {
              final List<dynamic> roomIds = data['combinedRoomId'] ?? [];
              return roomIds.contains(user.uid);
            })
            .toList();
      });
});

// Class managing mutations and input processing remains clean and operational
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
      'type': transactionType, 
      'timestamp': FieldValue.serverTimestamp(),
    });
  }
}