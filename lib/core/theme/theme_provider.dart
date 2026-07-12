import 'package:flutter/material.dart';
import 'package:flutter_riverpod/legacy.dart';

// Manage the current theme mode state (defaults to ThemeMode.light)
class ThemeNotifier extends StateNotifier<ThemeMode> {
  ThemeNotifier() : super(ThemeMode.light);

  void toggleTheme() {
    if (state == ThemeMode.light) {
      state = ThemeMode.dark;
    } else {
      state = ThemeMode.light;
    }
  }
}

// Global provider to watch and change the application theme state
final themeModeProvider = StateNotifierProvider<ThemeNotifier, ThemeMode>((ref) {
  return ThemeNotifier();
});