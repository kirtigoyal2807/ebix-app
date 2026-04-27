import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pilates_app/core/network/api_result.dart';
import 'package:pilates_app/features/booking/cubit/class_detail_state.dart';
import 'package:pilates_app/features/booking/data/classes_repository.dart';
import 'package:pilates_app/features/booking/data/models/class_slot_view_model.dart';

/// Loads a single class event (§13.5 `GET /classes/events/{eventId}`).
/// Accepts an optional [preloadedSlot] from the list so the UI is instant while
/// the full detail fetch is in-flight.
class ClassDetailCubit extends Cubit<ClassDetailState> {
  ClassDetailCubit(
    this._repository, {
    ClassSlotViewModel? preloadedSlot,
  }) : super(
          ClassDetailState(
            status: preloadedSlot != null
                ? ClassDetailLoadStatus.loaded
                : ClassDetailLoadStatus.initial,
            slot: preloadedSlot,
          ),
        );

  final ClassesRepository _repository;

  /// Fetch full event detail from the server. Updates [slot] in-place so that
  /// if [preloadedSlot] was provided the screen was already interactive.
  Future<void> loadEventDetail(String calendarEventId) async {
    if (state.isLoading) return;

    emit(state.copyWith(status: ClassDetailLoadStatus.loading, errorMessage: null));

    final result = await _repository.getEventDetail(calendarEventId);

    switch (result) {
      case ApiSuccess(:final data):
        final resolved = ClassSlotViewModel.fromEventDetail(data);
        final mergedSlot = resolved.copyWith(
          recentReviews: resolved.recentReviews ?? state.slot?.recentReviews,
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
