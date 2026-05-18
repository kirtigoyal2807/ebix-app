import 'package:flutter/material.dart';

import 'package:pilates_app/core/localization/arb/app_localizations.dart';
import 'package:pilates_app/core/network/api_result.dart';
import 'package:pilates_app/core/utils/checkout_payment_launcher.dart';
import 'package:pilates_app/core/utils/hosted_payment_webview_page.dart';
import 'package:pilates_app/features/booking/constants/class_checkout_payment_provider.dart';
import 'package:pilates_app/features/booking/cubit/confirm_booking_cubit.dart';
import 'package:pilates_app/features/booking/cubit/confirm_booking_submit_result.dart';
import 'package:pilates_app/features/booking/data/classes_repository.dart';
import 'package:pilates_app/features/my_booking/data/models/booking_resource.dart';

/// Hosted checkout for §13.7 single-session class purchase (webview + confirm).
class ClassSingleSessionCheckout {
  const ClassSingleSessionCheckout._();

  static Future<void> run({
    required BuildContext context,
    required ClassesRepository repository,
    required String calendarEventId,
    required AppLocalizations l10n,
    ConfirmBookingCubit? cubit,
    required void Function(BookingResource booking) onSuccess,
  }) async {
    final messenger = ScaffoldMessenger.of(context);
    final result = cubit != null
        ? await cubit.submit(usePlanSession: false)
        : await _purchaseViaRepository(repository, calendarEventId);

    if (!context.mounted) return;

    if (result.confirmedBooking != null) {
      onSuccess(result.confirmedBooking!);
      return;
    }

    final pending = result.pendingHostedPayment;
    if (pending == null) {
      _showSubmitError(messenger, l10n, result.errorMessage);
      return;
    }

    final webResult = await CheckoutPaymentLauncher.openInAppPaymentWebView(
      context,
      pending.paymentUrl,
    );
    if (!context.mounted) return;
    if (webResult?.outcome != HostedPaymentWebViewOutcome.success) {
      return;
    }

    final confirmed = await repository.confirmPayment(
      paymentReference: pending.paymentReference,
      paidAmount: pending.amount,
      currency: pending.currency,
    );
    if (!context.mounted) return;

    switch (confirmed) {
      case ApiSuccess(:final data):
        onSuccess(data);
      case ApiFailure(:final exception):
        messenger.showSnackBar(
          SnackBar(
            content: Text(exception.message ?? l10n.somethingWentWrong),
          ),
        );
    }
  }

  static Future<ConfirmBookingSubmitResult> _purchaseViaRepository(
    ClassesRepository repository,
    String calendarEventId,
  ) async {
    final purchase = await repository.purchaseSingleSession(
      calendarEventId,
      kClassSingleSessionPaymentProvider,
    );
    switch (purchase) {
      case ApiSuccess(:final data):
        final url = data.paymentUrl?.trim() ?? '';
        if (url.isEmpty) {
          return const ConfirmBookingSubmitResult(
            errorMessage: '_missing_payment_link',
          );
        }
        return ConfirmBookingSubmitResult(pendingHostedPayment: data);
      case ApiFailure(:final exception):
        return ConfirmBookingSubmitResult(errorMessage: exception.message);
    }
  }

  static void _showSubmitError(
    ScaffoldMessengerState messenger,
    AppLocalizations l10n,
    String? err,
  ) {
    if (err != null && err.startsWith('_')) {
      messenger.showSnackBar(
        SnackBar(content: Text(l10n.somethingWentWrong)),
      );
      return;
    }
    if (err != null && err.isNotEmpty) {
      messenger.showSnackBar(SnackBar(content: Text(err)));
    }
  }
}
