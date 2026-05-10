import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pilates_app/config/theme/app_colors.dart';
import 'package:pilates_app/config/theme/app_radius.dart';
import 'package:pilates_app/config/theme/app_text_styles.dart';
import 'package:pilates_app/core/utils/currency_display.dart';
import 'package:pilates_app/widgets/app_text.dart';

import '../../../../../widgets/app_shadow.dart';

class PlanCard extends StatelessWidget {
  final String id;
  final String title;
  final String price;
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
    final parsedPrice = tryParseCurrencyAmount(price);

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
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    AppText(
                      title,
                      style: (context) => AppTextStyles.body(context).copyWith(
                        fontSize: 16,
                        color: isDark
                            ? AppColors.lightText
                            : AppColors.darkText,
                      ),
                    ),
                    if (badgeText != null)
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
                ),
                const SizedBox(height: 12),

                Row(
                  children: [
                    Expanded(
                      child: _PlanPriceText(
                        amount: parsedPrice,
                        currencyCode: currencyCode,
                        priceSuffix: priceSuffix,
                        style: (context) =>
                            AppTextStyles.body(context).copyWith(fontSize: 18),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _PlanPriceText extends StatelessWidget {
  const _PlanPriceText({
    required this.amount,
    required this.currencyCode,
    required this.priceSuffix,
    required this.style,
  });

  final num? amount;
  final String currencyCode;
  final String priceSuffix;
  final TextStyle Function(BuildContext) style;

  @override
  Widget build(BuildContext context) {
    final textStyle = style(context);
    if (amount == null) {
      return AppText('—', style: style);
    }

    if (!isSaudiRiyalCode(currencyCode)) {
      final formattedPrice = formatCurrencyAmount(
        amount: amount!,
        code: currencyCode,
      );
      final priceLine = priceSuffix.isNotEmpty
          ? '$formattedPrice$priceSuffix'
          : formattedPrice;
      return AppText(priceLine, style: style);
    }

    final fontSize = textStyle.fontSize ?? 18;
    final iconHeight = fontSize * 0.95;
    final iconWidth = iconHeight * 14 / 16;
    final suffix = priceSuffix;

    return Directionality(
      textDirection: TextDirection.ltr,
      child: Text.rich(
        TextSpan(
          style: textStyle,
          children: [
            WidgetSpan(
              alignment: PlaceholderAlignment.middle,
              child: Padding(
                padding: const EdgeInsets.only(right: 6),
                child: SvgPicture.asset(
                  'assets/images/svg/ic_Saudi_Riyal_Symbol.svg',
                  height: iconHeight,
                  width: iconWidth,
                ),
              ),
            ),
            TextSpan(text: '${amount!.toStringAsFixed(2)}$suffix'),
          ],
        ),
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}
