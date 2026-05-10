import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pilates_app/config/theme/app_colors.dart';
import 'package:pilates_app/config/theme/app_spacing.dart';
import 'package:pilates_app/config/theme/app_text_styles.dart';
import 'package:pilates_app/features/auth/post_login/post_login_api_values.dart';
import 'package:pilates_app/widgets/app_app_bar.dart';
import 'package:pilates_app/widgets/app_button.dart';
import 'package:pilates_app/widgets/app_scaffold.dart';
import 'package:pilates_app/widgets/app_text.dart';
import '../../../core/localization/localization_extension.dart';
import '../cubit/auth_cubit.dart';
import 'widgets/sign_up_progress.dart';
import 'widgets/experience_option.dart';

class SignUpExperienceView extends StatefulWidget {
  const SignUpExperienceView({super.key});

  @override
  State<SignUpExperienceView> createState() => _SignUpExperienceViewState();
}

class _SignUpExperienceViewState extends State<SignUpExperienceView> {
  int? _selectedIndex;

  static const _api = [
    PostLoginExperienceApi.beginner,
    PostLoginExperienceApi.intermediate,
    PostLoginExperienceApi.advanced,
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return AppScaffold(
      appBar: AppAppBar(title: context.l10n.experience, isMoreMenu: false),
      body: Padding(
        padding: EdgeInsets.symmetric(
          // horizontal: AppSpacing.lg,
          vertical: AppSpacing.md,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg),
              child: const SignUpProgress(currentStep: 2, totalSteps: 5),
            ),
            SizedBox(height: AppSpacing.sm),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg),
              child: RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: '${context.l10n.step} 3',
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
            ),
            SizedBox(height: AppSpacing.sm),
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: AppSpacing.lg),
                      AppText(
                        context.l10n.experienceTitle,
                        style: AppTextStyles.heading1,
                        maxLines: 3,
                      ),
                      SizedBox(height: AppSpacing.lg),
                      ExperienceOption(
                        title: context.l10n.experienceBeginner,
                        description: context.l10n.experienceBeginnerDesc,
                        selected: _selectedIndex == 0,
                        iconPath: isDark
                            ? 'assets/images/svg/ic_beginner_dark.svg'
                            : 'assets/images/svg/ic_beginner.svg',
                        onTap: () => setState(() => _selectedIndex = 0),
                      ),
                      SizedBox(height: AppSpacing.md),
                      ExperienceOption(
                        title: context.l10n.experienceIntermediate,
                        description: context.l10n.experienceIntermediateDesc,
                        selected: _selectedIndex == 1,
                        iconPath: isDark
                            ? 'assets/images/svg/ic_intermediate_dark.svg'
                            : 'assets/images/svg/ic_intermediate.svg',
                        onTap: () => setState(() => _selectedIndex = 1),
                      ),
                      SizedBox(height: AppSpacing.md),
                      ExperienceOption(
                        title: context.l10n.experienceAdvanced,
                        description: context.l10n.experienceAdvancedDesc,
                        selected: _selectedIndex == 2,
                        iconPath: isDark
                            ? 'assets/images/svg/ic_advance_dark.svg'
                            : 'assets/images/svg/ic_advance.svg',
                        onTap: () => setState(() => _selectedIndex = 2),
                      ),
                      SizedBox(height: AppSpacing.lg),
                      AppText(
                        context.l10n.dontWorry,
                        style: (context) =>
                            AppTextStyles.body(context).copyWith(
                              fontWeight: FontWeight.w400,
                              color: isDark
                                  ? AppColors.darkGreyText
                                  : const Color(0xff79716B),
                            ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg),
              child: AppButton(
                key: const ValueKey('sign_up_experience_continue'),
                label: context.l10n.continueTxt,
                onPressed: _selectedIndex == null
                    ? null
                    : () {
                        context.read<AuthCubit>().continueSignUpExperience(
                          _api[_selectedIndex!],
                        );
                      },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
