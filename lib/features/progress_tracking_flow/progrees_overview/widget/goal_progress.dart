import 'package:flutter/material.dart';
import 'package:pilates_app/config/theme/app_colors.dart';
import 'package:pilates_app/config/theme/app_spacing.dart';
import 'package:pilates_app/config/theme/app_text_styles.dart';
import 'package:pilates_app/widgets/app_text.dart';

import '../../../../config/theme/app_radius.dart';
import '../../../../core/localization/localization_extension.dart';

class GoalProgress extends StatelessWidget {
  const GoalProgress({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      margin: EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: AppSpacing.lg),
      decoration: BoxDecoration(
        color: isDark ? AppColors.primaryDarkButton : AppColors.seekBarLight,
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          AppText(
            context.l10n.goal_progress_title,
            style: (context) =>
                AppTextStyles.experienceButton(context).copyWith(height: 1),
          ),
          SizedBox(height: AppSpacing.md),
          SizedBox(
            height: 200,
            width: 167,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Transform.rotate(
                  angle: 3.1416,
                  child: CircularProgressIndicator(
                    value: 0.75,
                    backgroundColor: isDark
                        ? AppColors.progressBGColor
                        : AppColors.darkGreyBorder,

                    constraints: BoxConstraints(
                      minHeight: 167,
                      minWidth: 167,
                      maxHeight: 167,
                      maxWidth: 167,
                    ),
                    strokeWidth: 16,
                    valueColor: AlwaysStoppedAnimation(
                      isDark
                          ? AppColors.languageIconDark
                          : AppColors.languageIcon, // your progress color
                    ),
                  ),
                ),

                /// 👇 Center text
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    AppText(
                      "75%",
                      style: (context) =>
                          AppTextStyles.headline(context).copyWith(
                            color: isDark
                                ? AppColors.lightText
                                : AppColors.darkText,
                          ),
                    ),
                    SizedBox(height: 2),
                    AppText(
                      context.l10n.goal_progress_complete,
                      style: (context) =>
                          AppTextStyles.textField(context).copyWith(),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: AppSpacing.md),
          AppText(
            context.l10n.goal_progress_sessions,
            style: (context) =>
                AppTextStyles.textFieldHeading(context).copyWith(height: 1),
          ),
          SizedBox(height: AppSpacing.sm),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            spacing: 6,
            children: [
              Icon(
                Icons.radar,
                size: 16,
                color: isDark
                    ? AppColors.languageIconDark
                    : AppColors.languageIcon,
              ),
              AppText(
                context.l10n.goal_progress_remaining,
                style: (context) => AppTextStyles.captionText(
                  context,
                ).copyWith(color: AppColors.lightGrey),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
