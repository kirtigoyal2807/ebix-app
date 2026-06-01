import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../features/auth/data/models/auth_user.dart';

/// Persists JWT for [DioClient] `accessToken` and session use.
class TokenStorage {
  TokenStorage(this._prefs);

  final SharedPreferences _prefs;

  static const _kAccessToken = 'auth_access_token';
  static const _kUserData = 'auth_user_data';
  static const _kHomeBranchId = 'auth_home_branch_id';
  static const _kMembershipPlanName = 'membership_plan_name';
  static const _kAppLocaleLanguageCode = 'app_locale_language_code';
  static const _kAppThemeMode = 'app_theme_mode';

  String? readToken() => _prefs.getString(_kAccessToken);

  Future<void> saveToken(String token) async {
    await _prefs.setString(_kAccessToken, token);
    if (kDebugMode) {
      debugPrint('[Auth] access token (saved): $token');
    }
  }

  Future<void> clearToken() => _prefs.remove(_kAccessToken);

  AuthUser? readUser() {
    final userJson = _prefs.getString(_kUserData);
    if (userJson != null) {
      try {
        final json = jsonDecode(userJson) as Map<String, dynamic>;
        return AuthUser.fromJson(json);
      } catch (e) {
        // Invalid stored user data
        clearUser();
      }
    }
    return null;
  }

  Future<void> saveUser(AuthUser user) async {
    final userJson = jsonEncode(user.toJson());
    await _prefs.setString(_kUserData, userJson);
  }

  Future<void> clearUser() => _prefs.remove(_kUserData);

  /// Last home branch chosen via `POST /auth/home-branch` (survives profile shape quirks).
  int? readHomeBranchId() {
    final id = _prefs.getInt(_kHomeBranchId);
    if (id == null || id <= 0) return null;
    return id;
  }

  Future<void> saveHomeBranchId(int id) async {
    if (id <= 0) return;
    await _prefs.setInt(_kHomeBranchId, id);
  }

  Future<void> clearHomeBranchId() => _prefs.remove(_kHomeBranchId);

  String? readMembershipPlanName() => _prefs.getString(_kMembershipPlanName);

  Future<void> saveMembershipPlanName(String planName) async {
    await _prefs.setString(_kMembershipPlanName, planName);
  }

  Future<void> clearMembershipPlanName() => _prefs.remove(_kMembershipPlanName);

  /// Persisted MaterialApp locale: `en` | `ar`. Null if the user has not chosen yet.
  String? readAppLocaleLanguageCode() =>
      _prefs.getString(_kAppLocaleLanguageCode);

  Future<void> saveAppLocaleLanguageCode(String languageCode) =>
      _prefs.setString(_kAppLocaleLanguageCode, languageCode);

  /// Persisted MaterialApp theme: `light` | `dark` | `system`. Null if not chosen yet.
  ThemeMode? readAppThemeMode() {
    return switch (_prefs.getString(_kAppThemeMode)) {
      'light' => ThemeMode.light,
      'dark' => ThemeMode.dark,
      'system' => ThemeMode.system,
      _ => null,
    };
  }

  Future<void> saveAppThemeMode(ThemeMode mode) {
    final value = switch (mode) {
      ThemeMode.light => 'light',
      ThemeMode.dark => 'dark',
      ThemeMode.system => 'system',
    };
    return _prefs.setString(_kAppThemeMode, value);
  }
}
