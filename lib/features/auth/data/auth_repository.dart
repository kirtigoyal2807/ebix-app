import 'package:dio/dio.dart';

import 'package:pilates_app/core/network/api_result.dart';
import 'package:pilates_app/core/network/api_envelope.dart';
import 'package:pilates_app/core/network/base_repository.dart';
import 'package:pilates_app/core/network/network_exception.dart';

import 'models/branches_list_result.dart';
import 'models/branch.dart';
import 'models/login_email_result.dart';
import 'models/pagination_meta.dart';
import 'models/register_gender.dart';
import 'models/auth_user.dart';

/// Pilates API — auth endpoints.
class AuthRepository extends BaseRepository {
  AuthRepository(super.dio);

  /// Email + password flow. On success, envelope `data` contains `user` + `token`.
  Future<ApiResult<LoginEmailResult>> loginWithEmail({
    required String email,
    required String password,
  }) {
    return post<LoginEmailResult>(
      'auth/login',
      data: {'email': email.trim(), 'password': password},
      fromJson: (json) =>
          LoginEmailResult.fromJson(json as Map<String, dynamic>),
    );
  }

  /// Phone OTP trigger: `phone` only. Success when envelope `success: true`.
  Future<ApiResult<bool>> requestPhoneLoginOtp({required String phone}) {
    return post<bool>(
      'auth/login',
      data: {'phone': phone},
      fromJson: (_) => true,
    );
  }

  /// Resend phone OTP (sign-up or sign-in flow). Body: [phone] only.
  Future<ApiResult<bool>> sendPhoneOtp({required String phone}) {
    return post<bool>(
      'auth/phone/send',
      data: {'phone': phone.trim()},
      fromJson: (_) => true,
    );
  }

