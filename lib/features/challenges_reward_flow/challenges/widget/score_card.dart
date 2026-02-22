import 'package:flutter/material.dart';
import 'package:pilates_app/config/theme/app_colors.dart';
import 'package:pilates_app/config/theme/app_spacing.dart';
import 'package:pilates_app/config/theme/app_text_styles.dart';
import 'package:pilates_app/core/localization/localization_extension.dart';
import 'package:pilates_app/widgets/app_text.dart';

import '../../../../config/theme/app_radius.dart';

class ScoreCard extends StatelessWidget {
  final int index;
  final String sortName;
  final String name;
  final String attendedClasses;

  const ScoreCard({
    super.key,
    required this.index,
    required this.sortName,
    required this.name,
    required this.attendedClasses,
  });

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
      child: Row(
        children: [
          AppText(
            "#$index",
            style: (context) => AppTextStyles.textFieldHeading(
              context,
            ).copyWith(fontSize: 16, height: 1.2),
          ),
          SizedBox(width: AppSpacing.xxl),
          Container(
            height: 48,
            width: 48,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: isDark
                  ? AppColors.trainerBlackBackgroundColor
                  : AppColors.seekBarLight,
              shape: BoxShape.circle,
            ),
            child: AppText(
              sortName,
              style: (context) => AppTextStyles.body(
                context,
              ).copyWith(fontSize: 20, height: 1.2),
            ),
          ),
          SizedBox(width: AppSpacing.base),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppText(
                name,
                style: (context) => AppTextStyles.textField(
                  context,
                ).copyWith(fontWeight: FontWeight.w500, height: 1.2),
              ),
              SizedBox(height: AppSpacing.xs),
              AppText(
                "$attendedClasses ${context.l10n.session_history_classes}",
                style: (context) => AppTextStyles.bodyTextSmall(context),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
