import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pilates_app/features/progress_tracking_flow/data/models/progress_goal_settings.dart';
import 'package:pilates_app/features/progress_tracking_flow/progrees_overview/cubit/progress_goal_cubit.dart';
import 'package:pilates_app/features/progress_tracking_flow/progrees_overview/cubit/progress_goal_state.dart';
import 'package:pilates_app/features/progress_tracking_flow/progrees_overview/goal_form_mapping.dart';
import 'package:pilates_app/widgets/app_button.dart';

import '../../../../config/theme/app_colors.dart';
import '../../../../config/theme/app_radius.dart';
import '../../../../config/theme/app_spacing.dart';
import '../../../../config/theme/app_text_styles.dart';
import '../../../../core/localization/localization_extension.dart';
import '../../../../widgets/app_app_bar.dart';
import '../../../../widgets/app_text.dart';
import '../../../auth/sign_up/widgets/experience_option.dart';
import '../../../auth/sign_up/widgets/monthly_target_slider.dart';

/// Edit training goal — `GET /progress/goal` (15.4) + `PUT /progress/goal` (15.5).
/// Expects [ProgressGoalCubit] above this route (e.g. [BlocProvider.value] from overview).
class EditGoal extends StatefulWidget {
  const EditGoal({super.key});

  @override
  State<EditGoal> createState() => _EditGoalState();
}

class _EditGoalState extends State<EditGoal> {
  int _selectedIndex = 0;
  int _monthly = 8;
  bool _hydrated = false;

