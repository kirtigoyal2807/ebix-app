import 'package:intl/intl.dart';
import 'package:pilates_app/core/utils/currency_display.dart';

import 'checkout_payment_intent_result.dart';
import 'checkout_start_result.dart';
import 'payment_success_summary.dart';

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
    this.pdfUrl,
    this.invoiceNumber,
    this.taxMinor,
    this.setupFeeMinor,
    this.nextBillingAtIso,
    this.cardLastFour,
    this.paymentBrand,
  });

  final String? paymentReference;
  final String? paidAtIso;
  final String? planName;
  final int? subtotalMinor;
  final int? discountMinor;
  final int? totalMinor;
  final String? currency;
  final String? providerName;

  /// Invoice / receipt PDF from checkout session or payment-intent payload.
  final String? pdfUrl;

  /// Display invoice number when the API sends one; else UI falls back to [paymentReference].
  final String? invoiceNumber;

  final int? taxMinor;
  final int? setupFeeMinor;
  final String? nextBillingAtIso;
  final String? cardLastFour;
  final String? paymentBrand;

  /// Reference or invoice # for the receipt header line.
  String? get displayInvoiceCode =>
      (invoiceNumber != null && invoiceNumber!.trim().isNotEmpty)
      ? invoiceNumber!.trim()
      : (paymentReference != null && paymentReference!.trim().isNotEmpty)
      ? paymentReference!.trim()
      : null;

  /// Card / wallet line for the receipt footer.
  String paymentMethodLine(String fallbackLabel) {
    final last4 = cardLastFour?.trim();
    final brand = paymentBrand?.trim();
    if (last4 != null && last4.isNotEmpty) {
      if (brand != null && brand.isNotEmpty) {
        return '$brand •••• $last4';
      }
      return '•••• $last4';
    }
    if (brand != null && brand.isNotEmpty) return brand;
    final p = providerName?.trim();
    if (p != null && p.isNotEmpty) return p;
    return fallbackLabel;
  }

  static String? _pdfUrlFromIntentRaw(Map<String, dynamic>? raw) {
    if (raw == null) return null;
    final top = CheckoutPaymentSummary.invoicePdfUrlFromMap(raw);
    if (top != null) return top;
    final pay = raw['payment'];
    if (pay is Map) {
      return CheckoutPaymentSummary.invoicePdfUrlFromMap(
        Map<String, dynamic>.from(pay as Map<dynamic, dynamic>),
      );
    }
    return null;
  }

  static CheckoutPaymentSummary? _paymentFromIntent(
    CheckoutPaymentIntentResult? intent,
  ) {
    final raw = intent?.raw;
    if (raw == null) return null;
    final p = raw['payment'];
    if (p is Map) {
      return CheckoutPaymentSummary.maybeFrom(
        Map<String, dynamic>.from(p as Map<dynamic, dynamic>),
      );
    }
    return null;
  }

  static CheckoutPricing? _pricingFromIntent(
    CheckoutPaymentIntentResult? intent,
  ) {
    final raw = intent?.raw;
    if (raw == null) return null;
    final p = raw['pricing'];
    if (p is Map) {
      return CheckoutPricing.maybeFrom(
        Map<String, dynamic>.from(p as Map<dynamic, dynamic>),
      );
    }
    return null;
  }

  static CheckoutPaymentSummary? _mergePaymentSummaries(
    CheckoutPaymentSummary? base,
    CheckoutPaymentSummary? overlay,
  ) {
    if (overlay == null) return base;
    if (base == null) return overlay;
    String? pick(String? o, String? b) {
      final ot = o?.trim();
      if (ot != null && ot.isNotEmpty) return ot;
      final bt = b?.trim();
      if (bt != null && bt.isNotEmpty) return bt;
      return null;
    }

    return CheckoutPaymentSummary(
      reference: pick(overlay.reference, base.reference),
      paidAt: pick(overlay.paidAt, base.paidAt),
      invoicePdfUrl: pick(overlay.invoicePdfUrl, base.invoicePdfUrl),
      invoiceNumber: pick(overlay.invoiceNumber, base.invoiceNumber),
      cardLastFour: pick(overlay.cardLastFour, base.cardLastFour),
      paymentBrand: pick(overlay.paymentBrand, base.paymentBrand),
      nextBillingAt: pick(overlay.nextBillingAt, base.nextBillingAt),
    );
  }

  /// Receipt from `GET payments/{checkoutId}/success-summary` (`data`).
  ///
  /// Pricing amounts on this API are **major** currency units (e.g. `799` SAR);
  /// they are converted to **minor** units for [formatMoney] / [InvoiceDetailsCard].
  static MembershipReceiptSummary fromPaymentSuccessSummary(
    PaymentSuccessSummary summary,
  ) {
    int? majorToMinor(num? v) {
      if (v == null) return null;
      return (v * 100).round();
    }

    final pricing = summary.pricing;
    final pay = summary.payment;
    final method = pay?.method?.trim();
    final provider = pay?.provider?.trim();
    final providerName = (method != null && method.isNotEmpty)
        ? method
        : (provider != null && provider.isNotEmpty ? provider : 'PayTabs');

    final paidAt = pay?.paidAt?.trim();
    final invoiceDate = summary.invoiceDate?.trim();
    final discountMajor = pricing?.discountAmount;

    return MembershipReceiptSummary(
      paymentReference: pay?.reference?.trim(),
      paidAtIso: (paidAt != null && paidAt.isNotEmpty)
          ? paidAt
          : (invoiceDate != null && invoiceDate.isNotEmpty
                ? invoiceDate
                : null),
      planName: summary.package?.name?.trim(),
      subtotalMinor: majorToMinor(pricing?.subtotal),
      discountMinor: discountMajor != null ? majorToMinor(discountMajor) : null,
      totalMinor: majorToMinor(pricing?.totalPaid ?? pricing?.subtotal),
      currency:
          (pricing?.currency != null && pricing!.currency!.trim().isNotEmpty)
          ? pricing.currency!.trim()
          : 'SAR',
      providerName: providerName,
      pdfUrl: summary.invoiceUrl,
      invoiceNumber: summary.invoiceNumber?.trim(),
      taxMinor: null,
      setupFeeMinor: null,
      nextBillingAtIso: summary.subscriptionNextBillingIso,
      cardLastFour: null,
      paymentBrand: null,
    );
  }

  /// Prefer live [session] after `GET checkout/{id}`; fill gaps from [intent] `data`.
  static MembershipReceiptSummary merge(
    CheckoutStartResult? session,
    CheckoutPaymentIntentResult? intent, {
    Map<String, dynamic>? gatewayCallback,
  }) {
    final intentPayment = _paymentFromIntent(intent);
    Map<String, dynamic>? gw = gatewayCallback;
    if (gw != null && gw.isNotEmpty) {
      final nested = gw['payment'];
      if (nested is Map) {
        gw = Map<String, dynamic>.from(nested as Map<dynamic, dynamic>);
      }
    }
    final gatewayPay = (gw == null || gw.isEmpty)
        ? null
        : CheckoutPaymentSummary.maybeFrom(gw);
    final basePay = session?.payment ?? intentPayment;
    final pay = _mergePaymentSummaries(basePay, gatewayPay);

    final intentPricing = _pricingFromIntent(intent);
    final pricing = session?.pricing ?? intentPricing;

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

    final providerRaw = raw?['provider'] as String?;
    final provider = (providerRaw != null && providerRaw.trim().isNotEmpty)
        ? providerRaw.trim()
        : 'PayTabs';

    return MembershipReceiptSummary(
      paymentReference: pay?.reference ?? intent?.paymentId,
      paidAtIso: pay?.paidAt ?? initiated,
      planName: session?.product?.name,
      subtotalMinor: pricing?.subtotal,
      discountMinor: pricing?.discountAmount,
      totalMinor: total ?? pricing?.subtotal,
      currency: (cur != null && cur.trim().isNotEmpty) ? cur.trim() : 'SAR',
      providerName: provider,
      pdfUrl: pay?.invoicePdfUrl ?? _pdfUrlFromIntentRaw(raw),
      invoiceNumber: pay?.invoiceNumber,
      taxMinor: pricing?.taxAmount,
      setupFeeMinor: pricing?.setupFeeAmount,
      nextBillingAtIso: pay?.nextBillingAt,
      cardLastFour: pay?.cardLastFour,
      paymentBrand: pay?.paymentBrand,
    );
  }

  /// [minor] is amount in smallest currency unit (e.g. halalah, cents), same as catalog `salePrice`.
  static String formatMoney(int? minor, String currency, [String? locale]) {
    if (minor == null) return '—';
    final major = minor / 100.0;
    return formatCurrencyAmount(amount: major, code: currency);
  }

  /// Backward-compatible alias; amounts are minor units → formatted major.
  static String formatMinor(int? minor, String currency) =>
      formatMoney(minor, currency);

  static String? shortDateFromIso(String? iso) {
    if (iso == null || iso.trim().isEmpty) return null;
    final t = iso.trim();
    if (t.length >= 10) return t.substring(0, 10);
    return t;
  }

  /// Localized paid date when [iso] is parseable; otherwise [shortDateFromIso] or raw.
  static String? formatPaidDate(String? iso, String languageCode) {
    if (iso == null || iso.trim().isEmpty) return null;
    final parsed = DateTime.tryParse(iso.trim());
    if (parsed != null) {
      try {
        return DateFormat.yMMMd(languageCode).format(parsed.toLocal());
      } catch (_) {
        return shortDateFromIso(iso);
      }
    }
    return shortDateFromIso(iso) ?? iso.trim();
  }

  static String? formatNextBilling(String? iso, String languageCode) {
    if (iso == null || iso.trim().isEmpty) return null;
    final parsed = DateTime.tryParse(iso.trim());
    if (parsed != null) {
      try {
        return DateFormat.yMMMd(languageCode).format(parsed.toLocal());
      } catch (_) {
        return iso.trim();
      }
    }
    return iso.trim();
  }
}
