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

/// Sends `POST /auth/goal` with [AuthState.postLoginExperience] + [goal] + [monthlyGoal]
/// (JWT from login via [DioClient]).
class PostLoginGoalView extends StatefulWidget {
  const PostLoginGoalView({super.key});

  @override
  State<PostLoginGoalView> createState() => _PostLoginGoalViewState();
}

class _PostLoginGoalViewState extends State<PostLoginGoalView> {
  int _selectedIndex = 0;
  int _monthlyClasses = 12;

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
              context.read<AuthCubit>().backPostLoginSetup();
            },
            title: context.l10n.goals,
            isMoreMenu: false,
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.lg,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: AppSpacing.lg),
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
                              ? 'assets/images/svg/goal/ic_dark_build_strength.svg'
                              : 'assets/images/svg/goal/ic_build_strength.svg',
                          onTap: () => setState(() => _selectedIndex = 0),
                        ),
                        const SizedBox(height: AppSpacing.base),
                        ExperienceOption(
                          title: context.l10n.findMindfulness,
                          description: context.l10n.findMindfulnessDesc,
                          selected: _selectedIndex == 1,
                          iconPath: isDark
                              ? 'assets/images/svg/goal/ic_find_dark_minsfulness.svg'
                              : 'assets/images/svg/goal/ic_find_minsfulness.svg',
                          onTap: () => setState(() => _selectedIndex = 1),
                        ),
                        const SizedBox(height: AppSpacing.base),
                        ExperienceOption(
                          title: context.l10n.improveFlexibility,
                          description: context.l10n.improveFlexibilityDesc,
                          selected: _selectedIndex == 2,
                          iconPath: isDark
                              ? 'assets/images/svg/goal/ic_dark_improve_flexibility.svg'
                              : 'assets/images/svg/goal/ic_improve_flexibility.svg',
                          onTap: () => setState(() => _selectedIndex = 2),
                        ),
                        const SizedBox(height: AppSpacing.base),
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
                          const SizedBox(height: AppSpacing.sm),
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
                        const SizedBox(height: AppSpacing.lg),
                        AppText(
                          context.l10n.monthlyTarget,
                          style: (context) =>
                              AppTextStyles.gelasioRegular(context).copyWith(),
                        ),
                        const SizedBox(height: AppSpacing.md),
                        MonthlyTargetSlider(
                          initialMonthlyClasses: _monthlyClasses,
                          onMonthlyClassesChanged: (v) {
                            setState(() => _monthlyClasses = v);
                          },
                        ),
                        if (fe['monthlygoal'] != null) ...[
                          const SizedBox(height: AppSpacing.sm),
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
                        const SizedBox(height: AppSpacing.lg),
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
                        const SizedBox(height: AppSpacing.lg),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.lg,
                  ),
                  child: AppButton(
                    key: const ValueKey('post_login_goal_submit'),
                    label: context.l10n.continueTxt,
                    isLoading: loading,
                    onPressed: loading
                        ? null
                        : () {
                            context.read<AuthCubit>().submitPostLoginGoal(
                              goal: PostLoginGoalApi.ordered[_selectedIndex],
                              monthlyGoal: _monthlyClasses,
                            );
                          },
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
