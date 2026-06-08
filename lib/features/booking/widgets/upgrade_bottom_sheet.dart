import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pilates_app/config/theme/app_colors.dart';
import 'package:pilates_app/config/theme/app_spacing.dart';
import 'package:pilates_app/config/theme/app_text_styles.dart';
import 'package:pilates_app/features/subscription/purchase_subscription/view/subscription_view.dart';
import 'package:pilates_app/widgets/app_text.dart';
import 'package:pilates_app/widgets/currency_amount_text.dart';

import '../../../config/theme/app_radius.dart';
import '../../../core/localization/localization_extension.dart';
import '../../../widgets/app_button.dart';

class BranchNotInPlanSheet extends StatelessWidget {
  const BranchNotInPlanSheet({
    super.key,
    this.singleClassPrice,
    this.showPaySingleClass = true,
    this.onPaySingleClass,
  });

  final num? singleClassPrice;

  /// When false, only [Buy a Plan] is shown (no drop-in for this class).
  final bool showPaySingleClass;

  final VoidCallback? onPaySingleClass;

  static const String _currencyCode = 'SAR';

  static void show(
    BuildContext context, {
    num? singleClassPrice,
    bool showPaySingleClass = true,
    VoidCallback? onPaySingleClass,
  }) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: AppColors.bottomSheetShadow,
      builder: (sheetContext) => BranchNotInPlanSheet(
        singleClassPrice: singleClassPrice,
        showPaySingleClass: showPaySingleClass,
        onPaySingleClass: onPaySingleClass == null
            ? null
            : () {
                Navigator.of(sheetContext).pop();
                onPaySingleClass();
              },
      ),
    );
  }

  void _onBuyPlan(BuildContext context) {
    Navigator.of(context).pop();
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => const SubscriptionView(),
      ),
    );
  }

  Widget _paySingleClassButton(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final l10n = context.l10n;
    final textStyle = AppTextStyles.button(context).copyWith(
      color: isDark ? AppColors.lightText : AppColors.darkText,
      fontSize: 16,
    );

    return Container(
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
      child: SizedBox(
        width: double.infinity,
        height: AppSpacing.buttonHeight,
        child: OutlinedButton(
          onPressed: onPaySingleClass,
          style: OutlinedButton.styleFrom(
            foregroundColor: isDark
                ? AppColors.primaryDark
                : AppColors.primaryBrown,
            side: BorderSide(
              color: isDark ? AppColors.greyText : AppColors.buttonBorder,
              width: 1.5,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppRadius.xl),
            ),
            padding: EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: (AppSpacing.buttonHeight - 30) / 2,
            ),
            fixedSize: Size(double.infinity, AppSpacing.buttonHeight),
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          child: Text.rich(
            TextSpan(
              style: textStyle,
              children: [
                TextSpan(text: l10n.paySingleClassPrefix),
                WidgetSpan(
                  alignment: PlaceholderAlignment.middle,
                  child: Directionality(
                    textDirection: TextDirection.ltr,
                    child: singleClassPrice == null
                        ? Text(
                            l10n.bookingPriceUnavailable,
                            style: textStyle,
                          )
                        : CurrencyAmountText(
                            amount: singleClassPrice,
                            currencyCode: _currencyCode,
                            style: (_) => textStyle,
                          ),
                  ),
                ),
                TextSpan(text: l10n.paySingleClassSuffix),
              ],
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return SafeArea(
      top: false,
      child: Container(
        padding: EdgeInsets.fromLTRB(
          AppSpacing.horizontalPadding,
          45,
          AppSpacing.horizontalPadding,
          AppSpacing.bottomActionPadding,
        ),
        decoration: BoxDecoration(
          color: isDark ? AppColors.homeBackground : Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
        ),
        child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          isDark
              ? SvgPicture.asset('assets/images/svg/ic_warning_dark.svg')
              : SvgPicture.asset('assets/images/svg/ic_warning.svg'),
          SizedBox(height: AppSpacing.lmd),
          AppText(
            context.l10n.branchNotInPlanTitle,
            textAlign: TextAlign.center,
            style: (context) => AppTextStyles.gelasioMedium(context),
          ),
          SizedBox(height: AppSpacing.xs),
          AppText(
            context.l10n.branchNotInPlanDescription,
            textAlign: TextAlign.center,
            style: (context) =>
                AppTextStyles.bodyText(context).copyWith(height: 1.55),
            maxLines: 3,
          ),
          SizedBox(height: AppSpacing.lg),
          AppButton(
            label: context.l10n.upgradeToElite,
            onPressed: () => _onBuyPlan(context),
            variant: AppButtonVariant.primary,
          ),
          if (showPaySingleClass && onPaySingleClass != null) ...[
            SizedBox(height: AppSpacing.sm),
            _paySingleClassButton(context),
          ],
          SizedBox(height: AppSpacing.sm),
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Padding(
              padding: EdgeInsets.symmetric(
                vertical: (AppSpacing.buttonHeight - 30) / 2,
              ),
              child: AppText(
                context.l10n.cancel,
                style: (context) => AppTextStyles.button(
                  context,
                ).copyWith(color: AppColors.lightGrey),
              ),
            ),
          ),
        ],
        ),
      ),
    );
  }
}
