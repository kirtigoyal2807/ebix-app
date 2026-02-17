import 'package:flutter/material.dart';
import 'package:pilates_app/config/theme/app_spacing.dart';
import 'package:pilates_app/features/explore/view/redeem_card_view.dart';

import '../../../config/theme/app_colors.dart';
import '../../../config/theme/app_text_styles.dart';
import '../../../core/localization/localization_extension.dart';
import '../../../widgets/app_text.dart';
import '../../account/widget/account_info_tile.dart';
import '../../my_booking/my_booking_view.dart';

class MyActivityInfo extends StatelessWidget {
  const MyActivityInfo({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText(
          context.l10n.myActivity,
          style: (context) => AppTextStyles.captionText(context).copyWith(
            fontWeight: FontWeight.w500,
            height: 1.55,
            color: AppColors.lightGrey,
          ),
        ),
        SizedBox(height: AppSpacing.lmd),
        AccountInfoTile(
          icon: isDark
              ? "assets/images/svg/explore/ic_dark_progress_dashBoard.svg"
              : "assets/images/svg/explore/ic_progress_dashBoard.svg",
          title: context.l10n.progressDashboard,
          subtitle: context.l10n.progressDashboardSubtitle,
        ),
        SizedBox(height: AppSpacing.lmd),
        AccountInfoTile(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => MyBookingView()),
            );
          },
          icon: isDark
              ? "assets/images/svg/explore/ic_dark_my_booking.svg"
              : "assets/images/svg/explore/ic_my_booking.svg",
          title: context.l10n.myBookings,
          subtitle: context.l10n.myBookingsSubtitle,
        ),
        SizedBox(height: AppSpacing.lmd),
        AccountInfoTile(
          icon: isDark
              ? "assets/images/svg/explore/ic_dark_challenges.svg"
              : "assets/images/svg/explore/ic_challenges.svg",
          title: context.l10n.challenges,
          subtitle: context.l10n.challengesSubtitle,
        ),
        SizedBox(height: AppSpacing.lmd),
        AccountInfoTile(
          icon: isDark
              ? "assets/images/svg/explore/ic_dark_reward_catelog.svg"
              : "assets/images/svg/explore/ic_reward_catelog.svg",
          title: context.l10n.rewardsCatalog,
          subtitle: context.l10n.rewardsCatalogSubtitle,
        ),
        SizedBox(height: AppSpacing.lmd),
        AccountInfoTile(
          icon: isDark
              ? "assets/images/svg/explore/ic_dark_achivements.svg"
              : "assets/images/svg/explore/ic_achivements.svg",
          title: context.l10n.achievements,
          subtitle: context.l10n.achievementsSubtitle,
        ),
        SizedBox(height: AppSpacing.lmd),
        AccountInfoTile(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => RedeemCardView()),
            );
          },
          icon: isDark
              ? "assets/images/svg/explore/ic_dark_redeem_gift.svg"
              : "assets/images/svg/explore/ic_redeem_gift.svg",
          title: context.l10n.redeemGiftCard,
          subtitle: context.l10n.redeemGiftCardSubtitle,
        ),
        SizedBox(height: AppSpacing.lmd),
        AccountInfoTile(
          icon: isDark
              ? "assets/images/svg/explore/Ic_dark_referral_program.svg"
              : "assets/images/svg/explore/Ic_referral_program.svg",
          title: context.l10n.referralProgram,
          subtitle: context.l10n.referralProgramSubtitle,
        ),
      ],
    );
  }
}
