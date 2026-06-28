import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

// Live stream listening directly to data updates 
final chatHistoryStreamProvider = StreamProvider.family<List<Map<String, dynamic>>, String>((ref, targetPhone) {
  final User? user = FirebaseAuth.instance.currentUser;
  if (user == null) return Stream.value([]);

  final String myUid = user.uid;
  
  // Querying records where current user is either sender or receiver
  return FirebaseFirestore.instance
      .collection('transactions')
      .where('combinedRoomId', arrayContains: targetPhone) // Or structure via dedicated chat room ids
      .orderBy('timestamp', descending: true)
      .snapshots()
      .map((snapshot) => snapshot.docs.map((doc) => doc.data()).toList());
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