import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pilates_app/core/network/api_result.dart';
import 'package:pilates_app/core/network/network_exception.dart';
import 'package:pilates_app/core/network/auth_locale_bridge.dart';
import 'package:pilates_app/core/storage/token_storage.dart';
import 'package:pilates_app/features/auth/data/auth_repository.dart';
import 'package:pilates_app/features/auth/data/models/branches_list_result.dart';
import 'package:pilates_app/features/auth/data/models/login_email_result.dart';
import 'package:pilates_app/features/auth/data/models/register_gender.dart';

import 'auth_flow.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepository _authRepository;
  final TokenStorage _tokenStorage;
  final AuthLocaleBridge _localeBridge;

  AuthCubit({
    required AuthRepository authRepository,
    required TokenStorage tokenStorage,
    required AuthLocaleBridge localeBridge,
  })  : this._impl(
          authRepository: authRepository,
          tokenStorage: tokenStorage,
          localeBridge: localeBridge,
          seed: AuthState.initial(),
          startSplash: true,
        );

  /// Tests and isolated screens: no splash timer, optional [seed] state.
  @visibleForTesting
  AuthCubit.forTesting({
    required AuthRepository authRepository,
    required TokenStorage tokenStorage,
    required AuthLocaleBridge localeBridge,
    AuthState? seed,
  }) : this._impl(
          authRepository: authRepository,
          tokenStorage: tokenStorage,
          localeBridge: localeBridge,
          seed: seed ?? AuthState.initial(),
          startSplash: false,
        );

  AuthCubit._impl({
    required AuthRepository authRepository,
    required TokenStorage tokenStorage,
    required AuthLocaleBridge localeBridge,
    required AuthState seed,
    required bool startSplash,
  })  : _authRepository = authRepository,
        _tokenStorage = tokenStorage,
        _localeBridge = localeBridge,
        super(seed) {
    _localeBridge.languageCode = state.locale.languageCode;
    if (startSplash) {
      _startSplash();
    }
  }

  // Splash logic
  void _startSplash() {
    Timer(const Duration(seconds: 4), () {
      emit(state.copyWith(flow: AuthFlow.onboarding));
    });
  }

  // Onboarding
  void goToSignUp() {
    emit(
      state
          .copyWith(
            flow: AuthFlow.signUp,
            signUpStep: 0,
            loginUiStatus: LoginUiStatus.idle,
            loginErrorMessage: '',
            loginFieldErrors: {},
            showPhoneOtpSuccess: false,
            registerUiStatus: RegisterUiStatus.idle,
            registerErrorMessage: '',
            registerFieldErrors: {},
            showRegisterOtpSuccess: false,
            signUpExperience: '',
          )
          .clearedForgotPasswordFlow()
          .clearedPostLoginProfile()
          .clearedSignUpBranchUi()
          .clearedSignUpPhoneVerification(),
    );
  }

  void goToSignIn() {
    emit(
      state
          .copyWith(
            flow: AuthFlow.signIn,
            loginUiStatus: LoginUiStatus.idle,
            loginErrorMessage: '',
            loginFieldErrors: {},
            showPhoneOtpSuccess: false,
            registerUiStatus: RegisterUiStatus.idle,
            registerErrorMessage: '',
            registerFieldErrors: {},
            showRegisterOtpSuccess: false,
          )
          .clearedForgotPasswordFlow()
          .clearedPostLoginProfile(),
    );
  }

  void backFromSignIn() {
    emit(
      state
          .copyWith(
            flow: AuthFlow.onboarding,
            loginUiStatus: LoginUiStatus.idle,
            loginErrorMessage: '',
            loginFieldErrors: {},
            showPhoneOtpSuccess: false,
            registerUiStatus: RegisterUiStatus.idle,
            registerErrorMessage: '',
            registerFieldErrors: {},
            showRegisterOtpSuccess: false,
          )
          .clearedForgotPasswordFlow()
          .clearedPostLoginProfile(),
    );
  }

  // Sign Up flow (5 steps)
  void nextSignUpStep() {
    if (state.signUpStep < 4) {
      emit(state.copyWith(signUpStep: state.signUpStep + 1));
    }
  }

  /// Sign-up step 2: store [experience] (`beginner` | `intermediate` | `advanced`) and open goals.
  void continueSignUpExperience(String experience) {
    if (state.flow != AuthFlow.signUp || state.signUpStep != 2) return;
    emit(
      state.copyWith(
        signUpExperience: experience,
        signUpStep: 3,
      ),
    );
  }

  /// Sign-up step 3: `POST /auth/goal` then advance to branch step on success.
  Future<void> submitSignUpGoalAndAdvance({
    required String goal,
    required int monthlyGoal,
  }) async {
    if (state.flow != AuthFlow.signUp || state.signUpStep != 3) {
      return;
    }
    final experience = state.signUpExperience.trim();
    if (experience.isEmpty) {
      return;
    }

    emit(
      state.copyWith(
        postLoginGoalUiStatus: PostLoginGoalUiStatus.loading,
        postLoginGoalErrorMessage: '',
        postLoginGoalFieldErrors: {},
      ),
    );

    final result = await _authRepository.submitUserGoal(
      experience: experience,
      goal: goal,
      monthlyGoal: monthlyGoal,
    );

    switch (result) {
      case ApiSuccess<bool>():
        emit(
          state.copyWith(
            signUpStep: 4,
            signUpExperience: state.signUpExperience,
            postLoginGoalUiStatus: PostLoginGoalUiStatus.idle,
            postLoginGoalErrorMessage: '',
            postLoginGoalFieldErrors: {},
          ),
        );
      case ApiFailure<bool>(:final exception):
        emit(
          state.copyWith(
            postLoginGoalUiStatus: PostLoginGoalUiStatus.idle,
            postLoginGoalErrorMessage: exception.message ?? '',
            postLoginGoalFieldErrors: _mapFieldErrors(exception),
          ),
        );
    }
  }

  void previousSignUpStep() {
    if (state.signUpStep > 0) {
      final ns = state.signUpStep - 1;
      if (state.signUpStep == 1 && ns == 0) {
        emit(
          state
              .copyWith(signUpStep: 0)
              .clearedSignUpPhoneVerification(),
        );
        return;
      }
      if (state.signUpStep == 4 && ns == 3) {
        emit(
          state.copyWith(
            signUpStep: 3,
            signUpBranchesLoadStatus: SignUpBranchesLoadStatus.idle,
            signUpBranches: [],
            signUpBranchesPagination: null,
            signUpBranchesErrorMessage: '',
            signUpHomeBranchStatus: SignUpHomeBranchStatus.idle,
            signUpHomeBranchErrorMessage: '',
            signUpHomeBranchFieldErrors: {},
            clearSelectedSignUpBranchId: true,
          ),
        );
        return;
      }
      emit(
        state.copyWith(
          signUpStep: ns,
          signUpExperience: ns <= 2 ? '' : state.signUpExperience,
          postLoginGoalUiStatus:
              ns < 3 ? PostLoginGoalUiStatus.idle : state.postLoginGoalUiStatus,
          postLoginGoalErrorMessage: ns < 3 ? '' : state.postLoginGoalErrorMessage,
          postLoginGoalFieldErrors: ns < 3 ? {} : state.postLoginGoalFieldErrors,
        ),
      );
    } else if (state.flow == AuthFlow.signUp) {
      emit(
        state
            .copyWith(
              flow: AuthFlow.onboarding,
              registerUiStatus: RegisterUiStatus.idle,
              registerErrorMessage: '',
              registerFieldErrors: {},
              showRegisterOtpSuccess: false,
              signUpExperience: '',
            )
            .clearedForgotPasswordFlow()
            .clearedPostLoginProfile()
            .clearedSignUpBranchUi()
            .clearedSignUpPhoneVerification(),
      );
    }
  }

  /// Sign-up step 1: `POST /auth/phone/verify` then advance (token used for later steps).
  Future<void> verifySignUpPhoneOtp({required String code}) async {
    if (state.flow != AuthFlow.signUp || state.signUpStep != 1) {
      return;
    }
    final phone = state.signUpPendingPhone.trim();
    final trimmedCode = code.trim();
    if (phone.isEmpty || trimmedCode.length != 6) {
      return;
    }

    emit(
      state.copyWith(
        signUpPhoneOtpUiStatus: SignUpPhoneOtpUiStatus.loading,
        signUpPhoneOtpErrorMessage: '',
        signUpPhoneOtpFieldErrors: {},
      ),
    );

    final result = await _authRepository.verifyPhoneOtp(
      phone: phone,
      code: trimmedCode,
    );

    switch (result) {
      case ApiSuccess<LoginEmailResult>(:final data):
        await _tokenStorage.saveToken(data.token);
        emit(
          state.copyWith(
            signUpStep: 2,
            user: data.user,
            signUpPhoneOtpUiStatus: SignUpPhoneOtpUiStatus.idle,
            signUpPhoneOtpErrorMessage: '',
            signUpPhoneOtpFieldErrors: {},
          ),
        );
      case ApiFailure<LoginEmailResult>(:final exception):
        emit(
          state.copyWith(
            signUpPhoneOtpUiStatus: SignUpPhoneOtpUiStatus.idle,
            signUpPhoneOtpErrorMessage: exception.message ?? '',
            signUpPhoneOtpFieldErrors: _mapFieldErrors(exception),
          ),
        );
    }
  }

  /// `GET /branches` when sign-up is on the branch step (loads once per visit).
  Future<void> loadSignUpBranches() async {
    if (state.flow != AuthFlow.signUp || state.signUpStep != 4) {
      return;
    }
    emit(
      state.copyWith(
        signUpBranchesLoadStatus: SignUpBranchesLoadStatus.loading,
        signUpBranchesErrorMessage: '',
      ),
    );

    final result = await _authRepository.listBranches(
      queryParameters: const {'page': 1, 'per_page': 50},
    );

    switch (result) {
      case ApiSuccess<BranchesListResult>(:final data):
        emit(
          state.copyWith(
            signUpBranchesLoadStatus: SignUpBranchesLoadStatus.loaded,
            signUpBranches: data.branches,
            signUpBranchesPagination: data.pagination,
          ),
        );
      case ApiFailure<BranchesListResult>(:final exception):
        emit(
          state.copyWith(
            signUpBranchesLoadStatus: SignUpBranchesLoadStatus.failure,
            signUpBranchesErrorMessage: exception.message ?? '',
          ),
        );
    }
  }

  void selectSignUpBranch(int branchId) {
    emit(state.copyWith(selectedSignUpBranchId: branchId));
  }

  /// `POST /auth/home-branch` then complete registration (home).
  Future<void> submitSignUpHomeBranchAndFinish() async {
    if (state.flow != AuthFlow.signUp || state.signUpStep != 4) {
      return;
    }
    final id = state.selectedSignUpBranchId;
    if (id == null) {
      return;
    }

    emit(
      state.copyWith(
        signUpHomeBranchStatus: SignUpHomeBranchStatus.loading,
        signUpHomeBranchErrorMessage: '',
        signUpHomeBranchFieldErrors: {},
      ),
    );

    final result = await _authRepository.setHomeBranch(homeBranchId: id);

    switch (result) {
      case ApiSuccess<bool>():
        emit(
          state
              .copyWith(
                flow: AuthFlow.authenticated,
                signUpExperience: '',
              )
              .clearedForgotPasswordFlow()
              .clearedPostLoginProfile()
              .clearedSignUpBranchUi(),
        );
      case ApiFailure<bool>(:final exception):
        emit(
          state.copyWith(
            signUpHomeBranchStatus: SignUpHomeBranchStatus.idle,
            signUpHomeBranchErrorMessage: exception.message ?? '',
            signUpHomeBranchFieldErrors: _mapFieldErrors(exception),
          ),
        );
    }
  }

  @visibleForTesting
  void completeSignUpForTesting() {
    emit(
      state
          .copyWith(
            flow: AuthFlow.authenticated,
            signUpExperience: '',
          )
          .clearedForgotPasswordFlow()
          .clearedPostLoginProfile()
          .clearedSignUpBranchUi(),
    );
  }

  // After email login — experience → goals → POST /auth/goal → home

  void continuePostLoginExperience(String experience) {
    emit(
      state.copyWith(
        postLoginExperience: experience,
        postLoginStep: 1,
      ),
    );
  }

  Future<void> backPostLoginSetup() async {
    if (state.postLoginStep > 0) {
      emit(state.copyWith(postLoginStep: 0));
    } else {
      await cancelPostLoginSetup();
    }
  }

  Future<void> cancelPostLoginSetup() async {
    await _tokenStorage.clearToken();
    emit(
      state
          .copyWith(
            flow: AuthFlow.signIn,
            clearUser: true,
            loginUiStatus: LoginUiStatus.idle,
            loginErrorMessage: '',
            loginFieldErrors: {},
            showPhoneOtpSuccess: false,
            registerUiStatus: RegisterUiStatus.idle,
            registerErrorMessage: '',
            registerFieldErrors: {},
            showRegisterOtpSuccess: false,
          )
          .clearedPostLoginProfile()
          .clearedForgotPasswordFlow(),
    );
  }

  Future<void> submitPostLoginGoal({
    required String goal,
    required int monthlyGoal,
  }) async {
    final experience = state.postLoginExperience.trim();
    if (experience.isEmpty) {
      return;
    }

    emit(
      state.copyWith(
        postLoginGoalUiStatus: PostLoginGoalUiStatus.loading,
        postLoginGoalErrorMessage: '',
        postLoginGoalFieldErrors: {},
      ),
    );

    final result = await _authRepository.submitUserGoal(
      experience: experience,
      goal: goal,
      monthlyGoal: monthlyGoal,
    );

    switch (result) {
      case ApiSuccess<bool>():
        emit(
          state
              .clearedPostLoginProfile()
              .copyWith(flow: AuthFlow.authenticated),
        );
      case ApiFailure<bool>(:final exception):
        emit(
          state.copyWith(
            postLoginGoalUiStatus: PostLoginGoalUiStatus.idle,
            postLoginGoalErrorMessage: exception.message ?? '',
            postLoginGoalFieldErrors: _mapFieldErrors(exception),
          ),
        );
    }
  }

  Future<void> loginWithEmail({
    required String email,
    required String password,
  }) async {
    emit(
      state
          .copyWith(
            loginUiStatus: LoginUiStatus.loading,
            loginErrorMessage: '',
            loginFieldErrors: {},
            registerUiStatus: RegisterUiStatus.idle,
            registerErrorMessage: '',
            registerFieldErrors: {},
            showRegisterOtpSuccess: false,
          )
          .clearedForgotPasswordFlow(),
    );

    final result = await _authRepository.loginWithEmail(
      email: email,
      password: password,
    );

    switch (result) {
      case ApiSuccess<LoginEmailResult>(:final data):
        await _tokenStorage.saveToken(data.token);
        emit(
          state
              .copyWith(
                loginUiStatus: LoginUiStatus.idle,
                loginErrorMessage: '',
                loginFieldErrors: {},
                user: data.user,
                flow: AuthFlow.postLoginSetup,
                postLoginStep: 0,
                postLoginExperience: '',
                postLoginGoalUiStatus: PostLoginGoalUiStatus.idle,
                postLoginGoalErrorMessage: '',
                postLoginGoalFieldErrors: {},
                showPhoneOtpSuccess: false,
                registerUiStatus: RegisterUiStatus.idle,
                registerErrorMessage: '',
                registerFieldErrors: {},
                showRegisterOtpSuccess: false,
              )
              .clearedForgotPasswordFlow(),
        );
      case ApiFailure<LoginEmailResult>(:final exception):
        final fields = <String, String>{};
        final raw = exception.fieldErrors;
        if (raw != null) {
          for (final entry in raw.entries) {
            if (entry.value.isNotEmpty) {
              fields[entry.key.toLowerCase()] = entry.value.first;
            }
          }
        }
        emit(
          state.copyWith(
            loginUiStatus: LoginUiStatus.idle,
            loginErrorMessage: exception.message ?? '',
            loginFieldErrors: fields,
          ),
        );
    }
  }

  Future<void> requestPhoneLoginOtp({required String phone}) async {
    emit(
      state
          .copyWith(
            loginUiStatus: LoginUiStatus.loading,
            loginErrorMessage: '',
            loginFieldErrors: {},
            showPhoneOtpSuccess: false,
            registerUiStatus: RegisterUiStatus.idle,
            registerErrorMessage: '',
            registerFieldErrors: {},
            showRegisterOtpSuccess: false,
          )
          .clearedForgotPasswordFlow(),
    );

    final result = await _authRepository.requestPhoneLoginOtp(phone: phone);

    switch (result) {
      case ApiSuccess<bool>():
        emit(
          state.copyWith(
            loginUiStatus: LoginUiStatus.idle,
            loginErrorMessage: '',
            loginFieldErrors: {},
            showPhoneOtpSuccess: true,
          ),
        );
      case ApiFailure<bool>(:final exception):
        emit(
          state.copyWith(
            loginUiStatus: LoginUiStatus.idle,
            loginErrorMessage: exception.message ?? '',
            loginFieldErrors: {},
            showPhoneOtpSuccess: false,
          ),
        );
    }
  }

  void clearPhoneOtpSuccessBanner() {
    if (state.showPhoneOtpSuccess) {
      emit(state.copyWith(showPhoneOtpSuccess: false));
    }
  }

  Future<void> register({
    required String firstName,
    String? lastName,
    required String email,
    required String phone,
    required String password,
    RegisterGender? gender,
    DateTime? dob,
  }) async {
    emit(
      state
          .copyWith(
            registerUiStatus: RegisterUiStatus.loading,
            registerErrorMessage: '',
            registerFieldErrors: {},
            showRegisterOtpSuccess: false,
            loginUiStatus: LoginUiStatus.idle,
            loginErrorMessage: '',
            loginFieldErrors: {},
            showPhoneOtpSuccess: false,
          )
          .clearedForgotPasswordFlow(),
    );

    final preFlow = state.flow;
    final preStep = state.signUpStep;

    final result = await _authRepository.register(
      firstName: firstName,
      lastName: lastName,
      email: email,
      phone: phone,
      password: password,
      gender: gender,
      dob: dob,
    );

    switch (result) {
      case ApiSuccess<bool>():
        final advanceOtp = preFlow == AuthFlow.signUp && preStep == 0;
        emit(
          state.copyWith(
            registerUiStatus: RegisterUiStatus.idle,
            registerErrorMessage: '',
            registerFieldErrors: {},
            showRegisterOtpSuccess: true,
            signUpStep: advanceOtp ? 1 : state.signUpStep,
            signUpPendingPhone: advanceOtp ? phone.trim() : state.signUpPendingPhone,
            signUpPhoneOtpUiStatus: SignUpPhoneOtpUiStatus.idle,
            signUpPhoneOtpErrorMessage: '',
            signUpPhoneOtpFieldErrors: {},
          ),
        );
      case ApiFailure<bool>(:final exception):
        final fields = <String, String>{};
        final raw = exception.fieldErrors;
        if (raw != null) {
          for (final entry in raw.entries) {
            if (entry.value.isNotEmpty) {
              fields[entry.key.toLowerCase()] = entry.value.first;
            }
          }
        }
        emit(
          state.copyWith(
            registerUiStatus: RegisterUiStatus.idle,
            registerErrorMessage: exception.message ?? '',
            registerFieldErrors: fields,
            showRegisterOtpSuccess: false,
          ),
        );
    }
  }

  void clearRegisterOtpSuccessBanner() {
    if (state.showRegisterOtpSuccess) {
      emit(state.copyWith(showRegisterOtpSuccess: false));
    }
  }

  // Forgot password (routes stacked on sign-in)

  void prepareForgotPasswordFlow() {
    emit(state.clearedForgotPasswordFlow());
  }

  Future<void> requestForgotPassword(String email) async {
    emit(
      state.copyWith(
        forgotPasswordUiStatus: ForgotPasswordUiStatus.loading,
        forgotPasswordErrorMessage: '',
        forgotPasswordFieldErrors: {},
      ),
    );

    final result = await _authRepository.requestPasswordForgot(email: email);

    switch (result) {
      case ApiSuccess<bool>():
        emit(
          state.copyWith(
            forgotPasswordUiStatus: ForgotPasswordUiStatus.idle,
            forgotPasswordEmail: email.trim(),
            forgotPasswordErrorMessage: '',
            forgotPasswordFieldErrors: {},
          ),
        );
      case ApiFailure<bool>(:final exception):
        emit(
          state.copyWith(
            forgotPasswordUiStatus: ForgotPasswordUiStatus.idle,
            forgotPasswordErrorMessage: exception.message ?? '',
            forgotPasswordFieldErrors: _mapFieldErrors(exception),
          ),
        );
    }
  }

  Future<void> verifyForgotEmailCode({
    required String email,
    required String code,
  }) async {
    emit(
      state.copyWith(
        forgotPasswordUiStatus: ForgotPasswordUiStatus.loading,
        forgotPasswordErrorMessage: '',
        forgotPasswordFieldErrors: {},
      ),
    );

    final result = await _authRepository.verifyEmailCode(email: email, code: code);

    switch (result) {
      case ApiSuccess<bool>():
        emit(
          state.copyWith(
            forgotPasswordUiStatus: ForgotPasswordUiStatus.idle,
            forgotPasswordEmail: email.trim(),
            forgotPasswordErrorMessage: '',
            forgotPasswordFieldErrors: {},
            forgotEmailCodeVerified: true,
          ),
        );
      case ApiFailure<bool>(:final exception):
        emit(
          state.copyWith(
            forgotPasswordUiStatus: ForgotPasswordUiStatus.idle,
            forgotPasswordErrorMessage: exception.message ?? '',
            forgotPasswordFieldErrors: _mapFieldErrors(exception),
            forgotEmailCodeVerified: false,
          ),
        );
    }
  }

  Future<void> resetForgotPassword({
    required String email,
    required String password,
  }) async {
    emit(
      state.copyWith(
        forgotPasswordUiStatus: ForgotPasswordUiStatus.loading,
        forgotPasswordErrorMessage: '',
        forgotPasswordFieldErrors: {},
      ),
    );

    final result =
        await _authRepository.resetPassword(email: email, password: password);

    switch (result) {
      case ApiSuccess<bool>():
        emit(state.clearedForgotPasswordFlow());
      case ApiFailure<bool>(:final exception):
        emit(
          state.copyWith(
            forgotPasswordUiStatus: ForgotPasswordUiStatus.idle,
            forgotPasswordErrorMessage: exception.message ?? '',
            forgotPasswordFieldErrors: _mapFieldErrors(exception),
          ),
        );
    }
  }

  Map<String, String> _mapFieldErrors(NetworkException exception) {
    final fields = <String, String>{};
    final raw = exception.fieldErrors;
    if (raw != null) {
      for (final entry in raw.entries) {
        if (entry.value.isNotEmpty) {
          fields[entry.key.toLowerCase()] = entry.value.first;
        }
      }
    }
    return fields;
  }

  // Language
  void changeLanguage(Locale locale) {
    _localeBridge.languageCode = locale.languageCode;
    emit(state.copyWith(locale: locale));
  }

  void changeTheme(ThemeMode mode) {
    emit(state.copyWith(themeMode: mode));
  }
}
