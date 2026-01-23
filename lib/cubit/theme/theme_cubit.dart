import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'theme_state.dart';

class ThemeCubit extends Cubit<ThemeState> {
  static const String _themeKey = 'app_theme_mode';
  late SharedPreferences _prefs;

  ThemeCubit()
      : super(const ThemeState(
          themeMode: ThemeMode.system,
          isDarkMode: false,
        )) {
    _initializePreferences();
  }

  Future<void> _initializePreferences() async {
    _prefs = await SharedPreferences.getInstance();
    await _loadSavedTheme();
  }

  Future<void> _loadSavedTheme() async {
    final savedTheme = _prefs.getString(_themeKey) ?? 'system';
    final themeMode = _stringToThemeMode(savedTheme);
    final isDarkMode = _isDarkMode(themeMode);
    emit(ThemeState(
      themeMode: themeMode,
      isDarkMode: isDarkMode,
    ));
  }

  Future<void> setThemeMode(ThemeMode themeMode) async {
    final isDarkMode = _isDarkMode(themeMode);
    await _prefs.setString(_themeKey, _themeModeToString(themeMode));
    emit(ThemeState(
      themeMode: themeMode,
      isDarkMode: isDarkMode,
    ));
  }

  Future<void> toggleTheme() async {
    final newMode = state.themeMode == ThemeMode.light
        ? ThemeMode.dark
        : ThemeMode.light;
    await setThemeMode(newMode);
  }

  bool _isDarkMode(ThemeMode themeMode) {
    if (themeMode == ThemeMode.system) {
      return WidgetsBinding.instance.platformDispatcher.platformBrightness ==
          Brightness.dark;
    }
    return themeMode == ThemeMode.dark;
  }

  String _themeModeToString(ThemeMode mode) {
    return mode.toString().split('.').last;
  }

  ThemeMode _stringToThemeMode(String mode) {
    switch (mode) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      default:
        return ThemeMode.system;
    }
  }
}
