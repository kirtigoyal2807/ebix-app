import 'package:pilates_app/core/localization/arb/app_localizations.dart';
import 'package:pilates_app/core/utils/currency_display.dart';

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
    this.apiFeatureLines,
  });

  final int id;
  final String sku;
  final String type;
  final String entitlementType;
  final String name;
  final String description;
  final num basePrice;
  final num salePrice;
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

  /// When the API sends `features` / `benefits` / `highlights`, those strings are
  /// shown in [toPlanMap] instead of derived [_featureLines].
  final List<String>? apiFeatureLines;

  /// Amount shown in plan cards — [salePrice] when set, else [basePrice], else `0`.
  num get displayPrice {
    if (salePrice > 0) return salePrice;
    if (basePrice > 0) return basePrice;
    return 0;
  }

  factory CatalogProduct.fromJson(Map<String, dynamic> json) {
    int asInt(dynamic v) {
      if (v is int) return v;
      if (v is num) return v.round();
      return int.tryParse(v?.toString() ?? '') ?? 0;
    }

    num asMajor(dynamic v) {
      if (v == null) return 0;
      if (v is num) return v;
      return num.tryParse(v.toString().replaceAll(',', '')) ?? 0;
    }

    num? readMajor(Map<String, dynamic> m, List<String> keys) {
      for (final key in keys) {
        if (!m.containsKey(key) || m[key] == null) continue;
        return asMajor(m[key]);
      }
      return null;
    }

    String? readString(Map<String, dynamic> m, List<String> keys) {
      for (final key in keys) {
        final raw = m[key];
        if (raw == null) continue;
        final s = raw.toString().trim();
        if (s.isNotEmpty) return s;
      }
      return null;
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

    bool readBool(Map<String, dynamic> m, List<String> keys) {
      for (final key in keys) {
        if (!m.containsKey(key)) continue;
        return asBool(m[key]);
      }
      return false;
    }

    List<String>? featureBulletsFromApi(Map<String, dynamic> m) {
      for (final key in const [
        'features',
        'benefits',
        'highlights',
        'featureList',
      ]) {
        final raw = m[key];
        if (raw is! List) continue;
        final out = <String>[];
        for (final e in raw) {
          if (e is String) {
            final s = e.trim();
            if (s.isNotEmpty) out.add(s);
          } else if (e is Map) {
            final mm = Map<String, dynamic>.from(e);
            final text =
                (mm['text'] ?? mm['label'] ?? mm['title'] ?? mm['name'])
                    ?.toString()
                    .trim();
            if (text != null && text.isNotEmpty) out.add(text);
          }
        }
        if (out.isNotEmpty) return out;
      }
      return null;
    }

    var basePrice = readMajor(json, const ['basePrice', 'base_price']) ?? 0;
    var salePrice =
        readMajor(json, const ['salePrice', 'sale_price']) ?? 0;
    if (salePrice <= 0) {
      salePrice =
          readMajor(json, const ['price', 'amount']) ?? salePrice;
    }

    final pricing = json['pricing'];
    if (pricing is Map) {
      final pm = Map<String, dynamic>.from(pricing);
      if (basePrice <= 0) {
        basePrice =
            readMajor(pm, const ['basePrice', 'base_price']) ?? basePrice;
      }
      if (salePrice <= 0) {
        salePrice = readMajor(pm, const [
              'salePrice',
              'sale_price',
              'price',
              'amount',
              'total',
              'totalAmount',
              'total_amount',
            ]) ??
            salePrice;
      }
    }

    return CatalogProduct(
      id: asInt(json['id']),
      sku: readString(json, const ['sku']) ?? '',
      type: readString(json, const ['type']) ?? '',
      entitlementType:
          readString(json, const ['entitlementType', 'entitlement_type']) ??
          '',
      name: readString(json, const ['name', 'title']) ?? '',
      description: readString(json, const ['description']) ?? '',
      basePrice: basePrice,
      salePrice: salePrice,
      currency:
          readString(json, const ['currency', 'currency_code']) ?? 'SAR',
      isActive: json.containsKey('isActive') || json.containsKey('is_active')
          ? readBool(json, const ['isActive', 'is_active'])
          : asBool(json['isActive']),
      isRecommended: readBool(json, const [
        'isRecommended',
        'is_recommended',
      ]),
      requiresHealthIntake: readBool(json, const [
        'requiresHealthIntake',
        'requires_health_intake',
      ]),
      isGlobal: readBool(json, const ['isGlobal', 'is_global']),
      isTransferable: readBool(json, const [
        'isTransferable',
        'is_transferable',
      ]),
      gender: readString(json, const ['gender']),
      validityDays: asInt(
        json['validityDays'] ?? json['validity_days'],
      ),
      bonusDays: asInt(json['bonusDays'] ?? json['bonus_days']),
      maxFreezingAttempts: asInt(
        json['maxFreezingAttempts'] ?? json['max_freezing_attempts'],
      ),
      maxFreezingDays: asInt(
        json['maxFreezingDays'] ?? json['max_freezing_days'],
      ),
      sessionCount: asIntNullable(
        json['sessionCount'] ?? json['session_count'],
      ),
      createdAt: readString(json, const ['createdAt', 'created_at']),
      apiFeatureLines: featureBulletsFromApi(json),
    );
  }

  /// Shown after the formatted amount in plan selection / detail UI.
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
    final bullets = (apiFeatureLines != null && apiFeatureLines!.isNotEmpty)
        ? apiFeatureLines!
        : _featureLines();
    return <String, dynamic>{
      'id': id.toString(),
      'title': name,
      'price': formatPrice(displayPrice),
      'priceAmount': displayPrice,
      'currency': currency,
      'badge': isRecommended ? l10n.mostPopular : null,
      'isPopular': isRecommended,
      'features': bullets,
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
