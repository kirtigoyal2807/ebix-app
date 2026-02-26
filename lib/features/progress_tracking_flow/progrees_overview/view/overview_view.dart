import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pilates_app/config/theme/app_colors.dart';
import 'package:pilates_app/config/theme/app_radius.dart';
import 'package:pilates_app/config/theme/app_spacing.dart';
import 'package:pilates_app/config/theme/app_text_styles.dart';
import 'package:pilates_app/core/localization/localization_extension.dart';
import 'package:pilates_app/widgets/app_text.dart';

import '../widget/goal_progress.dart';
import '../widget/weekly_activity.dart';
import '../widget/your_mind_practice.dart';
import 'edit_goal.dart';

class OverviewView extends StatelessWidget {
  const OverviewView({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return SingleChildScrollView(
      child: Column(
        children: [
          ///current Goal
          Container(
            margin: EdgeInsets.all(AppSpacing.lg),
            padding: EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: isDark ? AppColors.homeBackground : Colors.white,
              borderRadius: BorderRadius.circular(AppRadius.md),
              border: Border.all(
                color: isDark ? AppColors.greyText : AppColors.buttonBorder,
              ),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    AppText(
                      context.l10n.edit_goal_current_goal,
                      style: (context) => AppTextStyles.body(
                        context,
                      ).copyWith(color: AppColors.lightGrey, height: 1.55),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => EditGoal()),
                        );
                      },
                      child: SvgPicture.asset(
                        "assets/images/svg/ic_edit_square.svg",
                        color: isDark
                            ? AppColors.darkGreyText
                            : AppColors.lightGrey,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: AppSpacing.base),

                ListTile(
                  contentPadding: EdgeInsets.zero,
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
                    style: (context) => AppTextStyles.body(context).copyWith(
                      color: isDark
                          ? AppColors.darkGreyText
                          : AppColors.greyText,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                SizedBox(height: AppSpacing.base),

                Row(
                  spacing: 2,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SvgPicture.asset(
                      "assets/images/svg/ic_tip.svg",
                      height: 24,
                      width: 24,
                      color: AppColors.languageIconDark,
                    ),
                    Expanded(
                      child: AppText(
                        context.l10n.edit_goal_tap_hint,
                        style: (context) => AppTextStyles.body(context).copyWith(
                          color: AppColors.lightGrey,
                          height: 1,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          SizedBox(height: AppSpacing.sm),
          Divider(
            color: isDark ? AppColors.greyText : AppColors.buttonBorder,
            height: 1,
          ),
          SizedBox(height: AppSpacing.lg),

          GoalProgress(),
          SizedBox(height: AppSpacing.xl),
          YourMindPractice(),
          SizedBox(height: AppSpacing.xl),
          WeeklyActivity(),
          SizedBox(height: AppSpacing.buttonHeight),
        ],
      ),
    );
  }
}
