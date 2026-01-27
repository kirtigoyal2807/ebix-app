import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pilates_app/config/theme/app_spacing.dart';
import 'package:pilates_app/config/theme/app_text_styles.dart';
import 'package:pilates_app/widgets/app_app_bar.dart';
import 'package:pilates_app/widgets/app_button.dart';
import 'package:pilates_app/widgets/app_scaffold.dart';
import 'package:pilates_app/widgets/app_text.dart';
import '../../../core/localization/localization_extension.dart';
import '../cubit/auth_cubit.dart';
import 'widgets/sign_up_header.dart';
import 'widgets/sign_up_progress.dart';
import 'widgets/branch_option.dart';

class SignUpBranchView extends StatefulWidget {
  const SignUpBranchView({super.key});

  @override
  State<SignUpBranchView> createState() => _SignUpBranchViewState();
}

class _SignUpBranchViewState extends State<SignUpBranchView> {
  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBar: AppAppBar(
        onBack: () =>
            context.read<AuthCubit>().previousSignUpStep(),
        title: context.l10n.selectedBranch,
      ),
      body: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Progress
            const SignUpProgress(
              currentStep: 4,
              totalSteps: 5,
            ),
            const SizedBox(height: AppSpacing.sm),
            AppText(
              'Step ${0 + 5} of ${5}',
              style: AppTextStyles.caption,
            ),
            const SizedBox(height: AppSpacing.lg),

            // Header
            SignUpHeader(
              title: context.l10n.branchTitle,
              subtitle: context.l10n.branchSubtitle,
              step: 4,
              totalSteps: 5,
            ),

            const SizedBox(height: AppSpacing.lg),

            // Branch list (static for now)
            BranchOption(
              title: 'Balad, Al Al Munawarah',
              city: 'Al Madinah Al Munawarah',
              distance: '5 km away',
              type: 'Premium',
              selected: true,
              onTap: () => setState(() => _selectedIndex = 0),
            ),

            const SizedBox(height: AppSpacing.md),

            BranchOption(
              title: 'Prince Abdul Majeed Street',
              city: 'Al Madinah Al Munawarah',
              distance: '8 km away',
              type: 'Standard',
              selected: false,
              onTap: () => setState(() => _selectedIndex = 1),
            ),
            const Spacer(),

            // Finish
            AppButton(
              label: context.l10n.finishSignUp,
              onPressed: () =>
                  context.read<AuthCubit>().completeSignUp(),

            ),
          ],
        ),
      ),
    );
  }
}
