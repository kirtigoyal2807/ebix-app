import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:pilates_app/config/theme/app_colors.dart';
import 'package:pilates_app/config/theme/app_spacing.dart';
import 'package:pilates_app/config/theme/app_text_styles.dart';
import 'package:pilates_app/core/localization/localization_extension.dart';
import 'package:pilates_app/features/explore/widget/receive_gift_sheet.dart';
import 'package:pilates_app/widgets/app_button.dart';
import 'package:pilates_app/widgets/app_text.dart';

class GiftRedeemSuccessSheet extends StatelessWidget {
  const GiftRedeemSuccessSheet({super.key, this.onContinue});

  /// When provided, replaces the legacy "open ReceiveGiftSheet again" behavior
  /// so callers (e.g. the pending-gift home flow) can dismiss and refresh state.
  final VoidCallback? onContinue;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isRTL = Directionality.of(context) == TextDirection.rtl;

    return Material(
      color: isDark ? AppColors.homeBackground : AppColors.whiteColor,
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: EdgeInsets.only(
            left: AppSpacing.lg,
            right: AppSpacing.lg,
            top: AppSpacing.lg,
            bottom: AppSpacing.bottomActionPadding,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                children: [
                  Expanded(
                    child: AppText(
                      context.l10n.redeemGiftCard,
                      style: AppTextStyles.bottomSheetTitle,
                    ),
                  ),
                  GestureDetector(
                    child: Icon(
                      Icons.close,
                      color: isDark
                          ? AppColors.whiteColor
                          : AppColors.blackColor,
                    ),
                    onTap: () {
                      if (onContinue != null) {
                        onContinue!();
                      } else {
                        Navigator.of(context).pop();
                      }
                    },
                  ),
                ],
              ),
              SizedBox(height: AppSpacing.xl),
              Lottie.asset(
                "assets/json/tick.json",
                alignment: Alignment.center,
                repeat: false,
                width: 150,
                height: 150,
              ),

              SizedBox(height: AppSpacing.md),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                child: AppText(
                  context.l10n.giftRedeemedSuccess,
                  style: (context) =>
                      AppTextStyles.gelasioMedium(context).copyWith(
                        fontSize: 24,
                        color: isDark ? AppColors.lightText : Color(0xff0D0D12),
                        height: 1.2,
                      ),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(height: AppSpacing.xl),
              AppButton(
                label: context.l10n.continueTxt,
                onPressed: () {
                  if (onContinue != null) {
                    onContinue!();
                    return;
                  }
                  Navigator.of(context).pop();
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    backgroundColor: Colors.transparent,
                    barrierColor: AppColors.bottomSheetShadow,
                    builder: (_) => ReceiveGiftSheet(),
                  );
                },
                variant: AppButtonVariant.primary,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
