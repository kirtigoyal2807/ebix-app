import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pilates_app/config/theme/app_colors.dart';
import 'package:pilates_app/config/theme/app_radius.dart';
import 'package:pilates_app/config/theme/app_spacing.dart';
import 'package:pilates_app/widgets/app_button.dart';
import 'package:pilates_app/widgets/app_text.dart';

import '../../../../config/theme/app_text_styles.dart';
import '../../../../core/localization/arb/app_localizations.dart';
import 'gift_successfully_view.dart';

class WelcomeToPilateView extends StatelessWidget {
  const WelcomeToPilateView({super.key});

  @override
  Widget build(BuildContext context) {
    final statusPadding = MediaQuery.of(context).viewPadding.top;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(
            top: 34 + statusPadding,
            left: AppSpacing.lg,
            right: AppSpacing.lg,
            bottom: 34,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SvgPicture.asset("assets/images/svg/ic_celebration.svg"),

              SizedBox(height: AppSpacing.md),
              AppText(
                l10n.welcomeToPilates,
                style: (context) =>
                    AppTextStyles.gelasioMedium(context).copyWith(height: 1.55),
              ),

              SizedBox(height: AppSpacing.xs),
              AppText(
                l10n.membershipSetup,
                style: (context) =>
                    AppTextStyles.bodyText(context).copyWith(height: 1.55),
              ),
              SizedBox(height: AppSpacing.lg),
              Container(
                decoration: BoxDecoration(
                  color: isDark ? AppColors.homeBackground : Colors.white,
                  borderRadius: BorderRadius.circular(AppRadius.base),
                  border: Border.all(
                    width: 1,
                    color: isDark ? AppColors.greyText : AppColors.buttonBorder,
                  ),
                ),
                padding: const EdgeInsets.only(
                  top: AppSpacing.md,
                  left: AppSpacing.md,
                  right: AppSpacing.md,
                  bottom: AppSpacing.md,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// HEADER
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AppText(
                          l10n.invoiceDetails,
                          style: (context) => AppTextStyles.textFieldHeading(
                            context,
                          ).copyWith(fontSize: 14),
                        ),
                        SvgPicture.asset(
                          isDark
                              ? "assets/images/svg/ic_dark_the_pilates_studio.svg"
                              : "assets/images/svg/ic_the_pilates_studio.svg",
                        ),
                      ],
                    ),

                    const SizedBox(height: AppSpacing.md),

                    AppText(
                      l10n.invoiceNumber('#2026-0123-456'),
                      style: (context) =>
                          AppTextStyles.textFieldHeading(context).copyWith(
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            color: AppColors.lightGrey,
                          ),
                    ),

                    AppText(
                      l10n.invoiceDate,
                      style: (context) =>
                          AppTextStyles.textFieldHeading(context).copyWith(
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            color: AppColors.lightGrey,
                          ),
                    ),

                    const SizedBox(height: 64),

                    _buildRow(l10n.premiumPlanMonthly, "\$89.00", isDark),
                    const SizedBox(height: AppSpacing.xs),
                    _buildRow(l10n.setupFee, "\$0.00", isDark),
                    const SizedBox(height: AppSpacing.xs),
                    _buildRow(l10n.discount, "-\$10.00", isDark),
                    const SizedBox(height: AppSpacing.xs),
                    _buildRow(l10n.tax, "\$6.32", isDark),

                    const SizedBox(height: AppSpacing.md),
                    Divider(
                      color: isDark
                          ? AppColors.greyText
                          : AppColors.buttonBorder,
                      height: 1,
                    ),
                    const SizedBox(height: AppSpacing.md),

                    _buildRow(l10n.totalPaid, "\$85.32", isDark, isBold: true),

                    const SizedBox(height: AppSpacing.md),
                    Divider(
                      color: isDark
                          ? AppColors.greyText
                          : AppColors.buttonBorder,
                      height: 1,
                    ),
                    const SizedBox(height: AppSpacing.md),

                    _buildRow(l10n.paymentMethod, "•••• 3456", isDark),
                    const SizedBox(height: AppSpacing.xs),
                    _buildRow(l10n.nextBillingDateText, "Feb 23, 2026", isDark),
                  ],
                ),
              ),
              SizedBox(height: AppSpacing.md),
              Container(
                padding: EdgeInsets.all(AppSpacing.md),
                decoration: BoxDecoration(
                  color: isDark
                      ? AppColors.successColor.withValues(alpha: 0.36)
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
                          ? AppColors.lightGreyColor
                          : Color(0xff1C1B1F),
                    ),
                    SizedBox(width: AppSpacing.sm),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AppText(
                          l10n.creditsReady,
                          style: (context) =>
                              AppTextStyles.bodyText(context).copyWith(
                                color: isDark
                                    ? AppColors.lightText
                                    : AppColors.greyText,
                                fontWeight: FontWeight.w600,
                                height: 1.55,
                                fontSize: 12,
                              ),
                        ),
                        SizedBox(height: 2),
                        AppText(
                          l10n.bookFirstClass,
                          style: (context) =>
                              AppTextStyles.bodyText(context).copyWith(
                                color: isDark
                                    ? AppColors.lightGreyColor
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
              SizedBox(height: AppSpacing.xl),
              AppButton(
                label: l10n.startExploringClasses,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const GiftSuccessfullyView(),
                    ),
                  );
                },
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
                  label: l10n.downloadInvoice,
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

  static Widget _buildRow(
    String title,
    String value,
    bool isDark, {
    bool isBold = false,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        AppText(
          title,
          style: (context) => AppTextStyles.textFieldHeading(context).copyWith(
            fontSize: 12,
            fontWeight: FontWeight.w400,
            color: isDark ? AppColors.darkGreyText : AppColors.lightGrey,
            height: 1.2,
          ),
        ),

        AppText(
          value,
          style: (context) => AppTextStyles.textFieldHeading(context).copyWith(
            fontSize: 12,
            color: isDark ? AppColors.lightText : AppColors.greyText,
            height: 1.2,
          ),
        ),
      ],
    );
  }
}
