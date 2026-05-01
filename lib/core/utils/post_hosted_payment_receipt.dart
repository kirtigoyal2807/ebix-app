import 'package:flutter/material.dart';

import 'package:pilates_app/features/checkout/data/checkout_repository.dart';
import 'package:pilates_app/features/checkout/data/models/checkout_payment_intent_result.dart';
import 'package:pilates_app/features/checkout/data/models/checkout_start_result.dart';
import 'package:pilates_app/features/checkout/data/models/membership_receipt_summary.dart';
import 'package:pilates_app/features/subscription/purchase_subscription/view/success_membership_view.dart';

/// Refreshes checkout via API after hosted payment, builds [MembershipReceiptSummary],
/// and opens [SuccessMembershipView].
///
/// [gatewayCallback] is optional JSON/query data from the payment return page or
/// `PilatesPayment.postMessage` (see [HostedPaymentWebViewPage]).
///
/// When [dismissRootOverlayBeforeReceipt] is true, pops one route on the root
/// navigator before opening the receipt (use for the post-webview loading dialog
/// so callers must not also pop in a `finally` after this returns).
Future<void> pushReceiptAfterHostedPayment({
  required BuildContext context,
  required CheckoutRepository repo,
  required String checkoutSessionId,
  required CheckoutPaymentIntentResult paymentIntent,
  Map<String, dynamic>? gatewayCallback,
  bool dismissRootOverlayBeforeReceipt = false,
}) async {
  CheckoutStartResult? session =
      await repo.refreshCheckoutAfterHostedPayment(checkoutSessionId);
  if (session == null) {
    final detail = await repo.getCheckoutDetails(checkoutSessionId);
    session = detail.isSuccess ? detail.dataOrNull : null;
  }

  final receipt = MembershipReceiptSummary.merge(
    session,
    paymentIntent,
    gatewayCallback: gatewayCallback,
  );

  if (!context.mounted) return;
  if (dismissRootOverlayBeforeReceipt) {
    Navigator.of(context, rootNavigator: true).pop();
  }
  if (!context.mounted) return;
  await Navigator.of(context, rootNavigator: true).push<void>(
    MaterialPageRoute<void>(
      builder: (context) => SuccessMembershipView(receipt: receipt),
    ),
  );
}
