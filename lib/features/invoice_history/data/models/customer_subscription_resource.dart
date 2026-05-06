/// Item from `GET /subscriptions/customer/{customer}` — Mobile API §9.3.
///
/// Fields: `id`, `status`, `entitlementType`, `startsAt`, `expiresAt`, `isActive`,
/// `pricePaid`, `isTransferable`, `product`, `sessions`, `freezes[]`.
class CustomerSubscriptionResource {
  const CustomerSubscriptionResource({
    required this.id,
    required this.status,
    required this.entitlementType,
    this.startsAt,
    this.expiresAt,
    required this.isActive,
    this.isPaid = false,
    required this.pricePaid,
    required this.isTransferable,
    this.product,
    this.sessions,
    this.freezes = const [],
    this.createdAt,
    this.updatedAt,
    this.invoicePdfUrl,
    this.maxFreezeDays,
  });

  final String id;
  final String status;

  /// e.g. `none` | `session_pack` | `subscription`
  final String entitlementType;

  final DateTime? startsAt;
  final DateTime? expiresAt;
  final bool isActive;
  final bool isPaid;
  final double pricePaid;
  final bool isTransferable;
  final SubscriptionProductRef? product;
  final SubscriptionSessions? sessions;
  final List<SubscriptionFreeze> freezes;

  /// Not always present on §9.3 minimal payload; optional.
  final DateTime? createdAt;
  final DateTime? updatedAt;

  /// Invoice / receipt PDF URL if the API provides one (various key names).
  final String? invoicePdfUrl;

  /// Max calendar days allowed for a single freeze/pause (§9.1); may mirror [SubscriptionProductRef.maxFreezeDays].
  final int? maxFreezeDays;

  factory CustomerSubscriptionResource.fromJson(Map<String, dynamic> json) {
    final productRaw = json['product'];
    SubscriptionProductRef? product;
    if (productRaw is Map) {
      product = SubscriptionProductRef.fromJson(
        Map<String, dynamic>.from(productRaw),
      );
    }

    final sessionsRaw = json['sessions'];
    SubscriptionSessions? sessions;
    if (sessionsRaw is Map) {
      sessions = SubscriptionSessions.fromJson(
        Map<String, dynamic>.from(sessionsRaw),
      );
    }

    final freezesRaw = json['freezes'];
    final freezes = <SubscriptionFreeze>[];
    if (freezesRaw is List) {
      for (final e in freezesRaw) {
        if (e is Map) {
          freezes.add(SubscriptionFreeze.fromJson(Map<String, dynamic>.from(e)));
        }
      }
    }

    return CustomerSubscriptionResource(
      id: '${json['id'] ?? ''}',
      status: _parseStatus(json['status']),
      entitlementType:
          '${json['entitlementType'] ?? json['entitlement_type'] ?? 'none'}',
      startsAt: _parseDate(json['startsAt'] ?? json['starts_at']),
      expiresAt: _parseDate(json['expiresAt'] ?? json['expires_at']),
      isActive: json['isActive'] == true || json['is_active'] == true,
      isPaid: json['isPaid'] == true || json['is_paid'] == true,
      pricePaid: _double(json['pricePaid'] ?? json['price_paid']),
      isTransferable: json['isTransferable'] == true || json['is_transferable'] == true,
      product: product,
      sessions: sessions,
      freezes: freezes,
      createdAt: _parseDate(json['createdAt'] ?? json['created_at']),
      updatedAt: _parseDate(json['updatedAt'] ?? json['updated_at']),
      invoicePdfUrl: _firstNonEmptyString([
        json['invoicePdfUrl'],
        json['invoice_pdf_url'],
        json['pdfUrl'],
        json['pdf_url'],
        json['invoiceUrl'],
        json['invoice_url'],
        json['receiptUrl'],
        json['receipt_url'],
        json['downloadUrl'],
        json['download_url'],
      ]),
      maxFreezeDays: _mergeMaxFreezeDays(json, product),
    );
  }

