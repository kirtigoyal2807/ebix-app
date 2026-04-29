import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pilates_app/core/network/api_result.dart';
import 'package:pilates_app/features/booking/cubit/class_detail_state.dart';
import 'package:pilates_app/features/booking/data/classes_repository.dart';
import 'package:pilates_app/features/booking/data/models/class_slot_view_model.dart';

/// Loads class type detail (§13.3 `GET /classes/{classId}`) and maps it to a
/// [ClassSlotViewModel] for the detail UI.
///
/// Accepts an optional [preloadedSlot] from the list so the UI is instant while
/// the detail fetch is in-flight. [preferredCalendarEventId] selects which
/// upcoming event to show when the API returns several.
class ClassDetailCubit extends Cubit<ClassDetailState> {
  ClassDetailCubit(
    this._repository,
    String classId, {
    ClassSlotViewModel? preloadedSlot,
    this.preferredCalendarEventId,
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

  /// When set, must appear in `upcomingEvents` to select that session; otherwise
  /// the earliest upcoming event is used.
  final String? preferredCalendarEventId;

  /// Fetch class detail from the server and resolve [slot].
  Future<void> loadClassDetail() async {
    if (state.isLoading) return;

    emit(state.copyWith(status: ClassDetailLoadStatus.loading, errorMessage: null));

    String? preferredId;
    final explicit = preferredCalendarEventId?.trim();
    if (explicit != null && explicit.isNotEmpty) {
      preferredId = explicit;
    } else {
      final fromPreload = state.slot?.calendarEventId.trim();
      if (fromPreload != null && fromPreload.isNotEmpty) {
        preferredId = fromPreload;
      }
    }

    final result = await _repository.getClassDetail(_classId);

    switch (result) {
      case ApiSuccess(:final data):
        final picked = ClassSlotViewModel.pickUpcomingEvent(data, preferredId);
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
}
