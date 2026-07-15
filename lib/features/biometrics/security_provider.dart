import 'package:flutter/material.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'biometric_service.dart';

class SecurityState {
  final bool isUnlocked;
  final bool isSupported;
  final bool hasAttemptedAuth;

  SecurityState({
    required this.isUnlocked,
    required this.isSupported,
    required this.hasAttemptedAuth,
  });

  SecurityState copyWith({
    bool? isUnlocked,
    bool? isSupported,
    bool? hasAttemptedAuth,
  }) {
    return SecurityState(
      isUnlocked: isUnlocked ?? this.isUnlocked,
      isSupported: isSupported ?? this.isSupported,
      hasAttemptedAuth: hasAttemptedAuth ?? this.hasAttemptedAuth,
    );
  }
}

class SecurityNotifier extends StateNotifier<SecurityState> {
  final BiometricService _service = BiometricService();

  SecurityNotifier()
      : super(SecurityState(
          isUnlocked: false,
          isSupported: false,
          hasAttemptedAuth: false,
        )) {
    _checkHardwareCapabilities();
  }

  Future<void> _checkHardwareCapabilities() async {
    final supported = await _service.isDeviceSecure();
    debugPrint("=== BIOMETRIC HARDWARE CHECK: supported=$supported ===");
    state = state.copyWith(isSupported: supported);
  }

  void lockApp() {
    state = state.copyWith(isUnlocked: false, hasAttemptedAuth: false);
  }

  Future<bool> verifyIdentity() async {
    state = state.copyWith(hasAttemptedAuth: true);

    final supported = await _service.isDeviceSecure();
    debugPrint("=== verifyIdentity: device secure=$supported ===");

    if (!supported) {
      // No biometrics on device → auto unlock
      state = state.copyWith(isUnlocked: true, isSupported: false);
      return true;
    }

    final success = await _service.authenticateUser();
    debugPrint("=== verifyIdentity: auth success=$success ===");

    if (success) {
      state = state.copyWith(isUnlocked: true);
    }
    return success;
  }
}

// ✅ Semicolon added
final securityProvider =
    StateNotifierProvider<SecurityNotifier, SecurityState>((ref) {
  return SecurityNotifier();
});