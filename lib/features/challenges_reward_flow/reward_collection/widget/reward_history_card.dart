import 'package:flutter/material.dart';
import 'package:pilates_app/config/theme/app_colors.dart';
import 'package:pilates_app/config/theme/app_radius.dart';
import 'package:pilates_app/config/theme/app_spacing.dart';
import 'package:pilates_app/config/theme/app_text_styles.dart';
import 'package:pilates_app/core/localization/localization_extension.dart';
import 'package:pilates_app/widgets/app_text.dart';

class RewardHistoryCard extends StatelessWidget {
  final String title;
  final String subTitle;
  final int point;

  const RewardHistoryCard({
    super.key,
    required this.title,
    required this.subTitle,
    required this.point,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: isDark ? AppColors.homeBackground: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: isDark ? AppColors.greyText: AppColors.buttonBorder, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppText(
            title,
            style: (context) => AppTextStyles.experienceButton(context).copyWith(height: 1.4),
          ),
          SizedBox(height: AppSpacing.xs),
          AppText(
            subTitle,
            style: (context) => AppTextStyles.bodyLightText(context).copyWith(height: 1.4),
          ),
          SizedBox(height: AppSpacing.lmd),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              AppText(
                context.l10n.collected,
                style: (context) => AppTextStyles.boldBody(context).copyWith(
                  fontSize: 16,
                  height: 1.55,
                  color:  isDark ? AppColors.successBorderDark: AppColors.successColor,
                ),
              ),
              AppText(
                "-${context.l10n.points(point)}",
                style: (context) => AppTextStyles.boldBody(context).copyWith(
                  fontSize: 16,
                  height: 1.55,
                  color: AppColors.redLight,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
