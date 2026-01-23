import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../l10n/localization.dart';

part 'app_state.dart';

class AppCubit extends Cubit<AppState> {
  static const String _languageKey = 'app_language';
  late SharedPreferences _prefs;

  AppCubit()
      : super(const AppState(
          locale: Locale('en'),
          isLoading: false,
        )) {
    _initializePreferences();
  }

  Future<void> _initializePreferences() async {
    _prefs = await SharedPreferences.getInstance();
    await _loadSavedLanguage();
  }

  Future<void> _loadSavedLanguage() async {
    final savedLanguage = _prefs.getString(_languageKey) ?? 'en';
    final locale = Locale(savedLanguage);
    Localization.setLocale(locale);
    emit(state.copyWith(locale: locale));
  }

  Future<void> setLocale(Locale locale) async {
    Localization.setLocale(locale);
    await _prefs.setString(_languageKey, locale.languageCode);
    emit(state.copyWith(locale: locale));
  }

  void setLoading(bool isLoading) {
    emit(state.copyWith(isLoading: isLoading));
  }

  Future<void> switchLanguage(String languageCode) async {
    final locale = Locale(languageCode);
    await setLocale(locale);
  }
}
