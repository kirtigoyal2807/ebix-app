import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pilates_app/config/theme/app_spacing.dart';
import 'package:pilates_app/core/localization/localization_extension.dart';
import 'package:pilates_app/widgets/app_button.dart';
import 'package:pilates_app/widgets/app_scaffold.dart';
import '../cubit/auth_cubit.dart';
import '../cubit/auth_state.dart';
import 'onboarding_data.dart';
import 'widgets/onboarding_page.dart';
import 'widgets/onboarding_indicator.dart';

class OnboardingView extends StatefulWidget {
  const OnboardingView({super.key});

  @override
  State<OnboardingView> createState() => _OnboardingViewState();
}

class _OnboardingViewState extends State<OnboardingView> {
  final _controller = PageController();
  int _index = 0;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onNext() {
    context.read<AuthCubit>().goToSignUp();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      body: Column(
        children: [
          Expanded(
            child: OnboardingPage(item: onboardingItems[0])
          ),

          // OnboardingIndicator(count: onboardingItems.length, index: _index),
          const SizedBox(height: AppSpacing.lg),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
            child: AppButton(
              label: context.l10n.getStarted,
              onPressed: _onNext,
            ),
          ),

          const SizedBox(height: AppSpacing.sm),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
            child: AppButton(
              label: context.l10n.getStarted,
              onPressed: _onNext,
            ),
          ),
          const SizedBox(height: AppSpacing.lg),

        ],
      ),
    );
  }
}
