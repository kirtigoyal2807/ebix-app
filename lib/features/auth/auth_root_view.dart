import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:pilates_app/core/localization/localization_extension.dart';
import 'package:pilates_app/features/auth/post_login/post_login_experience_view.dart';
import 'package:pilates_app/features/auth/post_login/post_login_goal_view.dart';
import 'package:pilates_app/features/auth/sign_in/sign_in_phone_otp_view.dart';
import 'package:pilates_app/features/auth/sign_in/sign_in_view.dart';
import 'package:pilates_app/features/auth/sign_up/step_branch_view.dart';
import 'package:pilates_app/features/auth/sign_up/step_experience_view.dart';
import 'package:pilates_app/features/auth/sign_up/step_goal_view.dart';
import 'package:pilates_app/features/auth/sign_up/step_otp_view.dart';
import 'package:pilates_app/features/auth/sign_up/step_personal_info_view.dart';
import 'cubit/auth_cubit.dart';
import 'cubit/auth_state.dart';
import 'cubit/auth_flow.dart';
import 'onboarding/onboarding_view.dart';
import '../home/home_view.dart';

class AuthRootView extends StatefulWidget {
  const AuthRootView({super.key});

  @override
  State<AuthRootView> createState() => _AuthRootViewState();
}

class _AuthRootViewState extends State<AuthRootView>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _refreshProfileForAppOpenOrResume();
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _refreshProfileForAppOpenOrResume();
    }
  }

  void _refreshProfileForAppOpenOrResume() {
    if (!mounted) return;
    unawaited(context.read<AuthCubit>().refreshProfileForAppOpenOrResume());
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listenWhen: (previous, current) =>
          current.showRegisterOtpSuccess && !previous.showRegisterOtpSuccess,
      listener: (context, state) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(context.l10n.registerOtpSent)));
        context.read<AuthCubit>().clearRegisterOtpSuccessBanner();
      },
      child: BlocBuilder<AuthCubit, AuthState>(
        builder: (context, state) {
          switch (state.flow) {
            case AuthFlow.splash:
              return Lottie.asset(
                "assets/json/splash_screen.json",
                repeat: false,
              );

            case AuthFlow.onboarding:
              return const OnboardingView();

            case AuthFlow.signUp:
              // Keep personal info + OTP in one stack so step 0 state (text fields,
              // gender dropdown) stays mounted while step 1 is shown, until OTP
              // succeeds and [signUpStep] moves past 1.
              if (state.signUpStep <= 1) {
                return IndexedStack(
                  index: state.signUpStep,
                  sizing: StackFit.expand,
                  children: const [SignUpPersonalInfoView(), SignUpOtpView()],
                );
              }
              switch (state.signUpStep) {
                case 2:
                  return const SignUpExperienceView();
                case 3:
                  return const SignUpGoalView();
                case 4:
                  return const SignUpBranchView();

                default:
                  return const SizedBox();
              }

            case AuthFlow.signIn:
              if (state.signInPendingPhone.isNotEmpty) {
                return const SignInPhoneOtpView();
              }
              return const SignInView();

            case AuthFlow.postLoginSetup:
              switch (state.postLoginStep) {
                case 0:
                  return const PostLoginExperienceView();
                case 1:
                  return const PostLoginGoalView();
                default:
                  return const SizedBox();
              }

            case AuthFlow.authenticated:
              // Load profile if user is null (app restarted with saved token)
              if (state.user == null) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  if (!mounted) return;
                  unawaited(context.read<AuthCubit>().loadProfile());
                });
              }
              return const HomeView();
          }
        },
      ),
    );
  }
}
