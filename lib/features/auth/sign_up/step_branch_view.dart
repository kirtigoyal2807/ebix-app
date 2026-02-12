import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pilates_app/config/theme/app_colors.dart';
import 'package:pilates_app/config/theme/app_spacing.dart';
import 'package:pilates_app/config/theme/app_text_styles.dart';
import 'package:pilates_app/widgets/app_app_bar.dart';
import 'package:pilates_app/widgets/app_button.dart';
import 'package:pilates_app/widgets/app_scaffold.dart';
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
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return AppScaffold(
      appBar: AppAppBar(
        onBack: () => context.read<AuthCubit>().previousSignUpStep(),
        title: context.l10n.selectedBranch,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.md,
        ),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Progress
                    const SignUpProgress(currentStep: 3, totalSteps: 4),
                    const SizedBox(height: AppSpacing.sm),
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: '${context.l10n.step} 4',
                            style: AppTextStyles.caption(context).copyWith(
                              color: isDark
                                  ? AppColors.languageTextDark
                                  : AppColors.languageIcon,
                            ),
                          ),
                          TextSpan(
                            text: ' ${context.l10n.offf} 4',
                            style: AppTextStyles.caption(context),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xxl),

                    // Header
                    SignUpHeader(
                      title: context.l10n.branchTitle,
                      subtitle: context.l10n.branchSubtitle,
                      step: 3,
                      totalSteps: 4,
                    ),

                    const SizedBox(height: AppSpacing.lg),

                    // Branch list (static for now)
                    BranchOption(
                      title: 'Balad, Al Al Munawarah',
                      city: 'Al Madinah Al Munawarah',
                      distance: '5 km away',
                      type: 'Premium',
                      selected: _selectedIndex == 0,
                      onTap: () => setState(() => _selectedIndex = 0),
                    ),

                    const SizedBox(height: AppSpacing.md),

                    BranchOption(
                      title: 'Prince Abdul Majeed Street',
                      city: 'Al Madinah Al Munawarah',
                      distance: '8 km away',
                      type: 'Standard',
                      selected: _selectedIndex == 1,
                      onTap: () => setState(() => _selectedIndex = 1),
                    ),

                    const SizedBox(height: AppSpacing.lg),
                  ],
                ),
              ),
            ),

            // Finish
            AppButton(
              label: context.l10n.finishSignUp,
              onPressed: () => context.read<AuthCubit>().completeSignUp(),
            ),
          ],
        ),
      ),
    );
  }
}
