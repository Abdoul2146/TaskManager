import 'package:flutter/material.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Riverpod provider for managing the app's ThemeMode (light/dark).
/// Uses a StateNotifier to allow for persistent and reactive theme changes.
final themeModeProvider = StateNotifierProvider<ThemeModeNotifier, ThemeMode>((
  ref,
) {
  return ThemeModeNotifier();
});

/// StateNotifier that manages the ThemeMode state and persists it using SharedPreferences.
class ThemeModeNotifier extends StateNotifier<ThemeMode> {
  static const _key = 'theme_mode';

  ThemeModeNotifier() : super(ThemeMode.light) {
    _loadTheme();
  }

  /// Loads the saved theme mode from SharedPreferences.
  /// If no value is found, defaults to light mode.
  Future<void> _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final mode = prefs.getString(_key);
    if (mode == 'dark') {
      state = ThemeMode.dark;
    } else if (mode == 'light') {
      state = ThemeMode.light;
    } else {
      state = ThemeMode.light;
    }
  }

  /// Sets the theme mode and persists the choice in SharedPreferences.
  Future<void> setTheme(ThemeMode mode) async {
    state = mode;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, mode == ThemeMode.dark ? 'dark' : 'light');
  }
}
