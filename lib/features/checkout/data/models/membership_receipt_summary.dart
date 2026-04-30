import 'checkout_payment_intent_result.dart';
import 'checkout_start_result.dart';

/// Values for [InvoiceDetailsCard] / [SuccessMembershipView] after payment intent.
class MembershipReceiptSummary {
  const MembershipReceiptSummary({
    this.paymentReference,
    this.paidAtIso,
    this.planName,
    this.subtotalMinor,
    this.discountMinor,
    this.totalMinor,
    this.currency,
    this.providerName,
  });

  final String? paymentReference;
  final String? paidAtIso;
  final String? planName;
  final int? subtotalMinor;
  final int? discountMinor;
  final int? totalMinor;
  final String? currency;
  final String? providerName;

  /// Prefer live [session] after `GET checkout/{id}`; fill gaps from [intent] `data`.
  static MembershipReceiptSummary merge(
    CheckoutStartResult? session,
    CheckoutPaymentIntentResult? intent,
  ) {
    final pricing = session?.pricing;
    final raw = intent?.raw;
    int? total = pricing?.totalAmount;
    final cur = pricing?.currency ?? (raw?['currency'] as String?);
    if (total == null && raw != null) {
      final a = raw['amount'];
      if (a is num) {
        total = a.toInt();
      }
    }

    String? initiated;
    final metaRaw = raw?['metadata'];
    if (metaRaw is Map) {
      final meta = Map<String, dynamic>.from(metaRaw);
      initiated = meta['initiated_at']?.toString();
    }

    return MembershipReceiptSummary(
      paymentReference: session?.payment?.reference ?? intent?.paymentId,
      paidAtIso: session?.payment?.paidAt ?? initiated,
      planName: session?.product?.name,
      subtotalMinor: pricing?.subtotal,
      discountMinor: pricing?.discountAmount,
      totalMinor: total ?? pricing?.subtotal,
      currency: (cur != null && cur.trim().isNotEmpty) ? cur.trim() : 'SAR',
      providerName: raw?['provider'] as String? ?? 'PayTabs',
    );
  }

  static String formatMinor(int? minor, String currency) {
    if (minor == null) return '—';
    return '$minor $currency';
  }

  static String? shortDateFromIso(String? iso) {
    if (iso == null || iso.trim().isEmpty) return null;
    final t = iso.trim();
    if (t.length >= 10) return t.substring(0, 10);
    return t;
  }
}
