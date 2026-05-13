/// Badge entry from `GET /loyalty/achievements` `data.badges[]`.
class LoyaltyBadge {
  const LoyaltyBadge({
    required this.id,
    required this.name,
    this.description,
    this.iconUrl,
    required this.badgeKey,
    required this.badgeType,
    required this.isEarned,
    this.earnedAt,
  });

  final int id;
  final String name;
  final String? description;
  final String? iconUrl;
  final String badgeKey;
  final String badgeType;
  final bool isEarned;
  final DateTime? earnedAt;

  factory LoyaltyBadge.fromJson(Map<String, dynamic> json) {
    final earnedAt = _parseDate(json['earnedAt'] ?? json['earned_at']);
    final explicitEarned =
        json['isEarned'] == true || json['is_earned'] == true;
    final explicitNotEarned =
        json['isEarned'] == false || json['is_earned'] == false;

    /// `GET loyalty/badges` marks completion via [earnedAt]; achievements may send flags only.
    final isEarned =
        explicitEarned || (!explicitNotEarned && earnedAt != null);

    return LoyaltyBadge(
      id: _parseId(json['id']),
      name: '${json['name'] ?? ''}',
      description: _nullableNonEmptyString(json['description']),
      iconUrl: _nullableNonEmptyString(json['iconUrl'] ?? json['icon_url']),
      badgeKey: '${json['badgeKey'] ?? json['badge_key'] ?? ''}',
      badgeType: '${json['badgeType'] ?? json['badge_type'] ?? ''}',
      isEarned: isEarned,
      earnedAt: earnedAt,
    );
  }

  static String? _nullableNonEmptyString(dynamic v) {
    if (v == null) return null;
    final s = '$v'.trim();
    return s.isEmpty ? null : s;
  }

  static int _parseId(dynamic v) {
    if (v is int) return v;
    if (v is num) return v.toInt();
    if (v is String) {
      final n = int.tryParse(v);
      if (n != null) return n;
      return v.hashCode & 0x7fffffff;
    }
    return 0;
  }

  static DateTime? _parseDate(dynamic v) {
    if (v == null) return null;
    return DateTime.tryParse('$v');
  }
}
