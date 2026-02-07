import 'package:flutter/material.dart';
import 'package:pilates_app/config/theme/app_colors.dart';
import 'package:pilates_app/config/theme/app_spacing.dart';
import 'package:pilates_app/config/theme/app_text_styles.dart';
import 'package:pilates_app/core/localization/localization_extension.dart';
import 'package:pilates_app/widgets/app_text.dart';

class ClassAboutSection extends StatelessWidget {
  const ClassAboutSection({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final size = MediaQuery.sizeOf(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText(
          context.l10n.aboutThisClass,
          style: (context) => AppTextStyles.heading1(context).copyWith(
            color: isDark ? AppColors.lightText : AppColors.darkText,
            fontSize: size.width * 0.055 > 18 ? 18 : size.width * 0.055,
            fontWeight: FontWeight.w400,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        AppText(
          context.l10n.aboutClassDescription,
          style: (context) => AppTextStyles.bodyText(context).copyWith(
            height: 1.6,
          ),
          maxLines: 5,
        ),
      ],
    );
  }
}
