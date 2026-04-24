import 'package:pilates_app/core/network/api_result.dart';
import 'package:pilates_app/core/network/base_repository.dart';
import 'package:pilates_app/features/my_booking/data/models/booking_resource.dart';

/// Pilates API §13.6 — book with session pack (`POST /classes/{calendarEventId}/book`).
class ClassesRepository extends BaseRepository {
  ClassesRepository(super.dio);

  /// Body is empty JSON per API contract.
  Future<ApiResult<BookingResource>> bookWithPlan(String calendarEventId) {
    final id = calendarEventId.trim();
    return post<BookingResource>(
      '/classes/$id/book',
      data: <String, dynamic>{},
      fromJson: (json) =>
          BookingResource.fromJson(json as Map<String, dynamic>),
    );
  }
}
