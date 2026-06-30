import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

// Live stream provider that watches the user's document for linked banks
final activeUserBankProvider = StreamProvider<Map<String, dynamic>?>((ref) {
  final User? currentUser = FirebaseAuth.instance.currentUser;
  
  // If the user session isn't initialized yet, return an empty stream safe state
  if (currentUser == null) return Stream.value(null);

  return FirebaseFirestore.instance
      .collection('users')
      .doc(currentUser.uid)
      .snapshots()
      .map((snapshot) {
        if (snapshot.exists && snapshot.data() != null) {
          final data = snapshot.data()!;
          
          // Check Variation A: Looking for explicitly selected active profile parameters
          if (data.containsKey('activeBankName')) {
            return {
              'bankName': data['activeBankName'],
              'maskedAccount': data['activeMaskedAccount'],
            };
          } 
          // Check Variation B: Fallback check matching default first-tier linked items
          else if (data.containsKey('bankName')) {
            return {
              'bankName': data['bankName'],
              'maskedAccount': data['maskedAccountNo'] ?? 'XXXX XXXX 0000',
            };
          }
        }
        // Returns null to trigger the _buildEmptyState UI if no keys are found
        return null;
      });
});