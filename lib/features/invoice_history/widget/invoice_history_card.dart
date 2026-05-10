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
  final VoidCallback? onView;
  final VoidCallback? onDownload;

  const InvoiceHistoryCard({
    super.key,
    required this.month,
    required this.title,
    required this.subTitle,
    required this.date,
    required this.amount,
    this.refund = false,
    this.onView,
    this.onDownload,
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
            fontWeight: FontWeight.w500,
          ).copyWith(color: AppColors.lightGrey),
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: AppText(
                      title,
                      maxLines: 2,
                      style: (context) =>
                          AppTextStyles.experienceButton(context),
                    ),
                  ),
                  SizedBox(width: AppSpacing.sm),
                  AppText(
                    amount,
                    maxLines: 1,
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
                maxLines: 2,
                style: (context) => AppTextStyles.bodyText(
                  context,
                ).copyWith(color: AppColors.lightGrey),
              ),
              SizedBox(height: AppSpacing.base),
              Row(
                children: [
                  Expanded(
                    child: AppText(
                      date,
                      maxLines: 2,
                      style: (context) => AppTextStyles.bodyText(
                        context,
                      ).copyWith(color: AppColors.lightGrey, fontSize: 12),
                    ),
                  ),
                  if (onView != null)
                    Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: onView,
                        borderRadius: BorderRadius.circular(4),
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            vertical: 6,
                            horizontal: 6,
                          ),
                          child: AppText(
                            context.l10n.view,
                            maxLines: 1,
                            style: (context) =>
                                AppTextStyles.body(context).copyWith(
                                  fontSize: 12,
                                  color: Theme.of(context).colorScheme.primary,
                                  fontWeight: FontWeight.w600,
                                ),
                          ),
                        ),
                      ),
                    ),
                  if (onDownload != null) ...[
                    SizedBox(width: AppSpacing.xs),
                    Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: onDownload,
                        borderRadius: BorderRadius.circular(4),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 6,
                            horizontal: 6,
                          ),
                          child: AppText(
                            context.l10n.download,
                            maxLines: 1,
                            style: (context) =>
                                AppTextStyles.body(context).copyWith(
                                  fontSize: 12,
                                  color: Theme.of(context).colorScheme.primary,
                                  fontWeight: FontWeight.w600,
                                ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
