import 'package:flutter/material.dart';
import 'package:pilates_app/config/theme/app_colors.dart';
import 'package:pilates_app/config/theme/app_spacing.dart';
import 'package:pilates_app/config/theme/app_text_styles.dart';
import 'package:pilates_app/core/localization/localization_extension.dart';
import 'package:pilates_app/widgets/app_text.dart';

/// "In Your Plan" chip — shared by booking and featured class cards.
class InYourPlanBadge extends StatelessWidget {
  const InYourPlanBadge({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

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
        border: Border.all(
          color: isDark
              ? Colors.transparent
              : AppColors.featuredTagBackgroundColor,
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.check,
            color: isDark ? AppColors.lightGreyColor : AppColors.GreyColor,
            size: 12,
            fontWeight: FontWeight.bold,
          ),
          SizedBox(width: AppSpacing.xs),
          Flexible(
            child: AppText(
              context.l10n.inYourPlan,
              style: (context) => AppTextStyles.boldBody(context).copyWith(
                fontSize: 12,
                color: isDark ? AppColors.lightGreyColor : AppColors.GreyColor,
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

/// "Upgrade Required" chip — shared by booking and featured class cards.
class UpgradeRequiredBadge extends StatelessWidget {
  const UpgradeRequiredBadge({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xs,
      ),
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
