import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pilates_app/config/theme/app_colors.dart';
import 'package:pilates_app/config/theme/app_radius.dart';
import 'package:pilates_app/config/theme/app_spacing.dart';
import 'package:pilates_app/config/theme/app_text_styles.dart';
import 'package:pilates_app/core/localization/localization_extension.dart';
import 'package:pilates_app/features/home/data/models/home_response.dart';
import 'package:pilates_app/widgets/app_text.dart';

class ReceivedGiftCard extends StatelessWidget {
  const ReceivedGiftCard({super.key, required this.gift});

  final HomeReceivedGift gift;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      margin: EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      padding: EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: isDark ? AppColors.homeBackground : AppColors.whiteColor,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(
          color: isDark ? AppColors.greyText : AppColors.buttonBorder,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 48,
            width: 48,
            child: SvgPicture.asset(
              isDark
                  ? 'assets/images/svg/ic_dark_gift_card.svg'
                  : 'assets/images/svg/ic_gift_card.svg',
            ),
          ),
          SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText(
                  gift.title?.trim().isNotEmpty == true
                      ? gift.title!.trim()
                      : context.l10n.giftReceivedTitle,
                  style: (context) =>
                      AppTextStyles.heading1(context).copyWith(fontSize: 16),
                ),
                SizedBox(height: AppSpacing.xs),
                AppText(
                  gift.subtitle?.trim().isNotEmpty == true
                      ? gift.subtitle!.trim()
                      : context.l10n.receivedGiftSubtitle,
                  style: AppTextStyles.captionText,
                ),
                if ((gift.senderName ?? '').trim().isNotEmpty) ...[
                  SizedBox(height: AppSpacing.xs),
                  AppText(
                    '— ${gift.senderName!.trim()}',
                    style: AppTextStyles.captionText,
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
