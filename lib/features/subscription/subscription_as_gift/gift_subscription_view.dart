import 'package:flutter/material.dart';

import 'package:pilates_app/config/theme/app_spacing.dart';

import 'package:pilates_app/features/subscription/subscription_as_gift/view/plan_details_view.dart';
import 'package:pilates_app/features/subscription/subscription_as_gift/widget/gift_card.dart';
import 'package:pilates_app/features/subscription/subscription_as_gift/widget/receipt_details.dart';
import 'package:pilates_app/widgets/app_app_bar.dart';

import '../../../config/theme/app_colors.dart';

import '../../../core/localization/arb/app_localizations.dart';
import '../../../widgets/app_button.dart';

class GiftSubscriptionView extends StatelessWidget {
  const GiftSubscriptionView({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: AppAppBar(
        title: l10n.giftSubscription,
        isMoreMenu: false,
        onBack: () {
          Navigator.of(context).pop();
        },
      ),
      body: Padding(
        padding: EdgeInsets.only(
          // vertical: AppSpacing.md,
          left: AppSpacing.lg,
          right: AppSpacing.lg,
          bottom: AppSpacing.xl,
        ),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: AppSpacing.md),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      PilatesGiftCard(),

                      SizedBox(height: AppSpacing.lg),
                      ReceiptDetails(),
                    ],
                  ),
                ),
              ),
            ),

            AppButton(
              label: l10n.continueToPayment,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => PlanDetailsView()),
                );
              },

              buttonColor: isDark ?AppColors.primary:AppColors.primaryBrown,
              expanded: true,
            ),
          ],
        ),
      ),
    );
  }
}
