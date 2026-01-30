import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pilates_app/features/auth/sign_in/sign_in_view.dart';
import 'package:pilates_app/features/auth/sign_up/step_branch_view.dart';
import 'package:pilates_app/features/auth/sign_up/step_experience_view.dart';
import 'package:pilates_app/features/auth/sign_up/step_otp_view.dart';
import 'package:pilates_app/features/auth/sign_up/step_personal_info_view.dart';
import 'package:pilates_app/features/auth/splash/splash_view.dart';
import 'cubit/auth_cubit.dart';
import 'cubit/auth_state.dart';
import 'cubit/auth_flow.dart';
import 'onboarding/onboarding_view.dart';

class AuthRootView extends StatelessWidget {
  const AuthRootView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        switch (state.flow) {
          case AuthFlow.splash:
            return const SplashView();

          case AuthFlow.onboarding:
            return const OnboardingView();

          case AuthFlow.signUp:
            switch (state.signUpStep) {
              case 0:
                return const SignUpPersonalInfoView();
              case 1:
                return const SignUpOtpView();
              case 2:
                return const SignUpExperienceView();
              case 3:
                return const SignUpBranchView();
              default:
                return const SizedBox();
            }

          case AuthFlow.signIn:
            return const SignInView();
        }
      },
    );
  }
}

class _SplashPlaceholder extends StatelessWidget {
  const _SplashPlaceholder();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: Text('Splash')));
  }
}

class _OnboardingPlaceholder extends StatelessWidget {
  const _OnboardingPlaceholder();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: () => context.read<AuthCubit>().goToSignUp(),
          child: const Text('Go to Sign Up'),
        ),
      ),
    );
  }
}

class _SignUpPlaceholder extends StatelessWidget {
  final int step;

  const _SignUpPlaceholder({required this.step});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Sign Up Step ${step + 1}'),
            ElevatedButton(
              onPressed: () => context.read<AuthCubit>().nextSignUpStep(),
              child: const Text('Next'),
            ),
          ],
        ),
      ),
    );
  }
}

class _SignInPlaceholder extends StatelessWidget {
  const _SignInPlaceholder();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: Text('Sign In')));
  }
}
