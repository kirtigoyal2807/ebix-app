import 'package:flutter/material.dart';
import 'package:pilates_app/config/theme/app_colors.dart';
import 'package:pilates_app/config/theme/app_radius.dart';
import 'package:pilates_app/config/theme/app_text_styles.dart';
import 'package:pilates_app/core/utils/currency_display.dart';
import 'package:pilates_app/widgets/app_text.dart';
import 'package:pilates_app/widgets/currency_amount_text.dart';

import '../../../../../widgets/app_shadow.dart';

class PlanCard extends StatelessWidget {
  final String id;
  final String title;
  final String price;
  /// When set (from catalog [CatalogProduct.displayPrice]), used instead of parsing [price].
  final num? priceAmount;
  final String currencyCode;
  final bool isSelected;
  final bool isPopular;
  final String? badgeText; // e.g. "Most Popular" or "Starter"
  /// Billing line from catalog (e.g. ` / Month`, ` · 60 days`); empty hides suffix.
  final String priceSuffix;
  final VoidCallback onTap;

  const PlanCard({
    super.key,
    required this.id,
    required this.title,
    required this.price,
    this.priceAmount,
    this.currencyCode = 'SAR',
    required this.isSelected,
    this.badgeText,
    this.isPopular = false,
    this.priceSuffix = ' / Month',
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final parsedPrice = priceAmount ?? tryParseCurrencyAmount(price);

    return LayoutBuilder(
      // To ensure container doesn't overflow or break
      builder: (context, constraints) {
        return GestureDetector(
          onTap: onTap,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isDark ? AppColors.homeBackground : AppColors.whiteColor,
              borderRadius: BorderRadius.circular(AppRadius.md),
              border: Border.all(
                color: isDark ? AppColors.greyText : AppColors.buttonBorder,
              ),
              boxShadow: isDark
                  ? null
                  : [
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
                        textAlign: TextAlign.start,
                        style: (context) =>
                            AppTextStyles.body(context).copyWith(
                              fontSize: 16,
                              color: isDark
                                  ? AppColors.lightText
                                  : AppColors.darkText,
                            ),
                      ),
                    ),
                    if (badgeText != null) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color:
                              (
                              // isDark
                              // ? const Color(0x3BFDC700)
                              // :
                              AppColors.goldStarColor), // Gold for popular
                          borderRadius: BorderRadius.circular(20),
                          // border: isPopular ? null : Border.all(color: AppColors.lightGreyBorder),
                        ),
                        child: AppText(
                          badgeText!,
                          style: (context) =>
                              AppTextStyles.body(context).copyWith(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: (isDark
                                    ? AppColors.blackColor
                                    : AppColors.darkText),
                              ),
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 12),

                Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: CurrencyAmountText(
                    amount: parsedPrice,
                    currencyCode: currencyCode,
                    priceSuffix: priceSuffix,
                    textAlign: TextAlign.start,
                    style: (context) => AppTextStyles.body(context).copyWith(
                      fontSize: 18,
                      color: isDark
                          ? AppColors.lightText
                          : AppColors.darkText,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
