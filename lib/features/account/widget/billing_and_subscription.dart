import 'package:flutter/material.dart';
import 'package:pilates_app/config/theme/app_spacing.dart';

import '../../../config/theme/app_colors.dart';
import '../../../config/theme/app_text_styles.dart';
import '../../../core/localization/localization_extension.dart';
import '../../../widgets/app_text.dart';
import '../../explore/view/referral_program_view.dart';
import '../../invoice_history/invoice_history_view.dart';
import '../../subscription/purchase_subscription/view/subscription_view.dart';
import '../../view_subscription/view_subscription_view.dart';
import 'account_info_tile.dart';

class BillingAndSubscription extends StatelessWidget {
  const BillingAndSubscription({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText(
          context.l10n.billingSubscriptions,
          style: (context) => AppTextStyles.captionText(context).copyWith(
            fontWeight: FontWeight.w500,
            height: 1.55,
            color: AppColors.lightGrey,
          ),
        ),
        SizedBox(height: AppSpacing.lmd),
        AccountInfoTile(
          icon: isDark
              ? "assets/images/svg/account/ic_dark_my_subscription.svg"
              : "assets/images/svg/account/ic_my_subscription.svg",
          title: context.l10n.mySubscriptions,
          subtitle: context.l10n.viewManagePlans,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ViewSubscriptionView()),
            );
          },
        ),
        SizedBox(height: AppSpacing.lmd),
        AccountInfoTile(
          icon: isDark
              ? "assets/images/svg/account/ic_dark_buy_subscription.svg"
              : "assets/images/svg/account/ic_buy_subscription.svg",
          title: context.l10n.buySubscription,
          subtitle: context.l10n.purchaseNewPlan,
          onTap: () {
            Navigator.push<void>(
              context,
              MaterialPageRoute<void>(
                builder: (context) => const SubscriptionView(),
              ),
            );
          },
        ),
        SizedBox(height: AppSpacing.lmd),
        AccountInfoTile(
          icon: isDark
              ? "assets/images/svg/account/ic_dark_gift_subscription.svg"
              : "assets/images/svg/account/ic_gift_subscription.svg",
          title: context.l10n.giftSubscription,
          subtitle: context.l10n.sendGiftToSomeone,
          onTap: () {
            Navigator.push<void>(
              context,
              MaterialPageRoute<void>(
                builder: (context) =>
                    const SubscriptionView(initialIsGift: true),
              ),
            );
          },
        ),
        SizedBox(height: AppSpacing.lmd),
        AccountInfoTile(
          icon: isDark
              ? "assets/images/svg/explore/Ic_dark_referral_program.svg"
              : "assets/images/svg/explore/Ic_referral_program.svg",
          title: context.l10n.referralProgram,
          subtitle: context.l10n.referralProgramSubtitle,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const ReferralProgramView(),
              ),
            );
          },
        ),
        SizedBox(height: AppSpacing.lmd),
        AccountInfoTile(
          icon: isDark
              ? "assets/images/svg/account/ic_dark_invoice_history.svg"
              : "assets/images/svg/account/ic_invoice_history.svg",
          title: context.l10n.invoiceHistory,
          subtitle: context.l10n.viewBillingDocuments,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const InvoiceHistoryView(),
              ),
            );
          },
        ),
      ],
    );
  }
}
