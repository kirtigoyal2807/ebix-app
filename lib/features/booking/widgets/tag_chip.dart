import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../config/theme/app_colors.dart';
import '../../../config/theme/app_radius.dart';
import '../../../config/theme/app_spacing.dart';
import '../../../config/theme/app_text_styles.dart';

class TagChip extends StatelessWidget {
  final String label;
  final double fontSize;
  final int maxLines;
  final Color? backgroundColor;
  final Color? textColor;
  final bool pillShape;
  final bool constrainWidth;

  const TagChip({
    super.key,
    required this.label,
    required this.fontSize,
    this.maxLines = 2,
    this.backgroundColor,
    this.textColor,
    this.pillShape = false,
    this.constrainWidth = true,
  });

  static const _textHeightBehavior = TextHeightBehavior(
    applyHeightToFirstAscent: false,
    applyHeightToLastDescent: false,
  );

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final chip = Container(
      padding: EdgeInsets.symmetric(
        vertical: AppSpacing.xs,
        horizontal: 10,
      ).r,
      decoration: BoxDecoration(
        color: backgroundColor ??
            (isDark ? AppColors.darkLightBlue : AppColors.lightBlue),
        borderRadius: BorderRadius.circular(
          pillShape ? AppRadius.pillRadius : AppRadius.base,
        ),
      ),
      child: Text(
        label,
        maxLines: maxLines,
        overflow: TextOverflow.ellipsis,
        textHeightBehavior: _textHeightBehavior,
        style: AppTextStyles.bodyText(
          context,
          fontWeight: FontWeight.w500,
        ).copyWith(
          fontSize: fontSize,
          height: 1,
          color: textColor ??
              (isDark ? AppColors.lightBlue : AppColors.darkBlue),
        ),
      ),
    );

    if (!constrainWidth) return chip;

    return ConstrainedBox(
      constraints: BoxConstraints(
        maxWidth: MediaQuery.sizeOf(context).width * 0.65,
      ),
      child: chip,
    );
  }
}
