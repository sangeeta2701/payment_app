import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
// ➔ IMPORT BOTH PLATFORM DEFINITIONS TO FIX "IOSAuthMessages not defined"
import 'package:local_auth_android/local_auth_android.dart';
import 'package:local_auth_darwin/local_auth_darwin.dart'; 

class BiometricService {
  final LocalAuthentication _auth = LocalAuthentication();

  /// Check if the device hardware supports biometrics and has profiles enrolled
  Future<bool> isDeviceSecure() async {
    try {
      final bool canAuthenticateWithBiometrics = await _auth.canCheckBiometrics;
      final bool canAuthenticate = canAuthenticateWithBiometrics || await _auth.isDeviceSupported();
      return canAuthenticate;
    } catch (_) {
      return false;
    }
  }

  /// Trigger the native lock biometric system overlay panel
  Future<bool> authenticateUser() async {
    try {
      return await _auth.authenticate(
        localizedReason: 'Scan fingerprint or Face ID to unlock your Paytm Wallet',
        biometricOnly: false, 
        authMessages: const [
          AndroidAuthMessages(
            signInTitle: 'Paytm Wallet Secure Lock',
            cancelButton: 'Cancel',
          ),
          IOSAuthMessages(
            cancelButton: 'Cancel',
          ),
        ],
      );
    } on PlatformException catch (_) {
      return false;
    }
  }
}