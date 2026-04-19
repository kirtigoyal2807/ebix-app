import 'package:dio/dio.dart';
import 'package:pilates_app/core/network/api_result.dart';
import 'package:pilates_app/core/network/network_exception.dart';
import 'package:pilates_app/features/auth/data/auth_repository.dart';
import 'package:pilates_app/features/auth/data/models/branches_list_result.dart';
import 'package:pilates_app/features/auth/data/models/branch.dart';
import 'package:pilates_app/features/auth/data/models/login_email_result.dart';
import 'package:pilates_app/features/auth/data/models/register_gender.dart';

/// Test double with configurable outcomes for auth API methods.
class FakeAuthRepository extends AuthRepository {
  FakeAuthRepository() : super(Dio(BaseOptions(baseUrl: 'https://test.local/')));

  ApiResult<LoginEmailResult> loginResult = ApiFailure<LoginEmailResult>(
    NetworkException(type: NetworkFailureType.unknown, message: 'unset'),
  );
  ApiResult<bool> registerResult = const ApiSuccess<bool>(true);
  ApiResult<bool> phoneOtpResult = const ApiSuccess<bool>(true);
  ApiResult<bool> passwordForgotResult = const ApiSuccess<bool>(true);
  ApiResult<bool> verifyEmailCodeResult = const ApiSuccess<bool>(true);
  ApiResult<bool> resetPasswordResult = const ApiSuccess<bool>(true);
  ApiResult<bool> submitUserGoalResult = const ApiSuccess<bool>(true);
  ApiResult<BranchesListResult> listBranchesResult = ApiSuccess<BranchesListResult>(
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

  int loginCalls = 0;
  int registerCalls = 0;
  int phoneOtpCalls = 0;
  int passwordForgotCalls = 0;
  int verifyEmailCodeCalls = 0;
  int resetPasswordCalls = 0;
  int submitUserGoalCalls = 0;
  int listBranchesCalls = 0;
  int setHomeBranchCalls = 0;

  String? lastLoginEmail;
  String? lastRegisterEmail;
  String? lastForgotEmail;
  String? lastVerifyEmail;
  String? lastVerifyCode;
  String? lastResetEmail;
  String? lastResetPassword;
  String? lastSubmitExperience;
  String? lastSubmitGoal;
  int? lastSubmitMonthlyGoal;
  Map<String, dynamic>? lastListBranchesQuery;
  int? lastHomeBranchId;

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
  }) async {
    registerCalls++;
    lastRegisterEmail = email;
    return registerResult;
  }

  @override
  Future<ApiResult<bool>> requestPhoneLoginOtp({required String phone}) async {
    phoneOtpCalls++;
    return phoneOtpResult;
  }

  @override
  Future<ApiResult<bool>> requestPasswordForgot({required String email}) async {
    passwordForgotCalls++;
    lastForgotEmail = email;
    return passwordForgotResult;
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
  Future<ApiResult<BranchesListResult>> listBranches({
    Map<String, dynamic>? queryParameters,
  }) async {
    listBranchesCalls++;
    lastListBranchesQuery =
        queryParameters == null ? null : Map<String, dynamic>.from(queryParameters);
    return listBranchesResult;
  }

  @override
  Future<ApiResult<bool>> setHomeBranch({required int homeBranchId}) async {
    setHomeBranchCalls++;
    lastHomeBranchId = homeBranchId;
    return setHomeBranchResult;
  }
}
