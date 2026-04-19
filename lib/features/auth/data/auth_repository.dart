import 'package:pilates_app/core/network/api_result.dart';
import 'package:pilates_app/core/network/base_repository.dart';

import 'models/login_email_result.dart';
import 'models/register_gender.dart';

/// Pilates API — auth endpoints.
class AuthRepository extends BaseRepository {
  AuthRepository(super.dio);

  /// Email + password flow. On success, envelope `data` contains `user` + `token`.
  Future<ApiResult<LoginEmailResult>> loginWithEmail({
    required String email,
    required String password,
  }) {
    return post<LoginEmailResult>(
      '/auth/login',
      data: {
        'email': email.trim(),
        'password': password,
      },
      fromJson: (json) =>
          LoginEmailResult.fromJson(json as Map<String, dynamic>),
    );
  }

  /// Phone OTP trigger: `phone` only. Success when envelope `success: true`.
  Future<ApiResult<bool>> requestPhoneLoginOtp({required String phone}) {
    return post<bool>(
      '/auth/login',
      data: {'phone': phone},
      fromJson: (_) => true,
    );
  }

  /// Registration — success is OTP sent (envelope); no session/token in this step.
  Future<ApiResult<bool>> register({
    required String firstName,
    String? lastName,
    required String email,
    required String phone,
    required String password,
    RegisterGender? gender,
    DateTime? dob,
  }) {
    final data = <String, dynamic>{
      'firstName': firstName.trim(),
      'email': email.trim(),
      'phone': phone.trim(),
      'password': password,
    };
    final ln = lastName?.trim();
    if (ln != null && ln.isNotEmpty) {
      data['lastName'] = ln;
    }
    if (gender != null) {
      data['gender'] = gender.apiValue;
    }
    if (dob != null) {
      final y = dob.year.toString().padLeft(4, '0');
      final m = dob.month.toString().padLeft(2, '0');
      final d = dob.day.toString().padLeft(2, '0');
      data['dob'] = '$y-$m-$d';
    }

    return post<bool>(
      '/auth/register',
      data: data,
      fromJson: (_) => true,
    );
  }

  /// Step 1 — sends 6-digit code to email.
  Future<ApiResult<bool>> requestPasswordForgot({required String email}) {
    return post<bool>(
      '/auth/password/forgot',
      data: {'email': email.trim()},
      fromJson: (_) => true,
    );
  }

  /// Step 2 — verify code from email (10 min window).
  Future<ApiResult<bool>> verifyEmailCode({
    required String email,
    required String code,
  }) {
    return post<bool>(
      '/auth/email/verify',
      data: {
        'email': email.trim(),
        'code': code,
      },
      fromJson: (_) => true,
    );
  }

  /// Step 3 — set new password (after successful verify).
  Future<ApiResult<bool>> resetPassword({
    required String email,
    required String password,
  }) {
    return post<bool>(
      '/auth/password/reset',
      data: {
        'email': email.trim(),
        'password': password,
      },
      fromJson: (_) => true,
    );
  }

  /// Customer profile — requires JWT (saved after login).
  Future<ApiResult<bool>> submitUserGoal({
    required String experience,
    required String goal,
    required int monthlyGoal,
  }) {
    return post<bool>(
      '/auth/goal',
      data: {
        'experience': experience,
        'goal': goal,
        'monthlyGoal': monthlyGoal,
      },
      fromJson: (_) => true,
    );
  }
}