  /// Verify sign-up / login phone OTP — on success envelope `data` has `user` + `token`.
  Future<ApiResult<LoginEmailResult>> verifyPhoneOtp({
    required String phone,
    required String code,
  }) {
    return post<LoginEmailResult>(
      'auth/phone/verify',
      data: {'phone': phone.trim(), 'code': code.trim()},
      fromJson: (json) =>
          LoginEmailResult.fromJson(json as Map<String, dynamic>),
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

    return post<bool>('auth/register', data: data, fromJson: (_) => true);
  }

  /// Step 1 — sends 6-digit code to email.
  Future<ApiResult<bool>> requestPasswordForgot({required String email}) {
    return post<bool>(
      'auth/password/forgot',
      data: {'email': email.trim()},
      fromJson: (_) => true,
    );
  }

  /// Resend email OTP (forgot-password OTP screen). Body: [email] only.
  ///
  /// Debug backends may accept verification code `000000`.
  Future<ApiResult<bool>> sendEmailVerification({required String email}) {
    return post<bool>(
      'auth/email/send',
      data: {'email': email.trim()},
      fromJson: (_) => true,
    );
  }

  /// Step 2 — verify code from email (10 min window).
  ///
  /// Debug backends may accept code `000000`.
  Future<ApiResult<bool>> verifyEmailCode({
    required String email,
    required String code,
  }) {
    return post<bool>(
      'auth/email/verify',
      data: {'email': email.trim(), 'code': code},
      fromJson: (_) => true,
    );
  }

  /// Step 3 — set new password (after successful verify).
  Future<ApiResult<bool>> resetPassword({
    required String email,
    required String password,
  }) {
    return post<bool>(
      'auth/password/reset',
      data: {'email': email.trim(), 'password': password},
      fromJson: (_) => true,
    );
  }

  /// Public list — supports pagination/filter query params per API.
  Future<ApiResult<BranchesListResult>> listBranches({
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final response = await httpClient.get<dynamic>(
        'branches',
        queryParameters: queryParameters,
      );
      final code = response.statusCode;
      if (code == null) {
        return ApiFailure(
          NetworkException(
            type: NetworkFailureType.badResponse,
            message: 'Missing status code',
            responseData: response.data,
          ),
        );
      }
      if (code < 200 || code >= 300) {
        return ApiFailure(
          NetworkException(
            type: NetworkFailureType.badResponse,
            message: 'HTTP $code',
            statusCode: code,
            responseData: response.data,
          ),
        );
      }
      final raw = response.data;
      PaginationMeta? pagination;
      if (raw is Map<String, dynamic>) {
        final meta = raw['meta'];
        if (meta is Map<String, dynamic>) {
          final p = meta['pagination'];
          if (p is Map<String, dynamic>) {
            pagination = PaginationMeta.fromJson(p);
          }
        }
      }

      final envelope = ApiEnvelopeParser.tryParse(raw);
      if (envelope != null) {
        if (!envelope.success) {
          return ApiFailure(
            NetworkException.fromApiEnvelope(
              statusCode: code,
              message: envelope.message.isEmpty
                  ? 'Request failed'
                  : envelope.message,
              fieldErrors: envelope.fieldErrors,
              responseData: raw,
            ),
          );
        }
        final branches = _parseBranchesList(envelope.data);
        return ApiSuccess(
          BranchesListResult(branches: branches, pagination: pagination),
          statusCode: code,
        );
      }

      final branches = _parseBranchesList(raw);
      return ApiSuccess(
        BranchesListResult(branches: branches, pagination: pagination),
        statusCode: code,
      );
    } on DioException catch (e, st) {
      return ApiFailure(NetworkException.fromDioException(e, st));
    } catch (e, st) {
      return ApiFailure(NetworkException.fromUnknown(e, st));
    }
  }

  static List<Branch> _parseBranchesList(dynamic payload) {
    final list = _coerceList(payload);
    if (list == null) return [];
    return list
        .map((e) {
          final map = Map<String, dynamic>.from(e as Map);
          return Branch.fromJson(map);
        })
        .where((b) => b.isActive)
        .toList();
  }

  static List<dynamic>? _coerceList(dynamic payload) {
    if (payload is List<dynamic>) return payload;
    if (payload is Map) {
      final d = payload['data'] ?? payload['items'] ?? payload['branches'];
      if (d is List<dynamic>) return d;
    }
    return null;
  }

  /// Saved preferred branch — JWT customer.
  Future<ApiResult<bool>> setHomeBranch({required int homeBranchId}) {
    return post<bool>(
      'auth/home-branch',
      data: {'homeBranchId': homeBranchId},
      fromJson: (_) => true,
    );
  }

  /// Invalidate server session — requires JWT (Bearer via [DioClient]).
  Future<ApiResult<bool>> logout() {
    return post<bool>('auth/logout', fromJson: (_) => true);
  }

  /// Customer profile — requires JWT (saved after login).
  /// Uses `GET /auth/me` which returns full profile with goals, subscriptions, etc.
  Future<ApiResult<AuthUser>> getProfile() {
    return get<AuthUser>(
      'auth/me',
      fromJson: (json) => AuthUser.fromJson(json as Map<String, dynamic>),
    );
  }

  /// Update customer profile — `PUT /customers/profile`. All fields optional.
  /// Send only the fields the user changed. Returns the updated [AuthUser].
  /// When [avatarPath] is provided, uses `multipart/form-data`; otherwise JSON.
  Future<ApiResult<AuthUser>> updateProfile({
    String? firstName,
    String? lastName,
    String? email,
    String? phone,
    String? gender,
    DateTime? dob,
    String? avatarPath,
  }) async {
    final fields = <String, dynamic>{};
    if (firstName != null && firstName.isNotEmpty) {
      fields['firstName'] = firstName.trim();
    }
    if (lastName != null && lastName.isNotEmpty) {
      fields['lastName'] = lastName.trim();
    }
    if (email != null && email.isNotEmpty) {
      fields['email'] = email.trim();
    }
    if (phone != null && phone.isNotEmpty) fields['phone'] = phone;
    if (gender != null && gender.isNotEmpty) fields['gender'] = gender;
    if (dob != null) {
      final y = dob.year.toString().padLeft(4, '0');
      final m = dob.month.toString().padLeft(2, '0');
      final d = dob.day.toString().padLeft(2, '0');
      fields['dob'] = '$y-$m-$d';
    }

    final hasAvatar = avatarPath != null && avatarPath.isNotEmpty;

    if (hasAvatar) {
      // PHP/Laravel backends don't parse multipart/form-data on PUT requests,
      // so we POST with `_method: PUT` (Laravel method-spoofing).
      final formData = FormData.fromMap({
        '_method': 'PUT',
        ...fields,
        'avatar': await MultipartFile.fromFile(
          avatarPath,
          filename: avatarPath.split('/').last,
        ),
      });
      return post<AuthUser>(
        'customers/profile',
        data: formData,
        options: Options(contentType: 'multipart/form-data'),
        fromJson: (json) => AuthUser.fromJson(json as Map<String, dynamic>),
      );
    }

    return put<AuthUser>(
      'customers/profile',
      data: fields,
      options: Options(contentType: 'application/json'),
      fromJson: (json) => AuthUser.fromJson(json as Map<String, dynamic>),
    );
  }

  /// Customer profile — requires JWT (saved after login).
  Future<ApiResult<bool>> submitUserGoal({
    required String experience,
    required String goal,
    required int monthlyGoal,
  }) {
    return post<bool>(
      'auth/goal',
      data: {
        'experience': experience,
        'goal': goal,
        'monthlyGoal': monthlyGoal,
      },
      fromJson: (_) => true,
    );
  }
}
