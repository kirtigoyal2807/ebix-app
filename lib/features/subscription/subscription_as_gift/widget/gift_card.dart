import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pilates_app/config/theme/app_spacing.dart';
import 'package:pilates_app/config/theme/app_text_styles.dart';
import 'package:pilates_app/widgets/app_text.dart';

import '../../../../config/theme/app_colors.dart';
import '../../../../core/localization/arb/app_localizations.dart';
import '../../../../widgets/dotted_underline.dart';

class PilatesGiftCard extends StatelessWidget {
  const PilatesGiftCard({super.key});

  @override
  Widget build(BuildContext context) {

    final l10n = AppLocalizations.of(context);
    return ClipRRect(
      borderRadius: BorderRadius.circular(21),
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(21),
              gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: [
                  AppColors.languageIcon,
                  AppColors.splashBackgroundDark,
                ],
              ),
            ),

            padding: EdgeInsets.all(AppSpacing.lmd),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SvgPicture.asset(
                      "assets/images/svg/ic_white_the_pilate_studio.svg",
                    ),
                    Container(
                      height: 64,
                      width: 64,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: AppColors.splashBackgroundDark,
                        shape: BoxShape.circle,
                      ),
                      child: SvgPicture.asset(
                        'assets/images/svg/ic_gift.svg',
                        height: 35,
                        width: 35,
                        fit: BoxFit.fill,
                      ),
                    ),
                  ],
                ),

                SizedBox(height: AppSpacing.xi),

                AppText(
                  l10n.giftCard,
                  style: (context) => AppTextStyles.bodyText(
                    context,
                  ).copyWith(height: 1, color: AppColors.seekBarLight),
                ),
                SizedBox(height: AppSpacing.sm),
                AppText(
                  l10n.premiumPlan,
                  style: (context) => AppTextStyles.headline(
                    context,
                  ).copyWith(height: 1, color: Colors.white),
                ),
                SizedBox(height: AppSpacing.md),
                SizedBox(
                  width: double.infinity,
                  child: CustomPaint(
                    painter: DashedUnderlinePainter(
                      color: AppColors.darkGreyBorder,
                      dashWidth: 3,
                      dashSpace: 3,
                    ),
                  ),
                ),
                SizedBox(height: AppSpacing.md),
                AppText(
                  l10n.message,
                  style: (context) => AppTextStyles.captionText(
                    context,
                  ).copyWith(height: 1, color: AppColors.lightGreyText),
                ),
                SizedBox(height: AppSpacing.sm),
                AppText(
                  l10n.giftMessageLine1,
                  style: (context) => AppTextStyles.bodyText(
                    context,
                  ).copyWith(height: 1.5, color: AppColors.seekBarLight),
                ),
                AppText(
                  l10n.giftMessageLine2,
                  style: (context) => AppTextStyles.bodyText(
                    context,
                  ).copyWith(height: 1.5, color: AppColors.seekBarLight),
                ),
              ],
            ),
          ),
          Positioned.fill(
            top: AppSpacing.lmd,

            left: 0,
            right: 0,
            child: SvgPicture.asset(
              "assets/images/svg/ic_master_card_light_effect.svg",

              // height: 150,
              fit: BoxFit.fill,
            ),
          ),
        ],
      ),
    );
  }
}
