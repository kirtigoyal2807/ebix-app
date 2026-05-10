import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:pilates_app/config/theme/app_colors.dart';
import 'package:pilates_app/config/theme/app_radius.dart';
import 'package:pilates_app/config/theme/app_spacing.dart';
import 'package:pilates_app/features/home/home_tab_intent.dart';
import 'package:pilates_app/widgets/app_button.dart';
import 'package:pilates_app/widgets/app_text.dart';

import '../../../../config/theme/app_text_styles.dart';
import '../../../../core/localization/arb/app_localizations.dart';
import '../../../../widgets/dotted_underline.dart';

class GiftSuccessfullyView extends StatelessWidget {
  const GiftSuccessfullyView({
    super.key,
    this.recipientName,
    this.recipientEmail,
    this.deliveryMethodValue,
  });

  /// When both [recipientName] and [recipientEmail] are null, demo placeholders
  /// are used (e.g. entry from [WelcomeToPilateView]). Otherwise missing strings
  /// show an em dash.
  final String? recipientName;
  final String? recipientEmail;

  /// Shown as the delivery row value; defaults to [AppLocalizations.deliveryMethodInstant].
  final String? deliveryMethodValue;

  bool get _useDemoPlaceholders =>
      recipientName == null && recipientEmail == null;

  String _displayName() {
    if (_useDemoPlaceholders) return 'Sarah';
    final t = recipientName?.trim();
    return (t != null && t.isNotEmpty) ? t : '—';
  }

  String _displayEmail() {
    if (_useDemoPlaceholders) return 'Sarah@gmail.com';
    final t = recipientEmail?.trim();
    return (t != null && t.isNotEmpty) ? t : '—';
  }

  String _deliveryDisplay(AppLocalizations l10n) {
    final t = deliveryMethodValue?.trim();
    return (t != null && t.isNotEmpty) ? t : l10n.deliveryMethodInstant;
  }

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
            Lottie.asset(
              "assets/json/gift.json",
              height: 120,
              width: 120,
              repeat: false,
            ),

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
              padding: EdgeInsets.only(
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

                  SizedBox(height: 46),

                  _buildRow(l10n.recipientName, _displayName(), isDark),

                  SizedBox(height: AppSpacing.sm),
                  SizedBox(
                    width: double.infinity,
                    child: CustomPaint(
                      painter: DashedUnderlinePainter(
                        color: isDark
                            ? AppColors.greyText
                            : AppColors.buttonBorder,
                        dashWidth: 3,
                        dashSpace: 3,
                      ),
                    ),
                  ),

                  SizedBox(height: AppSpacing.sm),
                  _buildRow(l10n.email, _displayEmail(), isDark),
                  SizedBox(height: AppSpacing.sm),
                  SizedBox(
                    width: double.infinity,
                    child: CustomPaint(
                      painter: DashedUnderlinePainter(
                        color: isDark
                            ? AppColors.greyText
                            : AppColors.buttonBorder,
                        dashWidth: 3,
                        dashSpace: 3,
                      ),
                    ),
                  ),
                  SizedBox(height: AppSpacing.sm),
                  _buildRow(
                    l10n.deliveryMethod,
                    _deliveryDisplay(l10n),
                    isDark,
                  ),
                  SizedBox(height: AppSpacing.sm),
                  SizedBox(
                    width: double.infinity,
                    child: CustomPaint(
                      painter: DashedUnderlinePainter(
                        color: isDark
                            ? AppColors.greyText
                            : AppColors.buttonBorder,
                        dashWidth: 3,
                        dashSpace: 3,
                      ),
                    ),
                  ),
                  SizedBox(height: AppSpacing.sm),
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
                        : AppColors.GreyColor,
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
                                : AppColors.GreyColor,
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
              onPressed: () {
                homeTabIntent.value = 0;
                Navigator.of(
                  context,
                  rootNavigator: true,
                ).popUntil((route) => route.isFirst);
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

  static Widget _buildRow(String title, String value, bool isDark) {
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
