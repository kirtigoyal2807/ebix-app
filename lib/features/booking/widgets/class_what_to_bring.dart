import 'package:flutter/material.dart';
import 'package:pilates_app/config/theme/app_colors.dart';
import 'package:pilates_app/config/theme/app_spacing.dart';
import 'package:pilates_app/config/theme/app_text_styles.dart';
import 'package:pilates_app/core/localization/localization_extension.dart';
import 'package:pilates_app/widgets/app_text.dart';

class ClassWhatToBring extends StatelessWidget {
  const ClassWhatToBring({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final size = MediaQuery.sizeOf(context);

    final items = [
      context.l10n.itemAttire,
      context.l10n.itemWater,
      context.l10n.itemTowel,
      context.l10n.itemMat,
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText(
          context.l10n.whatToBring,
          style: (context) => AppTextStyles.heading1(context).copyWith(
            color: isDark ? AppColors.lightText : AppColors.darkText,
            fontSize: size.width * 0.055 > 18 ? 18 : size.width * 0.055,
            fontWeight: FontWeight.w400,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        Column(
          children: items.map((item) {
            return Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.xs),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(top: 8.0),
                    child: Icon(Icons.circle, size: 6, color: AppColors.greyText),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: AppText(
                      item,
                      style: (context) => AppTextStyles.bodyText(context),
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
