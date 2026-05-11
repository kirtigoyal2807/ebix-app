import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../config/theme/app_colors.dart';
import '../../../config/theme/app_radius.dart';
import '../../../config/theme/app_spacing.dart';
import '../../../config/theme/app_text_styles.dart';
import '../../../widgets/app_text.dart';

class TagChip extends StatelessWidget {
  final String label;
  final double fontSize;
  final int maxLines;

  const TagChip({
    super.key,
    required this.label,
    required this.fontSize,
    this.maxLines = 2,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxWidth: MediaQuery.sizeOf(context).width * 0.65,
      ),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 2, horizontal: 10).r,
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkLightBlue : AppColors.lightBlue,
          borderRadius: BorderRadius.circular(AppRadius.base),
        ),
        child: AppText(
          label,
          maxLines: maxLines,
          overflow: TextOverflow.ellipsis,
          style: (context) =>
              AppTextStyles.bodyText(
                context,
                fontWeight: FontWeight.w500,
              ).copyWith(
                fontSize: fontSize,
                height: 1.35,
                color: isDark ? AppColors.lightBlue : AppColors.darkBlue,
              ),
        ),
      ),
    );
  }
}
