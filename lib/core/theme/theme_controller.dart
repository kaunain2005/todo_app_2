// lib/core/theme/theme_controller.dart
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeController extends ValueNotifier<ThemeMode> {
  ThemeController() : super(ThemeMode.light);

  static const _key = 'theme_mode';

  ThemeMode get themeMode => value;
  bool get isDark => value == ThemeMode.dark;

  /// Load from local cache (FAST)
  Future<void> loadFromCache() async {
    final prefs = await SharedPreferences.getInstance();
    final theme = prefs.getString(_key);

    if (theme == 'dark') {
      value = ThemeMode.dark;
    } else if (theme == 'light') {
      value = ThemeMode.light;
    }
  }

  /// Save locally + notify UI
  Future<void> setTheme(ThemeMode mode) async {
    value = mode;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, mode == ThemeMode.dark ? 'dark' : 'light');
  }
}
