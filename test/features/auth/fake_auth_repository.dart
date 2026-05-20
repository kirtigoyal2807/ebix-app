import 'package:dio/dio.dart';
import 'package:pilates_app/core/network/api_result.dart';
import 'package:pilates_app/core/network/network_exception.dart';
import 'package:pilates_app/features/auth/data/auth_repository.dart';
import 'package:pilates_app/features/auth/data/models/branches_list_result.dart';
import 'package:pilates_app/features/auth/data/models/branch.dart';
import 'package:pilates_app/features/auth/data/models/auth_user.dart';
import 'package:pilates_app/features/auth/data/models/login_email_result.dart';
import 'package:pilates_app/features/auth/data/models/profile_verify_phone_result.dart';
import 'package:pilates_app/features/auth/data/models/register_gender.dart';

/// Test double with configurable outcomes for auth API methods.
class FakeAuthRepository extends AuthRepository {
  FakeAuthRepository()
    : super(Dio(BaseOptions(baseUrl: 'https://test.local/')));

  ApiResult<LoginEmailResult> loginResult = ApiFailure<LoginEmailResult>(
    NetworkException(type: NetworkFailureType.unknown, message: 'unset'),
  );
  ApiResult<bool> registerResult = const ApiSuccess<bool>(true);
  ApiResult<LoginEmailResult> verifyPhoneOtpResult =
      ApiSuccess<LoginEmailResult>(
        LoginEmailResult(
          user: AuthUser(email: 'verified@example.com', phone: '+966500000000'),
          token: 'phone-verify-jwt',
        ),
      );

  /// When set, [verifyProfilePhone] returns this; otherwise it mirrors [verifyPhoneOtpResult].
  ApiResult<ProfileVerifyPhoneResult>? verifyProfilePhoneResultOverride;
  ApiResult<bool> phoneOtpResult = const ApiSuccess<bool>(true);
  ApiResult<bool> sendPhoneOtpResult = const ApiSuccess<bool>(true);
  ApiResult<bool> passwordForgotResult = const ApiSuccess<bool>(true);
  ApiResult<bool> sendEmailVerificationResult = const ApiSuccess<bool>(true);
  ApiResult<bool> verifyEmailCodeResult = const ApiSuccess<bool>(true);
  ApiResult<AuthUser> verifyProfileEmailResult = const ApiSuccess<AuthUser>(
    AuthUser(email: 'profile-email@example.com'),
  );
  ApiResult<bool> resetPasswordResult = const ApiSuccess<bool>(true);
  ApiResult<bool> submitUserGoalResult = const ApiSuccess<bool>(true);
  ApiResult<AuthUser> getProfileResult = const ApiSuccess<AuthUser>(
    AuthUser(email: 'profile@example.com'),
  );
  ApiResult<BranchesListResult> listBranchesResult =
      ApiSuccess<BranchesListResult>(
        BranchesListResult(
          branches: [
            Branch(
              id: 1,
              title: 'Branch One',
              city: 'City',
              distance: '1 km',
              typeLabel: 'Standard',
            ),
          ],
        ),
      );
  ApiResult<bool> setHomeBranchResult = const ApiSuccess<bool>(true);
  ApiResult<bool> logoutResult = const ApiSuccess<bool>(true);

  int loginCalls = 0;
  int registerCalls = 0;
  int verifyPhoneOtpCalls = 0;
  int verifyProfilePhoneCalls = 0;
  int phoneOtpCalls = 0;
  int sendPhoneOtpCalls = 0;
  int passwordForgotCalls = 0;
  int sendEmailVerificationCalls = 0;
  int verifyEmailCodeCalls = 0;
  int verifyProfileEmailCalls = 0;
  int resetPasswordCalls = 0;
  int submitUserGoalCalls = 0;
  int getProfileCalls = 0;
  int getAuthMeCalls = 0;
  int listBranchesCalls = 0;
  int setHomeBranchCalls = 0;
  int logoutCalls = 0;

  String? lastLoginEmail;
  String? lastRegisterEmail;
  String? lastRegisterPhone;
  String? lastVerifyPhoneOtpPhone;
  String? lastVerifyPhoneOtpCode;
  String? lastVerifyProfilePhonePhone;
  String? lastVerifyProfilePhoneOtp;
  String? lastSendPhoneOtpPhone;
  String? lastForgotEmail;
  String? lastSendEmailVerificationEmail;
  String? lastVerifyEmail;
  String? lastVerifyCode;
  String? lastVerifyProfileEmail;
  String? lastVerifyProfileEmailCode;
  String? lastResetEmail;
  String? lastResetPassword;
  String? lastSubmitExperience;
  String? lastSubmitGoal;
  int? lastSubmitMonthlyGoal;
  Map<String, dynamic>? lastListBranchesQuery;
  int? lastHomeBranchId;
  Duration getProfileDelay = Duration.zero;

