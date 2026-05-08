import 'auth_user.dart';

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
    final token =
        json['token'] as String? ??
        json['access_token'] as String? ??
        json['accessToken'] as String?;
    if (token == null || token.isEmpty) {
      throw FormatException('Login response missing data.token');
    }
    return LoginEmailResult(user: AuthUser.fromJson(userRaw), token: token);
  }
}
