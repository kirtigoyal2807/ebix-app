import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pilates_app/config/theme/app_colors.dart';
import 'package:pilates_app/config/theme/app_radius.dart';
import 'package:pilates_app/config/theme/app_spacing.dart';
import 'package:pilates_app/core/localization/localization_extension.dart';
import 'package:pilates_app/widgets/app_app_bar.dart';
import 'package:pilates_app/widgets/app_button.dart';

import '../../../config/theme/app_text_styles.dart';
import '../../../widgets/app_text.dart';
import '../../../widgets/dotted_underline.dart';
import '../widget/redeem_gift_card_sheet.dart';

class RedeemCardView extends StatelessWidget {
  const RedeemCardView({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      decoration: BoxDecoration(
        color: AppColors.homeBackground,
        gradient: isDark
            ? null
            : const LinearGradient(
                begin: Alignment(-0.2, -1.0), // approximate for 168.39°
                end: Alignment(0.8, 1.0),
                colors: [
                  AppColors.subscriptionCardGradient1,
                  AppColors.subscriptionCardGradient2,
                ],
                stops: [0.1514, 1.0], // 15.14% → 1.0 (105% clamped)
              ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          surfaceTintColor: Colors.transparent,
          // IMPORTANT (Material 3)
          backgroundColor: Colors.transparent,
          scrolledUnderElevation: 0,
          // IMPORTANT
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios_rounded,
              size: 20,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),

          title: AppText(
            context.l10n.redeemGiftCard,
            style: (context) => AppTextStyles.appBarTitle(
              context,
            ).copyWith(color: isDark ? AppColors.lightText : Colors.white),
          ),
          centerTitle: true,
          elevation: 0,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsetsGeometry.symmetric(
              vertical: AppSpacing.md,
              horizontal: AppSpacing.lg,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SvgPicture.asset(
                  "assets/images/svg/ic_gift.svg",
                  height: 64,
                  width: 64,
                ),
                SizedBox(height: AppSpacing.md),
          
                AppText(
                    context.l10n.receivedGiftTitle,
                  style: (context) =>
                      AppTextStyles.gelasioMedium(context).copyWith(
                        color: isDark ? AppColors.lightText : Colors.white,
                        height: 1.55,
                      ),
                ),
          
                SizedBox(height: AppSpacing.xs),
                AppText(
                  context.l10n.receivedGiftSubtitle,
                  style: (context) => AppTextStyles.bodyText(context).copyWith(
                    color: isDark
                        ? AppColors.darkGreyText
                        : AppColors.selectedLanguageBg,
                    height: 1.55,
                  ),
                ),
                SizedBox(height: AppSpacing.lg),
                _messageCard(context: context),
                SizedBox(height: AppSpacing.lg),
                AppButton(
                  label: context.l10n.redeemYourGift,
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      backgroundColor: Colors.transparent,
                      barrierColor: AppColors.bottomSheetShadow,
                      builder: (_) => RedeemGiftCardSheet(),
                    );
                  },
                  variant: AppButtonVariant.primary,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _messageCard({required BuildContext context}) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: isDark ? AppColors.homeBackground : Colors.white,
        borderRadius: BorderRadius.circular(AppRadius.base),
        border: Border.all(
          color: isDark ? AppColors.greyText : AppColors.buttonBorder,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          AppText(
            context.l10n.message,
            style: (context) => AppTextStyles.bodyText(
              context,fontWeight: FontWeight.w500,
            ).copyWith(height: 1.2),
          ),
          SizedBox(height: AppSpacing.md),
          Container(
            padding: EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: isDark
                  ? AppColors.primaryDarkButton
                  : AppColors.containerGreyBg,
              borderRadius: BorderRadius.circular(AppRadius.base),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                AppText(
                  '''"${context.l10n.birthdayMessage}"''',
                  style: (context) =>
                      AppTextStyles.captionText(context).copyWith(
                        color: isDark
                            ? AppColors.darkGreyText
                            : AppColors.lightGrey,
                        height: 1.5,
                      ),
                  maxLines: 3,
                ),
                SizedBox(height: AppSpacing.sm),
                AppText(
                context.l10n.giftSender,
                  style: (context) => AppTextStyles.captionText(
                    context,
                  ).copyWith(color: isDark
                      ? AppColors.darkGreyText
                      :  AppColors.lightGrey, height: 1.5),
                ),
              ],
            ),
          ),
          SizedBox(height: AppSpacing.xl),
          AppText(
            context.l10n.yourGiftIncludes,
            style: (context) => AppTextStyles.bodyText(
              context,fontWeight: FontWeight.w500,
            ).copyWith( height: 1.2),
          ),
          SizedBox(height: AppSpacing.md),
          _checkedRow(context: context, feature: context.l10n.featureClasses),
          SizedBox(height: AppSpacing.sm),
          _checkedRow(context: context, feature: context.l10n.featureStudios),
          SizedBox(height: AppSpacing.sm),
          _checkedRow(context: context, feature: context.l10n.featureEquipment),
          SizedBox(height: AppSpacing.sm),
          _checkedRow(context: context, feature: context.l10n.featurePriority),
          SizedBox(height: AppSpacing.sm),
          _checkedRow(context: context, feature: context.l10n.featurePriority),
          SizedBox(height: AppSpacing.xl),
          Divider(color:isDark ? AppColors.greyText: AppColors.buttonBorder, height: 1),
          SizedBox(height: AppSpacing.xl),

          CustomPaint(
            painter: DashedUnderlinePainter(
              color: AppColors.primary,
              dashWidth: 3,
              dashSpace: 3,
              top: true,
              left: true,
              right: true,
            ),
            child: Container(
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.symmetric(vertical: AppSpacing.md),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(AppRadius.md),
                color: isDark ? AppColors.trainerBlackBackgroundColor: AppColors.selectedLanguageBg,
              ),
              child: Column(
                children: [
                  AppText(
                    context.l10n.redemptionCode,
                    style: (context) => AppTextStyles.bodyText(
                      context,
                    ).copyWith(color: AppColors.placeHolderText, height: 1),
                  ),
                  SizedBox(height: AppSpacing.md),
                  AppText(
                    "P I L A T E S   2 0 2 6",
                    style: (context) => AppTextStyles.bottomSheetTitle(
                      context,
                    ).copyWith(height: 1),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  _checkedRow({required BuildContext context, required String feature}) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          Icons.check,
          size: 12,
          color: isDark ? AppColors.languageIconDark : AppColors.languageIcon,
        ),
        const SizedBox(width: 4),
        Expanded(
          child: AppText(
            feature,
            style: (style) => AppTextStyles.bodyTextSmall(context).copyWith(
              color: isDark ? AppColors.darkGreyText : AppColors.lightGrey,
              fontSize: 12,
              height: 1.2,
            ),
          ),
        ),
      ],
    );
  }
}
