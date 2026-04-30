import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:pilates_app/config/theme/app_colors.dart';
import 'package:pilates_app/core/utils/checkout_payment_launcher.dart';
import 'package:pilates_app/features/checkout/data/checkout_repository.dart';
import 'package:pilates_app/features/checkout/data/models/checkout_payment_intent_result.dart';
import 'package:pilates_app/features/checkout/data/models/membership_receipt_summary.dart';
import 'package:pilates_app/features/subscription/purchase_subscription/data/subscription_health_intake_request.dart';
import 'package:pilates_app/features/subscription/purchase_subscription/view/review_screen_details_view.dart';
import 'package:pilates_app/features/subscription/purchase_subscription/view/success_membership_view.dart';
import 'package:pilates_app/widgets/app_button.dart';

import '../../../../config/theme/app_spacing.dart';
import '../../../../core/localization/arb/app_localizations.dart';
import '../cubit/subscription_cubit.dart';

class ReviewScreenView extends StatelessWidget {
  const ReviewScreenView({super.key});

  static Future<void> _pushReceiptScreen(
    BuildContext context,
    CheckoutRepository repo,
    String checkoutId,
    CheckoutPaymentIntentResult intent,
  ) async {
    final detail = await repo.getCheckoutDetails(checkoutId);
    final session = detail.isSuccess ? detail.dataOrNull : null;
    final receipt = MembershipReceiptSummary.merge(session, intent);
    if (!context.mounted) return;
    await Navigator.of(context).push<void>(
      MaterialPageRoute<void>(
        builder: (context) => SuccessMembershipView(receipt: receipt),
      ),
    );
  }

  Future<void> _onContinueToPayment(BuildContext context) async {
    final messenger = ScaffoldMessenger.of(context);
    final l10n = AppLocalizations.of(context)!;
    final cubit = context.read<SubscriptionCubit>();
    final id = cubit.state.checkoutSessionId.trim();
    if (id.isEmpty) {
      messenger.showSnackBar(
        SnackBar(content: Text(l10n.giftCheckoutSessionRequired)),
      );
      return;
    }

    final repo = context.read<CheckoutRepository>();

    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => const Center(
        child: CircularProgressIndicator(),
      ),
    );

    final requiresIntake = cubit.state.selectedProductRequiresHealthIntake;

    if (requiresIntake) {
      final ok = await cubit.ensureHealthQuestionnaireForIntake(repo);
      if (!ok) {
        if (context.mounted) {
          Navigator.of(context, rootNavigator: true).pop();
        }
        if (!context.mounted) return;
        messenger.showSnackBar(
          SnackBar(content: Text(l10n.loginErrorGeneric)),
        );
        return;
      }

      final intakeResult = await repo.submitHealthIntake(
        checkoutId: id,
        body: subscriptionHealthIntakeRequestBody(cubit.state),
      );

      if (!intakeResult.isSuccess) {
        if (context.mounted) {
          Navigator.of(context, rootNavigator: true).pop();
        }
        if (!context.mounted) return;
        final ex = intakeResult.exceptionOrNull;
        messenger.showSnackBar(
          SnackBar(
            content: Text(
              (ex?.message != null && ex!.message!.trim().isNotEmpty)
                  ? ex.message!
                  : l10n.loginErrorGeneric,
            ),
          ),
        );
        return;
      }
    }

    final result = await repo.fetchPaymentIntent(id);

    if (context.mounted) {
      Navigator.of(context, rootNavigator: true).pop();
    }

    if (!context.mounted) return;

    if (result.isSuccess) {
      final data = result.dataOrNull!;
      var showReceipt = false;
      if (data.alreadyCompleted) {
        messenger.showSnackBar(
          SnackBar(content: Text(l10n.checkoutPaymentAlreadyCompleted)),
        );
        showReceipt = true;
      } else {
        final url = data.paymentUrl;
        if (url != null && url.trim().isNotEmpty) {
          final opened =
              await CheckoutPaymentLauncher.openHostedPaymentUrl(url);
          if (context.mounted && !opened) {
            messenger.showSnackBar(
              SnackBar(content: Text(l10n.loginErrorGeneric)),
            );
          } else {
            showReceipt = opened;
          }
        } else if (context.mounted) {
          messenger.showSnackBar(
            SnackBar(content: Text(l10n.loginErrorGeneric)),
          );
        }
      }
      if (context.mounted && showReceipt) {
        await _pushReceiptScreen(context, repo, id, data);
      }
      return;
    }

    final e = result.exceptionOrNull;
    messenger.showSnackBar(
      SnackBar(
        content: Text(
          (e?.message != null && e!.message!.trim().isNotEmpty)
              ? e.message!
              : l10n.loginErrorGeneric,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: AppSpacing.lg,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const ReviewScreenDetailsView(),
          BlocBuilder<SubscriptionCubit, SubscriptionState>(
            buildWhen: (previous, current) =>
                previous.isTermsAccepted != current.isTermsAccepted,
            builder: (context, state) {
              return Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.lg,
                ),
                child: AppButton(
                  label: l10n.continueToPayment,
                  onPressed: state.isTermsAccepted
                      ? () => _onContinueToPayment(context)
                      : null,
                  buttonColor:
                      isDark ? AppColors.primary : AppColors.primaryBrown,
                  expanded: true,
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