  void _scheduleHydrate(ProgressGoalSettings? g) {
    if (g == null || _hydrated) return;
    _hydrated = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      setState(() {
        _selectedIndex = GoalFormMapping.indexFromStoredGoal(
          g.goal,
          context.l10n,
        );
        _monthly = GoalFormMapping.nearestMonthlyStep(g.monthlyGoal);
      });
    });
  }

  String _leadingIconForIndex(bool isDark, int index) {
    switch (index.clamp(0, 3)) {
      case 0:
        return isDark
            ? 'assets/images/svg/goal/ic_dark_build_strength.svg'
            : 'assets/images/svg/goal/ic_build_strength.svg';
      case 1:
        return isDark
            ? 'assets/images/svg/goal/ic_find_dark_minsfulness.svg'
            : 'assets/images/svg/goal/ic_find_minsfulness.svg';
      case 2:
        return isDark
            ? 'assets/images/svg/goal/ic_dark_improve_flexibility.svg'
            : 'assets/images/svg/goal/ic_improve_flexibility.svg';
      default:
        return isDark
            ? 'assets/images/svg/goal/ic_dark_general_fitness.svg'
            : 'assets/images/svg/goal/ic_general_fitness.svg';
    }
  }

  Future<void> _onSave(BuildContext context) async {
    final cubit = context.read<ProgressGoalCubit>();
    final l10n = context.l10n;
    final experience = cubit.state.goal?.experience ?? 'intermediate';
    final ok = await cubit.save(
      monthlyGoal: _monthly,
      goal: GoalFormMapping.goalTitleForIndex(l10n, _selectedIndex),
      experience: experience,
    );
    if (!context.mounted) return;
    if (ok) {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: AppAppBar(
        onBack: () => Navigator.of(context).pop(),
        title: context.l10n.edit_goal_title,
        isMoreMenu: false,
      ),
      body: BlocBuilder<ProgressGoalCubit, ProgressGoalState>(
        builder: (context, state) {
          if (state.status == ProgressGoalStatus.loading &&
              state.goal == null) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state.status == ProgressGoalStatus.failure &&
              state.goal == null) {
            return Center(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AppText(
                      state.errorMessage ?? '—',
                      textAlign: TextAlign.center,
                      style: (c) => AppTextStyles.bodyText(c),
                    ),
                    SizedBox(height: AppSpacing.md),
                    AppButton(
                      label: context.l10n.retry,
                      expanded: false,
                      onPressed: () => context.read<ProgressGoalCubit>().load(),
                    ),
                  ],
                ),
              ),
            );
          }

          final goal = state.goal;
          _scheduleHydrate(goal);

          final currentTitle =
              goal?.goal != null && goal!.goal!.trim().isNotEmpty
              ? goal.goal!.trim()
              : GoalFormMapping.goalTitleForIndex(context.l10n, _selectedIndex);
          final currentSubtitle = goal != null
              ? ProgressGoalSettings.experienceLabel(
                  context.l10n,
                  goal.experience,
                )
              : context.l10n.edit_goal_intermediate_level;

          return Column(
            children: [
              if (state.errorMessage != null &&
                  state.status == ProgressGoalStatus.failure &&
                  state.goal != null)
                Material(
                  color: AppColors.featuredTagBackgroundColor,
                  child: Padding(
                    padding: EdgeInsets.all(AppSpacing.md),
                    child: AppText(
                      state.errorMessage!,
                      style: (c) => AppTextStyles.captionText(c),
                    ),
                  ),
                ),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Container(
                        margin: EdgeInsets.only(
                          left: AppSpacing.lg,
                          right: AppSpacing.lg,
                          bottom: AppSpacing.lg,
                          top: AppSpacing.md,
                        ),
                        padding: EdgeInsets.only(
                          left: AppSpacing.md,
                          right: AppSpacing.md,
                          bottom: AppSpacing.sm,
                          top: AppSpacing.md,
                        ),
                        decoration: BoxDecoration(
                          color: isDark
                              ? AppColors.homeBackground
                              : Colors.white,
                          borderRadius: BorderRadius.circular(AppRadius.md),
                          border: Border.all(
                            color: isDark
                                ? AppColors.greyText
                                : AppColors.buttonBorder,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            AppText(
                              context.l10n.edit_goal_current_goal,
                              style: (c) => AppTextStyles.body(c).copyWith(
                                color: AppColors.lightGrey,
                                height: 1.55,
                              ),
                            ),
                            SizedBox(height: AppSpacing.sm),
                            ListTile(
                              contentPadding: EdgeInsets.zero,
                              minVerticalPadding: 0,
                              leading: SvgPicture.asset(
                                _leadingIconForIndex(isDark, _selectedIndex),
                                height: 64,
                                width: 64,
                              ),
                              title: AppText(
                                currentTitle,
                                style: (c) => AppTextStyles.experienceButton(
                                  c,
                                ).copyWith(fontSize: 18),
                              ),
                              subtitle: AppText(
                                currentSubtitle,
                                style: (c) => AppTextStyles.body(c).copyWith(
                                  color: isDark
                                      ? AppColors.darkGreyText
                                      : AppColors.greyText,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Divider(
                        color: isDark
                            ? AppColors.greyText
                            : AppColors.buttonBorder,
                        height: 1,
                      ),
                      SizedBox(height: AppSpacing.lg),
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: AppSpacing.lg,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            AppText(
                              context.l10n.edit_goal_choose_focus,
                              style: AppTextStyles.heading1,
                            ),
                            SizedBox(height: AppSpacing.md),
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
                            SizedBox(height: AppSpacing.lg),
                            AppText(
                              context.l10n.monthlyTarget,
                              style: (c) =>
                                  AppTextStyles.gelasioRegular(c).copyWith(),
                            ),
                            SizedBox(height: AppSpacing.md),
                            MonthlyTargetSlider(
                              key: ValueKey<int>(_monthly),
                              initialMonthlyClasses: _monthly,
                              onMonthlyClassesChanged: (v) {
                                setState(() => _monthly = v);
                              },
                            ),
                            SizedBox(height: AppSpacing.lg),
                            _buildSmartTip(context, isDark),
                            SizedBox(height: AppSpacing.lg),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.only(
                  left: AppSpacing.lg,
                  right: AppSpacing.lg,
                  bottom: AppSpacing.lg,
                ),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.homeBackground : Colors.white,
                ),
                child: AppButton(
                  label: context.l10n.edit_goal_save_changes,
                  isLoading: state.isSubmitting,
                  onPressed: state.isSubmitting ? null : () => _onSave(context),
                  variant: AppButtonVariant.primary,
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSmartTip(BuildContext context, bool isDark) {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? AppColors.primaryDarkButton : AppColors.greyContainerBg,
        borderRadius: BorderRadius.circular(AppRadius.base),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SvgPicture.asset('assets/images/svg/ic_tip.svg'),
          SizedBox(width: AppSpacing.sm),
          Expanded(
            child: RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: context.l10n.edit_goal_tip_label,
                    style: AppTextStyles.helpAndSupportItemSubLabel(
                      context,
                    ).copyWith(fontWeight: FontWeight.w600),
                  ),
                  TextSpan(
                    text: context.l10n.edit_goal_tip_content,
                    style: AppTextStyles.helpAndSupportItemSubLabel(
                      context,
                    ).copyWith(height: 1.55),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
