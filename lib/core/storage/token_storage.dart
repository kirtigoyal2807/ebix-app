import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../features/auth/data/models/auth_user.dart';

/// Persists JWT for [DioClient] `accessToken` and session use.
class TokenStorage {
  TokenStorage(this._prefs);

  final SharedPreferences _prefs;

  static const _kAccessToken = 'auth_access_token';
  static const _kUserData = 'auth_user_data';

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
}
