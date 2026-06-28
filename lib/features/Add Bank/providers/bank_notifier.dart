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

  /// Queries the decentralized global registry for accounts matching your authenticated number
  Future<void> findLinkedBankAccounts(BankModel selectedBank) async {
    state = const AsyncValue.loading();

    try {
      final User? currentUser = _auth.currentUser;
      if (currentUser == null || currentUser.phoneNumber == null) {
        state = AsyncValue.error("User validation signature missing.", StackTrace.current);
        return;
      }

      final String formattedUserPhone = currentUser.phoneNumber!;

      // Pull from central mock cloud server database setup
      final querySnapshot = await _firestore
          .collection('mock_central_bank_registry')
          .where('phoneNumber', isEqualTo: formattedUserPhone)
          .where('bankId', isEqualTo: selectedBank.id)
          .get();

      final AccountList accounts = querySnapshot.docs.map((doc) => doc.data()).toList();
      
      // Pass the arrays straight back as compiled states
      state = AsyncValue.data(accounts);
    } catch (e, stack) {
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
final bankProvider = StateNotifierProvider<BankNotifier, AsyncValue<AccountList>>((ref) {
  return BankNotifier();
});