/// Models for checkout session `data` objects (`POST /checkout/start`,
/// `GET /checkout/{id}`, `POST …/apply-coupon`, `POST …/health-intake`, etc.).
///
/// JSON envelope: `{ "success", "message", "data": { ... }, "meta": [...] }`.
/// [CheckoutStartResult] maps **`data`**. [responseMeta] holds top-level **`meta`**
/// (distinct from `data.metadata` on the session object).
library;

int? _readInt(dynamic value) {
  if (value == null) return null;
  if (value is int) return value;
  if (value is num) return value.toInt();
  return int.tryParse(value.toString());
}

int? _firstIntFromKeys(Map<String, dynamic> m, List<String> keys) {
  for (final k in keys) {
    final v = _readInt(m[k]);
    if (v != null) {
      return v;
    }
  }
  return null;
}

/// Parses API booleans that may be sent as `true`/`false`, `1`/`0`, or strings.
bool? _readBoolNullable(dynamic value) {
  if (value == null) return null;
  if (value is bool) return value;
  if (value is num) {
    if (value == 0) return false;
    if (value == 1) return true;
  }
  final s = value.toString().trim().toLowerCase();
  if (s == 'true' || s == '1' || s == 'yes') return true;
  if (s == 'false' || s == '0' || s == 'no') return false;
  return null;
}

String _readSessionId(Map<String, dynamic> json) {
  final raw = json['id'];
  if (raw is String && raw.trim().isNotEmpty) return raw.trim();
  if (raw != null) {
    final s = raw.toString().trim();
    if (s.isNotEmpty) return s;
  }
  throw FormatException('Checkout session missing id', json);
}

/// Session `data.metadata` — API may send an object (e.g. `{ "health_intake_id": 1 }`)
/// or omit the field. List-shaped metadata is treated as unsupported and ignored.
Map<String, dynamic>? _readMetadataMap(dynamic value) {
  if (value == null) return null;
  if (value is Map) {
    return Map<String, dynamic>.from(value);
  }
  return null;
}

class CheckoutStartResult {
  const CheckoutStartResult({
    required this.id,
    this.brandId,
    this.customerId,
    this.productId,
    this.branchId,
    this.isGift,
    this.status,
    this.requiresHealthIntake,
    this.requiresPayment,
    this.pricing,
    this.appliedOffer,
    this.payment,
    this.product,
    this.branch,
    this.customer,
    this.metadata,
    this.createdAt,
    this.updatedAt,
    this.responseMeta = const [],
  });

  final String id;
  final String? brandId;
  final int? customerId;
  final int? productId;
  final int? branchId;
  final bool? isGift;
  final CheckoutSessionStatus? status;
  final bool? requiresHealthIntake;
  final bool? requiresPayment;
  final CheckoutPricing? pricing;
  final CheckoutAppliedOffer? appliedOffer;
  final CheckoutPaymentSummary? payment;
  final CheckoutProductSummary? product;
  final CheckoutBranchSummary? branch;
  final CheckoutCustomerSummary? customer;

  /// Checkout session metadata from `data.metadata` (e.g. `health_intake_id`).
  final Map<String, dynamic>? metadata;
  final String? createdAt;
  final String? updatedAt;

  /// Parsed from envelope root `meta` (not `data.metadata`).
  final List<dynamic> responseMeta;

  /// Top-level `productId` or nested `product.id` when the API omits the former.
  int? get resolvedProductId => productId ?? product?.id;

  /// Top-level `requiresHealthIntake`, or nested `product.requiresHealthIntake`
  /// when the session payload only carries it on [product].
  bool? get resolvedRequiresHealthIntake =>
      requiresHealthIntake ?? product?.requiresHealthIntake;

  factory CheckoutStartResult.fromJson(
    Map<String, dynamic> json, {
    List<dynamic> responseMeta = const [],
  }) {
    return CheckoutStartResult(
      id: _readSessionId(json),
      brandId: json['brandId'] as String?,
      customerId: _readInt(json['customerId']),
      productId: _readInt(json['productId']),
      branchId: _readInt(json['branchId']),
      isGift: json['isGift'] as bool?,
      status: CheckoutSessionStatus.maybeFrom(json['status']),
      requiresHealthIntake: _readBoolNullable(json['requiresHealthIntake']),
      requiresPayment: _readBoolNullable(json['requiresPayment']),
      pricing: CheckoutPricing.maybeFrom(json['pricing']),
      appliedOffer: CheckoutAppliedOffer.maybeFrom(json['appliedOffer']),
      payment: CheckoutPaymentSummary.maybeFrom(json['payment']),
      product: CheckoutProductSummary.maybeFrom(json['product']),
      branch: CheckoutBranchSummary.maybeFrom(json['branch']),
      customer: CheckoutCustomerSummary.maybeFrom(json['customer']),
      metadata: _readMetadataMap(json['metadata']),
      createdAt: json['createdAt'] as String?,
      updatedAt: json['updatedAt'] as String?,
      responseMeta: List<dynamic>.from(responseMeta),
    );
  }

