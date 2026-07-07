import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:payment_app/features/Add%20Bank/models/bankModel.dart';

// Create a structural type signature mapping to list collections
typedef AccountList = List<Map<String, dynamic>>;

class BankNotifier extends StateNotifier<AsyncValue<AccountList>> {
  BankNotifier() : super(const AsyncValue.data([]));

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;


  Future<void> findLinkedBankAccounts(BankModel selectedBank) async {
  state = const AsyncValue.loading();

  try {
    final User? currentUser = _auth.currentUser;
    
    // ➔ DEBUG POINT 1: Inspect the raw Firebase user object status
    debugPrint("=== [DEBUG] BANK LINKING FLOW STARTED ===");
    debugPrint("Firebase Current User exists: ${currentUser != null}");
    if (currentUser != null) {
      debugPrint("********8Firebase Auth uid: ${currentUser.uid}");
      debugPrint("****************Firebase Auth phoneNumber: '${currentUser.phoneNumber}'");
    }

    // Fallback for development if the user object lacks a verified phone property
    final String formattedUserPhone = currentUser?.phoneNumber ?? "+916266520680"; 
    debugPrint("****************Phone number used for Firestore lookup query: '$formattedUserPhone'");
    debugPrint("****************Bank selected ID: '${selectedBank.id}' | Name: '${selectedBank.name}'");

    // ➔ DEBUG POINT 2: Fetch and evaluate query snapshots
    debugPrint("Executing Firestore collection query on 'mock_central_bank_registry'...");
    final querySnapshot = await _firestore
        .collection('mock_central_bank_registry')
        .where('phoneNumber', isEqualTo: formattedUserPhone)
        .where('bankId', isEqualTo: selectedBank.id)
        .get();

    debugPrint("****************Firestore query completed execution.");
    debugPrint("****************Total matching documents discovered in Cloud DB: ${querySnapshot.docs.length}");

    // If no document matches, let's print a sample to see what the database actually looks like
    if (querySnapshot.docs.isEmpty) {
      debugPrint("****************--- [WARNING] No exact match found. Printing first 2 docs from collection for structural cross-check ---");
      final sampleDocs = await _firestore.collection('mock_central_bank_registry').limit(2).get();
      for (var doc in sampleDocs.docs) {
        debugPrint("Sample Doc ID [${doc.id}] Data fields: ${doc.data()}");
      }
      debugPrint("--------------------------------------------------------------------------------------------------");
    }

    final AccountList accounts = querySnapshot.docs.map((doc) {
      final data = doc.data();
      debugPrint("Successfully parsed document matching target data profile: $data");
      return data;
    }).toList();
    
    state = AsyncValue.data(accounts);
    debugPrint("=== [DEBUG] BANK LINKING FLOW FINISHED SUCCESSFULLY ===");
  } catch (e, stack) {
    debugPrint("=== [CRITICAL ERROR] FLOW CAUGHT EXCEPTION ===");
    debugPrint("****************Exception Message: ${e.toString()}");
    debugPrint("****************Stack Trace: $stack");
    state = AsyncValue.error("Network lookup failure: ${e.toString()}", stack);
  }
}

  /// Sets the chosen bank profile as the active transactional payment protocol
  Future<bool> activateBankAccount(Map<String, dynamic> accountData) async {
    try {
      final User? currentUser = _auth.currentUser;
      if (currentUser == null) return false;

      // Update user base tracking settings
      await _firestore.collection('users').doc(currentUser.uid).update({
        'activeBankName': accountData['bankName'],
        'activeMaskedAccount': accountData['maskedAccountNo'],
        'bankLinkedAt': FieldValue.serverTimestamp(),
      });

      return true;
    } catch (e) {
      return false;
    }
  }

  void resetStatus() {
    state = const AsyncValue.data([]);
  }
}

// ➔ GLOBAL EXPOSED RIVERPOD STATE PROVIDER REF
final bankProvider =
    StateNotifierProvider<BankNotifier, AsyncValue<AccountList>>((ref) {
      return BankNotifier();
    });

final userAccountStatusStreamProvider = StreamProvider.autoDispose<bool>((ref) {
  final user = FirebaseAuth.instance.currentUser;
  if (user == null) return Stream.value(false);

  return FirebaseFirestore.instance
      .collection('users')
      .doc(user.uid)
      .snapshots()
      .map((snapshot) {
        if (!snapshot.exists) return false;
        final data = snapshot.data() ?? {};
        // Returns true if a bank account has been successfully linked
        return data.containsKey('activeBankName') &&
            data['activeBankName'] != null;
      });
});
