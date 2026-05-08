import 'customer_subscription_resource.dart';

/// Row shown in **Invoice history** (all tabs). Primary source is `GET /invoices`
/// (envelope + optional nested `data.data` array) → [fromJson].
///
/// [fromCustomerSubscription] is still used if you map subscription rows from `GET /subscriptions/me` elsewhere.
class InvoiceResource {
  const InvoiceResource({
    required this.id,
    required this.invoiceNumber,
    required this.title,
    required this.type,
    required this.amount,
    required this.currency,
    required this.status,
    required this.issuedAt,
    this.pdfUrl,
  });

  final String id;
  final String invoiceNumber;
  final String title;
  final String type;
  final double amount;
  final String currency;
  final String status;
  final DateTime issuedAt;
  final String? pdfUrl;

  bool get isRefund {
    final t = type.toLowerCase();
    final st = status.toLowerCase();
    return t == 'refund' ||
        t.contains('refund') ||
        st == 'refunded' ||
        st.contains('refund');
  }

  /// Row from subscription entitlements; [type] matches API `entitlementType`.
  factory InvoiceResource.fromCustomerSubscription(
    CustomerSubscriptionResource s,
  ) {
    final title = (s.product?.name ?? '').trim();
    return InvoiceResource(
      id: s.id,
      invoiceNumber: s.id,
      title: title.isEmpty ? '—' : title,
      type: s.entitlementType,
      amount: s.pricePaid,
      currency: 'SAR',
      status: s.status,
      issuedAt:
          s.createdAt ??
          s.startsAt ??
          s.expiresAt ??
          DateTime.fromMillisecondsSinceEpoch(0, isUtc: true),
      pdfUrl: s.invoicePdfUrl,
    );
  }

  factory InvoiceResource.fromJson(Map<String, dynamic> json) {
    final issuedRaw =
        json['date'] ??
        json['paidAt'] ??
        json['paid_at'] ??
        json['issued_at'] ??
        json['issuedAt'] ??
        json['created_at'] ??
        json['createdAt'];
    final titleRaw = '${json['title'] ?? json['description'] ?? ''}'.trim();
    return InvoiceResource(
      id: '${json['id'] ?? ''}',
      invoiceNumber:
          '${json['number'] ?? json['invoice_number'] ?? json['invoiceNumber'] ?? ''}',
      title: titleRaw.isEmpty ? '—' : titleRaw,
      type: _parseStringField(
        json['type'] ??
            json['invoice_type'] ??
            json['invoiceType'] ??
            json['kind'] ??
            json['category'],
      ),
      amount: _double(json['amount'] ?? json['total'] ?? json['total_amount']),
      currency: '${json['currency'] ?? 'SAR'}',
      status: _parseStringField(
        json['status'] ?? json['payment_status'] ?? json['paymentStatus'],
        fallback: 'paid',
      ),
      issuedAt: _parseDate(issuedRaw),
      pdfUrl: _firstNonEmptyString([
        json['invoiceUrl'],
        json['invoice_url'],
        json['pdf_url'],
        json['pdfUrl'],
        json['download_url'],
        json['downloadUrl'],
      ]),
    );
  }

  /// Normalizes API fields that may be a plain string or `{ "value": "...", "label": "..." }`.
  static String _parseStringField(dynamic raw, {String fallback = ''}) {
    if (raw == null) return fallback;
    if (raw is Map) {
      final m = Map<String, dynamic>.from(raw);
      final v = '${m['value'] ?? m['label'] ?? ''}'.trim();
      return v.isEmpty ? fallback : v;
    }
    final s = '$raw'.trim();
    return s.isEmpty ? fallback : s;
  }

  static String? _firstNonEmptyString(List<dynamic> candidates) {
    for (final v in candidates) {
      if (v == null) continue;
      final s = '$v'.trim();
      if (s.isNotEmpty) return s;
    }
    return null;
  }

  static double _double(dynamic v) {
    if (v == null) return 0;
    if (v is num) return v.toDouble();
    return double.tryParse('$v') ?? 0;
  }

  static DateTime _parseDate(dynamic v) {
    if (v == null) return DateTime.fromMillisecondsSinceEpoch(0, isUtc: true);
    if (v is DateTime) return v.toUtc();
    final s = '$v'.trim();
    if (s.isEmpty) {
      return DateTime.fromMillisecondsSinceEpoch(0, isUtc: true);
    }
    return DateTime.tryParse(s)?.toUtc() ??
        DateTime.tryParse(s.replaceFirst(' ', 'T'))?.toUtc() ??
        DateTime.fromMillisecondsSinceEpoch(0, isUtc: true);
  }
}
