import 'package:flutter/material.dart';
import 'package:pilates_app/config/theme/app_colors.dart';
import 'package:pilates_app/config/theme/app_radius.dart';
import 'package:pilates_app/config/theme/app_spacing.dart';
import 'package:pilates_app/config/theme/app_text_styles.dart';
import 'package:pilates_app/core/localization/localization_extension.dart';
import 'package:pilates_app/widgets/app_text.dart';

class ClassLocationCard extends StatelessWidget {
  const ClassLocationCard({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: isDark ? AppColors.homeBackground : AppColors.whiteColor,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(
          color: isDark ? AppColors.greyText : AppColors.buttonBorder,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppText(
            context.l10n.location,
            style: (context) => AppTextStyles.captionText(context).copyWith(
              color: AppColors.lightGrey,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          AppText(
            context.l10n.branchDowntown,
            style: (context) => AppTextStyles.boldBody(context).copyWith(
              fontSize: 14,
              color: isDark ? AppColors.lightText : AppColors.darkText,
            ),
          ),
          AppText(
            context.l10n.branchAddressDetail,
            style: (context) => AppTextStyles.boldBody(context).copyWith(
              fontSize: 14,
              color: isDark ? AppColors.lightText : AppColors.darkText,
            ),
          ),
        ],
      ),
    );
  }
}