  /// When the API stores the health intake row id under `data.metadata`.
  int? get healthIntakeId => _readInt(metadata?['health_intake_id']);
}

class CheckoutSessionStatus {
  const CheckoutSessionStatus({this.value, this.label});

  final String? value;
  final String? label;

  static CheckoutSessionStatus? maybeFrom(dynamic raw) {
    if (raw is! Map) return null;
    final m = Map<String, dynamic>.from(raw);
    return CheckoutSessionStatus(
      value: m['value'] as String?,
      label: m['label'] as String?,
    );
  }
}

class CheckoutPricing {
  const CheckoutPricing({
    this.subtotal,
    this.discountAmount,
    this.totalAmount,
    this.currency,
    this.taxAmount,
    this.setupFeeAmount,
  });

  final int? subtotal;
  final int? discountAmount;
  final int? totalAmount;
  final String? currency;

  /// VAT / tax in minor units when the API includes it on `pricing`.
  final int? taxAmount;

  /// One-time setup fee in minor units when present.
  final int? setupFeeAmount;

  static CheckoutPricing? maybeFrom(dynamic raw) {
    if (raw is! Map) return null;
    final m = Map<String, dynamic>.from(raw);
    return CheckoutPricing(
      subtotal: _readInt(m['subtotal'] ?? m['sub_total']),
      discountAmount: _readInt(
        m['discountAmount'] ??
            m['discount_amount'] ??
            m['couponDiscount'] ??
            m['coupon_discount'],
      ),
      totalAmount: _readInt(
        m['totalAmount'] ?? m['total_amount'] ?? m['total'],
      ),
      currency: (m['currency'] ?? m['currency_code']) as String?,
      taxAmount: _readInt(
        m['taxAmount'] ??
            m['tax'] ??
            m['tax_amount'] ??
            m['vatAmount'] ??
            m['vat'],
      ),
      setupFeeAmount: _readInt(
        m['setupFee'] ??
            m['setup_fee'] ??
            m['setupFeeAmount'] ??
            m['setup_fee_amount'],
      ),
    );
  }
}

class CheckoutAppliedOffer {
  const CheckoutAppliedOffer({
    this.offerId,
    this.code,
    this.bonusDays,
    this.bonusSessions,
  });

  final int? offerId;
  final String? code;
  final int? bonusDays;
  final int? bonusSessions;

  static CheckoutAppliedOffer? maybeFrom(dynamic raw) {
    if (raw is! Map) return null;
    final m = Map<String, dynamic>.from(raw);
    return CheckoutAppliedOffer(
      offerId: _readInt(m['offerId']),
      code: m['code'] as String?,
      bonusDays: _readInt(m['bonusDays']),
      bonusSessions: _readInt(m['bonusSessions']),
    );
  }
}

class CheckoutPaymentSummary {
  const CheckoutPaymentSummary({
    this.reference,
    this.paidAt,
    this.invoicePdfUrl,
    this.invoiceNumber,
    this.cardLastFour,
    this.paymentBrand,
    this.nextBillingAt,
  });

  final String? reference;
  final String? paidAt;

  /// Receipt / invoice PDF when the session `payment` object includes a link.
  final String? invoicePdfUrl;

  /// Human-facing invoice number when distinct from [reference].
  final String? invoiceNumber;

  final String? cardLastFour;
  final String? paymentBrand;

  /// ISO or display date for next billing when the API returns it on `payment`.
  final String? nextBillingAt;

  static String? _invoiceUrlFromMap(Map<String, dynamic> m) {
    const keys = <String>[
      'invoicePdfUrl',
      'invoice_pdf_url',
      'pdfUrl',
      'pdf_url',
      'invoiceUrl',
      'invoice_url',
      'downloadUrl',
      'download_url',
      'receiptUrl',
      'receipt_url',
    ];
    for (final k in keys) {
      final v = m[k];
      if (v is String && v.trim().isNotEmpty) return v.trim();
      if (v != null) {
        final s = v.toString().trim();
        if (s.isNotEmpty) return s;
      }
    }
    return null;
  }

  /// Invoice / receipt PDF URL from a flat map (session `payment` or nested maps).
  static String? invoicePdfUrlFromMap(Map<String, dynamic> m) =>
      _invoiceUrlFromMap(m);

