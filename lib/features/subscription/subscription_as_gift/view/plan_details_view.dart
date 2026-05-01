import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:pilates_app/config/theme/app_spacing.dart';
import 'package:pilates_app/core/utils/checkout_payment_launcher.dart';
import 'package:pilates_app/core/utils/hosted_payment_webview_page.dart';
import 'package:pilates_app/core/utils/post_hosted_payment_receipt.dart';
import 'package:pilates_app/features/checkout/data/checkout_repository.dart';
import 'package:pilates_app/features/checkout/data/models/checkout_payment_intent_result.dart';

import 'package:pilates_app/widgets/app_app_bar.dart';

import '../../../../config/theme/app_colors.dart';
import '../../../../core/localization/arb/app_localizations.dart';
import '../../../../widgets/app_button.dart';
import '../../purchase_subscription/view/review_screen_details_view.dart';

class PlanDetailsView extends StatelessWidget {
  const PlanDetailsView({super.key, this.checkoutId});

  /// Checkout session UUID (same as used for `POST …/gift` and payment intent).
  final String? checkoutId;

  static Future<void> _pushReceiptScreen(
    BuildContext context,
    CheckoutRepository repo,
    String checkoutId,
    CheckoutPaymentIntentResult intent, {
    Map<String, dynamic>? gatewayCallback,
    bool dismissRootOverlayBeforeReceipt = false,
  }) async {
    await pushReceiptAfterHostedPayment(
      context: context,
      repo: repo,
      checkoutSessionId: checkoutId,
      paymentIntent: intent,
      gatewayCallback: gatewayCallback,
      dismissRootOverlayBeforeReceipt: dismissRootOverlayBeforeReceipt,
    );
  }

  Future<void> _onContinueToPayment(BuildContext context) async {
    final messenger = ScaffoldMessenger.of(context);
    final l10n = AppLocalizations.of(context)!;
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
      builder: (dialogContext) => const Center(
        child: CircularProgressIndicator(),
      ),
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
        await _pushReceiptScreen(context, repo, id, data);
        return;
      }

      final url = data.paymentUrl;
      if (url != null && url.trim().isNotEmpty) {
        final paymentResult =
            await CheckoutPaymentLauncher.openInAppPaymentWebView(
          context,
          url,
        );
        if (!context.mounted) return;

        if (paymentResult?.outcome != HostedPaymentWebViewOutcome.success) {
          return;
        }
        final paid = paymentResult!;

        showDialog<void>(
          context: context,
          barrierDismissible: false,
          builder: (dialogContext) => const Center(
            child: CircularProgressIndicator(),
          ),
        );
        try {
          await _pushReceiptScreen(
            context,
            repo,
            id,
            data,
            gatewayCallback: paid.gatewayPayload,
            dismissRootOverlayBeforeReceipt: true,
          );
        } catch (_) {
          if (context.mounted) {
            Navigator.of(context, rootNavigator: true).pop();
          }
        }
        return;
      }

      if (context.mounted) {
        messenger.showSnackBar(
          SnackBar(content: Text(l10n.loginErrorGeneric)),
        );
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
      appBar: AppAppBar(
        title: l10n.planDetails,
        isMoreMenu: false,
        onBack: () {
          Navigator.of(context).pop();
        },
      ),
      body: Padding(
        padding: EdgeInsets.only(
          bottom: AppSpacing.xl,
        ),
        child: Column(
          children: [
            ReviewScreenDetailsView(checkoutSessionId: checkoutId),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
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
