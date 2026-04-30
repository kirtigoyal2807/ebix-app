/// Models for checkout session `data` objects (`POST /checkout/start`,
/// `GET /checkout/{id}`, `POST …/apply-coupon`, `POST …/health-intake`, etc.).
///
/// JSON envelope: `{ "success", "message", "data": { ... }, "meta": [...] }`.
/// [CheckoutStartResult] maps **`data`**. [responseMeta] holds top-level **`meta`**
/// (distinct from `data.metadata` on the session object).

int? _readInt(dynamic value) {
  if (value == null) return null;
  if (value is int) return value;
  if (value is num) return value.toInt();
  return int.tryParse(value.toString());
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
    return Map<String, dynamic>.from(value as Map<dynamic, dynamic>);
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
      requiresHealthIntake: json['requiresHealthIntake'] as bool?,
      requiresPayment: json['requiresPayment'] as bool?,
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
  });

  final int? subtotal;
  final int? discountAmount;
  final int? totalAmount;
  final String? currency;

  static CheckoutPricing? maybeFrom(dynamic raw) {
    if (raw is! Map) return null;
    final m = Map<String, dynamic>.from(raw);
    return CheckoutPricing(
      subtotal: _readInt(m['subtotal']),
      discountAmount: _readInt(m['discountAmount']),
      totalAmount: _readInt(m['totalAmount']),
      currency: m['currency'] as String?,
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
  const CheckoutPaymentSummary({this.reference, this.paidAt});

  final String? reference;
  final String? paidAt;

  static CheckoutPaymentSummary? maybeFrom(dynamic raw) {
    if (raw is! Map) return null;
    final m = Map<String, dynamic>.from(raw);
    return CheckoutPaymentSummary(
      reference: m['reference'] as String?,
      paidAt: m['paidAt'] as String?,
    );
  }
}

class CheckoutProductSummary {
  const CheckoutProductSummary({
    this.id,
    this.name,
    this.type,
    this.entitlementType,
  });

  final int? id;
  final String? name;
  final String? type;
  final String? entitlementType;

  static CheckoutProductSummary? maybeFrom(dynamic raw) {
    if (raw is! Map) return null;
    final m = Map<String, dynamic>.from(raw);
    return CheckoutProductSummary(
      id: _readInt(m['id']),
      name: m['name'] as String?,
      type: m['type'] as String?,
      entitlementType: m['entitlementType'] as String?,
    );
  }
}

class CheckoutBranchSummary {
  const CheckoutBranchSummary({
    this.id,
    this.name,
    this.shortCode,
  });

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
