import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';
import 'package:local_auth_android/local_auth_android.dart';
import 'package:local_auth_darwin/local_auth_darwin.dart';

class BiometricService {
  final LocalAuthentication _auth = LocalAuthentication();

  Future<bool> isDeviceSecure() async {
    try {
      final bool canCheckBiometrics = await _auth.canCheckBiometrics;
      final bool isDeviceSupported = await _auth.isDeviceSupported();

      debugPrint("=== BiometricService ===");
      debugPrint("**********************8canCheckBiometrics: $canCheckBiometrics");
      debugPrint("isDeviceSupported: $isDeviceSupported");

      final List<BiometricType> availableBiometrics =
          await _auth.getAvailableBiometrics();
      debugPrint("**********************8availableBiometrics: $availableBiometrics");

      return canCheckBiometrics || isDeviceSupported;
    } catch (e) {
      debugPrint("**********************8isDeviceSecure error: $e");
      return false;
    }
  }

  Future<bool> authenticateUser() async {
    try {
      
      final bool result = await _auth.authenticate(
        localizedReason:
            'Scan fingerprint or Face ID to unlock your Payment Wallet',
        biometricOnly: false,
        persistAcrossBackgrounding: true, 
        authMessages: const [
          AndroidAuthMessages(
            signInTitle: 'Payment Wallet Secure Lock',
            cancelButton: 'Cancel',
          ),
          IOSAuthMessages(
            cancelButton: 'Cancel',
          ),
        ],
      );

      debugPrint("=== authenticateUser result: $result ===");
      return result;

    } on LocalAuthException catch (e) {
      debugPrint("*************LocalAuthException: ${e.code} — ${e.description}");
      return false;
    } catch (e) {
      debugPrint("Auth error: $e");
      return false;
    }
  }
}