import 'dart:async';
import 'dart:ui';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'auth_state.dart';
import 'auth_flow.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthState.initial()) {
    _startSplash();
  }

  // Splash logic
  void _startSplash() {
    Timer(const Duration(seconds: 2), () {
      emit(state.copyWith(flow: AuthFlow.onboarding));
    });
  }

  // Onboarding
  void goToSignUp() {
    emit(state.copyWith(flow: AuthFlow.signUp, signUpStep: 0));
  }

  void goToSignIn() {
    emit(state.copyWith(flow: AuthFlow.signIn));
  }

  // Sign Up flow (5 steps)
  void nextSignUpStep() {
    if (state.signUpStep < 3) {
      emit(state.copyWith(signUpStep: state.signUpStep + 1));
    }
  }

  void previousSignUpStep() {
    if (state.signUpStep > 0) {
      emit(state.copyWith(signUpStep: state.signUpStep - 1));
    }
  }

  void completeSignUp() {
    // later → API / token logic
    emit(state.copyWith(flow: AuthFlow.signIn));
  }

  // Language
  void changeLanguage(Locale locale) {
    emit(state.copyWith(locale: locale));
  }
}
