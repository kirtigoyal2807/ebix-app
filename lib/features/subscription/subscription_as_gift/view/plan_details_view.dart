import 'package:flutter/material.dart';

import 'package:pilates_app/config/theme/app_spacing.dart';

import 'package:pilates_app/features/subscription/subscription_as_gift/view/welcome_to_pilate_view.dart';

import 'package:pilates_app/widgets/app_app_bar.dart';

import '../../../../config/theme/app_colors.dart';
import '../../../../core/localization/arb/app_localizations.dart';
import '../../../../widgets/app_button.dart';
import '../../purchase_subscription/view/review_screen_details_view.dart';
import '../../purchase_subscription/view/success_membership_view.dart';

class PlanDetailsView extends StatelessWidget {
  const PlanDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: AppAppBar(
        title: l10n.planDetails,
        isMoreMenu: false,
        onBack: () {
          Navigator.of(context).pop();
        },
      ),
      body: Padding(
        padding: EdgeInsets.only(
          // vertical: AppSpacing.md,
          // left: AppSpacing.lg,
          // right: AppSpacing.lg,
          bottom: AppSpacing.xl,
        ),
        child: Column(
          children: [
            ReviewScreenDetailsView(),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
              child: AppButton(
                label: l10n.continueToPayment,
                onPressed: () {
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(
                  //     builder: (context) => WelcomeToPilateView(),
                  //   ),
                  // );
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SuccessMembershipView(),
                    ),
                  );
                },

                buttonColor: isDark
                    ? AppColors.primary
                    : AppColors.primaryBrown,
                expanded: true,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
