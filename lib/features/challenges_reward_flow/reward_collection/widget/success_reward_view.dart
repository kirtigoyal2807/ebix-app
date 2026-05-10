import 'package:flutter/material.dart';
import 'package:pilates_app/config/theme/app_colors.dart';
import 'package:pilates_app/config/theme/app_radius.dart';
import 'package:pilates_app/config/theme/app_spacing.dart';
import 'package:pilates_app/config/theme/app_text_styles.dart';
import 'package:pilates_app/core/localization/localization_extension.dart';
import 'package:pilates_app/widgets/app_button.dart';
import 'package:pilates_app/widgets/app_text.dart';

class RewardRedeemSuccessSheet extends StatelessWidget {
  const RewardRedeemSuccessSheet({super.key});

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
          padding: EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.lg,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                children: [
                  Expanded(
                    child: AppText(
                      context.l10n.redeem_reward,
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
                    onTap: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
              SizedBox(height: AppSpacing.xl),
              Container(
                height: 100,
                width: 100,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: isDark
                      ? AppColors.successColor.withValues(alpha: 0.61)
                      : AppColors.successColor,
                  borderRadius: BorderRadius.circular(AppRadius.pillRadius),
                ),
                child: const Icon(Icons.done, color: Colors.white, size: 80),
              ),
              SizedBox(height: AppSpacing.md),
              AppText(
                context.l10n.rewardRedemption,
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
                label: context.l10n.continueTxt,
                onPressed: () {
                  Navigator.of(context).pop();
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
