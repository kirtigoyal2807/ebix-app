import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pilates_app/config/theme/app_spacing.dart';
import 'package:pilates_app/widgets/app_app_bar.dart';
import 'package:pilates_app/widgets/app_button.dart';
import 'package:pilates_app/widgets/app_scaffold.dart';
import '../../../core/localization/localization_extension.dart';
import '../cubit/auth_cubit.dart';
import 'widgets/sign_up_header.dart';
import 'widgets/sign_up_progress.dart';
import 'widgets/experience_option.dart';

class SignUpExperienceView extends StatefulWidget {
  const SignUpExperienceView({super.key});

  @override
  State<SignUpExperienceView> createState() =>
      _SignUpExperienceViewState();
}

class _SignUpExperienceViewState
    extends State<SignUpExperienceView> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBar: AppAppBar(
        onBack: () =>
            context.read<AuthCubit>().previousSignUpStep(),
      ),
      body: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Progress
            const SignUpProgress(
              currentStep: 3,
              totalSteps: 5,
            ),

            const SizedBox(height: AppSpacing.lg),

            // Header
            SignUpHeader(
              title: context.l10n.experienceTitle,
              subtitle: context.l10n.experienceSubtitle,
              step: 3,
              totalSteps: 5,
            ),

            const SizedBox(height: AppSpacing.xl),

            // Options
            ExperienceOption(
              title: context.l10n.experienceBeginner,
              description:
              context.l10n.experienceBeginnerDesc,
              selected: _selectedIndex == 0,
              onTap: () => setState(() => _selectedIndex = 0),
            ),

            const SizedBox(height: AppSpacing.md),

            ExperienceOption(
              title: context.l10n.experienceIntermediate,
              description:
              context.l10n.experienceIntermediateDesc,
              selected: _selectedIndex == 1,
              onTap: () => setState(() => _selectedIndex = 1),
            ),

            const SizedBox(height: AppSpacing.md),

            ExperienceOption(
              title: context.l10n.experienceAdvanced,
              description:
              context.l10n.experienceAdvancedDesc,
              selected: _selectedIndex == 2,
              onTap: () => setState(() => _selectedIndex = 2),
            ),

            const Spacer(),

            // Continue
            AppButton(
              label: context.l10n.next,
              onPressed: () =>
                  context.read<AuthCubit>().nextSignUpStep(),
            ),
          ],
        ),
      ),
    );
  }
}
