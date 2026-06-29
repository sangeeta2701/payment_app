import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

// Automatically streams linked banks from the user's main dynamic profile document
final activeUserBankProvider = StreamProvider<Map<String, dynamic>?>((ref) {
  final User? currentUser = FirebaseAuth.instance.currentUser;
  if (currentUser == null) return Stream.value(null);

  return FirebaseFirestore.instance
      .collection('users')
      .doc(currentUser.uid)
      .snapshots()
      .map((snapshot) {
        if (snapshot.exists && snapshot.data() != null) {
          final data = snapshot.data()!;
          if (data.containsKey('activeBankName')) {
            return {
              'bankName': data['activeBankName'],
              'maskedAccount': data['activeMaskedAccount'],
            };
          }
        }
        return null;
      });
});