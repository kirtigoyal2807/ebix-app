/// Benefit line from `GET /loyalty/tiers` `benefits[]`.
///
/// Objects typically use **`label`** for user-facing copy and optional **`key`**
/// (nullable) for stable ids. Plain-text benefits may omit `key` or send only
/// `label` / `title` / `description`.
class LoyaltyTierBenefit {
  const LoyaltyTierBenefit({
    required this.title,
    required this.description,
    this.benefitKey,
  });

  /// Main line in the UI (maps from `label`, then `title` / `name`, else humanized `key`).
  final String title;

  /// Subtitle when `description` / `subtitle` exist on the payload.
  final String description;

  /// API `key` when present (e.g. `earn_rate`); optional for analytics / future i18n.
  final String? benefitKey;

  factory LoyaltyTierBenefit.fromJson(Map<String, dynamic> json) {
    final key = _trimOrEmptyAsNull(json['key']);
    final label = _trimOrEmptyAsNull(json['label']);
    final titleField =
        _trimOrEmptyAsNull(json['title']) ?? _trimOrEmptyAsNull(json['name']);
    final desc = _trimOrEmptyAsNull(json['description']) ??
        _trimOrEmptyAsNull(json['subtitle']);

    var primary = label ?? titleField;
    if (primary == null && key != null) {
      primary = _humanizeBenefitKey(key);
    }
    primary ??= '';

    return LoyaltyTierBenefit(
      title: primary,
      description: desc ?? '',
      benefitKey: key,
    );
  }

  static String? _trimOrEmptyAsNull(dynamic v) {
    if (v == null) return null;
    final t = v.toString().trim();
    return t.isEmpty ? null : t;
  }

  static String _humanizeBenefitKey(String key) {
    return key
        .split(RegExp(r'[_\s]+'))
        .where((w) => w.isNotEmpty)
        .map(
          (w) =>
              '${w[0].toUpperCase()}${w.length > 1 ? w.substring(1).toLowerCase() : ''}',
        )
        .join(' ');
  }
}

/// Tier row from `GET /loyalty/tiers` — `data` is a JSON array.
class LoyaltyTier {
  const LoyaltyTier({
    required this.id,
    this.key,
    required this.name,
    required this.description,
    required this.sortOrder,
    required this.benefits,
    this.isCurrent = false,
    this.pointsMin,
    this.pointsMax,
    this.pointsToNext,
  });

  final String id;
  final String? key;
  final String name;
  final String description;
  final int sortOrder;
  final List<LoyaltyTierBenefit> benefits;
  final bool isCurrent;
  final int? pointsMin;
  final int? pointsMax;

  /// Points still needed to reach the next tier, when the API sends it.
  final int? pointsToNext;

  factory LoyaltyTier.fromJson(Map<String, dynamic> json) {
    final benefits = <LoyaltyTierBenefit>[];
    final raw = json['benefits'];
    if (raw is List) {
      for (final e in raw) {
        if (e is String) {
          final line = e.trim();
          if (line.isNotEmpty) {
            benefits.add(LoyaltyTierBenefit(title: line, description: ''));
          }
          continue;
        }
        if (e is Map<String, dynamic>) {
          final b = LoyaltyTierBenefit.fromJson(e);
          if (b.title.trim().isNotEmpty || b.description.trim().isNotEmpty) {
            benefits.add(b);
          }
        } else if (e is Map) {
          final b = LoyaltyTierBenefit.fromJson(
            Map<String, dynamic>.from(e),
          );
          if (b.title.trim().isNotEmpty || b.description.trim().isNotEmpty) {
            benefits.add(b);
          }
        }
      }
    }

    final minPoints = _readInt(
      json['minimumPoints'] ??
          json['pointsMin'] ??
          json['minPoints'],
    );

    return LoyaltyTier(
      id: json['id']?.toString() ?? '',
      key: json['slug']?.toString() ?? json['key']?.toString(),
      name: json['name']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      sortOrder: (json['sortOrder'] as num?)?.toInt() ?? 0,
      benefits: benefits,
      isCurrent: json['isCurrent'] == true || json['current'] == true,
      pointsMin: minPoints,
      pointsMax: _readInt(json['pointsMax'] ?? json['maxPoints']),
      pointsToNext: _readInt(json['pointsToNext']),
    );
  }

  static int? _readInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is num) return value.toInt();
    return int.tryParse(value.toString());
  }
}
