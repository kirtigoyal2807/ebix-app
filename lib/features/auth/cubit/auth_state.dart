import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:pilates_app/core/storage/token_storage.dart';
import 'package:pilates_app/features/auth/data/models/auth_user.dart';
import 'package:pilates_app/features/auth/data/models/branch.dart';
import 'package:pilates_app/features/auth/data/models/pagination_meta.dart';

import 'auth_flow.dart';

enum LoginUiStatus { idle, loading }

enum RegisterUiStatus { idle, loading }

enum ForgotPasswordUiStatus { idle, loading }

enum PostLoginGoalUiStatus { idle, loading }

enum SignUpBranchesLoadStatus { idle, loading, loaded, failure }

enum SignUpHomeBranchStatus { idle, loading }

enum SignUpPhoneOtpUiStatus { idle, loading }

class AuthState extends Equatable {
  final AuthFlow flow;
  final int signUpStep; // 0 → 4
  final Locale locale;
  final ThemeMode themeMode;

  final LoginUiStatus loginUiStatus;

  /// Shown under form or snackbar; empty means none.
  final String loginErrorMessage;

  final Map<String, String> loginFieldErrors;
  final String signInPendingPhone;

  final AuthUser? user;

  /// One-shot: phone OTP request succeeded — UI shows snackbar then clears.
  final bool showPhoneOtpSuccess;

  final RegisterUiStatus registerUiStatus;
  final String registerErrorMessage;
  final Map<String, String> registerFieldErrors;

  /// One-shot: `/auth/register` succeeded (OTP sent).
  final bool showRegisterOtpSuccess;

  /// Forgot password (navigator stack from sign-in).
  final ForgotPasswordUiStatus forgotPasswordUiStatus;
  final String forgotPasswordEmail;
  final String forgotPasswordErrorMessage;
  final Map<String, String> forgotPasswordFieldErrors;

  /// `true` after `POST /auth/email/verify` succeeds (step 2).
  final bool forgotEmailCodeVerified;

  /// After email login: 0 = experience, 1 = goals (+ API).
  final int postLoginStep;

  /// API `experience` value, e.g. `beginner` — set before goals screen.
  final String postLoginExperience;

  final PostLoginGoalUiStatus postLoginGoalUiStatus;
  final String postLoginGoalErrorMessage;
  final Map<String, String> postLoginGoalFieldErrors;

  /// Sign-up step 2→3: API `experience` for [submitUserGoal] on [SignUpGoalView].
  final String signUpExperience;

  /// Phone (E.164) pending `POST /auth/phone/verify` after [`POST /auth/register`].
  final String signUpPendingPhone;

  final SignUpPhoneOtpUiStatus signUpPhoneOtpUiStatus;
  final String signUpPhoneOtpErrorMessage;
  final Map<String, String> signUpPhoneOtpFieldErrors;

  /// Sign-up branch step: `GET /branches` + `POST /auth/home-branch`.
  final SignUpBranchesLoadStatus signUpBranchesLoadStatus;
  final List<Branch> signUpBranches;
  final PaginationMeta? signUpBranchesPagination;
  final String signUpBranchesErrorMessage;
  final SignUpHomeBranchStatus signUpHomeBranchStatus;
  final String signUpHomeBranchErrorMessage;
  final Map<String, String> signUpHomeBranchFieldErrors;
  final int? selectedSignUpBranchId;