  static String? _firstNonEmptyString(
    Map<String, dynamic> m,
    List<String> keys,
  ) {
    for (final k in keys) {
      final v = m[k];
      if (v is String && v.trim().isNotEmpty) return v.trim();
      if (v != null) {
        final s = v.toString().trim();
        if (s.isNotEmpty) return s;
      }
    }
    return null;
  }

  static String? _cardLastFourFromMap(Map<String, dynamic> m) {
    final direct = _firstNonEmptyString(m, const [
      'last4',
      'last_four',
      'cardLast4',
      'card_last4',
    ]);
    if (direct != null) return direct;
    for (final key in const ['paymentMethod', 'payment_method', 'card']) {
      final nested = m[key];
      if (nested is Map) {
        final nm = Map<String, dynamic>.from(nested);
        final inner = _firstNonEmptyString(nm, const [
          'last4',
          'last_four',
          'lastFour',
        ]);
        if (inner != null) return inner;
      }
    }
    return null;
  }

  static CheckoutPaymentSummary? maybeFrom(dynamic raw) {
    if (raw is! Map) return null;
    final m = Map<String, dynamic>.from(raw);
    return CheckoutPaymentSummary(
      reference: _firstNonEmptyString(m, const [
        'reference',
        'tran_ref',
        'tranRef',
        'transaction_id',
        'transactionId',
        'payment_id',
        'paymentId',
      ]),
      paidAt: _firstNonEmptyString(m, const [
        'paidAt',
        'paid_at',
        'payment_date',
        'paymentDate',
      ]),
      invoicePdfUrl: _invoiceUrlFromMap(m),
      invoiceNumber: _firstNonEmptyString(m, const [
        'invoiceNumber',
        'invoice_number',
        'invoiceNo',
        'invoice_no',
      ]),
      cardLastFour: _cardLastFourFromMap(m),
      paymentBrand: _firstNonEmptyString(m, const [
        'brand',
        'scheme',
        'cardBrand',
        'card_brand',
        'paymentBrand',
        'payment_brand',
      ]),
      nextBillingAt: _firstNonEmptyString(m, const [
        'nextBillingAt',
        'next_billing_at',
        'nextBillingDate',
        'next_billing_date',
        'renewsAt',
        'renews_at',
        'subscriptionRenewsAt',
      ]),
    );
  }
}

class CheckoutProductSummary {
  const CheckoutProductSummary({
    this.id,
    this.name,
    this.type,
    this.entitlementType,
    this.requiresHealthIntake,
    this.sessionCount,
    this.validityDays,
  });

  final int? id;
  final String? name;
  final String? type;
  final String? entitlementType;
  final bool? requiresHealthIntake;
  final int? sessionCount;
  final int? validityDays;

  /// Suffix after formatted checkout price (aligned with [CatalogProduct.priceSubtitle]).
  String get billingPriceSuffix {
    final t = (type ?? '').toLowerCase();
    final et = (entitlementType ?? '').toLowerCase();
    if (t == 'membership' && et == 'subscription') {
      return ' / Month';
    }
    if (t == 'membership') {
      return ' / Month';
    }
    final vd = validityDays ?? 0;
    if (vd > 0) {
      return ' · $vd days';
    }
    return '';
  }

  static CheckoutProductSummary? maybeFrom(dynamic raw) {
    if (raw is! Map) return null;
    final m = Map<String, dynamic>.from(raw);
    return CheckoutProductSummary(
      id: _readInt(m['id']),
      name: m['name'] as String?,
      type: m['type'] as String?,
      entitlementType: m['entitlementType'] as String?,
      requiresHealthIntake: _readBoolNullable(m['requiresHealthIntake']),
      sessionCount: _firstIntFromKeys(m, const [
        'sessionCount',
        'sessions',
        'sessionsPerMonth',
        'classesPerMonth',
      ]),
      validityDays: _readInt(m['validityDays']),
    );
  }
}

class CheckoutBranchSummary {
  const CheckoutBranchSummary({this.id, this.name, this.shortCode});

  final int? id;
  final String? name;
  final String? shortCode;

  static CheckoutBranchSummary? maybeFrom(dynamic raw) {
    if (raw is! Map) return null;
    final m = Map<String, dynamic>.from(raw);
    return CheckoutBranchSummary(
      id: _readInt(m['id']),
      name: m['name'] as String?,
      shortCode: m['shortCode'] as String?,
    );
  }
}

class CheckoutCustomerSummary {
  const CheckoutCustomerSummary({this.id, this.name});

  final int? id;
  final String? name;

  static CheckoutCustomerSummary? maybeFrom(dynamic raw) {
    if (raw is! Map) return null;
    final m = Map<String, dynamic>.from(raw);
    return CheckoutCustomerSummary(
      id: _readInt(m['id']),
      name: m['name'] as String?,
    );
  }
}
