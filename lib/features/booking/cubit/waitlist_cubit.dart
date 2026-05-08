import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pilates_app/core/network/api_result.dart';
import 'package:pilates_app/features/booking/cubit/waitlist_state.dart';
import 'package:pilates_app/features/booking/data/classes_repository.dart';

/// §13.9 — `POST /classes/{calendarEventId}/waitlist`
class WaitlistCubit extends Cubit<WaitlistState> {
  WaitlistCubit(
    this._repository, {
    required this.calendarEventId,
    required this.waitlistCount,
  }) : super(const WaitlistState());

  final ClassesRepository _repository;
  final String calendarEventId;

  /// Number of people currently on the waitlist (from the class slot data).
  final int? waitlistCount;

  /// Returns `true` on success, `false` on failure.
  Future<bool> joinWaitlist() async {
    if (state.isSubmitting) return false;

    emit(state.copyWith(isSubmitting: true, errorMessage: null));

    final result = await _repository.joinWaitlist(calendarEventId);

    switch (result) {
      case ApiSuccess(:final data):
        emit(
          state.copyWith(
            isSubmitting: false,
            bookingResult: data,
            errorMessage: null,
          ),
        );
        return true;
      case ApiFailure(:final exception):
        emit(
          state.copyWith(isSubmitting: false, errorMessage: exception.message),
        );
        return false;
    }
  }
}
