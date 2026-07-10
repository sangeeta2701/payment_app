import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

// Mapped configuration structure tracking user transaction histories
final chatHistoryStreamProvider = StreamProvider.autoDispose.family<List<Map<String, dynamic>>, String>((ref, targetPhoneOrUpi) {
  final User? user = FirebaseAuth.instance.currentUser;
  if (user == null) return Stream.value([]);

  // Strip country codes or domain structures to extract the raw text identifier
  final cleanTarget = targetPhoneOrUpi.replaceAll("+91", "").split('@')[0].trim();

  return FirebaseFirestore.instance
      .collection('transactions')
      .orderBy('timestamp', descending: true) 
      .snapshots()
      .map((snapshot) {
        return snapshot.docs
            .map((doc) => doc.data())
            .where((data) {
              final String senderId = data['senderId'] ?? "";
              final String receiverPhone = (data['receiverPhone'] ?? "").toString().trim();
              
              // Verify if CURRENT user is part of the transaction
              final bool isIUser = (senderId == user.uid || receiverPhone == user.uid);
              
              // Verify if TARGET user/identifier matches this chat room window context
              final bool isTargetUser = (receiverPhone == cleanTarget || 
                                        senderId == cleanTarget || 
                                        (data['combinedRoomId'] as List? ?? []).contains(cleanTarget));

              return isIUser || isTargetUser;
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