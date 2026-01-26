import 'dart:ui';

import 'package:equatable/equatable.dart';
import 'auth_flow.dart';

class AuthState extends Equatable {
  final AuthFlow flow;
  final int signUpStep; // 0 → 4
  final Locale locale;

  const AuthState({
    required this.flow,
    required this.signUpStep,
    required this.locale,
  });

  factory AuthState.initial() {
    return const AuthState(
      flow: AuthFlow.splash,
      signUpStep: 0,
      locale: Locale('en'),
    );
  }

  AuthState copyWith({
    AuthFlow? flow,
    int? signUpStep,
    Locale? locale,
  }) {
    return AuthState(
      flow: flow ?? this.flow,
      signUpStep: signUpStep ?? this.signUpStep,
      locale: locale ?? this.locale,
    );
  }

  @override
  List<Object?> get props => [flow, signUpStep, locale];
}
