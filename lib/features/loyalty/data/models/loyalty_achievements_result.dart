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
