import 'loyalty_achievement_rule.dart';
import 'loyalty_badge.dart';

/// `data` object from `GET /loyalty/achievements` (17.10).
class LoyaltyAchievementsResult {
  const LoyaltyAchievementsResult({
    required this.badges,
    required this.achievements,
  });

  final List<LoyaltyBadge> badges;
  final List<LoyaltyAchievementRule> achievements;

  /// Best-effort link between a badge row and a rule row.
  ///
  /// Order: exact `ruleKey` == `badgeKey` → same numeric `id` (as in dev payloads)
  /// → match `thresholdValue` to the first integer in [LoyaltyBadge.description]
  /// (e.g. "Attended 5 classes" → 5) with optional `ruleType` / `badgeType` alignment.
  LoyaltyAchievementRule? ruleMatchingBadge(LoyaltyBadge badge) {
    final key = badge.badgeKey.trim();

    if (key.isNotEmpty) {
      for (final r in achievements) {
        if (r.ruleKey.trim() == key) return r;
      }
    }

    for (final r in achievements) {
      if (r.id == badge.id) return r;
    }

    final n = _firstIntInString(badge.description);
    if (n != null) {
      final byThreshold = achievements
          .where((r) => _thresholdMatches(r.thresholdValue, n))
          .toList();
      if (byThreshold.length == 1) return byThreshold.single;
      for (final r in byThreshold) {
        if (_ruleAlignsWithBadge(r, badge)) return r;
      }
      if (byThreshold.isNotEmpty) return byThreshold.first;
    }

    return null;
  }

  factory LoyaltyAchievementsResult.fromJson(Map<String, dynamic> json) {
    final badges = <LoyaltyBadge>[];
    final rawBadges = json['badges'];
    if (rawBadges is List<dynamic>) {
      for (final e in rawBadges) {
        if (e is Map<String, dynamic>) {
          badges.add(LoyaltyBadge.fromJson(e));
        } else if (e is Map) {
          badges.add(LoyaltyBadge.fromJson(Map<String, dynamic>.from(e)));
        }
      }
    }

    final rules = <LoyaltyAchievementRule>[];
    final rawRules = json['achievements'];
    if (rawRules is List<dynamic>) {
      for (final e in rawRules) {
        if (e is Map<String, dynamic>) {
          rules.add(LoyaltyAchievementRule.fromJson(e));
        } else if (e is Map) {
          rules.add(
            LoyaltyAchievementRule.fromJson(Map<String, dynamic>.from(e)),
          );
        }
      }
    }

    return LoyaltyAchievementsResult(badges: badges, achievements: rules);
  }

  int get earnedBadgeCount => badges.where((b) => b.isEarned).length;
}

bool _thresholdMatches(double? threshold, int n) {
  if (threshold == null) return false;
  return (threshold - n).abs() < 0.0001;
}

int? _firstIntInString(String? s) {
  if (s == null || s.trim().isEmpty) return null;
  final m = RegExp(r'\d+').firstMatch(s);
  if (m == null) return null;
  return int.tryParse(m.group(0)!);
}

bool _ruleAlignsWithBadge(LoyaltyAchievementRule r, LoyaltyBadge b) {
  final bt = b.badgeType.toLowerCase();
  final rt = r.ruleType.toLowerCase();
  if (bt.contains('attendance') && rt.contains('attendance')) return true;
  if (bt.contains('streak') && rt.contains('streak')) return true;
  if (bt.contains('referral') && rt.contains('referral')) return true;
  if (bt.contains('milestone') &&
      (rt.contains('milestone') ||
          rt.contains('count') ||
          rt.contains('attendance'))) {
    return true;
  }
  return false;
}
