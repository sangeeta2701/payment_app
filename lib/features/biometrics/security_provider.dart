import 'package:flutter_riverpod/legacy.dart';
import 'biometric_service.dart';

class SecurityState {
  final bool isUnlocked;
  final bool isSupported;

  SecurityState({required this.isUnlocked, required this.isSupported});

  SecurityState copyWith({bool? isUnlocked, bool? isSupported}) {
    return SecurityState(
      isUnlocked: isUnlocked ?? this.isUnlocked,
      isSupported: isSupported ?? this.isSupported,
    );
  }
}

class SecurityNotifier extends StateNotifier<SecurityState> {
  final BiometricService _service = BiometricService();

  SecurityNotifier() : super(SecurityState(isUnlocked: false, isSupported: false)) {
    _checkHardwareCapabilities();
  }

  Future<void> _checkHardwareCapabilities() async {
    final supported = await _service.isDeviceSecure();
    state = state.copyWith(isSupported: supported);
  }

  /// Lock out user profile instantly
  void lockApp() {
    state = state.copyWith(isUnlocked: false);
  }

  /// Prompt verification gate
  Future<bool> verifyIdentity() async {
    // If device doesn't have secure biometrics setup, skip to prevent getting stuck
    if (!state.isSupported) {
      state = state.copyWith(isUnlocked: true);
      return true;
    }

    final success = await _service.authenticateUser();
    if (success) {
      state = state.copyWith(isUnlocked: true);
    }
    return success;
  }
}

// Global hook provider
final securityProvider = StateNotifierProvider<SecurityNotifier, SecurityState>((ref) {
  return SecurityNotifier();
});