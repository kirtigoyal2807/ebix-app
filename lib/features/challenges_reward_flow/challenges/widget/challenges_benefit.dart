import 'package:flutter/material.dart';
import 'package:pilates_app/config/theme/app_colors.dart';
import 'package:pilates_app/config/theme/app_radius.dart';
import 'package:pilates_app/config/theme/app_spacing.dart';
import 'package:pilates_app/config/theme/app_text_styles.dart';
import 'package:pilates_app/widgets/app_text.dart';

import '../../../../core/localization/localization_extension.dart';

class ChallengesBenefit extends StatelessWidget {
  const ChallengesBenefit({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: EdgeInsets.all(AppSpacing.lmd),
      decoration: BoxDecoration(
        color: isDark ? AppColors.homeBackground : AppColors.whiteColor,
        border: Border.all(
          color: isDark ? AppColors.greyText : AppColors.buttonBorder,
          width: 1,
        ),
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          _buildRow(
            isDark: isDark,
            title: context.l10n.benefit_gold_badge,
            subtitle: context.l10n.benefit_feb_champion,
          ),
          SizedBox(height: AppSpacing.base),
          _buildRow(
            isDark: isDark,
            title: context.l10n.benefit_bonus_points(500),
            subtitle: context.l10n.benefit_redeem_rewards,
          ),
          SizedBox(height: AppSpacing.base),
          _buildRow(
            isDark: isDark,
            title: context.l10n.benefit_discount(15),
            subtitle: context.l10n.benefit_next_billing,
          ),
        ],
      ),
    );
  }

  Row _buildRow({
    required bool isDark,
    required String title,
    required String subtitle,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          Icons.check_circle_outline_rounded,
          size: 24,
          color: isDark ? AppColors.successBorderDark : AppColors.successColor,
        ),
        SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppText(
              title,
              style: (context) => AppTextStyles.body(context).copyWith(
                color: isDark ? AppColors.lightText : AppColors.darkText,
              ),
            ),
            SizedBox(height: AppSpacing.xs),
            AppText(
              subtitle,
              style: (context) =>
                  AppTextStyles.bodyLightText(context).copyWith(fontSize: 12),
            ),
          ],
        ),
      ],
    );
  }
}
