import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Persists JWT for [DioClient] `accessToken` and session use.
class TokenStorage {
  TokenStorage(this._prefs);

  final SharedPreferences _prefs;

  static const _kAccessToken = 'auth_access_token';

  String? readToken() => _prefs.getString(_kAccessToken);

  Future<void> saveToken(String token) async {
    await _prefs.setString(_kAccessToken, token);
    if (kDebugMode) {
      debugPrint('[Auth] access token (saved): $token');
    }
  }

  Future<void> clearToken() => _prefs.remove(_kAccessToken);
}
