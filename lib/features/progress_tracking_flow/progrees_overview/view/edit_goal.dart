import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pilates_app/widgets/app_button.dart';

import '../../../../config/theme/app_colors.dart';
import '../../../../config/theme/app_radius.dart';
import '../../../../config/theme/app_spacing.dart';
import '../../../../config/theme/app_text_styles.dart';
import '../../../../core/localization/arb/app_localizations.dart';
import '../../../../core/localization/localization_extension.dart';
import '../../../../widgets/app_app_bar.dart';
import '../../../../widgets/app_text.dart';
import '../../../auth/sign_up/widgets/experience_option.dart';
import '../../../auth/sign_up/widgets/monthly_target_slider.dart';

class EditGoal extends StatefulWidget {
  const EditGoal({super.key});

  @override
  State<EditGoal> createState() => _EditGoalState();
}

class _EditGoalState extends State<EditGoal> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: AppAppBar(
        onBack: () => Navigator.of(context).pop(),
        title: context.l10n.edit_goal_title,
        isMoreMenu: false,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  ///current Goal
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
                      color: isDark ? AppColors.homeBackground : Colors.white,
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
                          style: (context) => AppTextStyles.body(
                            context,
                          ).copyWith(color: AppColors.lightGrey, height: 1.55),
                        ),
                        SizedBox(height: AppSpacing.sm),

                        ListTile(
                          contentPadding: EdgeInsets.zero,
                          minVerticalPadding: 0,

                          leading: SvgPicture.asset(
                            isDark
                                ? "assets/images/svg/goal/ic_find_dark_minsfulness.svg"
                                : "assets/images/svg/goal/ic_find_minsfulness.svg",
                            height: 64,
                            width: 64,
                          ),
                          title: AppText(
                            context.l10n.findMindfulness,
                            style: (context) => AppTextStyles.experienceButton(
                              context,
                            ).copyWith(fontSize: 18),
                          ),
                          subtitle: AppText(
                            context.l10n.edit_goal_intermediate_level,
                            style: (context) =>
                                AppTextStyles.body(context).copyWith(
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
                    color: isDark ? AppColors.greyText : AppColors.buttonBorder,
                    height: 1,
                  ),
                  SizedBox(height: AppSpacing.lg),

                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.lg,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AppText(
                          context.l10n.edit_goal_choose_focus,
                          style: AppTextStyles.heading1,
                        ),

                        const SizedBox(height: AppSpacing.md),

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
                        _buildSmartTip(context, isDark),
                        const SizedBox(height: AppSpacing.lg),
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
              onPressed: () {},
              variant: AppButtonVariant.primary,
            ),
          ),
        ],
      ),
    );
  }

  /// SMART TIP
  Widget _buildSmartTip(BuildContext context, bool isDark) {
    final l10n = AppLocalizations.of(context);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? AppColors.primaryDarkButton : AppColors.greyContainerBg,
        borderRadius: BorderRadius.circular(AppRadius.base),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SvgPicture.asset("assets/images/svg/ic_tip.svg"),
          const SizedBox(width: AppSpacing.sm),
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
