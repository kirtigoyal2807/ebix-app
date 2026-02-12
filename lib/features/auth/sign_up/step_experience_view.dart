import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pilates_app/config/theme/app_colors.dart';
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
import 'widgets/experience_option.dart';

class SignUpExperienceView extends StatefulWidget {
  const SignUpExperienceView({super.key});

  @override
  State<SignUpExperienceView> createState() => _SignUpExperienceViewState();
}

class _SignUpExperienceViewState extends State<SignUpExperienceView> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return AppScaffold(
      appBar: AppAppBar(
        onBack: () => context.read<AuthCubit>().previousSignUpStep(),
        title: context.l10n.experience,
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
                    const SignUpProgress(currentStep: 2, totalSteps: 4),
                    const SizedBox(height: AppSpacing.sm),
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: '${context.l10n.step} 3',
                            style: AppTextStyles.caption(
                              context,
                            ).copyWith(color: isDark
                                ? AppColors.languageTextDark
                                : AppColors.languageIcon,),
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
                    // SignUpHeader(
                    //   title: context.l10n.experienceTitle,
                    //   subtitle: context.l10n.experienceSubtitle,
                    //   step: 2,
                    //   totalSteps: 4,
                    // ),

                    AppText(context.l10n.experienceTitle, style: AppTextStyles.heading1),
                    // const SizedBox(height: AppSpacing.sm + 2),

                    const SizedBox(height: AppSpacing.lg),

                    // Options
                    ExperienceOption(
                      title: context.l10n.experienceBeginner,
                      description: context.l10n.experienceBeginnerDesc,
                      selected: _selectedIndex == 0,
                      iconPath: isDark ? "assets/images/svg/ic_beginner_dark.svg":"assets/images/svg/ic_beginner.svg",
                      onTap: () => setState(() => _selectedIndex = 0),
                    ),

                    const SizedBox(height: AppSpacing.md),

                    ExperienceOption(
                      title: context.l10n.experienceIntermediate,
                      description: context.l10n.experienceIntermediateDesc,
                      selected: _selectedIndex == 1,
                      iconPath: isDark ? "assets/images/svg/ic_intermediate_dark.svg":"assets/images/svg/ic_intermediate.svg",
                      onTap: () => setState(() => _selectedIndex = 1),
                    ),

                    const SizedBox(height: AppSpacing.md),

                    ExperienceOption(
                      title: context.l10n.experienceAdvanced,
                      description: context.l10n.experienceAdvancedDesc,
                      selected: _selectedIndex == 2,
                      iconPath: isDark ? "assets/images/svg/ic_advance_dark.svg":"assets/images/svg/ic_advance.svg",
                      onTap: () => setState(() => _selectedIndex = 2),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    AppText(
                      context.l10n.dontWorry,
                      style: (context) => AppTextStyles.body(context).copyWith(
                        fontWeight: FontWeight.w400,

                        color: isDark ? AppColors.darkGreyText : Color(0xff79716B)
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Continue
            AppButton(
              label: context.l10n.continueTxt,
              onPressed: () => context.read<AuthCubit>().nextSignUpStep(),
            ),
          ],
        ),
      ),
    );
  }
}
