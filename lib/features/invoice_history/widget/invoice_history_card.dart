import 'package:flutter/material.dart';
import 'package:pilates_app/config/theme/app_colors.dart';
import 'package:pilates_app/config/theme/app_radius.dart';
import 'package:pilates_app/config/theme/app_spacing.dart';
import 'package:pilates_app/widgets/app_text.dart';

import '../../../config/theme/app_text_styles.dart';
import '../../../core/localization/localization_extension.dart';

class InvoiceHistoryCard extends StatelessWidget {
  final String month;
  final String title;
  final String subTitle;
  final String date;
  final String amount;
  final bool? refund;

  const InvoiceHistoryCard({
    super.key,
    required this.month,
    required this.title,
    required this.subTitle,
    required this.date,
    required this.amount,
    this.refund = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText(
          month,
          style: (context) => AppTextStyles.bodyText(
            context,
          ).copyWith(fontWeight: FontWeight.w500, color: AppColors.lightGrey),
        ),
        SizedBox(height: AppSpacing.sm),
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.lmd,
          ),
          decoration: BoxDecoration(
            color: isDark ? AppColors.homeBackground : Colors.white,
            borderRadius: BorderRadius.circular(AppRadius.md),
            border: Border.all(
              width: 1,
              color: isDark ? AppColors.greyText : AppColors.buttonBorder,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  AppText(
                    title,
                    style: (context) => AppTextStyles.experienceButton(context),
                  ),
                  AppText(
                    amount,
                    style: (context) =>
                        AppTextStyles.experienceButton(context).copyWith(
                          color: refund == true
                              ? (isDark
                                    ? AppColors.successBorderDark
                                    : AppColors.successColor)
                              : isDark
                              ? AppColors.lightText
                              : AppColors.darkText,
                        ),
                  ),
                ],
              ),
              SizedBox(height: AppSpacing.xs),
              AppText(
                subTitle,
                style: (context) => AppTextStyles.bodyText(
                  context,
                ).copyWith(color: AppColors.lightGrey),
              ),
              SizedBox(height: AppSpacing.base),
              Row(
                children: [
                  AppText(
                    date,
                    style: (context) => AppTextStyles.bodyText(
                      context,
                    ).copyWith(color: AppColors.lightGrey, fontSize: 12),
                  ),
                  Spacer(),
                  AppText(
                    context.l10n.view,
                    style: (context) =>
                        AppTextStyles.body(context).copyWith(fontSize: 12),
                  ),
                  SizedBox(width: AppSpacing.md),
                  AppText(
                    context.l10n.download,
                    style: (context) =>
                        AppTextStyles.body(context).copyWith(fontSize: 12),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
