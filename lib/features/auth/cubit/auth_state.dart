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

/// `/auth/phone/send` (resend code) — separate from verify loading.
enum PhoneOtpSendUiStatus { idle, loading }

/// Shown on Account tab while [`GET customers/profile`] runs after switching to that tab.
enum AccountProfileRefreshStatus { idle, loading }

class AuthState extends Equatable {
  final AuthFlow flow;
  final int signUpStep; // 0 → 4
  final Locale locale;
  final ThemeMode themeMode;
  final String dateOfBirth;

  final LoginUiStatus loginUiStatus;

  /// Shown under form or snackbar; empty means none.
  final String loginErrorMessage;

  final Map<String, String> loginFieldErrors;
  final String signInPendingPhone;

  final AuthUser? user;

  /// ID of the last `pendingGift` for which we surfaced the redemption popup.
  /// Used to ensure the popup is shown only once per gift across home-tab visits.
  final String? lastShownPendingGiftId;

  final AccountProfileRefreshStatus accountProfileRefreshStatus;

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

  /// One-shot: [AuthCubit.requestForgotPassword] succeeded — [ForgotPasswordView] opens OTP then clears.
  final bool showForgotPasswordOtp;

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

  final PhoneOtpSendUiStatus phoneOtpSendUiStatus;
  final String phoneOtpSendErrorMessage;

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
    this.lastShownPendingGiftId,
    required this.accountProfileRefreshStatus,
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
    required this.showForgotPasswordOtp,
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
    required this.phoneOtpSendUiStatus,
    required this.phoneOtpSendErrorMessage,
    required this.signUpBranchesLoadStatus,
    required this.signUpBranches,
    this.signUpBranchesPagination,
    required this.signUpBranchesErrorMessage,
    required this.signUpHomeBranchStatus,
    required this.signUpHomeBranchErrorMessage,
    required this.signUpHomeBranchFieldErrors,
    this.selectedSignUpBranchId,
    required this.dateOfBirth,
  });

  factory AuthState.initial() {
    return AuthState(
      flow: AuthFlow.splash,
      signUpStep: 0,
      locale: const Locale('en'),
      themeMode: ThemeMode.system,
      loginUiStatus: LoginUiStatus.idle,
      loginErrorMessage: '',
      loginFieldErrors: const {},
      signInPendingPhone: '',
      user: null,
      lastShownPendingGiftId: null,
      accountProfileRefreshStatus: AccountProfileRefreshStatus.idle,
      showPhoneOtpSuccess: false,
      registerUiStatus: RegisterUiStatus.idle,
      registerErrorMessage: '',
      registerFieldErrors: const {},
      showRegisterOtpSuccess: false,
      forgotPasswordUiStatus: ForgotPasswordUiStatus.idle,
      forgotPasswordEmail: '',
      forgotPasswordErrorMessage: '',
      forgotPasswordFieldErrors: const {},
      forgotEmailCodeVerified: false,
      showForgotPasswordOtp: false,
      postLoginStep: 0,
      postLoginExperience: '',
      postLoginGoalUiStatus: PostLoginGoalUiStatus.idle,
      postLoginGoalErrorMessage: '',
      postLoginGoalFieldErrors: const {},
      signUpExperience: '',
      signUpPendingPhone: '',
      signUpPhoneOtpUiStatus: SignUpPhoneOtpUiStatus.idle,
      signUpPhoneOtpErrorMessage: '',
      signUpPhoneOtpFieldErrors: const {},
      phoneOtpSendUiStatus: PhoneOtpSendUiStatus.idle,
      phoneOtpSendErrorMessage: '',
      signUpBranchesLoadStatus: SignUpBranchesLoadStatus.idle,
      signUpBranches: const [],
      signUpBranchesPagination: null,
      signUpBranchesErrorMessage: '',
      signUpHomeBranchStatus: SignUpHomeBranchStatus.idle,
      signUpHomeBranchErrorMessage: '',
      signUpHomeBranchFieldErrors: const {},
      selectedSignUpBranchId: null,
      dateOfBirth: '',
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
    String? lastShownPendingGiftId,
    bool clearLastShownPendingGiftId = false,
    AccountProfileRefreshStatus? accountProfileRefreshStatus,
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
    bool? showForgotPasswordOtp,
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
    PhoneOtpSendUiStatus? phoneOtpSendUiStatus,
    String? phoneOtpSendErrorMessage,
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
    String? dateOfBirth,
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
      lastShownPendingGiftId: clearLastShownPendingGiftId
          ? null
          : (lastShownPendingGiftId ?? this.lastShownPendingGiftId),
      accountProfileRefreshStatus:
          accountProfileRefreshStatus ?? this.accountProfileRefreshStatus,
      showPhoneOtpSuccess: showPhoneOtpSuccess ?? this.showPhoneOtpSuccess,
      registerUiStatus: registerUiStatus ?? this.registerUiStatus,
      registerErrorMessage: registerErrorMessage ?? this.registerErrorMessage,
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
      showForgotPasswordOtp:
          showForgotPasswordOtp ?? this.showForgotPasswordOtp,
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
      phoneOtpSendUiStatus: phoneOtpSendUiStatus ?? this.phoneOtpSendUiStatus,
      phoneOtpSendErrorMessage:
          phoneOtpSendErrorMessage ?? this.phoneOtpSendErrorMessage,
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
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
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
      showForgotPasswordOtp: false,
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
      phoneOtpSendUiStatus: PhoneOtpSendUiStatus.idle,
      phoneOtpSendErrorMessage: '',
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
      phoneOtpSendUiStatus: PhoneOtpSendUiStatus.idle,
      phoneOtpSendErrorMessage: '',
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
    lastShownPendingGiftId,
    accountProfileRefreshStatus,
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
    showForgotPasswordOtp,
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
    phoneOtpSendUiStatus,
    phoneOtpSendErrorMessage,
    signUpBranchesLoadStatus,
    signUpBranches,
    signUpBranchesPagination,
    signUpBranchesErrorMessage,
    signUpHomeBranchStatus,
    signUpHomeBranchErrorMessage,
    signUpHomeBranchFieldErrors,
    selectedSignUpBranchId,
    dateOfBirth,
  ];
}

/// Cold-start [AuthState] from persisted JWT — must stay in sync with [main] / [AuthCubit] seeding.
AuthState initialAuthStateFromTokenStorage(TokenStorage tokenStorage) {
  final hasSavedSession = (tokenStorage.readToken() ?? '').trim().isNotEmpty;
  final storedLang = tokenStorage.readAppLocaleLanguageCode();
  final locale = storedLang == 'ar' ? const Locale('ar') : const Locale('en');
  return AuthState.initial().copyWith(
    flow: hasSavedSession ? AuthFlow.authenticated : AuthFlow.splash,
    locale: locale,
  );
}