  const AuthState({
    required this.flow,
    required this.signUpStep,
    required this.locale,
    required this.themeMode,
    required this.loginUiStatus,
    required this.loginErrorMessage,
    required this.loginFieldErrors,
    required this.signInPendingPhone,
    this.user,
    required this.showPhoneOtpSuccess,
    required this.registerUiStatus,
    required this.registerErrorMessage,
    required this.registerFieldErrors,
    required this.showRegisterOtpSuccess,
    required this.forgotPasswordUiStatus,
    required this.forgotPasswordEmail,
    required this.forgotPasswordErrorMessage,
    required this.forgotPasswordFieldErrors,
    required this.forgotEmailCodeVerified,
    required this.postLoginStep,
    required this.postLoginExperience,
    required this.postLoginGoalUiStatus,
    required this.postLoginGoalErrorMessage,
    required this.postLoginGoalFieldErrors,
    required this.signUpExperience,
    required this.signUpPendingPhone,
    required this.signUpPhoneOtpUiStatus,
    required this.signUpPhoneOtpErrorMessage,
    required this.signUpPhoneOtpFieldErrors,
    required this.signUpBranchesLoadStatus,
    required this.signUpBranches,
    this.signUpBranchesPagination,
    required this.signUpBranchesErrorMessage,
    required this.signUpHomeBranchStatus,
    required this.signUpHomeBranchErrorMessage,
    required this.signUpHomeBranchFieldErrors,
    this.selectedSignUpBranchId,
  });

  factory AuthState.initial() {
    return const AuthState(
      flow: AuthFlow.splash,
      signUpStep: 0,
      locale: Locale('en'),
      themeMode: ThemeMode.system,
      loginUiStatus: LoginUiStatus.idle,
      loginErrorMessage: '',
      loginFieldErrors: {},
      signInPendingPhone: '',
      user: null,
      showPhoneOtpSuccess: false,
      registerUiStatus: RegisterUiStatus.idle,
      registerErrorMessage: '',
      registerFieldErrors: {},
      showRegisterOtpSuccess: false,
      forgotPasswordUiStatus: ForgotPasswordUiStatus.idle,
      forgotPasswordEmail: '',
      forgotPasswordErrorMessage: '',
      forgotPasswordFieldErrors: {},
      forgotEmailCodeVerified: false,
      postLoginStep: 0,
      postLoginExperience: '',
      postLoginGoalUiStatus: PostLoginGoalUiStatus.idle,
      postLoginGoalErrorMessage: '',
      postLoginGoalFieldErrors: {},
      signUpExperience: '',
      signUpPendingPhone: '',
      signUpPhoneOtpUiStatus: SignUpPhoneOtpUiStatus.idle,
      signUpPhoneOtpErrorMessage: '',
      signUpPhoneOtpFieldErrors: {},
      signUpBranchesLoadStatus: SignUpBranchesLoadStatus.idle,
      signUpBranches: [],
      signUpBranchesPagination: null,
      signUpBranchesErrorMessage: '',
      signUpHomeBranchStatus: SignUpHomeBranchStatus.idle,
      signUpHomeBranchErrorMessage: '',
      signUpHomeBranchFieldErrors: {},
      selectedSignUpBranchId: null,
    );
  }

