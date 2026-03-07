import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pilates_app/config/theme/app_colors.dart';
import 'package:pilates_app/config/theme/app_spacing.dart';
import 'package:pilates_app/config/theme/app_text_styles.dart';
import 'package:pilates_app/features/auth/sign_up/widgets/experience_option.dart';
import 'package:pilates_app/features/auth/sign_up/widgets/monthly_target_slider.dart';
import 'package:pilates_app/widgets/app_app_bar.dart';
import 'package:pilates_app/widgets/app_button.dart';
import 'package:pilates_app/widgets/app_scaffold.dart';
import 'package:pilates_app/widgets/app_text.dart';
import 'package:pilates_app/widgets/app_text_field.dart';
import 'package:pilates_app/widgets/app_dropdown.dart';
import 'package:pilates_app/widgets/phone_number_field.dart';

import '../../../core/localization/localization_extension.dart';
import '../cubit/auth_cubit.dart';
import 'widgets/sign_up_header.dart';
import 'widgets/sign_up_progress.dart';

class SignUpGoalView extends StatefulWidget {
  const SignUpGoalView({super.key});

  @override
  State<SignUpGoalView> createState() => _SignUpGoalViewState();
}

class _SignUpGoalViewState extends State<SignUpGoalView> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return AppScaffold(
      appBar: AppAppBar(
        onBack: () => context.read<AuthCubit>().previousSignUpStep(),
        title: context.l10n.goals,
        isMoreMenu: false,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          // horizontal: AppSpacing.lg,
          vertical: AppSpacing.md,
        ),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.lg,
                  // vertical: AppSpacing.md,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Progress bar
                    const SignUpProgress(currentStep: 3, totalSteps: 5),
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
                            text: ' ${context.l10n.offf} 5',
                            style: AppTextStyles.caption(context),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: AppSpacing.xxl),


                    AppText(
                      context.l10n.pilatesPrimaryFocusTitle,
                      style: AppTextStyles.heading1,
                    ),

                    const SizedBox(height: AppSpacing.lg),


                    ExperienceOption(
                      title: context.l10n.buildStrength,
                      description: context.l10n.buildStrengthDesc,
                      selected: _selectedIndex == 0,
                      iconPath: isDark
                          ? "assets/images/svg/goal/ic_dark_build_strength.svg"
                          : "assets/images/svg/goal/ic_build_strength.svg",
                      onTap: () => setState(() => _selectedIndex = 0),
                    ),
                    const SizedBox(height: AppSpacing.base),

                    ExperienceOption(
                      title: context.l10n.findMindfulness,
                      description: context.l10n.findMindfulnessDesc,
                      selected: _selectedIndex == 1,
                      iconPath: isDark
                          ? "assets/images/svg/goal/ic_find_dark_minsfulness.svg"
                          : "assets/images/svg/goal/ic_find_minsfulness.svg",
                      onTap: () => setState(() => _selectedIndex = 1),
                    ),
                    const SizedBox(height: AppSpacing.base),
                    ExperienceOption(
                      title: context.l10n.improveFlexibility,
                      description: context.l10n.improveFlexibilityDesc,
                      selected: _selectedIndex == 2,
                      iconPath: isDark
                          ? "assets/images/svg/goal/ic_dark_improve_flexibility.svg"
                          : "assets/images/svg/goal/ic_improve_flexibility.svg",
                      onTap: () => setState(() => _selectedIndex = 2),
                    ),
                    const SizedBox(height: AppSpacing.base),
                    ExperienceOption(
                      title: context.l10n.generalFitness,
                      description: context.l10n.generalFitnessDesc,
                      selected: _selectedIndex == 3,
                      iconPath: isDark
                          ? "assets/images/svg/goal/ic_dark_general_fitness.svg"
                          : "assets/images/svg/goal/ic_general_fitness.svg",
                      onTap: () => setState(() => _selectedIndex = 3),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    AppText(
                      context.l10n.monthlyTarget,
                      style: (context) =>
                          AppTextStyles.gelasioRegular(context).copyWith(),
                    ),

                    const SizedBox(height: AppSpacing.md),
                    MonthlyTargetSlider(),
                    const SizedBox(height: AppSpacing.lg),

                    AppText(
                      context.l10n.dontWorry,
                      style: (context) => AppTextStyles.body(context).copyWith(
                        fontWeight: FontWeight.w400,

                        color: isDark
                            ? AppColors.darkGreyText
                            : Color(0xff79716B),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                  ],
                ),
              ),
            ),

            // Continue button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
              child: AppButton(
                label: context.l10n.continueTxt,
                onPressed: () => context.read<AuthCubit>().nextSignUpStep(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
