import 'package:flutter/material.dart';
import 'package:pilates_app/config/theme/app_colors.dart';
import 'package:pilates_app/config/theme/app_radius.dart';
import 'package:pilates_app/core/localization/localization_extension.dart';
import 'package:pilates_app/widgets/app_button.dart';

import '../../../../config/theme/app_spacing.dart';
import '../../../../config/theme/app_text_styles.dart';
import '../../../../widgets/app_text.dart';
import '../view/loyalty_tiers_view.dart';

class SliverBenefitCard extends StatelessWidget {
  const SliverBenefitCard({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      margin: EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      padding: EdgeInsets.all(AppSpacing.lmd),
      decoration: BoxDecoration(
        color: isDark ? AppColors.homeBackground : AppColors.whiteColor,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(
          color: isDark ? AppColors.greyText : AppColors.buttonBorder,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildRow(
            isDark: isDark,
            title: context.l10n.featurePriorityBooking,
            subtitle: context.l10n.featurePriorityBookingDesc,
          ),
          SizedBox(height: AppSpacing.base),
          _buildRow(
            isDark: isDark,
            title: context.l10n.featureMerchDiscount,
            subtitle: context.l10n.featureMerchDiscountDesc,
          ),
          SizedBox(height: AppSpacing.base),
          _buildRow(
            isDark: isDark,
            title: context.l10n.featureGuestPass,
            subtitle: context.l10n.featureGuestPassDesc,
          ),
          SizedBox(height: AppSpacing.md),
          Container(
            decoration: BoxDecoration(
              color: isDark ? AppColors.homeBackground : Colors.white,
              borderRadius: BorderRadius.circular(AppRadius.xl),
              boxShadow: [
                BoxShadow(
                  color: AppColors.shadowColor.withValues(alpha: 0.06),
                  offset: const Offset(0, 1),
                  blurRadius: 2,
                  spreadRadius: 0,
                ),
              ],
            ),
            child: AppButton(
              label: context.l10n.viewAllTiers,
              onPressed: () {
                Navigator.of(context).push<void>(
                  MaterialPageRoute<void>(
                    builder: (_) => const LoyaltyTiersView(),
                  ),
                );
              },
              variant: AppButtonVariant.secondary,
            ),
          ),
        ],
      ),
    );
  }

  Row _buildRow({
    required bool isDark,
    required String title,
    required String subtitle,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          Icons.check_circle_outline_rounded,
          size: 24,
          color: isDark ? AppColors.successBorderDark : AppColors.successColor,
        ),
        SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppText(
              title,
              style: (context) => AppTextStyles.body(context).copyWith(
                color: isDark ? AppColors.lightText : AppColors.darkText,
              ),
            ),
            SizedBox(height: AppSpacing.xs),
            AppText(
              subtitle,
              style: (context) =>
                  AppTextStyles.bodyLightText(context).copyWith(fontSize: 12),
            ),
          ],
        ),
      ],
    );
  }
}
