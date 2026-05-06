/// Rule from `GET /loyalty/achievements` `data.achievements[]`.
class LoyaltyAchievementRule {
  const LoyaltyAchievementRule({
    required this.id,
    required this.name,
    required this.ruleKey,
    required this.ruleType,
    this.thresholdValue,
    required this.rewardPoints,
  });

  final int id;
  final String name;
  final String ruleKey;
  final String ruleType;
  final double? thresholdValue;
  final int rewardPoints;

  factory LoyaltyAchievementRule.fromJson(Map<String, dynamic> json) {
    return LoyaltyAchievementRule(
      id: _int(json['id']),
      name: '${json['name'] ?? ''}',
      ruleKey: '${json['ruleKey'] ?? json['rule_key'] ?? ''}',
      ruleType: '${json['ruleType'] ?? json['rule_type'] ?? ''}',
      thresholdValue: _doubleOrNull(
        json['thresholdValue'] ?? json['threshold_value'],
      ),
      rewardPoints: _int(json['rewardPoints'] ?? json['reward_points']),
    );
  }

  static int _int(dynamic v) {
    if (v is int) return v;
    if (v is num) return v.toInt();
    return int.tryParse('$v') ?? 0;
  }

  static double? _doubleOrNull(dynamic v) {
    if (v == null) return null;
    if (v is double) return v;
    if (v is int) return v.toDouble();
    if (v is num) return v.toDouble();
    return double.tryParse('$v');
  }
}
