import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:pilates_app/features/auth/data/models/auth_user.dart';

import 'auth_flow.dart';

enum LoginUiStatus { idle, loading }

enum RegisterUiStatus { idle, loading }

enum ForgotPasswordUiStatus { idle, loading }

enum PostLoginGoalUiStatus { idle, loading }

class AuthState extends Equatable {
  final AuthFlow flow;
  final int signUpStep; // 0 → 4
  final Locale locale;
  final ThemeMode themeMode;

  final LoginUiStatus loginUiStatus;

  /// Shown under form or snackbar; empty means none.
  final String loginErrorMessage;

  final Map<String, String> loginFieldErrors;

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

  const AuthState({
    required this.flow,
    required this.signUpStep,
    required this.locale,
    required this.themeMode,
    required this.loginUiStatus,
    required this.loginErrorMessage,
    required this.loginFieldErrors,
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
  }) {
    return AuthState(
      flow: flow ?? this.flow,
      signUpStep: signUpStep ?? this.signUpStep,
      locale: locale ?? this.locale,
      themeMode: themeMode ?? this.themeMode,
      loginUiStatus: loginUiStatus ?? this.loginUiStatus,
      loginErrorMessage: loginErrorMessage ?? this.loginErrorMessage,
      loginFieldErrors: loginFieldErrors ?? this.loginFieldErrors,
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

  @override
  List<Object?> get props => [
        flow,
        signUpStep,
        locale,
        themeMode,
        loginUiStatus,
        loginErrorMessage,
        loginFieldErrors,
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
      ];
}
