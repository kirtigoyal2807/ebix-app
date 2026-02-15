import 'dart:ui';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'auth_flow.dart';

class AuthState extends Equatable {
  final AuthFlow flow;
  final int signUpStep; // 0 → 4
  final Locale locale;
  final ThemeMode themeMode;

  const AuthState({
    required this.flow,
    required this.signUpStep,
    required this.locale,
    required this.themeMode,
  });

  factory AuthState.initial() {
    return const AuthState(
      flow: AuthFlow.splash,
      signUpStep: 0,
      locale: Locale('en'),
      themeMode: ThemeMode.system,
    );
  }

  AuthState copyWith({
    AuthFlow? flow,
    int? signUpStep,
    Locale? locale,
    ThemeMode? themeMode,
  }) {
    return AuthState(
      flow: flow ?? this.flow,
      signUpStep: signUpStep ?? this.signUpStep,
      locale: locale ?? this.locale,
      themeMode: themeMode ?? this.themeMode,
    );
  }

  @override
  List<Object?> get props => [flow, signUpStep, locale,themeMode];
}
