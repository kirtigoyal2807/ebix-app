import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:pilates_app/config/theme/app_colors.dart';
import 'package:pilates_app/features/subscription/purchase_subscription/view/review_screen_details_view.dart';
import 'package:pilates_app/features/subscription/purchase_subscription/view/subscription_hosted_payment_flow.dart';
import 'package:pilates_app/widgets/app_button.dart';

import '../../../../config/theme/app_spacing.dart';
import '../../../../core/localization/arb/app_localizations.dart';
import '../cubit/subscription_cubit.dart';

class ReviewScreenView extends StatelessWidget {
  const ReviewScreenView({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(child: ReviewScreenDetailsView()),
          Padding(
            padding: const EdgeInsets.only(
              left: AppSpacing.lg,
              right: AppSpacing.lg,
              bottom: AppSpacing.sm,
            ),
            child: BlocBuilder<SubscriptionCubit, SubscriptionState>(
              buildWhen: (previous, current) =>
                  previous.isTermsAccepted != current.isTermsAccepted ||
                  previous.checkoutSessionId != current.checkoutSessionId ||
                  previous.selectedPlanId != current.selectedPlanId ||
                  previous.selectedBranchId != current.selectedBranchId ||
                  previous.currentStep != current.currentStep,
              builder: (context, state) {
                final hasAllPaymentInputs =
                    state.checkoutSessionId.trim().isNotEmpty &&
                    state.selectedPlanId.trim().isNotEmpty &&
                    (state.selectedBranchId ?? 0) > 0 &&
                    state.currentStep == 9;
                return AppButton(
                  label: l10n.continueTxt,
                  onPressed: state.isTermsAccepted && hasAllPaymentInputs
                      ? () {
                          unawaited(
                            runSubscriptionHostedPaymentFlow(
                              context,
                              deferReceiptUntilAfterRequiredInformation: true,
                            ),
                          );
                        }
                      : null,
                  buttonColor: isDark
                      ? AppColors.primary
                      : AppColors.primaryBrown,
                  expanded: true,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
