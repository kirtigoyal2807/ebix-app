import 'auth_user.dart';

/// Bearer token from auth `data` maps when the backend includes one.
String? readOptionalAuthTokenFromAuthData(Map<String, dynamic> json) {
  final raw = json['token'] as String? ??
      json['access_token'] as String? ??
      json['accessToken'] as String?;
  final trimmed = raw?.trim();
  if (trimmed == null || trimmed.isEmpty) return null;
  return trimmed;
}

/// `data` from successful email/password login: user + token.
class LoginEmailResult {
  const LoginEmailResult({required this.user, required this.token});

  final AuthUser user;
  final String token;

  factory LoginEmailResult.fromJson(Map<String, dynamic> json) {
    final userRaw = json['user'];
    if (userRaw is! Map<String, dynamic>) {
      throw FormatException('Login response missing data.user object');
    }
    final token = readOptionalAuthTokenFromAuthData(json);
    if (token == null) {
      throw FormatException('Login response missing data.token');
    }
    return LoginEmailResult(user: AuthUser.fromJson(userRaw), token: token);
  }
}
