/// Response `data` from `GET payments/{checkoutId}/success-summary`.
class PaymentSuccessSummary {
  const PaymentSuccessSummary({
    this.invoiceNumber,
    this.invoiceDate,
    this.invoiceUrl,
    this.package,
    this.pricing,
    this.payment,
    this.subscription,
    this.checkoutId,
    this.status,
  });

  final String? invoiceNumber;
  final String? invoiceDate;

  /// PDF or hosted invoice link when present.
  final String? invoiceUrl;
  final PaymentSuccessReceiptPackage? package;
  final PaymentSuccessReceiptPricing? pricing;
  final PaymentSuccessReceiptPayment? payment;

  /// Omitted or structured per product type; optional fields read for next billing.
  final Map<String, dynamic>? subscription;
  final String? checkoutId;
  final String? status;

  factory PaymentSuccessSummary.fromJson(Map<String, dynamic> json) {
    Map<String, dynamic>? subMap;
    final rawSub = json['subscription'];
    if (rawSub is Map) {
      subMap = Map<String, dynamic>.from(rawSub);
    }

    PaymentSuccessReceiptPackage? pkg;
    final rawPkg = json['package'];
    if (rawPkg is Map) {
      pkg = PaymentSuccessReceiptPackage.fromJson(
        Map<String, dynamic>.from(rawPkg),
      );
    }

    PaymentSuccessReceiptPricing? pricing;
    final rawPricing = json['pricing'];
    if (rawPricing is Map) {
      pricing = PaymentSuccessReceiptPricing.fromJson(
        Map<String, dynamic>.from(rawPricing),
      );
    }

    PaymentSuccessReceiptPayment? payment;
    final rawPay = json['payment'];
    if (rawPay is Map) {
      payment = PaymentSuccessReceiptPayment.fromJson(
        Map<String, dynamic>.from(rawPay),
      );
    }

    return PaymentSuccessSummary(
      invoiceNumber: json['invoiceNumber']?.toString(),
      invoiceDate: json['invoiceDate']?.toString(),
      invoiceUrl: _nonEmptyString(json['invoiceUrl']),
      package: pkg,
      pricing: pricing,
      payment: payment,
      subscription: subMap,
      checkoutId: json['checkoutId']?.toString(),
      status: json['status']?.toString(),
    );
  }

  static String? _nonEmptyString(dynamic v) {
    if (v is String) {
      final t = v.trim();
      return t.isEmpty ? null : t;
    }
    return null;
  }

  /// Next billing / renewal date from [subscription] when the API includes it.
  String? get subscriptionNextBillingIso {
    final m = subscription;
    if (m == null) return null;
    const keys = <String>[
      'nextBillingAt',
      'next_billing_at',
      'currentPeriodEnd',
      'current_period_end',
      'renewsAt',
      'renews_at',
    ];
    for (final k in keys) {
      final v = m[k];
      if (v is String && v.trim().isNotEmpty) return v.trim();
    }
    return null;
  }
}

class PaymentSuccessReceiptPackage {
  const PaymentSuccessReceiptPackage({
    this.id,
    this.name,
    this.entitlementType,
    this.sessionCount,
    this.validityDays,
  });

  final int? id;
  final String? name;
  final String? entitlementType;
  final int? sessionCount;
  final int? validityDays;

  factory PaymentSuccessReceiptPackage.fromJson(Map<String, dynamic> json) {
    return PaymentSuccessReceiptPackage(
      id: _readInt(json['id']),
      name: json['name']?.toString(),
      entitlementType: json['entitlementType']?.toString(),
      sessionCount: _readInt(json['sessionCount']),
      validityDays: _readInt(json['validityDays']),
    );
  }
}

class PaymentSuccessReceiptPricing {
  const PaymentSuccessReceiptPricing({
    this.subtotal,
    this.discountAmount,
    this.discountLabel,
    this.bonusSessions,
    this.bonusDays,
    this.totalPaid,
    this.currency,
  });

  /// Amounts are **major** currency units (e.g. whole SAR), per mobile API contract.
  final num? subtotal;
  final num? discountAmount;
  final String? discountLabel;
  final int? bonusSessions;
  final int? bonusDays;
  final num? totalPaid;
  final String? currency;

  factory PaymentSuccessReceiptPricing.fromJson(Map<String, dynamic> json) {
    return PaymentSuccessReceiptPricing(
      subtotal: _readNum(json['subtotal']),
      discountAmount: _readNum(json['discountAmount']),
      discountLabel: json['discountLabel']?.toString(),
      bonusSessions: _readInt(json['bonusSessions']),
      bonusDays: _readInt(json['bonusDays']),
      totalPaid: _readNum(json['totalPaid']),
      currency: json['currency']?.toString(),
    );
  }
}

class PaymentSuccessReceiptPayment {
  const PaymentSuccessReceiptPayment({
    this.method,
    this.reference,
    this.paidAt,
    this.provider,
  });

  final String? method;
  final String? reference;
  final String? paidAt;
  final String? provider;

  factory PaymentSuccessReceiptPayment.fromJson(Map<String, dynamic> json) {
    return PaymentSuccessReceiptPayment(
      method: json['method']?.toString(),
      reference: json['reference']?.toString(),
      paidAt: json['paidAt']?.toString(),
      provider: json['provider']?.toString(),
    );
  }
}

int? _readInt(dynamic v) {
  if (v == null) return null;
  if (v is int) return v;
  if (v is num) return v.toInt();
  return int.tryParse(v.toString());
}

num? _readNum(dynamic v) {
  if (v == null) return null;
  if (v is num) return v;
  return num.tryParse(v.toString());
}
