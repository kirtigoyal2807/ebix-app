import 'package:flutter_test/flutter_test.dart';
import 'package:pilates_app/core/network/api_result.dart';
import 'package:pilates_app/core/network/auth_locale_bridge.dart';
import 'package:pilates_app/core/network/network_exception.dart';
import 'package:pilates_app/core/storage/token_storage.dart';
import 'package:pilates_app/features/auth/cubit/auth_cubit.dart';
import 'package:pilates_app/features/auth/cubit/auth_flow.dart';
import 'package:pilates_app/features/auth/cubit/auth_state.dart';
import 'package:pilates_app/features/auth/data/models/auth_user.dart';
import 'package:pilates_app/features/auth/data/models/branch.dart';
import 'package:pilates_app/features/auth/data/models/branches_list_result.dart';
import 'package:pilates_app/features/auth/data/models/login_email_result.dart';
import 'package:pilates_app/features/auth/data/models/pagination_meta.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'fake_auth_repository.dart';

void main() {
  late FakeAuthRepository fakeRepo;
  late TokenStorage storage;
  late AuthLocaleBridge bridge;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    fakeRepo = FakeAuthRepository();
    storage = TokenStorage(await SharedPreferences.getInstance());
    bridge = AuthLocaleBridge();
  });

  AuthCubit buildCubit({AuthState? seed}) {
    return AuthCubit.forTesting(
      authRepository: fakeRepo,
      tokenStorage: storage,
      localeBridge: bridge,
      seed: seed ??
          AuthState.initial().copyWith(
            flow: AuthFlow.onboarding,
          ),
    );
  }

  group('AuthCubit register + navigation', () {
    test('register success moves signUpStep 0 to 1 and sets OTP flag', () async {
      fakeRepo.registerResult = const ApiSuccess<bool>(true);
      final cubit = buildCubit(
        seed: AuthState.initial().copyWith(
          flow: AuthFlow.signUp,
          signUpStep: 0,
        ),
      );

      await cubit.register(
        firstName: 'Noor',
        email: 'noor@example.com',
        phone: '+966500000001',
        password: 'Secret@123',
      );

      expect(cubit.state.signUpStep, 1);
      expect(cubit.state.showRegisterOtpSuccess, isTrue);
      expect(cubit.state.registerUiStatus, RegisterUiStatus.idle);
      expect(cubit.state.signUpPendingPhone, '+966500000001');
      expect(fakeRepo.registerCalls, 1);
      await cubit.close();
    });

    test('previousSignUpStep from step 0 navigates to onboarding', () async {
      final cubit = buildCubit(
        seed: AuthState.initial().copyWith(
          flow: AuthFlow.signUp,
          signUpStep: 0,
        ),
      );

      cubit.previousSignUpStep();
      expect(cubit.state.flow, AuthFlow.onboarding);
      await cubit.close();
    });
  });

  group('AuthCubit sign-up phone OTP', () {
    test('verifySignUpPhoneOtp saves token and advances to step 2', () async {
      fakeRepo.verifyPhoneOtpResult = ApiSuccess<LoginEmailResult>(
        LoginEmailResult(
          user: AuthUser(email: 'v@example.com', phone: '+966500000001'),
          token: 'jwt-phone-verify',
        ),
      );
      final cubit = buildCubit(
        seed: AuthState.initial().copyWith(
          flow: AuthFlow.signUp,
          signUpStep: 1,
          signUpPendingPhone: '+966500000001',
        ),
      );

      await cubit.verifySignUpPhoneOtp(code: '654321');

      expect(cubit.state.signUpStep, 2);
      expect(storage.readToken(), 'jwt-phone-verify');
      expect(cubit.state.user?.email, 'v@example.com');
      expect(fakeRepo.verifyPhoneOtpCalls, 1);
      expect(fakeRepo.lastVerifyPhoneOtpPhone, '+966500000001');
      expect(fakeRepo.lastVerifyPhoneOtpCode, '654321');
      await cubit.close();
    });

    test('verifySignUpPhoneOtp does nothing when not on OTP step', () async {
      final cubit = buildCubit(
        seed: AuthState.initial().copyWith(
          flow: AuthFlow.signUp,
          signUpStep: 0,
          signUpPendingPhone: '+966500000001',
        ),
      );

      await cubit.verifySignUpPhoneOtp(code: '123456');

      expect(fakeRepo.verifyPhoneOtpCalls, 0);
      await cubit.close();
    });

    test('verifySignUpPhoneOtp does nothing when code length is not 6', () async {
      final cubit = buildCubit(
        seed: AuthState.initial().copyWith(
          flow: AuthFlow.signUp,
          signUpStep: 1,
          signUpPendingPhone: '+966500000001',
        ),
      );

      await cubit.verifySignUpPhoneOtp(code: '12345');

      expect(fakeRepo.verifyPhoneOtpCalls, 0);
      await cubit.close();
    });

    test('previousSignUpStep from OTP step clears pending phone', () async {
      final cubit = buildCubit(
        seed: AuthState.initial().copyWith(
          flow: AuthFlow.signUp,
          signUpStep: 1,
          signUpPendingPhone: '+966500000001',
        ),
      );

      cubit.previousSignUpStep();

      expect(cubit.state.signUpStep, 0);
      expect(cubit.state.signUpPendingPhone, isEmpty);
      await cubit.close();
    });
  });

  group('AuthCubit sign-up experience/goals (POST /auth/goal)', () {
    test('continueSignUpExperience sets experience and opens goals step', () async {
      final cubit = buildCubit(
        seed: AuthState.initial().copyWith(
          flow: AuthFlow.signUp,
          signUpStep: 2,
        ),
      );

      cubit.continueSignUpExperience('intermediate');

      expect(cubit.state.signUpStep, 3);
      expect(cubit.state.signUpExperience, 'intermediate');
      await cubit.close();
    });

    test('submitSignUpGoalAndAdvance calls API and advances to step 4', () async {
      fakeRepo.submitUserGoalResult = const ApiSuccess<bool>(true);
      final cubit = buildCubit(
        seed: AuthState.initial().copyWith(
          flow: AuthFlow.signUp,
          signUpStep: 3,
          signUpExperience: 'beginner',
        ),
      );

      await cubit.submitSignUpGoalAndAdvance(
        goal: 'Build Strength',
        monthlyGoal: 8,
      );

      expect(cubit.state.signUpStep, 4);
      expect(fakeRepo.submitUserGoalCalls, 1);
      expect(fakeRepo.lastSubmitExperience, 'beginner');
      expect(fakeRepo.lastSubmitGoal, 'Build Strength');
      expect(fakeRepo.lastSubmitMonthlyGoal, 8);
      await cubit.close();
    });

    test('previousSignUpStep from goals clears stored experience', () async {
      final cubit = buildCubit(
        seed: AuthState.initial().copyWith(
          flow: AuthFlow.signUp,
          signUpStep: 3,
          signUpExperience: 'advanced',
        ),
      );

      cubit.previousSignUpStep();

      expect(cubit.state.signUpStep, 2);
      expect(cubit.state.signUpExperience, isEmpty);
      await cubit.close();
    });
  });

  group('AuthCubit sign-up branches', () {
    test('loadSignUpBranches loads list and pagination', () async {
      fakeRepo.listBranchesResult = ApiSuccess<BranchesListResult>(
        BranchesListResult(
          branches: const [
            Branch(
              id: 2,
              title: 'Central',
              city: 'Riyadh',
              distance: '2 km',
              typeLabel: 'Premium',
            ),
          ],
          pagination: const PaginationMeta(
            currentPage: 1,
            lastPage: 2,
            perPage: 50,
            total: 60,
          ),
        ),
      );
      final cubit = buildCubit(
        seed: AuthState.initial().copyWith(
          flow: AuthFlow.signUp,
          signUpStep: 4,
        ),
      );

      await cubit.loadSignUpBranches();

      expect(
        cubit.state.signUpBranchesLoadStatus,
        SignUpBranchesLoadStatus.loaded,
      );
      expect(cubit.state.signUpBranches, hasLength(1));
      expect(cubit.state.signUpBranches.first.id, 2);
      expect(cubit.state.signUpBranchesPagination?.total, 60);
      expect(fakeRepo.listBranchesCalls, 1);
      expect(fakeRepo.lastListBranchesQuery!['page'], 1);
      expect(fakeRepo.lastListBranchesQuery!['per_page'], 50);
      await cubit.close();
    });

    test('loadSignUpBranches failure sets failure status', () async {
      fakeRepo.listBranchesResult = ApiFailure<BranchesListResult>(
        NetworkException(
          type: NetworkFailureType.unknown,
          message: 'network down',
        ),
      );
      final cubit = buildCubit(
        seed: AuthState.initial().copyWith(
          flow: AuthFlow.signUp,
          signUpStep: 4,
        ),
      );

      await cubit.loadSignUpBranches();

      expect(
        cubit.state.signUpBranchesLoadStatus,
        SignUpBranchesLoadStatus.failure,
      );
      expect(cubit.state.signUpBranchesErrorMessage, 'network down');
      await cubit.close();
    });

    test('loadSignUpBranches does nothing when not on branch step', () async {
      final cubit = buildCubit(
        seed: AuthState.initial().copyWith(
          flow: AuthFlow.signUp,
          signUpStep: 3,
        ),
      );

      await cubit.loadSignUpBranches();

      expect(fakeRepo.listBranchesCalls, 0);
      await cubit.close();
    });

    test('submitSignUpHomeBranchAndFinish calls API and completes sign-up',
        () async {
      fakeRepo.setHomeBranchResult = const ApiSuccess<bool>(true);
      final cubit = buildCubit(
        seed: AuthState.initial().copyWith(
          flow: AuthFlow.signUp,
          signUpStep: 4,
          selectedSignUpBranchId: 7,
          signUpBranchesLoadStatus: SignUpBranchesLoadStatus.loaded,
          signUpBranches: const [
            Branch(
              id: 7,
              title: 'X',
              city: 'Y',
              distance: '1',
              typeLabel: 'Standard',
            ),
          ],
        ),
      );

      await cubit.submitSignUpHomeBranchAndFinish();

      expect(cubit.state.flow, AuthFlow.authenticated);
      expect(fakeRepo.setHomeBranchCalls, 1);
      expect(fakeRepo.lastHomeBranchId, 7);
      await cubit.close();
    });

    test('submitSignUpHomeBranchAndFinish does nothing without selection',
        () async {
      fakeRepo.setHomeBranchResult = const ApiSuccess<bool>(true);
      final cubit = buildCubit(
        seed: AuthState.initial().copyWith(
          flow: AuthFlow.signUp,
          signUpStep: 4,
          selectedSignUpBranchId: null,
        ),
      );

      await cubit.submitSignUpHomeBranchAndFinish();

      expect(fakeRepo.setHomeBranchCalls, 0);
      await cubit.close();
    });

    test('previousSignUpStep from branch step clears branch state', () async {
      final cubit = buildCubit(
        seed: AuthState.initial().copyWith(
          flow: AuthFlow.signUp,
          signUpStep: 4,
          signUpBranchesLoadStatus: SignUpBranchesLoadStatus.loaded,
          signUpBranches: const [
            Branch(
              id: 1,
              title: 'A',
              city: 'B',
              distance: '1',
              typeLabel: 'Standard',
            ),
          ],
          selectedSignUpBranchId: 1,
        ),
      );

      cubit.previousSignUpStep();

      expect(cubit.state.signUpStep, 3);
      expect(cubit.state.signUpBranches, isEmpty);
      expect(cubit.state.selectedSignUpBranchId, isNull);
      expect(
        cubit.state.signUpBranchesLoadStatus,
        SignUpBranchesLoadStatus.idle,
      );
      await cubit.close();
    });
  });

  group('AuthCubit login', () {
    test('loginWithEmail saves token and opens post-login setup', () async {
      fakeRepo.loginResult = const ApiSuccess<LoginEmailResult>(
        LoginEmailResult(
          user: AuthUser(email: 'a@b.com'),
          token: 'jwt-test',
        ),
      );
      final cubit = buildCubit(
        seed: AuthState.initial().copyWith(flow: AuthFlow.signIn),
      );

      await cubit.loginWithEmail(email: 'a@b.com', password: 'Secret@123');

      expect(cubit.state.flow, AuthFlow.postLoginSetup);
      expect(cubit.state.postLoginStep, 0);
      expect(storage.readToken(), 'jwt-test');
      expect(cubit.state.user?.email, 'a@b.com');
      await cubit.close();
    });

    test('login failure maps field errors', () async {
      fakeRepo.loginResult = ApiFailure<LoginEmailResult>(
        NetworkException(
          type: NetworkFailureType.validation,
          message: 'Bad',
          fieldErrors: {'email': ['invalid']},
        ),
      );
      final cubit = buildCubit(
        seed: AuthState.initial().copyWith(flow: AuthFlow.signIn),
      );

      await cubit.loginWithEmail(email: 'a@b.com', password: 'wrong');

      expect(cubit.state.flow, AuthFlow.signIn);
      expect(cubit.state.loginFieldErrors['email'], 'invalid');
      await cubit.close();
    });

    test('requestPhoneLoginOtp success toggles phone OTP banner', () async {
      fakeRepo.phoneOtpResult = const ApiSuccess<bool>(true);
      final cubit = buildCubit(
        seed: AuthState.initial().copyWith(flow: AuthFlow.signIn),
      );

      await cubit.requestPhoneLoginOtp(phone: '+966500000000');

      expect(cubit.state.showPhoneOtpSuccess, isTrue);
      expect(fakeRepo.phoneOtpCalls, 1);
      await cubit.close();
    });
  });

  group('AuthCubit forgot password', () {
    test('requestForgotPassword success sets email', () async {
      fakeRepo.passwordForgotResult = const ApiSuccess<bool>(true);
      final cubit = buildCubit(
        seed: AuthState.initial().copyWith(flow: AuthFlow.signIn),
      );

      await cubit.requestForgotPassword('noor@example.com');

      expect(cubit.state.forgotPasswordUiStatus, ForgotPasswordUiStatus.idle);
      expect(cubit.state.forgotPasswordEmail, 'noor@example.com');
      expect(cubit.state.forgotPasswordErrorMessage, isEmpty);
      expect(fakeRepo.passwordForgotCalls, 1);
      expect(fakeRepo.lastForgotEmail, 'noor@example.com');
      await cubit.close();
    });

    test('verifyForgotEmailCode success sets verified flag', () async {
      fakeRepo.verifyEmailCodeResult = const ApiSuccess<bool>(true);
      final cubit = buildCubit(
        seed: AuthState.initial().copyWith(flow: AuthFlow.signIn),
      );

      await cubit.verifyForgotEmailCode(
        email: 'noor@example.com',
        code: '123456',
      );

      expect(cubit.state.forgotEmailCodeVerified, isTrue);
      expect(fakeRepo.verifyEmailCodeCalls, 1);
      expect(fakeRepo.lastVerifyCode, '123456');
      await cubit.close();
    });

    test('resetForgotPassword success clears forgot flow', () async {
      fakeRepo.resetPasswordResult = const ApiSuccess<bool>(true);
      final cubit = buildCubit(
        seed: AuthState.initial().copyWith(
          flow: AuthFlow.signIn,
          forgotPasswordEmail: 'noor@example.com',
          forgotEmailCodeVerified: true,
        ),
      );

      await cubit.resetForgotPassword(
        email: 'noor@example.com',
        password: 'NewSecret@123',
      );

      expect(cubit.state.forgotPasswordEmail, isEmpty);
      expect(cubit.state.forgotEmailCodeVerified, isFalse);
      expect(cubit.state.forgotPasswordFieldErrors, isEmpty);
      expect(fakeRepo.resetPasswordCalls, 1);
      expect(fakeRepo.lastResetPassword, 'NewSecret@123');
      await cubit.close();
    });

    test('requestForgotPassword failure maps field errors', () async {
      fakeRepo.passwordForgotResult = ApiFailure<bool>(
        NetworkException(
          type: NetworkFailureType.validation,
          message: 'not found',
          fieldErrors: {'email': ['invalid']},
        ),
      );
      final cubit = buildCubit(
        seed: AuthState.initial().copyWith(flow: AuthFlow.signIn),
      );

      await cubit.requestForgotPassword('x@y.com');

      expect(cubit.state.forgotPasswordFieldErrors['email'], 'invalid');
      await cubit.close();
    });
  });

  group('AuthCubit post-login goal', () {
    test('continuePostLoginExperience advances step and stores value', () async {
      fakeRepo.loginResult = const ApiSuccess<LoginEmailResult>(
        LoginEmailResult(
          user: AuthUser(email: 'a@b.com'),
          token: 'jwt-test',
        ),
      );
      final cubit = buildCubit(
        seed: AuthState.initial().copyWith(flow: AuthFlow.signIn),
      );

      await cubit.loginWithEmail(email: 'a@b.com', password: 'x');
      cubit.continuePostLoginExperience('intermediate');

      expect(cubit.state.postLoginStep, 1);
      expect(cubit.state.postLoginExperience, 'intermediate');
      await cubit.close();
    });

    test('submitPostLoginGoal success goes to authenticated', () async {
      fakeRepo.submitUserGoalResult = const ApiSuccess<bool>(true);
      final cubit = buildCubit(
        seed: AuthState.initial().copyWith(
          flow: AuthFlow.postLoginSetup,
          postLoginStep: 1,
          postLoginExperience: 'beginner',
        ),
      );

      await cubit.submitPostLoginGoal(
        goal: 'Build Strength',
        monthlyGoal: 12,
      );

      expect(cubit.state.flow, AuthFlow.authenticated);
      expect(fakeRepo.submitUserGoalCalls, 1);
      expect(fakeRepo.lastSubmitExperience, 'beginner');
      expect(fakeRepo.lastSubmitGoal, 'Build Strength');
      expect(fakeRepo.lastSubmitMonthlyGoal, 12);
      await cubit.close();
    });

    test('submitPostLoginGoal does nothing when experience was not set', () async {
      fakeRepo.submitUserGoalResult = const ApiSuccess<bool>(true);
      final cubit = buildCubit(
        seed: AuthState.initial().copyWith(
          flow: AuthFlow.postLoginSetup,
          postLoginStep: 1,
          postLoginExperience: '',
        ),
      );

      await cubit.submitPostLoginGoal(
        goal: 'Build Strength',
        monthlyGoal: 12,
      );

      expect(fakeRepo.submitUserGoalCalls, 0);
      expect(cubit.state.flow, AuthFlow.postLoginSetup);
      await cubit.close();
    });

    test('cancelPostLoginSetup clears token and returns to sign in', () async {
      fakeRepo.loginResult = const ApiSuccess<LoginEmailResult>(
        LoginEmailResult(
          user: AuthUser(email: 'a@b.com'),
          token: 'jwt-test',
        ),
      );
      final cubit = buildCubit(
        seed: AuthState.initial().copyWith(flow: AuthFlow.signIn),
      );

      await cubit.loginWithEmail(email: 'a@b.com', password: 'x');
      await cubit.cancelPostLoginSetup();

      expect(cubit.state.flow, AuthFlow.signIn);
      expect(storage.readToken(), isNull);
      expect(cubit.state.user, isNull);
      await cubit.close();
    });
  });
}
