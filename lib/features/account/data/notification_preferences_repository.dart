import 'package:pilates_app/core/network/api_result.dart';
import 'package:pilates_app/core/network/base_repository.dart';

import 'models/notification_preferences.dart';

/// Pilates API — notification preferences.
class NotificationPreferencesRepository extends BaseRepository {
  NotificationPreferencesRepository(super.dio);

  /// GET /notifications/preferences
  /// Returns the customer's per-channel notification opt-in/opt-out settings.
  Future<ApiResult<NotificationPreferences>> getPreferences() {
    return get<NotificationPreferences>(
      '/notifications/preferences',
      fromJson: (json) =>
          NotificationPreferences.fromJson(json as Map<String, dynamic>),
    );
  }

  /// PUT /notifications/preferences
  /// Updates the customer's notification preferences (partial updates supported).
  Future<ApiResult<NotificationPreferences>> updatePreferences(
    Map<String, dynamic> data,
  ) {
    return put<NotificationPreferences>(
      '/notifications/preferences',
      data: data,
      fromJson: (json) =>
          NotificationPreferences.fromJson(json as Map<String, dynamic>),
    );
  }
}