  AuthState copyWith({
    AuthFlow? flow,
    int? signUpStep,
    Locale? locale,
    ThemeMode? themeMode,
    LoginUiStatus? loginUiStatus,
    String? loginErrorMessage,
    Map<String, String>? loginFieldErrors,
    String? signInPendingPhone,
    bool clearSignInPendingPhone = false,
    AuthUser? user,
    bool clearUser = false,
    bool? showPhoneOtpSuccess,
    RegisterUiStatus? registerUiStatus,
    String? registerErrorMessage,
    Map<String, String>? registerFieldErrors,
    bool? showRegisterOtpSuccess,
    ForgotPasswordUiStatus? forgotPasswordUiStatus,
    String? forgotPasswordEmail,
    String? forgotPasswordErrorMessage,
    Map<String, String>? forgotPasswordFieldErrors,
    bool? forgotEmailCodeVerified,
    int? postLoginStep,
    String? postLoginExperience,
    PostLoginGoalUiStatus? postLoginGoalUiStatus,
    String? postLoginGoalErrorMessage,
    Map<String, String>? postLoginGoalFieldErrors,
    String? signUpExperience,
    String? signUpPendingPhone,
    bool clearSignUpPendingPhone = false,
    SignUpPhoneOtpUiStatus? signUpPhoneOtpUiStatus,
    String? signUpPhoneOtpErrorMessage,
    Map<String, String>? signUpPhoneOtpFieldErrors,
    SignUpBranchesLoadStatus? signUpBranchesLoadStatus,
    List<Branch>? signUpBranches,
    PaginationMeta? signUpBranchesPagination,
    bool clearSignUpBranchesPagination = false,
    String? signUpBranchesErrorMessage,
    SignUpHomeBranchStatus? signUpHomeBranchStatus,
    String? signUpHomeBranchErrorMessage,
    Map<String, String>? signUpHomeBranchFieldErrors,
    int? selectedSignUpBranchId,
    bool clearSelectedSignUpBranchId = false,
  }) {
    return AuthState(
      flow: flow ?? this.flow,
      signUpStep: signUpStep ?? this.signUpStep,
      locale: locale ?? this.locale,
      themeMode: themeMode ?? this.themeMode,
      loginUiStatus: loginUiStatus ?? this.loginUiStatus,
      loginErrorMessage: loginErrorMessage ?? this.loginErrorMessage,
      loginFieldErrors: loginFieldErrors ?? this.loginFieldErrors,
      signInPendingPhone: clearSignInPendingPhone
          ? ''
          : (signInPendingPhone ?? this.signInPendingPhone),
      user: clearUser ? null : (user ?? this.user),
      showPhoneOtpSuccess: showPhoneOtpSuccess ?? this.showPhoneOtpSuccess,
      registerUiStatus: registerUiStatus ?? this.registerUiStatus,
      registerErrorMessage:
          registerErrorMessage ?? this.registerErrorMessage,
      registerFieldErrors: registerFieldErrors ?? this.registerFieldErrors,
      showRegisterOtpSuccess:
          showRegisterOtpSuccess ?? this.showRegisterOtpSuccess,
      forgotPasswordUiStatus:
          forgotPasswordUiStatus ?? this.forgotPasswordUiStatus,
      forgotPasswordEmail: forgotPasswordEmail ?? this.forgotPasswordEmail,
      forgotPasswordErrorMessage:
          forgotPasswordErrorMessage ?? this.forgotPasswordErrorMessage,
      forgotPasswordFieldErrors:
          forgotPasswordFieldErrors ?? this.forgotPasswordFieldErrors,
      forgotEmailCodeVerified:
          forgotEmailCodeVerified ?? this.forgotEmailCodeVerified,
      postLoginStep: postLoginStep ?? this.postLoginStep,
      postLoginExperience: postLoginExperience ?? this.postLoginExperience,
      postLoginGoalUiStatus:
          postLoginGoalUiStatus ?? this.postLoginGoalUiStatus,
      postLoginGoalErrorMessage:
          postLoginGoalErrorMessage ?? this.postLoginGoalErrorMessage,
      postLoginGoalFieldErrors:
          postLoginGoalFieldErrors ?? this.postLoginGoalFieldErrors,
      signUpExperience: signUpExperience ?? this.signUpExperience,
      signUpPendingPhone: clearSignUpPendingPhone
          ? ''
          : (signUpPendingPhone ?? this.signUpPendingPhone),
      signUpPhoneOtpUiStatus:
          signUpPhoneOtpUiStatus ?? this.signUpPhoneOtpUiStatus,
      signUpPhoneOtpErrorMessage:
          signUpPhoneOtpErrorMessage ?? this.signUpPhoneOtpErrorMessage,
      signUpPhoneOtpFieldErrors:
          signUpPhoneOtpFieldErrors ?? this.signUpPhoneOtpFieldErrors,
      signUpBranchesLoadStatus:
          signUpBranchesLoadStatus ?? this.signUpBranchesLoadStatus,
      signUpBranches: signUpBranches ?? this.signUpBranches,
      signUpBranchesPagination: clearSignUpBranchesPagination
          ? null
          : (signUpBranchesPagination ?? this.signUpBranchesPagination),
      signUpBranchesErrorMessage:
          signUpBranchesErrorMessage ?? this.signUpBranchesErrorMessage,
      signUpHomeBranchStatus:
          signUpHomeBranchStatus ?? this.signUpHomeBranchStatus,
      signUpHomeBranchErrorMessage:
          signUpHomeBranchErrorMessage ?? this.signUpHomeBranchErrorMessage,
      signUpHomeBranchFieldErrors:
          signUpHomeBranchFieldErrors ?? this.signUpHomeBranchFieldErrors,
      selectedSignUpBranchId: clearSelectedSignUpBranchId
          ? null
          : (selectedSignUpBranchId ?? this.selectedSignUpBranchId),
    );
  }

