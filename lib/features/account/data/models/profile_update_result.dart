import 'package:pilates_app/features/auth/data/models/auth_user.dart';

/// Result of profile update: success, pending phone/email verification, or failure.
sealed class ProfileUpdateResult {
  const ProfileUpdateResult();
}

/// Profile updated successfully.
final class ProfileUpdateSuccess extends ProfileUpdateResult {
  const ProfileUpdateSuccess(this.user);

  final AuthUser user;
}

/// Phone verification required before profile update completes.
final class ProfileUpdatePhoneVerificationRequired extends ProfileUpdateResult {
  const ProfileUpdatePhoneVerificationRequired({
    required this.phone,
    this.otpCode,
  });

  final String phone;

  /// Debug OTP code (only present in dev environment).
  final String? otpCode;
}

/// Email verification required before the new email is active.
final class ProfileUpdateEmailVerificationRequired extends ProfileUpdateResult {
  const ProfileUpdateEmailVerificationRequired({required this.email});

  final String email;
}

/// Profile update failed.
final class ProfileUpdateFailure extends ProfileUpdateResult {
  const ProfileUpdateFailure({
    required this.message,
    this.fieldErrors = const {},
  });

  final String message;
  final Map<String, String> fieldErrors;
}