  @override
  Future<ApiResult<LoginEmailResult>> loginWithEmail({
    required String email,
    required String password,
  }) async {
    loginCalls++;
    lastLoginEmail = email;
    return loginResult;
  }

  @override
  Future<ApiResult<bool>> register({
    required String firstName,
    String? lastName,
    required String email,
    required String phone,
    required String password,
    RegisterGender? gender,
    DateTime? dob,
    String referralCode = '',
  }) async {
    registerCalls++;
    lastRegisterEmail = email;
    lastRegisterPhone = phone;
    return registerResult;
  }

  @override
  Future<ApiResult<LoginEmailResult>> verifyPhoneOtp({
    required String phone,
    required String code,
  }) async {
    verifyPhoneOtpCalls++;
    lastVerifyPhoneOtpPhone = phone;
    lastVerifyPhoneOtpCode = code;
    return verifyPhoneOtpResult;
  }

  @override
  Future<ApiResult<ProfileVerifyPhoneResult>> verifyProfilePhone({
    required String phone,
    required String otp,
  }) async {
    verifyProfilePhoneCalls++;
    lastVerifyProfilePhonePhone = phone;
    lastVerifyProfilePhoneOtp = otp;
    final override = verifyProfilePhoneResultOverride;
    if (override != null) {
      return override;
    }
    switch (verifyPhoneOtpResult) {
      case ApiSuccess<LoginEmailResult>(:final data):
        return ApiSuccess(
          ProfileVerifyPhoneResult(user: data.user, token: data.token),
        );
      case ApiFailure<LoginEmailResult>(:final exception):
        return ApiFailure<ProfileVerifyPhoneResult>(exception);
    }
  }

  @override
  Future<ApiResult<bool>> requestPhoneLoginOtp({required String phone}) async {
    phoneOtpCalls++;
    return phoneOtpResult;
  }

  @override
  Future<ApiResult<bool>> sendPhoneOtp({required String phone}) async {
    sendPhoneOtpCalls++;
    lastSendPhoneOtpPhone = phone;
    return sendPhoneOtpResult;
  }

  @override
  Future<ApiResult<bool>> requestPasswordForgot({required String email}) async {
    passwordForgotCalls++;
    lastForgotEmail = email;
    return passwordForgotResult;
  }

  @override
  Future<ApiResult<bool>> sendEmailVerification({required String email}) async {
    sendEmailVerificationCalls++;
    lastSendEmailVerificationEmail = email;
    return sendEmailVerificationResult;
  }

  @override
  Future<ApiResult<bool>> verifyEmailCode({
    required String email,
    required String code,
  }) async {
    verifyEmailCodeCalls++;
    lastVerifyEmail = email;
    lastVerifyCode = code;
    return verifyEmailCodeResult;
  }

  @override
  Future<ApiResult<AuthUser>> verifyProfileEmail({
    required String email,
    required String code,
  }) async {
    verifyProfileEmailCalls++;
    lastVerifyProfileEmail = email;
    lastVerifyProfileEmailCode = code;
    return verifyProfileEmailResult;
  }

  @override
  Future<ApiResult<bool>> resetPassword({
    required String email,
    required String password,
  }) async {
    resetPasswordCalls++;
    lastResetEmail = email;
    lastResetPassword = password;
    return resetPasswordResult;
  }

  @override
  Future<ApiResult<bool>> submitUserGoal({
    required String experience,
    required String goal,
    required int monthlyGoal,
  }) async {
    submitUserGoalCalls++;
    lastSubmitExperience = experience;
    lastSubmitGoal = goal;
    lastSubmitMonthlyGoal = monthlyGoal;
    return submitUserGoalResult;
  }

  @override
  Future<ApiResult<AuthUser>> getProfile() async {
    getProfileCalls++;
    if (getProfileDelay > Duration.zero) {
      await Future<void>.delayed(getProfileDelay);
    }
    return getProfileResult;
  }

  @override
  Future<ApiResult<AuthUser>> getAuthMe() async {
    getAuthMeCalls++;
    if (getProfileDelay > Duration.zero) {
      await Future<void>.delayed(getProfileDelay);
    }
    return getProfileResult;
  }

  @override
  Future<ApiResult<BranchesListResult>> listBranches({
    Map<String, dynamic>? queryParameters,
  }) async {
    listBranchesCalls++;
    lastListBranchesQuery = queryParameters == null
        ? null
        : Map<String, dynamic>.from(queryParameters);
    return listBranchesResult;
  }

  @override
  Future<ApiResult<bool>> setHomeBranch({required int homeBranchId}) async {
    setHomeBranchCalls++;
    lastHomeBranchId = homeBranchId;
    return setHomeBranchResult;
  }

  @override
  Future<ApiResult<bool>> logout() async {
    logoutCalls++;
    return logoutResult;
  }
}
