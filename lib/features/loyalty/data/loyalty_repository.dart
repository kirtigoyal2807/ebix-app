import 'package:pilates_app/core/network/api_result.dart';
import 'package:pilates_app/core/network/base_repository.dart';

import 'models/loyalty_achievements_result.dart';
import 'models/loyalty_challenge.dart';
import 'models/loyalty_challenge_detail.dart';
import 'models/loyalty_leaderboard_entry.dart';
import 'models/loyalty_points_history_entry.dart';
import 'models/loyalty_reward.dart';
import 'models/loyalty_tier.dart';
import 'models/loyalty_reward_redeem_result.dart';

/// Pilates API — loyalty module (17.x).
class LoyaltyRepository extends BaseRepository {
  LoyaltyRepository(super.dio);

  static List<LoyaltyReward> _rewardsFromJson(dynamic json) {
    if (json is! List) return [];
    return json
        .map(
          (e) => LoyaltyReward.fromJson(
            e is Map<String, dynamic> ? e : Map<String, dynamic>.from(e as Map),
          ),
        )
        .toList();
  }

  static List<LoyaltyChallenge> _challengesFromJson(dynamic json) {
    if (json is! List) return [];
    return json
        .map(
          (e) => LoyaltyChallenge.fromJson(
            e is Map<String, dynamic> ? e : Map<String, dynamic>.from(e as Map),
          ),
        )
        .toList();
  }

  static List<LoyaltyLeaderboardEntry> _leaderboardFromJson(dynamic json) {
    if (json is! List) return [];
    return json
        .map(
          (e) => LoyaltyLeaderboardEntry.fromJson(
            e is Map<String, dynamic> ? e : Map<String, dynamic>.from(e as Map),
          ),
        )
        .toList();
  }

  static List<LoyaltyPointsHistoryEntry> _pointsHistoryFromJson(dynamic json) {
    if (json is! List) return [];
    return json
        .map(
          (e) => LoyaltyPointsHistoryEntry.fromJson(
            e is Map<String, dynamic> ? e : Map<String, dynamic>.from(e as Map),
          ),
        )
        .toList();
  }

  static List<LoyaltyTier> _tiersFromJson(dynamic json) {
    List<dynamic> list;
    if (json is List) {
      list = json;
    } else if (json is Map) {
      final map = Map<String, dynamic>.from(json);
      final dynamic tiers =
          map['tiers'] ?? (map['data'] is List ? map['data'] : null);
      if (tiers is List) {
        list = tiers;
      } else {
        return [];
      }
    } else {
      return [];
    }
    return list
        .map(
          (e) => LoyaltyTier.fromJson(
            e is Map<String, dynamic> ? e : Map<String, dynamic>.from(e as Map),
          ),
        )
        .toList();
  }

  /// Tier catalog (`GET loyalty/tiers`). Envelope `data` is a **list** of tiers
  /// (`id`, `name`, `slug`, `minimumPoints`, `sortOrder`, `isCurrent`, `pointsToNext`, `benefits[]`),
  /// or a map with `tiers` / list-shaped `data`.
  Future<ApiResult<List<LoyaltyTier>>> getTiers() {
    return get<List<LoyaltyTier>>('loyalty/tiers', fromJson: _tiersFromJson);
  }

  /// Ledger of loyalty point changes (earn / redeem / etc.).
  Future<ApiResult<List<LoyaltyPointsHistoryEntry>>> getPointsHistory() {
    return get<List<LoyaltyPointsHistoryEntry>>(
      'loyalty/points-history',
      fromJson: _pointsHistoryFromJson,
    );
  }

  /// 17.10 Achievements — badges (earned + locked) and achievement rules.
  Future<ApiResult<LoyaltyAchievementsResult>> getAchievements() {
    return get<LoyaltyAchievementsResult>(
      'loyalty/achievements',
      fromJson: (json) =>
          LoyaltyAchievementsResult.fromJson(json as Map<String, dynamic>),
    );
  }

  /// Catalog of redeemable loyalty rewards.
  Future<ApiResult<List<LoyaltyReward>>> getRewards() {
    return get<List<LoyaltyReward>>(
      'loyalty/rewards',
      fromJson: _rewardsFromJson,
    );
  }

  /// Single reward for detail / redeem confirmation.
  Future<ApiResult<LoyaltyReward>> getReward(int id) {
    return get<LoyaltyReward>(
      'loyalty/rewards/$id',
      fromJson: (json) => LoyaltyReward.fromJson(
        json is Map<String, dynamic>
            ? json
            : Map<String, dynamic>.from(json as Map),
      ),
    );
  }

  /// Redeem points for a reward. On business failure envelope, returns [ApiFailure].
  Future<ApiResult<LoyaltyRewardRedeemResult>> redeemReward(int id) {
    return post<LoyaltyRewardRedeemResult>(
      'loyalty/rewards/$id/redeem',
      fromJson: (json) => LoyaltyRewardRedeemResult.fromJson(
        json is Map<String, dynamic>
            ? json
            : Map<String, dynamic>.from(json as Map),
      ),
    );
  }

  /// Active and past challenges visible to the member.
  Future<ApiResult<List<LoyaltyChallenge>>> getChallenges() {
    return get<List<LoyaltyChallenge>>(
      'loyalty/challenges',
      fromJson: _challengesFromJson,
    );
  }

  /// Challenge detail with embedded leaderboard snapshot.
  Future<ApiResult<LoyaltyChallengeDetail>> getChallengeDetail(int id) {
    return get<LoyaltyChallengeDetail>(
      'loyalty/challenges/$id',
      fromJson: (json) => LoyaltyChallengeDetail.fromJson(
        json is Map<String, dynamic>
            ? json
            : Map<String, dynamic>.from(json as Map),
      ),
    );
  }

  /// Join a challenge. Success yields `true` when envelope is successful (body may be empty).
  Future<ApiResult<bool>> joinChallenge(int id) {
    return post<bool>('loyalty/challenges/$id/join', fromJson: (_) => true);
  }

  /// Leaderboard for a challenge.
  Future<ApiResult<List<LoyaltyLeaderboardEntry>>> getChallengeLeaderboard(
    int id,
  ) {
    return get<List<LoyaltyLeaderboardEntry>>(
      'loyalty/challenges/$id/leaderboard',
      fromJson: _leaderboardFromJson,
    );
  }
}