  /// Handles plain string or `{ "value": "...", "label": "..." }` (common in mobile API).
  static String _parseStatus(dynamic v) {
    if (v == null) return '';
    if (v is Map) {
      final m = Map<String, dynamic>.from(v);
      final label = m['label'];
      final value = m['value'];
      final s = '${label ?? value ?? ''}'.trim();
      return s;
    }
    return '$v'.trim();
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

  static int? _mergeMaxFreezeDays(
    Map<String, dynamic> json,
    SubscriptionProductRef? product,
  ) {
    int? top = SubscriptionSessions._intOrNull(
      json['maxFreezeDays'] ??
          json['max_freeze_days'] ??
          json['maxPauseDays'] ??
          json['max_pause_days'] ??
          json['freezeQuotaDays'] ??
          json['freeze_quota_days'],
    );
    final fromProduct = product?.maxFreezeDays;
    if (top != null && top > 0) return top;
    if (fromProduct != null && fromProduct > 0) return fromProduct;
    return null;
  }

  static DateTime? _parseDate(dynamic v) {
    if (v == null) return null;
    if (v is DateTime) return v.toUtc();
    final s = '$v'.trim();
    if (s.isEmpty) return null;
    return DateTime.tryParse(s)?.toUtc() ??
        DateTime.tryParse(s.replaceFirst(' ', 'T'))?.toUtc();
  }
}

class SubscriptionProductRef {
  const SubscriptionProductRef({this.id, this.name, this.maxFreezeDays});

  final int? id;
  final String? name;
  final int? maxFreezeDays;

  factory SubscriptionProductRef.fromJson(Map<String, dynamic> json) {
    final idRaw = json['id'];
    int? id;
    if (idRaw is int) {
      id = idRaw;
    } else if (idRaw is num) {
      id = idRaw.toInt();
    } else {
      id = int.tryParse('$idRaw');
    }
    final name = '${json['name'] ?? ''}'.trim();
    final maxFreeze = SubscriptionSessions._intOrNull(
      json['maxFreezeDays'] ??
          json['max_freeze_days'] ??
          json['maxPauseDays'] ??
          json['max_pause_days'],
    );
    return SubscriptionProductRef(
      id: id,
      name: name.isEmpty ? null : name,
      maxFreezeDays: maxFreeze,
    );
  }
}

class SubscriptionSessions {
  const SubscriptionSessions({
    this.total,
    required this.used,
    this.remaining,
  });

  final int? total;
  final int used;
  final int? remaining;

  factory SubscriptionSessions.fromJson(Map<String, dynamic> json) {
    return SubscriptionSessions(
      total: _intOrNull(json['total']),
      used: _int(json['used'], 0),
      remaining: _intOrNull(json['remaining']),
    );
  }

  static int _int(dynamic v, int fallback) {
    if (v == null) return fallback;
    if (v is int) return v;
    if (v is num) return v.toInt();
    return int.tryParse('$v') ?? fallback;
  }

  static int? _intOrNull(dynamic v) {
    if (v == null) return null;
    if (v is int) return v;
    if (v is num) return v.toInt();
    return int.tryParse('$v');
  }
}

class SubscriptionFreeze {
  const SubscriptionFreeze({
    required this.id,
    required this.status,
    this.startDate,
    this.endDate,
    this.daysFrozen = 0,
  });

  final String id;
  final String status;
  final String? startDate;
  final String? endDate;
  final int daysFrozen;

  factory SubscriptionFreeze.fromJson(Map<String, dynamic> json) {
    final idRaw = json['id'];
    final idStr = idRaw == null ? '' : '$idRaw'.trim();
    return SubscriptionFreeze(
      id: idStr,
      status: '${json['status'] ?? ''}',
      startDate: json['startDate']?.toString() ?? json['start_date']?.toString(),
      endDate: json['endDate']?.toString() ?? json['end_date']?.toString(),
      daysFrozen: SubscriptionSessions._int(
        json['daysFrozen'] ?? json['days_frozen'],
        0,
      ),
    );
  }
}
