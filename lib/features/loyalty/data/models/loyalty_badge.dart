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
    return LoyaltyBadge(
      id: _parseId(json['id']),
      name: '${json['name'] ?? ''}',
      description: _nullableNonEmptyString(json['description']),
      iconUrl: _nullableNonEmptyString(json['iconUrl'] ?? json['icon_url']),
      badgeKey: '${json['badgeKey'] ?? json['badge_key'] ?? ''}',
      badgeType: '${json['badgeType'] ?? json['badge_type'] ?? ''}',
      isEarned: json['isEarned'] == true || json['is_earned'] == true,
      earnedAt: _parseDate(json['earnedAt'] ?? json['earned_at']),
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