  /// Clears forgot-password API session (e.g. after login or when leaving sign-in flow).
  AuthState clearedForgotPasswordFlow() {
    return copyWith(
      forgotPasswordUiStatus: ForgotPasswordUiStatus.idle,
      forgotPasswordEmail: '',
      forgotPasswordErrorMessage: '',
      forgotPasswordFieldErrors: {},
      forgotEmailCodeVerified: false,
    );
  }

  /// Resets post-login experience/goals draft (e.g. after submit or leaving sign-in).
  AuthState clearedPostLoginProfile() {
    return copyWith(
      postLoginStep: 0,
      postLoginExperience: '',
      postLoginGoalUiStatus: PostLoginGoalUiStatus.idle,
      postLoginGoalErrorMessage: '',
      postLoginGoalFieldErrors: {},
    );
  }

  /// Clears phone-login OTP draft (when leaving sign-in or returning to phone form).
  AuthState clearedSignInPhoneVerification() {
    return copyWith(
      clearSignInPendingPhone: true,
      loginUiStatus: LoginUiStatus.idle,
      loginErrorMessage: '',
      loginFieldErrors: {},
      showPhoneOtpSuccess: false,
    );
  }

  AuthState clearedSignUpBranchUi() {
    return copyWith(
      signUpBranchesLoadStatus: SignUpBranchesLoadStatus.idle,
      signUpBranches: [],
      clearSignUpBranchesPagination: true,
      signUpBranchesErrorMessage: '',
      signUpHomeBranchStatus: SignUpHomeBranchStatus.idle,
      signUpHomeBranchErrorMessage: '',
      signUpHomeBranchFieldErrors: {},
      clearSelectedSignUpBranchId: true,
    );
  }

  /// Clears phone OTP step draft (when leaving sign-up or restarting).
  AuthState clearedSignUpPhoneVerification() {
    return copyWith(
      clearSignUpPendingPhone: true,
      signUpPhoneOtpUiStatus: SignUpPhoneOtpUiStatus.idle,
      signUpPhoneOtpErrorMessage: '',
      signUpPhoneOtpFieldErrors: {},
    );
  }

  @override
  List<Object?> get props => [
        flow,
        signUpStep,
        locale,
        themeMode,
        loginUiStatus,
        loginErrorMessage,
        loginFieldErrors,
        signInPendingPhone,
        user,
        showPhoneOtpSuccess,
        registerUiStatus,
        registerErrorMessage,
        registerFieldErrors,
        showRegisterOtpSuccess,
        forgotPasswordUiStatus,
        forgotPasswordEmail,
        forgotPasswordErrorMessage,
        forgotPasswordFieldErrors,
        forgotEmailCodeVerified,
        postLoginStep,
        postLoginExperience,
        postLoginGoalUiStatus,
        postLoginGoalErrorMessage,
        postLoginGoalFieldErrors,
        signUpExperience,
        signUpPendingPhone,
        signUpPhoneOtpUiStatus,
        signUpPhoneOtpErrorMessage,
        signUpPhoneOtpFieldErrors,
        signUpBranchesLoadStatus,
        signUpBranches,
        signUpBranchesPagination,
        signUpBranchesErrorMessage,
        signUpHomeBranchStatus,
        signUpHomeBranchErrorMessage,
        signUpHomeBranchFieldErrors,
        selectedSignUpBranchId,
      ];
}

/// Cold-start [AuthState] from persisted JWT — must stay in sync with [main] / [AuthCubit] seeding.
AuthState initialAuthStateFromTokenStorage(TokenStorage tokenStorage) {
  final hasSavedSession =
      (tokenStorage.readToken() ?? '').trim().isNotEmpty;
  return AuthState.initial().copyWith(
    flow: hasSavedSession ? AuthFlow.authenticated : AuthFlow.splash,
  );
}
