import 'package:flutter/material.dart';
import 'package:pilates_app/config/theme/app_colors.dart';
import 'package:pilates_app/config/theme/app_radius.dart';
import 'package:pilates_app/config/theme/app_spacing.dart';
import 'package:pilates_app/config/theme/app_text_styles.dart';
import 'package:pilates_app/widgets/app_text.dart';

import '../../../core/localization/localization_extension.dart';

class ExistingPlanView extends StatelessWidget {
  const ExistingPlanView({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          children: [
            _buildCard(
              label:context.l10n.premiumPlan,
              subtitle:  context.l10n.upgradedFromBasic,
              date: context.l10n.sinceDate("Jan 15, 2026"),
              status:  context.l10n.activeStatus,
              isDark: isDark,
            ),
            SizedBox(height: AppSpacing.md),
            _buildCard(
              label:  context.l10n.basicPlan,
              subtitle:  context.l10n.initialSubscription,
              date: context.l10n.planDuration("Dec 2025", "Jan 2026"),
              status:  context.l10n.activeStatus,
              isDark: isDark,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCard({
    required String label,
    required String subtitle,
    required String date,
    required String status,
    required bool isDark,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: AppSpacing.lmd,
        horizontal: AppSpacing.md,
      ),
      decoration: BoxDecoration(
        color: isDark ? AppColors.homeBackground : Colors.white,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(
          color: isDark ? AppColors.greyText : AppColors.buttonBorder,
          width: 1,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,

        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText(
                  label,
                  style: (context) =>
                      AppTextStyles.experienceButton(context).copyWith(
                        color: isDark ? AppColors.lightText :  AppColors.darkText,
                      ),
                ),
                SizedBox(height: AppSpacing.sm),
                AppText(
                  subtitle,
                  style: (context) => AppTextStyles.bodyTextSmall(
                    context,
                  ).copyWith(color: AppColors.lightGrey),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              AppText(
                status,
                style: (context) => AppTextStyles.experienceButton(
                  context,
                ).copyWith(color: AppColors.successBorderDark),
              ),
              SizedBox(height: AppSpacing.sm),
              AppText(
                date,
                style: (context) => AppTextStyles.bodyTextSmall(
                  context,
                ).copyWith(color: AppColors.lightGrey),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
