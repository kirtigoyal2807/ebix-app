import 'auth_user.dart';
import 'login_email_result.dart';

/// Updated profile after the customer confirms a pending phone change via OTP.
class ProfileVerifyPhoneResult {
  const ProfileVerifyPhoneResult({required this.user, this.token});

  final AuthUser user;
  final String? token;

  factory ProfileVerifyPhoneResult.fromJson(Map<String, dynamic> json) {
    final userRaw = json['user'];
    final Map<String, dynamic> userMap;
    if (userRaw is Map) {
      userMap = Map<String, dynamic>.from(userRaw);
    } else {
      // Backend returns the customer profile as `data` (same shape as profile resource).
      userMap = Map<String, dynamic>.from(json);
    }
    return ProfileVerifyPhoneResult(
      user: AuthUser.fromJson(userMap),
      token: readOptionalAuthTokenFromAuthData(json),
    );
  }
}
