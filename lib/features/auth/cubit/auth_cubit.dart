import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:pilates_app/core/network/api_result.dart';
import 'package:pilates_app/core/network/network_exception.dart';
import 'package:pilates_app/core/network/auth_locale_bridge.dart';
import 'package:pilates_app/core/storage/token_storage.dart';
import 'package:pilates_app/features/auth/data/auth_repository.dart';
import 'package:pilates_app/features/auth/data/models/branches_list_result.dart';
import 'package:pilates_app/features/auth/data/models/login_email_result.dart';
import 'package:pilates_app/features/auth/data/models/profile_verify_phone_result.dart';
import 'package:pilates_app/features/auth/data/models/register_gender.dart';
import 'package:pilates_app/features/auth/data/models/auth_user.dart';

import 'auth_flow.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepository _authRepository;
  final TokenStorage _tokenStorage;
  final AuthLocaleBridge _localeBridge;

  bool _logoutInFlight = false;
  Future<void>? _profileRefreshFuture;
  Future<void>? _authMeRefreshFuture;
  bool _splashPendingConnectivity = false;
  bool _splashStarted = false;

  /// [seed] is normally computed in [main] from [TokenStorage]: if a JWT exists,
  /// [AuthFlow.authenticated] skips splash/onboarding on cold start.
  AuthCubit({
    required AuthRepository authRepository,
    required TokenStorage tokenStorage,
    required AuthLocaleBridge localeBridge,
    AuthState? seed,
  }) : this._impl(
         authRepository: authRepository,
         tokenStorage: tokenStorage,
         localeBridge: localeBridge,
         seed: seed ?? AuthState.initial(),
         startSplash: (seed ?? AuthState.initial()).flow == AuthFlow.splash,
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
  }) : _authRepository = authRepository,
       _tokenStorage = tokenStorage,
       _localeBridge = localeBridge,
       super(seed.copyWith(user: tokenStorage.readUser())) {
    _localeBridge.languageCode = state.locale.languageCode;
    if (startSplash) {
      _splashPendingConnectivity = true;
    }
  }

  /// Called when [AppBootstrapView] confirms the device has network access.
  void onConnectivityReady() {
    if (_splashPendingConnectivity && !_splashStarted) {
      _splashPendingConnectivity = false;
      _splashStarted = true;
      _startSplash();
    }
  }

  AuthRepository get authRepository => _authRepository;
  TokenStorage get tokenStorage => _tokenStorage;

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
          .clearedSignInPhoneVerification()
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
          .clearedPostLoginProfile()
          .clearedSignInPhoneVerification(),
    );
  }

  void backFromSignIn() {
    if (state.signInPendingPhone.isNotEmpty) {
      emit(state.clearedSignInPhoneVerification());
      return;
    }
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
          .clearedPostLoginProfile()
          .clearedSignInPhoneVerification(),
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
    emit(state.copyWith(signUpExperience: experience, signUpStep: 3));
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
        emit(state.copyWith(signUpStep: 0).clearedSignUpPhoneVerification());
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
          postLoginGoalUiStatus: ns < 3
              ? PostLoginGoalUiStatus.idle
              : state.postLoginGoalUiStatus,
          postLoginGoalErrorMessage: ns < 3
              ? ''
              : state.postLoginGoalErrorMessage,
          postLoginGoalFieldErrors: ns < 3
              ? {}
              : state.postLoginGoalFieldErrors,
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
        await _tokenStorage.saveUser(data.user);
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

  /// Resend OTP on sign-up step 2 — `POST /auth/phone/send`.
  /// Returns `true` if a network request was made (success or failure), `false` if skipped.
  Future<bool> resendSignUpPhoneOtp() async {
    if (state.flow != AuthFlow.signUp || state.signUpStep != 1) {
      return false;
    }
    if (state.phoneOtpSendUiStatus == PhoneOtpSendUiStatus.loading) {
      return false;
    }
    final phone = state.signUpPendingPhone.trim();
    if (phone.isEmpty) {
      return false;
    }

    emit(
      state.copyWith(
        phoneOtpSendUiStatus: PhoneOtpSendUiStatus.loading,
        phoneOtpSendErrorMessage: '',
      ),
    );

    final result = await _authRepository.sendPhoneOtp(phone: phone);

    switch (result) {
      case ApiSuccess<bool>():
        emit(
          state.copyWith(
            phoneOtpSendUiStatus: PhoneOtpSendUiStatus.idle,
            phoneOtpSendErrorMessage: '',
          ),
        );
      case ApiFailure<bool>(:final exception):
        emit(
          state.copyWith(
            phoneOtpSendUiStatus: PhoneOtpSendUiStatus.idle,
            phoneOtpSendErrorMessage: exception.message ?? '',
          ),
        );
    }
    return true;
  }

  /// `GET /branches` when sign-up is on the branch step (loads once per visit).
  Future<void> loadSignUpBranches({double? lat, double? lng}) async {
    if (state.flow != AuthFlow.signUp || state.signUpStep != 4) {
      return;
    }
    emit(
      state.copyWith(
        signUpBranchesLoadStatus: SignUpBranchesLoadStatus.loading,
        signUpBranchesErrorMessage: '',
      ),
    );

    final queryParameters = <String, dynamic>{
      'page': 1,
      'per_page': 50,
      if (lat != null) 'lat': lat,
      if (lng != null) 'lng': lng,
    };

    final result = await _authRepository.listBranches(
      queryParameters: queryParameters,
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
              .copyWith(flow: AuthFlow.authenticated, signUpExperience: '')
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
          .copyWith(flow: AuthFlow.authenticated, signUpExperience: '')
          .clearedForgotPasswordFlow()
          .clearedPostLoginProfile()
          .clearedSignUpBranchUi(),
    );
  }

  // After email login — experience → goals → POST /auth/goal → home

  void continuePostLoginExperience(String experience) {
    emit(state.copyWith(postLoginExperience: experience, postLoginStep: 1));
  }

  Future<void> backPostLoginSetup() async {
    if (state.postLoginStep > 0) {
      emit(state.copyWith(postLoginStep: 0));
    } else {
      await cancelPostLoginSetup();
    }
  }

  /// `POST /auth/logout` then clear local session and open sign-in.
  Future<void> logout() async {
    if (state.flow != AuthFlow.authenticated || _logoutInFlight) {
      return;
    }
    _logoutInFlight = true;
    try {
      await _authRepository.logout();
    } finally {
      _logoutInFlight = false;
    }
    await _tokenStorage.clearToken();
    await _tokenStorage.clearUser();
    await _tokenStorage.clearMembershipPlanName();
    emit(
      state
          .copyWith(
            flow: AuthFlow.signIn,
            clearUser: true,
            clearLastShownPendingGiftId: true,
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
          .clearedForgotPasswordFlow()
          .clearedSignInPhoneVerification()
          .clearedSignUpBranchUi()
          .clearedSignUpPhoneVerification()
          .clearedProfileEmailOtp(),
    );
  }

  Future<void> cancelPostLoginSetup() async {
    await _tokenStorage.clearToken();
    await _tokenStorage.clearUser();
    await _tokenStorage.clearMembershipPlanName();
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
          .clearedForgotPasswordFlow()
          .clearedSignInPhoneVerification()
          .clearedProfileEmailOtp(),
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
          state.clearedPostLoginProfile().copyWith(
            flow: AuthFlow.authenticated,
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
        await _tokenStorage.saveUser(data.user);
        emit(
          state
              .copyWith(
                loginUiStatus: LoginUiStatus.idle,
                loginErrorMessage: '',
                loginFieldErrors: {},
                user: data.user,
                flow: AuthFlow.authenticated,
                showPhoneOtpSuccess: false,
                registerUiStatus: RegisterUiStatus.idle,
                registerErrorMessage: '',
                registerFieldErrors: {},
                showRegisterOtpSuccess: false,
              )
              .clearedForgotPasswordFlow()
              .clearedPostLoginProfile()
              .clearedSignInPhoneVerification(),
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
            phoneOtpSendUiStatus: PhoneOtpSendUiStatus.idle,
            phoneOtpSendErrorMessage: '',
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
            signInPendingPhone: phone.trim(),
            showPhoneOtpSuccess: false,
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

  Future<void> verifySignInPhoneOtp({required String code}) async {
    final phone = state.signInPendingPhone.trim();
    final otp = code.trim();
    if (state.flow != AuthFlow.signIn || phone.isEmpty || otp.length != 6) {
      return;
    }

    emit(
      state.copyWith(
        loginUiStatus: LoginUiStatus.loading,
        loginErrorMessage: '',
        loginFieldErrors: {},
      ),
    );

    final result = await _authRepository.verifyPhoneOtp(
      phone: phone,
      code: otp,
    );

    switch (result) {
      case ApiSuccess<LoginEmailResult>(:final data):
        await _tokenStorage.saveToken(data.token);
        await _tokenStorage.saveUser(data.user);
        emit(
          state
              .copyWith(
                loginUiStatus: LoginUiStatus.idle,
                loginErrorMessage: '',
                loginFieldErrors: {},
                user: data.user,
                flow: AuthFlow.authenticated,
                showPhoneOtpSuccess: false,
                registerUiStatus: RegisterUiStatus.idle,
                registerErrorMessage: '',
                registerFieldErrors: {},
                showRegisterOtpSuccess: false,
              )
              .clearedForgotPasswordFlow()
              .clearedPostLoginProfile()
              .clearedSignInPhoneVerification(),
        );
      case ApiFailure<LoginEmailResult>(:final exception):
        emit(
          state.copyWith(
            loginUiStatus: LoginUiStatus.idle,
            loginErrorMessage: exception.message ?? '',
            loginFieldErrors: _mapFieldErrors(exception),
          ),
        );
    }
  }

  /// Resend OTP on sign-in phone verification — `POST /auth/phone/send`.
  /// Returns `true` if a network request was made (success or failure), `false` if skipped.
  Future<bool> resendSignInPhoneOtp() async {
    if (state.flow != AuthFlow.signIn) {
      return false;
    }
    if (state.phoneOtpSendUiStatus == PhoneOtpSendUiStatus.loading) {
      return false;
    }
    final phone = state.signInPendingPhone.trim();
    if (phone.isEmpty) {
      return false;
    }

    emit(
      state.copyWith(
        phoneOtpSendUiStatus: PhoneOtpSendUiStatus.loading,
        phoneOtpSendErrorMessage: '',
      ),
    );

    final result = await _authRepository.sendPhoneOtp(phone: phone);

    switch (result) {
      case ApiSuccess<bool>():
        emit(
          state.copyWith(
            phoneOtpSendUiStatus: PhoneOtpSendUiStatus.idle,
            phoneOtpSendErrorMessage: '',
          ),
        );
      case ApiFailure<bool>(:final exception):
        emit(
          state.copyWith(
            phoneOtpSendUiStatus: PhoneOtpSendUiStatus.idle,
            phoneOtpSendErrorMessage: exception.message ?? '',
          ),
        );
    }
    return true;
  }

  Future<void> register({
    required String firstName,
    String? lastName,
    required String email,
    required String phone,
    required String password,
    RegisterGender? gender,
    DateTime? dob,
    String referralCode = '',
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
            phoneOtpSendUiStatus: PhoneOtpSendUiStatus.idle,
            phoneOtpSendErrorMessage: '',
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
      referralCode: referralCode,
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
            signUpPendingPhone: advanceOtp
                ? phone.trim()
                : state.signUpPendingPhone,
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

  void clearForgotPasswordOtpOffer() {
    if (state.showForgotPasswordOtp) {
      emit(state.copyWith(showForgotPasswordOtp: false));
    }
  }

  Future<void> requestForgotPassword(String email) async {
    emit(
      state.copyWith(
        forgotPasswordUiStatus: ForgotPasswordUiStatus.loading,
        forgotPasswordErrorMessage: '',
        forgotPasswordFieldErrors: {},
        showForgotPasswordOtp: false,
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
            showForgotPasswordOtp: true,
          ),
        );
      case ApiFailure<bool>(:final exception):
        emit(
          state.copyWith(
            forgotPasswordUiStatus: ForgotPasswordUiStatus.idle,
            forgotPasswordErrorMessage: exception.message ?? '',
            forgotPasswordFieldErrors: _mapFieldErrors(exception),
            showForgotPasswordOtp: false,
          ),
        );
    }
  }

  /// Forgot-password OTP screen — resend code via [AuthRepository.sendEmailVerification].
  Future<void> resendForgotPasswordEmail(String email) async {
    emit(
      state.copyWith(
        forgotPasswordUiStatus: ForgotPasswordUiStatus.loading,
        forgotPasswordErrorMessage: '',
        forgotPasswordFieldErrors: {},
        // New code invalidates prior verify; avoids OTP listener pushing reset screen on resend.
        forgotEmailCodeVerified: false,
        showForgotPasswordOtp: false,
      ),
    );

    final result = await _authRepository.sendEmailVerification(email: email);

    switch (result) {
      case ApiSuccess<bool>():
        emit(
          state.copyWith(
            forgotPasswordUiStatus: ForgotPasswordUiStatus.idle,
            forgotPasswordEmail: email.trim(),
            forgotPasswordErrorMessage: '',
            forgotPasswordFieldErrors: {},
            showForgotPasswordOtp: false,
          ),
        );
      case ApiFailure<bool>(:final exception):
        emit(
          state.copyWith(
            forgotPasswordUiStatus: ForgotPasswordUiStatus.idle,
            forgotPasswordErrorMessage: exception.message ?? '',
            forgotPasswordFieldErrors: _mapFieldErrors(exception),
            showForgotPasswordOtp: false,
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
        forgotEmailCodeVerified: false,
        showForgotPasswordOtp: false,
      ),
    );

    final result = await _authRepository.verifyEmailCode(
      email: email,
      code: code,
    );

    switch (result) {
      case ApiSuccess<bool>():
        emit(
          state.copyWith(
            forgotPasswordUiStatus: ForgotPasswordUiStatus.idle,
            forgotPasswordEmail: email.trim(),
            forgotPasswordErrorMessage: '',
            forgotPasswordFieldErrors: {},
            forgotEmailCodeVerified: true,
            showForgotPasswordOtp: false,
          ),
        );
      case ApiFailure<bool>(:final exception):
        emit(
          state.copyWith(
            forgotPasswordUiStatus: ForgotPasswordUiStatus.idle,
            forgotPasswordErrorMessage: exception.message ?? '',
            forgotPasswordFieldErrors: _mapFieldErrors(exception),
            forgotEmailCodeVerified: false,
            showForgotPasswordOtp: false,
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
        showForgotPasswordOtp: false,
      ),
    );

    final result = await _authRepository.resetPassword(
      email: email,
      password: password,
    );

    switch (result) {
      case ApiSuccess<bool>():
        emit(state.clearedForgotPasswordFlow());
      case ApiFailure<bool>(:final exception):
        emit(
          state.copyWith(
            forgotPasswordUiStatus: ForgotPasswordUiStatus.idle,
            forgotPasswordErrorMessage: exception.message ?? '',
            forgotPasswordFieldErrors: _mapFieldErrors(exception),
            showForgotPasswordOtp: false,
          ),
        );
    }
  }

  Future<void> loadProfile() async {
    final token = (_tokenStorage.readToken() ?? '').trim();
    if (token.isEmpty) {
      return;
    }

    final inFlight = _profileRefreshFuture;
    if (inFlight != null) {
      return inFlight;
    }

    final future = _loadUser(token, _authRepository.getProfile);
    _profileRefreshFuture = future;
    return future.whenComplete(() {
      if (identical(_profileRefreshFuture, future)) {
        _profileRefreshFuture = null;
      }
    });
  }

  /// Loads the authenticated user via [`GET /auth/me`] (home shell / lightweight refresh).
  Future<void> loadAuthMe() async {
    final token = (_tokenStorage.readToken() ?? '').trim();
    if (token.isEmpty) {
      return;
    }

    final inFlight = _authMeRefreshFuture;
    if (inFlight != null) {
      return inFlight;
    }

    final future = _loadUser(token, _authRepository.getAuthMe);
    _authMeRefreshFuture = future;
    return future.whenComplete(() {
      if (identical(_authMeRefreshFuture, future)) {
        _authMeRefreshFuture = null;
      }
    });
  }

  Future<void> _loadUser(
    String token,
    Future<ApiResult<AuthUser>> Function() fetch,
  ) async {
    final result = await fetch();
    if (isClosed || (_tokenStorage.readToken() ?? '').trim() != token) {
      return;
    }
    switch (result) {
      case ApiSuccess<AuthUser>(:final data):
        await _tokenStorage.saveUser(data);
        if (!isClosed) {
          emit(state.copyWith(user: data));
        }
      case ApiFailure<AuthUser>():
        // Profile load failed - keep the last known user profile.
        break;
    }
  }

  /// Re-applies the latest [AuthUser] from [TokenStorage] to [state.user].
  ///
  /// Used when another layer persists user from [`GET /auth/me`] without going
  /// through this cubit (e.g. [HomeCubit.refreshHomeAndProfileSilently]).
  void syncUserFromStorage() {
    if (isClosed || state.flow != AuthFlow.authenticated) return;
    emit(state.copyWith(user: _tokenStorage.readUser()));
  }

  /// Refreshes authenticated user via [`GET /auth/me`] on cold open and app resume.
  Future<void> refreshProfileForAppOpenOrResume() async {
    if (state.flow != AuthFlow.authenticated) {
      return;
    }
    await loadAuthMe();
  }

  /// [`GET /customers/profile`] after switching to the Account tab (not when already on it).
  Future<void> refreshProfileWhenSelectingAccountTab() async {
    emit(
      state.copyWith(
        accountProfileRefreshStatus: AccountProfileRefreshStatus.loading,
      ),
    );
    try {
      await loadProfile();
    } finally {
      emit(
        state.copyWith(
          accountProfileRefreshStatus: AccountProfileRefreshStatus.idle,
        ),
      );
    }
  }

  /// Mark the redemption popup as already presented for [giftId] so we don't
  /// re-open it on the next home-tab visit. Cleared on logout / when a new gift
  /// arrives (different ID).
  void markPendingGiftPopupShown(String giftId) {
    if (state.lastShownPendingGiftId == giftId) return;
    emit(state.copyWith(lastShownPendingGiftId: giftId));
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

  // Profile Phone Verification
  // These methods are used when updating phone number in profile

  /// Verify phone OTP for profile phone update.
  /// Does not check flow state - can be called from any flow.
  Future<void> verifyProfilePhoneOtp({
    required String phone,
    required String code,
  }) async {
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

    final result = await _authRepository.verifyProfilePhone(
      phone: phone,
      otp: trimmedCode,
    );

    switch (result) {
      case ApiSuccess<ProfileVerifyPhoneResult>(:final data):
        final newToken = data.token;
        if (newToken != null && newToken.isNotEmpty) {
          await _tokenStorage.saveToken(newToken);
        }
        await _tokenStorage.saveUser(data.user);
        emit(
          state.copyWith(
            user: data.user,
            signUpPhoneOtpUiStatus: SignUpPhoneOtpUiStatus.idle,
            signUpPhoneOtpErrorMessage: '',
            signUpPhoneOtpFieldErrors: {},
          ),
        );
      case ApiFailure<ProfileVerifyPhoneResult>(:final exception):
        final fieldErrors = _mapFieldErrors(exception);
        if (fieldErrors['code'] == null && fieldErrors['otp'] != null) {
          fieldErrors['code'] = fieldErrors['otp']!;
        }
        emit(
          state.copyWith(
            signUpPhoneOtpUiStatus: SignUpPhoneOtpUiStatus.idle,
            signUpPhoneOtpErrorMessage: exception.message ?? '',
            signUpPhoneOtpFieldErrors: fieldErrors,
          ),
        );
    }
  }

  /// Verify email code after profile email change — `POST /auth/profile/verify-email`.
  Future<void> verifyProfileEmailCode({
    required String email,
    required String code,
  }) async {
    final trimmedEmail = email.trim();
    final trimmedCode = code.trim();
    if (trimmedEmail.isEmpty || trimmedCode.length != 6) {
      return;
    }

    emit(
      state.copyWith(
        profileEmailOtpUiStatus: ProfileEmailOtpUiStatus.loading,
        profileEmailOtpErrorMessage: '',
        profileEmailOtpFieldErrors: {},
      ),
    );

    final result = await _authRepository.verifyProfileEmail(
      email: trimmedEmail,
      code: trimmedCode,
    );

    switch (result) {
      case ApiSuccess<AuthUser>(:final data):
        await _tokenStorage.saveUser(data);
        emit(
          state.copyWith(
            user: data,
            profileEmailOtpUiStatus: ProfileEmailOtpUiStatus.idle,
            profileEmailOtpErrorMessage: '',
            profileEmailOtpFieldErrors: {},
          ),
        );
      case ApiFailure<AuthUser>(:final exception):
        var fieldErrors = _mapFieldErrors(exception);
        if (fieldErrors['code'] == null && fieldErrors['email'] != null) {
          fieldErrors = Map<String, String>.from(fieldErrors)
            ..['code'] = fieldErrors['email']!;
        }
        emit(
          state.copyWith(
            profileEmailOtpUiStatus: ProfileEmailOtpUiStatus.idle,
            profileEmailOtpErrorMessage: exception.message ?? '',
            profileEmailOtpFieldErrors: fieldErrors,
          ),
        );
    }
  }

  // Language
  void changeLanguage(Locale locale) {
    _localeBridge.languageCode = locale.languageCode;
    emit(state.copyWith(locale: locale));
    unawaited(_tokenStorage.saveAppLocaleLanguageCode(locale.languageCode));
  }

  void changeTheme(ThemeMode mode) {
    emit(state.copyWith(themeMode: mode));
  }

  void changeDOB(DateTime date) {
    String formattedDate = DateFormat("dd/MM/yyyy").format(date);
    emit(state.copyWith(dateOfBirth: formattedDate));
  }
}
