import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pilates_app/config/theme/app_colors.dart';
import 'package:pilates_app/config/theme/app_spacing.dart';
import 'package:pilates_app/config/theme/app_text_styles.dart';
import 'package:pilates_app/core/localization/localization_extension.dart';
import 'package:pilates_app/features/auth/cubit/auth_cubit.dart';
import 'package:pilates_app/features/auth/cubit/auth_state.dart';
import 'package:pilates_app/features/auth/post_login/post_login_api_values.dart';
import 'package:pilates_app/features/auth/sign_up/widgets/experience_option.dart';
import 'package:pilates_app/features/auth/sign_up/widgets/monthly_target_slider.dart';
import 'package:pilates_app/widgets/app_app_bar.dart';
import 'package:pilates_app/widgets/app_button.dart';
import 'package:pilates_app/widgets/app_scaffold.dart';
import 'package:pilates_app/widgets/app_text.dart';

import 'widgets/sign_up_progress.dart';

class SignUpGoalView extends StatefulWidget {
  const SignUpGoalView({super.key});

  @override
  State<SignUpGoalView> createState() => _SignUpGoalViewState();
}

class _SignUpGoalViewState extends State<SignUpGoalView> {
  int? _selectedIndex;
  int _monthlyClasses = 8;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return BlocConsumer<AuthCubit, AuthState>(
      listenWhen: (previous, current) {
        return previous.postLoginGoalUiStatus ==
                PostLoginGoalUiStatus.loading &&
            current.postLoginGoalUiStatus == PostLoginGoalUiStatus.idle &&
            current.postLoginGoalErrorMessage.isNotEmpty &&
            current.postLoginGoalFieldErrors.isEmpty;
      },
      listener: (context, state) {
        final text = state.postLoginGoalErrorMessage.trim().isEmpty
            ? context.l10n.loginErrorGeneric
            : state.postLoginGoalErrorMessage;
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(text)));
      },
      builder: (context, state) {
        final fe = state.postLoginGoalFieldErrors;
        final loading =
            state.postLoginGoalUiStatus == PostLoginGoalUiStatus.loading;

        return AppScaffold(
          appBar: AppAppBar(
            onBack: () {
              context.read<AuthCubit>().previousSignUpStep();
            },
            title: context.l10n.goals,
            isMoreMenu: false,
          ),
          body: Padding(
            padding: EdgeInsets.only(top: AppSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                  child: const SignUpProgress(currentStep: 3, totalSteps: 5),
                ),
                SizedBox(height: AppSpacing.sm),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                  child: RichText(
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
                ),
                SizedBox(height: AppSpacing.sm),
                Expanded(
                  child: Stack(
                    children: [
                      SingleChildScrollView(
                        padding: EdgeInsets.symmetric(
                          horizontal: AppSpacing.lg,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: AppSpacing.lg),
                            AppText(
                              context.l10n.pilatesPrimaryFocusTitle,
                              style: AppTextStyles.heading1,
                            ),
                            SizedBox(height: AppSpacing.lg),
                            ExperienceOption(
                              title: context.l10n.buildStrength,
                              description: context.l10n.buildStrengthDesc,
                              selected: _selectedIndex == 0,
                              iconPath: isDark
                                  ? 'assets/images/svg/goal/ic_dark_build_strength.svg'
                                  : 'assets/images/svg/goal/ic_build_strength.svg',
                              onTap: () => setState(() => _selectedIndex = 0),
                            ),
                            SizedBox(height: AppSpacing.base),
                            ExperienceOption(
                              title: context.l10n.findMindfulness,
                              description: context.l10n.findMindfulnessDesc,
                              selected: _selectedIndex == 1,
                              iconPath: isDark
                                  ? 'assets/images/svg/goal/ic_find_dark_minsfulness.svg'
                                  : 'assets/images/svg/goal/ic_find_minsfulness.svg',
                              onTap: () => setState(() => _selectedIndex = 1),
                            ),
                            SizedBox(height: AppSpacing.base),
                            ExperienceOption(
                              title: context.l10n.improveFlexibility,
                              description: context.l10n.improveFlexibilityDesc,
                              selected: _selectedIndex == 2,
                              iconPath: isDark
                                  ? 'assets/images/svg/goal/ic_dark_improve_flexibility.svg'
                                  : 'assets/images/svg/goal/ic_improve_flexibility.svg',
                              onTap: () => setState(() => _selectedIndex = 2),
                            ),
                            SizedBox(height: AppSpacing.base),
                            ExperienceOption(
                              title: context.l10n.generalFitness,
                              description: context.l10n.generalFitnessDesc,
                              selected: _selectedIndex == 3,
                              iconPath: isDark
                                  ? 'assets/images/svg/goal/ic_dark_general_fitness.svg'
                                  : 'assets/images/svg/goal/ic_general_fitness.svg',
                              onTap: () => setState(() => _selectedIndex = 3),
                            ),
                            if (fe['goal'] != null) ...[
                              SizedBox(height: AppSpacing.sm),
                              Center(
                                child: AppText(
                                  fe['goal']!,
                                  style: (context) =>
                                      AppTextStyles.caption(context).copyWith(
                                        color: isDark
                                            ? AppColors.redDark
                                            : AppColors.redLight,
                                      ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ],
                            SizedBox(height: AppSpacing.lg),
                            AppText(
                              context.l10n.monthlyTarget,
                              style: (context) => AppTextStyles.gelasioRegular(
                                context,
                              ).copyWith(),
                            ),
                            SizedBox(height: AppSpacing.md),
                            MonthlyTargetSlider(
                              initialMonthlyClasses: _monthlyClasses,
                              onMonthlyClassesChanged: (v) {
                                setState(() => _monthlyClasses = v);
                              },
                            ),
                            if (fe['monthlygoal'] != null) ...[
                              SizedBox(height: AppSpacing.sm),
                              AppText(
                                fe['monthlygoal']!,
                                style: (context) =>
                                    AppTextStyles.caption(context).copyWith(
                                      color: isDark
                                          ? AppColors.redDark
                                          : AppColors.redLight,
                                    ),
                              ),
                            ],
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
                            SizedBox(
                              height:
                                  MediaQuery.sizeOf(context).height * 0.04 + 48,
                            ),
                          ],
                        ),
                      ),

                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: Container(
                          height: AppSpacing.md + 52,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin:
                                  Alignment.bottomCenter, // start from bottom
                              end: Alignment.topCenter, // fade to top
                              colors: isDark
                                  ? [
                                      AppColors.darkShadow,
                                      AppColors.darkShadow.withValues(alpha: 0),
                                    ]
                                  : [
                                      Colors.white,
                                      Colors.white.withValues(alpha: 0),
                                    ],
                            ),
                          ),
                        ),
                      ),

                      // Sticky action button
                      Positioned(
                        left: 0,
                        right: 0,
                        bottom: AppSpacing.md,
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: AppSpacing.lg,
                          ),
                          child: AppButton(
                            key: const ValueKey('sign_up_goal_submit'),
                            label: context.l10n.continueTxt,
                            isLoading: loading,
                            onPressed: loading || _selectedIndex == null
                                ? null
                                : () {
                                    context
                                        .read<AuthCubit>()
                                        .submitSignUpGoalAndAdvance(
                                          goal: PostLoginGoalApi
                                              .ordered[_selectedIndex!],
                                          monthlyGoal: _monthlyClasses,
                                        );
                                  },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
