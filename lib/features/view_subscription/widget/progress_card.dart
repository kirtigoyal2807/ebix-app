import 'package:flutter/material.dart';
import 'package:pilates_app/config/theme/app_colors.dart';
import 'package:pilates_app/config/theme/app_spacing.dart';
import 'package:pilates_app/config/theme/app_text_styles.dart';
import 'package:pilates_app/widgets/app_text.dart';

import '../../../config/theme/app_radius.dart';
import '../../../core/localization/localization_extension.dart';

class ProgressBarCard extends StatelessWidget {
  const ProgressBarCard({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: isDark
            ? AppColors.primaryDarkContainer
            : AppColors.subscriptionCardGradient1,
        borderRadius: BorderRadius.circular(AppRadius.sm),
      ),
      child: Column(
        children: [
          _buildRow(
            label: context.l10n.classesUsed,
            value: "12 / 15",
            isDark: isDark,
          ),
          SizedBox(height: AppSpacing.sm),
          ClipRRect(
            borderRadius: BorderRadius.circular(64),
            child: LinearProgressIndicator(
              value: 0.8,
              backgroundColor: isDark
                  ? AppColors.primary
                  : AppColors.buttonBorder,
              color: AppColors.successColor,
              minHeight: 8,
            ),
          ),
          SizedBox(height: AppSpacing.md),
          _buildRow(
            label: context.l10n.pauseUsed,
            value: "7 / 14",
            isDark: isDark,
          ),
          SizedBox(height: AppSpacing.sm),
          ClipRRect(
            borderRadius: BorderRadius.circular(64),
            child: LinearProgressIndicator(
              value: 0.45,
              backgroundColor: isDark
                  ? AppColors.primary
                  : AppColors.buttonBorder,
              color: AppColors.successColor,
              minHeight: 8,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRow({
    required String label,
    required String value,
    required bool isDark,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        AppText(
          label,
          style: (context) => AppTextStyles.bodyText(context).copyWith(
            fontSize: 12,
            color: isDark ? AppColors.lightText : Colors.white,
            height: 1.2,
          ),
        ),

        AppText(
          value,
          style: (context) => AppTextStyles.bodyText(context).copyWith(
            fontSize: 12,
            color: isDark ? AppColors.lightText : Colors.white,
            height: 1.2,
          ),
        ),
      ],
    );
  }
}
