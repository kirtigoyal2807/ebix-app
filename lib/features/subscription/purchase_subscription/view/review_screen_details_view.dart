import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../config/theme/app_colors.dart';
import '../../../../config/theme/app_radius.dart';
import '../../../../config/theme/app_spacing.dart';
import '../../../../config/theme/app_text_styles.dart';
import '../../../../core/localization/arb/app_localizations.dart';
import '../../../../widgets/app_button.dart';
import '../../../../widgets/app_shadow.dart';
import '../../../../widgets/app_text.dart';
import '../../../../widgets/app_text_field.dart';
import '../../../../widgets/dotted_underline.dart';

class ReviewScreenDetailsView extends StatelessWidget {
  const ReviewScreenDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;
    return Expanded(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppText(
                l10n.reviewYourSelection,
                style: (style) => AppTextStyles.heading1(context),
              ),
              const SizedBox(height: 4),
              AppText(
                l10n.confirmPlanDetails,
                style: (context) => AppTextStyles.bodyText(context),
              ),
              const SizedBox(height: AppSpacing.md),

              Container(
                padding: EdgeInsets.all(AppSpacing.lmd),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.homeBackground : Colors.white,
                  borderRadius: BorderRadius.circular(AppRadius.md),
                  border: Border.all(
                    color: isDark ? AppColors.greyText : AppColors.buttonBorder,
                    width: 1,
                  ),

                  boxShadow: [
                    AppShadows.lightShadow,
                    AppShadows.mediumShadow,
                    AppShadows.mediumHeavyShadow,
                    BoxShadow(
                      color: AppColors.shadowColor.withValues(alpha: 0.01),
                      offset: const Offset(0, 64),
                      blurRadius: 25,
                      spreadRadius: 0,
                    ),
                    BoxShadow(
                      color: AppColors.shadowColor.withValues(alpha: 0.00),
                      offset: const Offset(0, 99),
                      blurRadius: 28,
                      spreadRadius: 0,
                    ),
                  ],
                  // boxShadow: [
                  //   AppShadows.lightShadow,
                  //   AppShadows.mediumShadow,
                  //   AppShadows.mediumHeavyShadow,
                  //   AppShadows.heavyShadow,
                  //   AppShadows.extraHeavyShadow,
                  // ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(
                        vertical: 1,
                        horizontal: AppSpacing.sm,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.successColor,
                        borderRadius: BorderRadius.circular(AppRadius.base),
                      ),
                      child: AppText(
                        l10n.active,
                        style: (context) =>
                            AppTextStyles.bodyText(context,       fontWeight: FontWeight.w500,).copyWith(
                              color: Colors.white,

                              fontSize: 12,
                              height: 1.8,
                            ),
                      ),
                    ),
                    SizedBox(height: AppSpacing.base),
                    AppText(
                      l10n.premiumPlan,
                      style: (context) =>
                          AppTextStyles.bodyText(context,     fontWeight: FontWeight.w500,).copyWith(
                            color: isDark
                                ? AppColors.lightText
                                : AppColors.darkText,

                            fontSize: 24,
                          ),
                    ),
                    SizedBox(height: AppSpacing.md),
                    AppText(
                      l10n.pricePerMonth,
                      style: (context) =>
                          AppTextStyles.bodyText(context,  fontWeight: FontWeight.w500,).copyWith(
                            color: isDark
                                ? AppColors.languageTextDark
                                : AppColors.languageIcon,

                            fontSize: 18,
                            height: 0,
                          ),
                    ),
                    SizedBox(height: AppSpacing.xl),
                    _buildClassDetailRow(
                      label: "${l10n.startDate}:",
                      value: "${l10n.today} (Feb 12, 2026)",
                      isDark: isDark,
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    _buildClassDetailRow(
                      label: "${l10n.classesPerMonth}:",
                      value: "12",
                      isDark: isDark,
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    _buildClassDetailRow(
                      label: "${l10n.validAt}:",
                      value: l10n.featureStudios,
                      isDark: isDark,
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    _buildClassDetailRow(
                      label: "${l10n.nextBillingDateText}:",
                      value: "March 12, 2026",
                      isBorder: false,
                      isDark: isDark,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: AppSpacing.lg),

              Container(
                padding: EdgeInsets.all(AppSpacing.lmd),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.homeBackground : Colors.white,
                  borderRadius: BorderRadius.circular(AppRadius.md),
                  border: Border.all(
                    color: isDark ? AppColors.greyText : AppColors.buttonBorder,
                    width: 1,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppText(
                      l10n.haveVoucherCode,
                      style: (context) => AppTextStyles.gelasioRegular(
                        context,fontWeight: FontWeight.w500,
                      ).copyWith( height: 1.2),
                    ),
                    SizedBox(height: AppSpacing.md),
                    AppTextField(hint: l10n.enterVoucherCode),
                    SizedBox(height: AppSpacing.base),
                    AppButton(label: l10n.apply, onPressed: () {}),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              AppText(
                "${l10n.acceptedPaymentMethods}:",
                style: (context) =>
                    AppTextStyles.bodyTextSmall(context).copyWith(height: 1.2),
              ),
              const SizedBox(height: AppSpacing.md),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SvgPicture.asset(
                    isDark
                        ? "assets/images/svg/ic_dark_cs_mada.svg"
                        : "assets/images/svg/ic_cs_mada.svg",
                  ),
                  SizedBox(width: AppSpacing.sm),
                  SvgPicture.asset(
                    isDark
                        ? "assets/images/svg/ic_dark_tabby.svg"
                        : "assets/images/svg/ic_tabby.svg",
                  ),
                  SizedBox(width: AppSpacing.sm),
                  SvgPicture.asset(
                    isDark
                        ? "assets/images/svg/ic_dark_master.svg"
                        : "assets/images/svg/ic_master.svg",
                  ),
                  SizedBox(width: AppSpacing.sm),
                  SvgPicture.asset(
                    isDark
                        ? "assets/images/svg/ic_dark_visa.svg"
                        : "assets/images/svg/ic_visa.svg",
                  ), SizedBox(width: AppSpacing.sm),
                  SvgPicture.asset(
                    isDark
                        ? "assets/images/svg/ic_dark_tamara.svg"
                        : "assets/images/svg/ic_tamara.svg",
                  ),


                ],
              ),
              const SizedBox(height: 90),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildClassDetailRow({
    required String label,
    required String value,
    required bool isDark,
    bool isMultiLine = false,
    bool isBorder = true,
  }) {
    return SizedBox(
      width: double.infinity,
      child: CustomPaint(
        painter: isBorder
            ? DashedUnderlinePainter(
                color: isDark ? AppColors.greyText : AppColors.buttonBorder,
              )
            : null,
        child: Padding(
          padding: EdgeInsets.only(bottom: isBorder ? AppSpacing.sm : 0),
          child: Row(
            crossAxisAlignment: isMultiLine
                ? CrossAxisAlignment.start
                : CrossAxisAlignment.center,
            children: [
              Expanded(
                child: AppText(
                  label,
                  style: (context) => AppTextStyles.textFieldHeading(context),
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: AppText(
                  value,
                  style: (context) => AppTextStyles.bodyText(context),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
