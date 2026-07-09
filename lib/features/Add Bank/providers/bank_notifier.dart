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

    // Hard stop — no fake fallbacks
    if (currentUser == null) {
      state = AsyncValue.error(
        "Session expired. Please log in again.",
        StackTrace.current,
      );
      return;
    }

    final String formattedUserPhone = currentUser.phoneNumber ?? "";

    if (formattedUserPhone.isEmpty) {
      state = AsyncValue.error(
        "Phone number not found on your account.",
        StackTrace.current,
      );
      return;
    }

    debugPrint("****************UID: ${currentUser.uid}");
    debugPrint("****************Phone: $formattedUserPhone");
    debugPrint("****************BankId: ${selectedBank.id}");

    final querySnapshot = await _firestore
        .collection('mock_central_bank_registry')
        .where('phoneNumber', isEqualTo: formattedUserPhone)
        .where('bankId', isEqualTo: selectedBank.id)
        .get();

    debugPrint("****************Docs found: ${querySnapshot.docs.length}");

    final AccountList accounts = querySnapshot.docs.map((doc) {
      debugPrint("****************Doc data: ${doc.data()}");
      return doc.data();
    }).toList();

    state = AsyncValue.data(accounts);

  } catch (e, stack) {
    debugPrint("****************Exception: $e");
    state = AsyncValue.error("Lookup failed: ${e.toString()}", stack);
  }
}

Future<bool> activateBankAccount(Map<String, dynamic> accountData) async {
  try {
    final User? currentUser = _auth.currentUser;

    // Hard stop — no fake fallbacks
    if (currentUser == null) {
      debugPrint("****************[ERROR] currentUser is null. User not authenticated.");
      return false;
    }

    final String uid = currentUser.uid;
    debugPrint("****************[DB] Writing to users/$uid");

    await _firestore.collection('users').doc(uid).set({
      'activeBankName': accountData['bankName'],
      'activeMaskedAccount': accountData['maskedAccountNo'],
      'activeUpiId': accountData['upiId'],
      'bankLinkedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));

    debugPrint("****************[DB] Write successful.");
    return true;

  } catch (e) {
    debugPrint("****************[ERROR] activateBankAccount failed: $e");
    return false;
  }
}

 

  /// Sets the chosen bank profile as the active transactional payment protocol
//   Future<bool> activateBankAccount(Map<String, dynamic> accountData) async {
//   try {
//     final User? currentUser = _auth.currentUser;
    
//     debugPrint("****************[DB UPDATE LOG] Checking user authentication profile state...");
    
//     // ➔ DEVELOPMENT FIX: Fall back to a dedicated local testing doc ID string if auth session evaluates to null
//     final String targetUserUid = currentUser?.uid ?? "mock_developer_user_uid";
    
//     debugPrint("****************[DB UPDATE LOG] Writing account profile variables to users/$targetUserUid...");

//     // Write operation updates or initializes the specific user record smoothly
//     await _firestore.collection('users').doc(targetUserUid).set({
//       'activeBankName': accountData['bankName'],
//       'activeMaskedAccount': accountData['maskedAccountNo'],
//       'bankLinkedAt': FieldValue.serverTimestamp(),
//     }, SetOptions(merge: true));

//     debugPrint("****************[DB UPDATE LOG] Cloud Firestore document updated successfully.");
//     return true;
//   } catch (e) {
//     debugPrint("****************[CRITICAL CATCH EXCEPTION] activateBankAccount failed: ${e.toString()}");
//     return false;
//   }
// }

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
