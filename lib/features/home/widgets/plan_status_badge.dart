import 'package:flutter/material.dart';
import 'package:pilates_app/config/theme/app_colors.dart';
import 'package:pilates_app/config/theme/app_spacing.dart';
import 'package:pilates_app/config/theme/app_text_styles.dart';
import 'package:pilates_app/core/localization/localization_extension.dart';
import 'package:pilates_app/widgets/app_text.dart';

class PlanStatusBadge extends StatelessWidget {
  const PlanStatusBadge({super.key, required this.inPlan});

  final bool inPlan;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (inPlan) {
      return Container(
        padding: EdgeInsets.symmetric(
          horizontal: AppSpacing.sm,
          vertical: AppSpacing.xs,
        ),
        margin: EdgeInsets.only(right: AppSpacing.xs),
        decoration: BoxDecoration(
          color: isDark
              ? AppColors.successColor.withValues(alpha: 0.36)
              : AppColors.featuredTagBackgroundColor,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.check,
              color: isDark ? AppColors.lightGreyColor : AppColors.GreyColor,
              size: 12,
            ),
            SizedBox(width: AppSpacing.xs),
            Flexible(
              child: AppText(
                context.l10n.inYourPlan,
                style: (context) => AppTextStyles.boldBody(context).copyWith(
                  fontSize: 12,
                  color: isDark
                      ? AppColors.lightGreyColor
                      : AppColors.GreyColor,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xs,
      ),
      margin: EdgeInsets.only(right: AppSpacing.xs),
      decoration: BoxDecoration(
        color: isDark
            ? AppColors.upgradeDarkBackgroundColor.withValues(alpha: 0.11)
            : AppColors.upgradeLightBackgroundColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.lock_outline,
            color: isDark
                ? AppColors.upgradeDarkLockBackgroundColor
                : AppColors.lightRedColor,
            size: 14,
          ),
          const SizedBox(width: 4),
          Flexible(
            child: AppText(
              context.l10n.upgradeRequired,
              style: (context) => AppTextStyles.boldBody(context).copyWith(
                fontSize: 12,
                color: isDark
                    ? AppColors.upgradeDarkLockBackgroundColor
                    : AppColors.upgradeDarkLockBackgroundColor,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
