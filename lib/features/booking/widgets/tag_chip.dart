import 'package:flutter/material.dart';

import '../../../config/theme/app_colors.dart';
import '../../../config/theme/app_radius.dart';
import '../../../config/theme/app_spacing.dart';
import '../../../config/theme/app_text_styles.dart';
import '../../../widgets/app_text.dart';

class TagChip extends StatelessWidget {
  final String label;
  final double fontSize;

  const TagChip({super.key, required this.label, required this.fontSize});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: EdgeInsets.symmetric(vertical: 1, horizontal: AppSpacing.sm),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkLightBlue : AppColors.lightBlue,
        borderRadius: BorderRadius.circular(AppRadius.base),
      ),
      child: AppText(
        label,
        style: (context) =>
            AppTextStyles.bodyText(
              context,
              fontWeight: FontWeight.w500,
            ).copyWith(
              fontSize: fontSize,
              height: 1.8,
              color: isDark ? AppColors.lightBlue : AppColors.darkBlue,
            ),
      ),
    );
  }
}
