import 'package:flutter/material.dart';
import 'package:pilates_app/config/theme/app_colors.dart';
import 'package:pilates_app/config/theme/app_radius.dart';
import 'package:pilates_app/config/theme/app_spacing.dart';
import 'package:pilates_app/config/theme/app_text_styles.dart';
import 'package:pilates_app/core/localization/localization_extension.dart';
import 'package:pilates_app/widgets/app_text.dart';

class RewardHistoryCard extends StatelessWidget {
  const RewardHistoryCard({
    super.key,
    required this.title,
    required this.subTitle,
    required this.pointsDelta,
    required this.balanceAfter,
  });

  final String title;
  final String subTitle;
  final int pointsDelta;
  final int balanceAfter;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final earned = pointsDelta >= 0;
    final absPoints = pointsDelta.abs();
    final pointsColor = earned
        ? (isDark ? AppColors.successBorderDark : AppColors.successColor)
        : AppColors.redLight;
    final pointsLabel = earned
        ? '+${context.l10n.points_short(absPoints)}'
        : '-${context.l10n.points_short(absPoints)}';

    return Container(
      padding: EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: isDark ? AppColors.homeBackground : AppColors.whiteColor,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(
          color: isDark ? AppColors.greyText : AppColors.buttonBorder,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppText(
            title,
            style: (context) =>
                AppTextStyles.experienceButton(context).copyWith(height: 1.4),
          ),
          SizedBox(height: AppSpacing.xs),
          AppText(
            subTitle,
            style: (context) =>
                AppTextStyles.bodyLightText(context).copyWith(height: 1.4),
          ),
          SizedBox(height: AppSpacing.lmd),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: AppText(
                  '${context.l10n.current_balance}: ${context.l10n.points_short(balanceAfter)}',
                  style: (context) => AppTextStyles.bodyLightText(context)
                      .copyWith(fontSize: 12, height: 1.4),
                ),
              ),
              AppText(
                pointsLabel,
                style: (context) => AppTextStyles.boldBody(context).copyWith(
                  fontSize: 16,
                  height: 1.55,
                  color: pointsColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
