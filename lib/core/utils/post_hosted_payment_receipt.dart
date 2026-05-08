import 'package:flutter/material.dart';

import 'package:pilates_app/core/network/network_exception.dart';
import 'package:pilates_app/features/checkout/data/checkout_repository.dart';
import 'package:pilates_app/features/checkout/data/models/checkout_payment_intent_result.dart';
import 'package:pilates_app/features/checkout/data/models/checkout_start_result.dart';
import 'package:pilates_app/features/checkout/data/models/membership_receipt_summary.dart';
import 'package:pilates_app/features/checkout/data/models/payment_success_summary.dart';
import 'package:pilates_app/features/subscription/purchase_subscription/view/success_membership_view.dart';

/// `true` when [getPaymentSuccessSummary] should be retried (PayTabs webhook still
/// settling, or transient network). Other failures stop polling and fall back to
/// [MembershipReceiptSummary.merge].
bool _shouldRetryPaymentSuccessSummary(NetworkException? ex) {
  if (ex == null) return false;
  if (ex.type == NetworkFailureType.timeout ||
      ex.type == NetworkFailureType.connection) {
    return true;
  }
  if (ex.statusCode == 422) {
    final m = (ex.message ?? '').toLowerCase();
    return m.contains('not been completed') ||
        m.contains('not completed yet') ||
        m.contains('has not been completed') ||
        m.contains('payment for this checkout');
  }
  return false;
}

/// Loads the post-payment receipt (prefer `GET payments/{id}/success-summary`),
/// builds [MembershipReceiptSummary], and opens [SuccessMembershipView].
///
/// [gatewayCallback] is optional JSON/query data from the payment return page or
/// `PilatesPayment.postMessage` (see [HostedPaymentWebViewPage]).
///
/// When [dismissRootOverlayBeforeReceipt] is true, pops one route on the root
/// navigator before opening the receipt (use for the post-webview loading dialog
/// so callers must not also pop in a `finally` after this returns).
///
/// After the PayTabs return page (e.g. `…/payments/callback/paytabs` with
/// `success: true`), the summary endpoint may briefly return **422** with
/// *"Payment for this checkout has not been completed yet."* — that case is retried
/// with [paymentSummaryMaxAttempts] / [paymentSummaryDelay] before falling back to
/// polling `GET checkout/{id}` and [MembershipReceiptSummary.merge].
Future<void> pushReceiptAfterHostedPayment({
  required BuildContext context,
  required CheckoutRepository repo,
  required String checkoutSessionId,
  required CheckoutPaymentIntentResult paymentIntent,
  Map<String, dynamic>? gatewayCallback,
  bool dismissRootOverlayBeforeReceipt = false,
  int maxAttempts = 5,
  Duration delayBetweenAttempts = const Duration(milliseconds: 800),
  int paymentSummaryMaxAttempts = 15,
  Duration paymentSummaryDelay = const Duration(seconds: 1),
}) async {
  PaymentSuccessSummary? summaryPayload;
  for (var i = 0; i < paymentSummaryMaxAttempts; i++) {
    final summary = await repo.getPaymentSuccessSummary(checkoutSessionId);
    if (summary.isSuccess) {
      final data = summary.dataOrNull;
      if (data != null) {
        summaryPayload = data;
        break;
      }
    } else {
      final ex = summary.exceptionOrNull;
      if (!_shouldRetryPaymentSuccessSummary(ex)) {
        break;
      }
    }
    if (i < paymentSummaryMaxAttempts - 1) {
      await Future<void>.delayed(paymentSummaryDelay);
    }
  }

  final MembershipReceiptSummary receipt;
  if (summaryPayload != null) {
    receipt = MembershipReceiptSummary.fromPaymentSuccessSummary(
      summaryPayload,
    );
  } else {
    CheckoutStartResult? session = await repo.refreshCheckoutAfterHostedPayment(
      checkoutSessionId,
      maxAttempts: maxAttempts,
      delayBetweenAttempts: delayBetweenAttempts,
    );
    if (session == null) {
      final detail = await repo.getCheckoutDetails(checkoutSessionId);
      session = detail.isSuccess ? detail.dataOrNull : null;
    }

    receipt = MembershipReceiptSummary.merge(
      session,
      paymentIntent,
      gatewayCallback: gatewayCallback,
    );
  }

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
