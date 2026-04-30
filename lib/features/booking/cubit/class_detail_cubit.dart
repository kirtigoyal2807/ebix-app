import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pilates_app/core/network/api_result.dart';
import 'package:pilates_app/features/booking/cubit/class_detail_state.dart';
import 'package:pilates_app/features/booking/data/classes_repository.dart';
import 'package:pilates_app/features/booking/data/models/class_slot_view_model.dart';
import 'package:pilates_app/features/booking/data/models/gym_class_resource.dart';

/// Loads class type detail (§13.3 `GET /classes/{classId}`) and maps it to a
/// [ClassSlotViewModel] for the detail UI.
///
/// Accepts an optional [preloadedSlot] from the list so the UI is instant while
/// the detail fetch is in-flight. The displayed session is the next upcoming
/// event (earliest [UpcomingEvent.startAt] that is still at or after the user's
/// current time) from the API response.
class ClassDetailCubit extends Cubit<ClassDetailState> {
  ClassDetailCubit(
    this._repository,
    String classId, {
    ClassSlotViewModel? preloadedSlot,
  })  : _classId = classId.trim(),
        super(
          ClassDetailState(
            status: preloadedSlot != null
                ? ClassDetailLoadStatus.loaded
                : ClassDetailLoadStatus.initial,
            slot: preloadedSlot,
          ),
        );

  final ClassesRepository _repository;
  final String _classId;

  /// Fetch class detail from the server and resolve [slot].
  Future<void> loadClassDetail() async {
    if (state.isLoading) return;

    emit(state.copyWith(status: ClassDetailLoadStatus.loading, errorMessage: null));

    final result = await _repository.getClassDetail(_classId);

    switch (result) {
      case ApiSuccess(:final data):
        final picked = _pickMatchingOrUpcomingEvent(data);
        final resolved =
            ClassSlotViewModel.fromGymClassResource(data, event: picked);
        final mergedSlot = resolved.copyWith(
          recentReviews: resolved.recentReviews ?? state.slot?.recentReviews,
          avgRating: resolved.avgRating ?? state.slot?.avgRating,
          basePrice: resolved.basePrice ?? state.slot?.basePrice,
        );
        emit(
          state.copyWith(
            status: ClassDetailLoadStatus.loaded,
            slot: mergedSlot,
            errorMessage: null,
          ),
        );
      case ApiFailure(:final exception):
        emit(
          state.copyWith(
            status: state.slot != null
                ? ClassDetailLoadStatus.loaded
                : ClassDetailLoadStatus.error,
            errorMessage: exception.message,
          ),
        );
    }
  }

  UpcomingEvent? _pickMatchingOrUpcomingEvent(GymClassResource data) {
    final preloadedEventId = state.slot?.calendarEventId.trim() ?? '';
    if (preloadedEventId.isNotEmpty) {
      for (final event in data.upcomingEvents) {
        if (event.id.trim() == preloadedEventId) {
          return event;
        }
      }
    }
    return ClassSlotViewModel.pickUpcomingEvent(data);
  }
}
