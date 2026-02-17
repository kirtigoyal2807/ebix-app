import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pilates_app/config/theme/app_colors.dart';
import 'package:pilates_app/config/theme/app_radius.dart';
import 'package:pilates_app/config/theme/app_spacing.dart';
import 'package:pilates_app/config/theme/app_text_styles.dart';
import 'package:pilates_app/core/localization/localization_extension.dart';
import 'package:pilates_app/widgets/app_button.dart';
import 'package:pilates_app/widgets/app_text.dart';
import 'package:pilates_app/widgets/app_text_field.dart';

import 'gift_redeem_success_sheet.dart';

class RedeemGiftCardSheet extends StatelessWidget {
  const RedeemGiftCardSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isRTL = Directionality.of(context) == TextDirection.rtl;

    return Material(
      color: isDark ? AppColors.homeBackground : AppColors.whiteColor,
      borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.lg,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: AppText(
                      context.l10n.redeemGiftCard,
                      style: AppTextStyles.bottomSheetTitle,
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.close,
                      color: isDark
                          ? AppColors.whiteColor
                          : AppColors.blackColor,
                    ),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.xl),
              Center(
                child: SvgPicture.asset(
                  isDark?
                      "assets/images/svg/ic_dark_gift_card.svg"
                      :
                  "assets/images/svg/ic_gift_card.svg",
                  height: 192,
                  width: 192,
                ),
              ),

              const SizedBox(height: AppSpacing.lg),
              AppTextField(
                hint: context.l10n.enterGiftCardCode,
                label: context.l10n.enterRedeemCode,
                errorText: context.l10n.invalidGiftCardCode,
              ),
              const SizedBox(height: AppSpacing.xl),
              AppButton(
                label: context.l10n.redeemGift,
                onPressed: () {
                  Navigator.of(context).pop();
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    backgroundColor: Colors.transparent,
                    barrierColor: AppColors.bottomSheetShadow,
                    builder: (_) => GiftRedeemSuccessSheet(),
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
