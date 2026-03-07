import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lottie/lottie.dart';
import 'package:pilates_app/config/theme/app_colors.dart';
import 'package:pilates_app/config/theme/app_radius.dart';
import 'package:pilates_app/config/theme/app_spacing.dart';
import 'package:pilates_app/widgets/app_button.dart';
import 'package:pilates_app/widgets/app_text.dart';

import '../../../../config/theme/app_text_styles.dart';
import '../../../../core/localization/arb/app_localizations.dart';
import '../../../../widgets/dotted_underline.dart';
import '../../purchase_subscription/view/widgets/plan_details_modal.dart';

class GiftSuccessfullyView extends StatelessWidget {
  const GiftSuccessfullyView({super.key});

  @override
  Widget build(BuildContext context) {
    final statusPadding = MediaQuery.of(context).viewPadding.top;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      body: Padding(
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


            Lottie.asset("assets/json/gift.json",height: 120,width: 120,repeat: false),

            SizedBox(height: AppSpacing.md),
            AppText(
              l10n.giftSentSuccessfully,
              style: (context) =>
                  AppTextStyles.gelasioMedium(context).copyWith(height: 1.55),
            ),

            SizedBox(height: AppSpacing.xs),
            AppText(
              l10n.giftProcessedMessage,
              style: (context) =>
                  AppTextStyles.bodyText(context).copyWith(height: 1.55),
              textAlign: TextAlign.center,
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
                  AppText(
                    l10n.deliverySummary,
                    style: (context) => AppTextStyles.bodyText(
                      context,
                    ).copyWith(fontWeight: FontWeight.w600),
                  ),

                  const SizedBox(height: 46),

                  _buildRow(l10n.recipientName, "Sarah", isDark),

                  const SizedBox(height: AppSpacing.sm),
                  SizedBox(
                    width: double.infinity,
                    child: CustomPaint(
                      painter: DashedUnderlinePainter(
                        color:  isDark ? AppColors.greyText : AppColors.buttonBorder,
                        dashWidth: 3,
                        dashSpace: 3,
                      ),
                    ),
                  ),

                  const SizedBox(height: AppSpacing.sm),
                  _buildRow(l10n.email, "Sarah@gmail.com", isDark),
                  const SizedBox(height: AppSpacing.sm),
                  SizedBox(
                    width: double.infinity,
                    child: CustomPaint(
                      painter: DashedUnderlinePainter(
                        color:  isDark ? AppColors.greyText : AppColors.buttonBorder,
                        dashWidth: 3,
                        dashSpace: 3,
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  _buildRow(
                    l10n.deliveryMethod,
                    l10n.deliveryMethodInstant,
                    isDark,
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  SizedBox(
                    width: double.infinity,
                    child: CustomPaint(
                      painter: DashedUnderlinePainter(
                        color:  isDark ? AppColors.greyText : AppColors.buttonBorder,
                        dashWidth: 3,
                        dashSpace: 3,
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  _buildRow(l10n.giftStatus, l10n.delivered, isDark),
                ],
              ),
            ),
            SizedBox(height: AppSpacing.md),
            Container(
              padding: EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                color: isDark
                    ? AppColors.successColor.withValues(alpha: 0.3)
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
                        : Color(0xff1C1B1F),
                    fontWeight: FontWeight.bold,
                  ),
                  SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: AppText(
                      l10n.redemptionEmailMessage,
                      style: (context) =>
                          AppTextStyles.bodyText(context).copyWith(
                            color: isDark
                                ? AppColors.lightGreyColor
                                : AppColors.greyText,
                            fontWeight: FontWeight.w600,
                            height: 1.55,
                            fontSize: 12,
                          ),
                      maxLines: 3,
                    ),
                  ),
                ],
              ),
            ),
            Spacer(),
            AppButton(
              label: l10n.startExploringClasses,
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
                label: l10n.sendAnotherGift,
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pop(context);
                  Navigator.pop(context);
                  Navigator.pop(context);
                  // final plan = {
                  //   'id': 'premium',
                  //   'title': l10n.premiumPlanTitle,
                  //   'price': '89\$',
                  //   'badge': l10n.mostPopular,
                  //   'isPopular': true,
                  //   'features': [
                  //     l10n.feature12Classes,
                  //     l10n.featureDowntownUptown,
                  //     l10n.featureFreeMatEquipment,
                  //     l10n.featurePriorityBooking,
                  //   ],
                  // };
                  // showModalBottomSheet(
                  //   context: context,
                  //   isScrollControlled: true,
                  //   backgroundColor: Colors.transparent,
                  //   barrierColor:     AppColors.bottomSheetShadow,
                  //   builder: (context) => PlanDetailsModal(
                  //     plan: plan,
                  //     appLabel: l10n.continueTxt,
                  //   ),
                  // );
                },
                variant: AppButtonVariant.secondary,
              ),
            ),
          ],
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
            color: isDark ? AppColors.lightGrey : AppColors.lightGrey,
            height: 1.2,
          ),
        ),

        AppText(
          value,
          style: (context) => AppTextStyles.textFieldHeading(context).copyWith(
            fontSize: 12,
            color: isDark ? AppColors.darkGreyText : AppColors.greyText,
            height: 1.2,
          ),
        ),
      ],
    );
  }
}
