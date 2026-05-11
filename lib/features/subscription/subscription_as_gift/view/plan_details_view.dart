import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:pilates_app/config/theme/app_spacing.dart';
import 'package:pilates_app/core/utils/checkout_payment_launcher.dart';
import 'package:pilates_app/core/utils/hosted_payment_webview_page.dart';
import 'package:pilates_app/features/checkout/data/checkout_repository.dart';

import 'package:pilates_app/widgets/app_app_bar.dart';

import '../../../../config/theme/app_colors.dart';
import '../../../../core/localization/arb/app_localizations.dart';
import '../../../../widgets/app_button.dart';
import '../../purchase_subscription/view/review_screen_details_view.dart';
import '../cubit/gift_subscription_cubit.dart';
import '../cubit/gift_subscription_state.dart';
import 'gift_successfully_view.dart';

class PlanDetailsView extends StatelessWidget {
  const PlanDetailsView({super.key, this.checkoutId});

  /// Checkout session UUID (same as used for `POST …/gift` and payment intent).
  final String? checkoutId;

  static Future<void> _pushGiftSentSuccessScreen(BuildContext context) async {
    final l10n = AppLocalizations.of(context);
    GiftSubscriptionCubit? giftCubit;
    try {
      giftCubit = context.read<GiftSubscriptionCubit>();
    } catch (_) {}

    final state = giftCubit?.state;
    final name = state?.submittedRecipientName?.trim();
    final email = state?.submittedRecipientEmail?.trim();

    var deliveryValue = l10n.deliveryMethodInstant;
    if (state != null &&
        state.selectedDeliveryOption == DeliveryOption.scheduledDelivery) {
      final iso = state.scheduledDeliveryDateIso?.trim();
      if (iso != null && iso.isNotEmpty) {
        deliveryValue = iso;
      }
    }

    if (!context.mounted) return;
    await Navigator.of(context, rootNavigator: true).push<void>(
      MaterialPageRoute<void>(
        fullscreenDialog: true,
        builder: (ctx) => GiftSuccessfullyView(
          recipientName: name,
          recipientEmail: email,
          deliveryMethodValue: deliveryValue,
        ),
      ),
    );
  }

  Future<void> _onContinueToPayment(BuildContext context) async {
    final messenger = ScaffoldMessenger.of(context);
    final l10n = AppLocalizations.of(context);
    final id = checkoutId?.trim();
    if (id == null || id.isEmpty) {
      messenger.showSnackBar(
        SnackBar(content: Text(l10n.giftCheckoutSessionRequired)),
      );
      return;
    }

    final repo = context.read<CheckoutRepository>();

    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) =>
          const Center(child: CircularProgressIndicator()),
    );

    final result = await repo.fetchPaymentIntent(id);

    if (context.mounted) {
      Navigator.of(context, rootNavigator: true).pop();
    }

    if (!context.mounted) return;

    if (result.isSuccess) {
      final data = result.dataOrNull!;
      if (data.alreadyCompleted) {
        messenger.showSnackBar(
          SnackBar(content: Text(l10n.checkoutPaymentAlreadyCompleted)),
        );
        await _pushGiftSentSuccessScreen(context);
        return;
      }

      final url = data.paymentUrl;
      if (url != null && url.trim().isNotEmpty) {
        final paymentResult =
            await CheckoutPaymentLauncher.openInAppPaymentWebView(context, url);
        if (!context.mounted) return;

        if (paymentResult?.outcome != HostedPaymentWebViewOutcome.success) {
          return;
        }
        if (!context.mounted) return;
        await _pushGiftSentSuccessScreen(context);
        return;
      }

      if (context.mounted) {
        messenger.showSnackBar(SnackBar(content: Text(l10n.loginErrorGeneric)));
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
    final l10n = AppLocalizations.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppAppBar(
        title: l10n.planDetails,
        isMoreMenu: false,
        onBack: () {
          Navigator.of(context).pop();
        },
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ReviewScreenDetailsView(checkoutSessionId: checkoutId),
            ),
            Padding(
              padding: EdgeInsets.only(
                left: AppSpacing.lg,
                right: AppSpacing.lg,
                bottom: AppSpacing.sm,
              ),
              child: AppButton(
                label: l10n.continueToPayment,
                onPressed: () => _onContinueToPayment(context),
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
