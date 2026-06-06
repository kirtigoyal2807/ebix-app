import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pilates_app/config/theme/app_colors.dart';
import 'package:pilates_app/config/theme/app_spacing.dart';
import 'package:pilates_app/config/theme/app_text_styles.dart';
import 'package:pilates_app/core/localization/localization_extension.dart';
import 'package:pilates_app/features/auth/data/models/auth_user.dart';
import 'package:pilates_app/widgets/app_button.dart';
import 'package:pilates_app/widgets/app_text.dart';

class ReceiveGiftSheet extends StatelessWidget {
  const ReceiveGiftSheet({super.key, this.pendingGift, this.onViewGift});

  /// Optional pending gift used by the home-tab popup flow. When provided,
  /// [onViewGift] is invoked on tap of the View Gift button so the parent
  /// can route to the redemption details screen with this gift.
  final PendingGift? pendingGift;
  final VoidCallback? onViewGift;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

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
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  GestureDetector(
                    child: Icon(
                      Icons.close,
                      color: isDark
                          ? AppColors.whiteColor
                          : AppColors.blackColor,
                    ),
                    onTap: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
              Center(
                child: ClipOval(
                  child: SizedBox(
                    height: 192,
                    width: 192,
                    child: SvgPicture.asset(
                      isDark
                          ? "assets/images/svg/ic_dark_gift_card.svg"
                          : "assets/images/svg/ic_gift_card.svg",
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),

              SizedBox(height: AppSpacing.lg),
              AppText(
                context.l10n.giftReceivedTitle,
                style: (context) =>
                    AppTextStyles.gelasioMedium(context).copyWith(
                      fontSize: 24,
                      color: isDark ? AppColors.lightText : Color(0xff0D0D12),
                      height: 1.2,
                    ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: AppSpacing.xl),
              AppButton(
                label: context.l10n.viewGift,
                onPressed: () {
                  // Leave this sheet on the stack so the redemption screen can pop
                  // both it and [RedeemCardView] after a successful redeem flow.
                  onViewGift?.call();
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
