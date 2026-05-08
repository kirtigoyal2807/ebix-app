import 'package:pilates_app/core/network/api_result.dart';
import 'package:pilates_app/core/network/base_repository.dart';

import 'models/notification_preferences.dart';

/// Pilates API — notification preferences.
class NotificationPreferencesRepository extends BaseRepository {
  NotificationPreferencesRepository(super.dio);

  /// GET /notifications/preferences
  Future<ApiResult<NotificationPreferences>> getPreferences() {
    return get<NotificationPreferences>(
      '/notifications/preferences',
      fromJson: (json) =>
          NotificationPreferences.fromJson(json as Map<String, dynamic>),
    );
  }

  /// PUT /notifications/preferences
  /// Partial updates: include only keys you send inside [preferences].
  /// Root [push] and [email] are required by the backend alongside [preferences].
  Future<ApiResult<void>> updatePreferences({
    required bool push,
    required bool email,
    required Map<String, dynamic> preferences,
  }) {
    return put<void>(
      '/notifications/preferences',
      data: <String, dynamic>{
        'push': push,
        'email': email,
        'preferences': preferences,
      },
      fromJson: (_) {},
    );
  }
}
