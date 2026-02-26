import 'package:flutter/material.dart';
import 'package:pilates_app/core/localization/localization_extension.dart';

import '../../../../config/theme/app_colors.dart';
import '../../../../config/theme/app_radius.dart';
import '../../../../config/theme/app_spacing.dart';
import '../../../../config/theme/app_text_styles.dart';
import '../../../../widgets/app_text.dart';

class SessionHistoryCard extends StatelessWidget {
  const SessionHistoryCard({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      margin: EdgeInsets.only(bottom: AppSpacing.md),
      padding: EdgeInsets.symmetric(
        vertical: AppSpacing.lmd,
        horizontal: AppSpacing.md,
      ),
      decoration: BoxDecoration(
        color: isDark ? AppColors.homeBackground : Colors.white,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(
          color: isDark ? AppColors.greyText : AppColors.buttonBorder,
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppText(
                   context.l10n.session_card_class_name,
                    style: (context) => AppTextStyles.textFieldHeading(
                      context,
                    ).copyWith(height: 1.4),
                  ),
                  AppText(
                    context.l10n.session_card_instructor,
                    style: (context) =>
                        AppTextStyles.caption(context).copyWith(height: 1.4),
                  ),
                ],
              ),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: AppSpacing.sm,
                  vertical: 1,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(AppRadius.base),
                  color: isDark
                      ? AppColors.successColor.withValues(alpha: 0.36)
                      : AppColors.featuredTagBackgroundColor,
                ),
                child: AppText(
                    context.l10n.session_card_status_completed,
                  style: (context) =>
                      AppTextStyles.splashVersion(context).copyWith(
                        color: isDark
                            ? AppColors.successBorderDark
                            : AppColors.successColor,
                        height: 1.8
                      ),
                ),
              ),
            ],
          ),

          SizedBox(height: 12),
          Row(
            children: [
              Icon(
                Icons.calendar_today_outlined,
                size: 16,
                color: AppColors.languageIcon,
              ),
              SizedBox(width: AppSpacing.xs),
              AppText(
    context.l10n.session_card_today,
                style: (context) => AppTextStyles.helpAndSupportItemSubLabel(
                  context,
                ).copyWith(height: 1.2),
              ),
              SizedBox(width: AppSpacing.sm),
              Icon(Icons.schedule, size: 16, color: AppColors.languageIcon),
              SizedBox(width: AppSpacing.xs),
              AppText(
    context.l10n.session_card_duration,
                style: (context) => AppTextStyles.helpAndSupportItemSubLabel(
                  context,
                ).copyWith(height: 1.2),
              ),

              Spacer(),
              AppText(
              context.l10n.session_card_points,
                style: (context) =>
                    AppTextStyles.body(context).copyWith(height: 1.2),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
