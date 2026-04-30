import 'package:pilates_app/core/localization/arb/app_localizations.dart';

/// One row from `GET /products` envelope `data` array.
class CatalogProduct {
  const CatalogProduct({
    required this.id,
    required this.sku,
    required this.type,
    required this.entitlementType,
    required this.name,
    required this.description,
    required this.basePrice,
    required this.salePrice,
    required this.currency,
    required this.isActive,
    required this.isRecommended,
    required this.requiresHealthIntake,
    required this.isGlobal,
    required this.isTransferable,
    required this.gender,
    required this.validityDays,
    required this.bonusDays,
    required this.maxFreezingAttempts,
    required this.maxFreezingDays,
    required this.sessionCount,
    required this.createdAt,
  });

  final int id;
  final String sku;
  final String type;
  final String entitlementType;
  final String name;
  final String description;
  final int basePrice;
  final int salePrice;
  final String currency;
  final bool isActive;
  final bool isRecommended;
  final bool requiresHealthIntake;
  final bool isGlobal;
  final bool isTransferable;
  final String? gender;
  final int validityDays;
  final int bonusDays;
  final int maxFreezingAttempts;
  final int maxFreezingDays;
  final int? sessionCount;
  final String? createdAt;

  factory CatalogProduct.fromJson(Map<String, dynamic> json) {
    int asInt(dynamic v) {
      if (v is int) return v;
      if (v is num) return v.round();
      return int.tryParse(v?.toString() ?? '') ?? 0;
    }

    int? asIntNullable(dynamic v) {
      if (v == null) return null;
      return asInt(v);
    }

    bool asBool(dynamic v) {
      if (v is bool) return v;
      if (v == 1 || v == '1' || v == 'true') return true;
      return false;
    }

    return CatalogProduct(
      id: asInt(json['id']),
      sku: json['sku']?.toString() ?? '',
      type: json['type']?.toString() ?? '',
      entitlementType: json['entitlementType']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      basePrice: asInt(json['basePrice']),
      salePrice: asInt(json['salePrice']),
      currency: json['currency']?.toString() ?? 'SAR',
      isActive: asBool(json['isActive']),
      isRecommended: asBool(json['isRecommended']),
      requiresHealthIntake: asBool(json['requiresHealthIntake']),
      isGlobal: asBool(json['isGlobal']),
      isTransferable: asBool(json['isTransferable']),
      gender: json['gender']?.toString(),
      validityDays: asInt(json['validityDays']),
      bonusDays: asInt(json['bonusDays']),
      maxFreezingAttempts: asInt(json['maxFreezingAttempts']),
      maxFreezingDays: asInt(json['maxFreezingDays']),
      sessionCount: asIntNullable(json['sessionCount']),
      createdAt: json['createdAt']?.toString(),
    );
  }

  /// Shown next to the amount in [PlanDetailsModal] (after the SAR icon).
  String get priceSubtitle {
    final t = type.toLowerCase();
    final et = entitlementType.toLowerCase();
    if (t == 'membership' && et == 'subscription') {
      return ' / Month';
    }
    if (t == 'membership') {
      return ' / Month';
    }
    if (validityDays > 0) {
      return ' · $validityDays days';
    }
    return '';
  }

  List<String> _featureLines() {
    final out = <String>[];
    final sc = sessionCount;
    if (sc != null) {
      out.add(sc == 1 ? '1 session' : '$sc sessions');
    }
    if (validityDays > 0) {
      out.add('Valid $validityDays days');
    }
    if (maxFreezingDays > 0 && maxFreezingAttempts > 0) {
      out.add(
        'Freeze up to $maxFreezingDays days ($maxFreezingAttempts times)',
      );
    }
    final g = gender?.trim();
    if (g != null && g.isNotEmpty) {
      out.add('${g[0].toUpperCase()}${g.length > 1 ? g.substring(1) : ''}');
    }
    return out.take(5).toList();
  }

  /// Shape expected by [PlanCard] / [PlanDetailsModal].
  Map<String, dynamic> toPlanMap(AppLocalizations l10n) {
    return <String, dynamic>{
      'id': id.toString(),
      'title': name,
      'price': salePrice.toString(),
      'badge': isRecommended ? l10n.mostPopular : null,
      'isPopular': isRecommended,
      'features': _featureLines(),
      'priceSubtitle': priceSubtitle,
      'requiresHealthIntake': requiresHealthIntake,
    };
  }

  /// Parses envelope `data` when it is a single product object (`GET /products/{id}`).
  static CatalogProduct fromEnvelopeData(dynamic payload) {
    if (payload is! Map) {
      throw StateError('Expected product object in envelope data');
    }
    return CatalogProduct.fromJson(Map<String, dynamic>.from(payload));
  }

  /// Parses envelope `data` when it is a JSON array of product objects.
  static List<CatalogProduct> listFromEnvelopeData(dynamic payload) {
    if (payload is! List) return [];
    final out = <CatalogProduct>[];
    for (final item in payload) {
      if (item is! Map) continue;
      final p = CatalogProduct.fromJson(Map<String, dynamic>.from(item));
      if (p.isActive) out.add(p);
    }
    return out;
  }
}
