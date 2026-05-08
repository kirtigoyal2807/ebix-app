import 'package:pilates_app/core/network/api_result.dart';
import 'package:pilates_app/core/network/base_repository.dart';

import 'models/progress_goal_settings.dart';
import 'models/progress_overview.dart';
import 'models/session_history_page_result.dart';
import 'models/weekly_activity_result.dart';

/// Pilates API — progress module (15.x).
class ProgressRepository extends BaseRepository {
  ProgressRepository(super.dio);

  /// 15.1 Overview — month-to-date stats and streaks.
  Future<ApiResult<ProgressOverview>> getOverview() {
    return get<ProgressOverview>(
      'progress/overview',
      fromJson: (json) =>
          ProgressOverview.fromJson(json as Map<String, dynamic>),
    );
  }

  /// 15.2 Session history — paginated sessions.
  Future<ApiResult<SessionHistoryPageResult>> getSessionHistory({
    String filter = 'all',
    int page = 1,
    int perPage = 20,
  }) {
    final safePerPage = perPage.clamp(1, 100);
    return get<SessionHistoryPageResult>(
      'progress/session-history',
      queryParameters: {'filter': filter, 'page': page, 'perPage': safePerPage},
      fromJson: (json) =>
          SessionHistoryPageResult.fromJson(json as Map<String, dynamic>),
    );
  }

  /// 15.3 Weekly activity — Mon–Sun minutes and session counts.
  Future<ApiResult<WeeklyActivityResult>> getWeeklyActivity() {
    return get<WeeklyActivityResult>(
      'progress/weekly-activity',
      fromJson: (json) =>
          WeeklyActivityResult.fromJson(json as Map<String, dynamic>),
    );
  }

  /// 15.4 Current training goal settings.
  Future<ApiResult<ProgressGoalSettings>> getGoal() {
    return get<ProgressGoalSettings>(
      'progress/goal',
      fromJson: (json) =>
          ProgressGoalSettings.fromJson(json as Map<String, dynamic>),
    );
  }

  /// 15.5 Update goal — send only fields that should change.
  Future<ApiResult<bool>> updateGoal({
    int? monthlyGoal,
    String? experience,
    String? goal,
  }) {
    final body = <String, dynamic>{};
    if (monthlyGoal != null) {
      body['monthlyGoal'] = monthlyGoal.clamp(0, 365);
    }
    if (experience != null) {
      body['experience'] = experience;
    }
    if (goal != null) {
      body['goal'] = goal;
    }
    return put<bool>('progress/goal', data: body, fromJson: (_) => true);
  }
}
