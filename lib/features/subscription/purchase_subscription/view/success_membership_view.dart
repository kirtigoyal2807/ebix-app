import 'package:flutter/material.dart';
import 'package:pilates_app/config/theme/app_colors.dart';
import 'package:pilates_app/config/theme/app_radius.dart';
import 'package:pilates_app/config/theme/app_spacing.dart';
import 'package:pilates_app/config/theme/app_text_styles.dart';
import 'package:pilates_app/features/subscription/purchase_subscription/view/widgets/invoice_details_card.dart';
import 'package:pilates_app/widgets/app_button.dart';
import 'package:pilates_app/widgets/app_text.dart';

import '../../../../core/localization/localization_extension.dart';

class SuccessMembershipView extends StatelessWidget {
  const SuccessMembershipView({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.only(
            left: AppSpacing.lg,
            right: AppSpacing.lg,
            top: 36 + MediaQuery.of(context).viewPadding.top,
            bottom: AppSpacing.lg,
          ),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomLeft,
              stops: [0.1514, 1.0], // 15.14% → 0.1514, 105.62% clamped to 1.0
              colors: [Color(0xFF3D281A), Color(0xFF9A7E6D)],
            ),
          ),
          child: Column(
            children: [
              Container(
                height: 64,
                width: 64,
                decoration: BoxDecoration(
                  color: isDark
                      ? AppColors.successColor.withValues(alpha: 0.61)
                      : AppColors.successColor,
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.check, color: Colors.white, size: 48),
              ),

              SizedBox(height: AppSpacing.md),

              AppText(
                context.l10n.welcomeToPilates,
                style: (context) =>
                    AppTextStyles.gelasioMedium(context).copyWith(
                      color: isDark ? AppColors.lightText : Colors.white,
                      height: 1.55,
                    ),
              ),
              SizedBox(height: AppSpacing.xs),
              AppText(
                context.l10n.membershipSetup,
                style: (context) => AppTextStyles.bodyText(context).copyWith(
                  color: isDark ? AppColors.lightText : Colors.white,
                  height: 1.55,
                ),
              ),
              SizedBox(height: AppSpacing.lg),
              InvoiceDetailsCard(),
              SizedBox(height: AppSpacing.lg),
              Container(
                padding: EdgeInsets.all(AppSpacing.md),
                decoration: BoxDecoration(
                  color: isDark
                      ? AppColors.successColor.withValues(alpha: 0.61)
                      : AppColors.featuredTagBackgroundColor,
                  borderRadius: BorderRadius.circular(AppRadius.base),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.done,
                      size: 16,
                      color: isDark
                          ? AppColors.successBorderDark
                          : AppColors.successColor,
                    ),
                    SizedBox(width: AppSpacing.sm),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AppText(
                          context.l10n.creditsReady,
                          style: (context) =>
                              AppTextStyles.bodyText(context).copyWith(
                                color: isDark
                                    ? AppColors.lightText
                                    : AppColors.successColor,
                                fontWeight: FontWeight.w600,
                                height: 1.55,
                                fontSize: 12,
                              ),
                        ),
                        SizedBox(height: 2),
                        AppText(
                          context.l10n.bookFirstClass,
                          style: (context) =>
                              AppTextStyles.bodyText(context).copyWith(
                                color: isDark
                                    ? AppColors.successBorderDark
                                    : AppColors.greyText,
                                fontWeight: FontWeight.w400,
                                height: 1.55,
                                fontSize: 12,
                              ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 27),
              AppButton(
                label: context.l10n.startExploring,
                onPressed: () {},
                variant: AppButtonVariant.primary,
              ),

              SizedBox(height: AppSpacing.sm),
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
                  label: context.l10n.downloadInvoice,
                  onPressed: () {},
                  variant: AppButtonVariant.secondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
