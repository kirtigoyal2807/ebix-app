import 'package:pilates_app/core/network/api_result.dart';
import 'package:pilates_app/core/network/base_repository.dart';

import 'models/loyalty_achievements_result.dart';

/// Pilates API — loyalty module (17.x).
class LoyaltyRepository extends BaseRepository {
  LoyaltyRepository(super.dio);

  /// 17.10 Achievements — badges (earned + locked) and achievement rules.
  Future<ApiResult<LoyaltyAchievementsResult>> getAchievements() {
    return get<LoyaltyAchievementsResult>(
      '/loyalty/achievements',
      fromJson: (json) =>
          LoyaltyAchievementsResult.fromJson(json as Map<String, dynamic>),
    );
  }
}
