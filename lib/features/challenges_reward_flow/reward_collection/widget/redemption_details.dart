import 'package:flutter/material.dart';
import 'package:pilates_app/config/theme/app_colors.dart';
import 'package:pilates_app/config/theme/app_radius.dart';
import 'package:pilates_app/widgets/app_button.dart';

import '../../../../config/theme/app_spacing.dart';
import '../../../../config/theme/app_text_styles.dart';
import '../../../../core/localization/localization_extension.dart';
import '../../../../widgets/app_text.dart';

class RedemptionDetails extends StatelessWidget {
  const RedemptionDetails({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: EdgeInsets.all(AppSpacing.lmd),
      decoration: BoxDecoration(
        color:isDark ? AppColors.homeBackground: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: isDark ? AppColors.greyText: AppColors.buttonBorder, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildRow(
            isDark: isDark,
            title: context.l10n.redeem_how_to_collect,
            subtitle:
            context.l10n.redeem_collect_desc, ),
          SizedBox(height: AppSpacing.base),
          _buildRow(
            isDark: isDark,
            title: context.l10n.redeem_valid_for,
            subtitle: context.l10n.redeem_valid_desc, ),
          SizedBox(height: AppSpacing.base),
          _buildRow(
            isDark: isDark,
            title: context.l10n.redeem_available_at,
            subtitle: context.l10n.redeem_available_desc,
          ),
        ],
      ),
    );
  }

  _buildRow({
    required bool isDark,
    required String title,
    required String subtitle,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          Icons.check_circle_outline_rounded,
          size: 20,
          color:isDark ? AppColors.successBorderDark: AppColors.successColor,
        ),
        SizedBox(width: AppSpacing.sm),
        Expanded(
          child: Column(
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
                    AppTextStyles.bodyLightText(context).copyWith(fontSize: 12,height: 1.40),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
