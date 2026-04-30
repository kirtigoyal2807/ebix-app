import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:pilates_app/core/network/api_result.dart';
import 'package:pilates_app/features/booking/data/classes_repository.dart';
import 'package:pilates_app/features/my_booking/data/models/booking_resource.dart';
import 'confirm_booking_state.dart';

class ConfirmBookingCubit extends Cubit<ConfirmBookingState> {
  ConfirmBookingCubit(
    this._repository, {
    required this.calendarEventId,
  }) : super(const ConfirmBookingState());

  final ClassesRepository _repository;
  final String calendarEventId;

  void setAgree() {
    emit(state.copyWith(agreePolicy: !state.agreePolicy));
  }

  /// `POST /classes/{calendarEventId}/book` — caller should only invoke when
  /// [agreePolicy] is true. Returns the [BookingResource] on success, or null.
  Future<BookingResource?> submitBooking() async {
    if (!state.agreePolicy) return null;
    emit(
      state.copyWith(
        isSubmitting: true,
        errorMessage: null,
      ),
    );
    final result = await _repository.bookWithPlan(calendarEventId);
    switch (result) {
      case ApiSuccess(:final data):
        emit(
          state.copyWith(
            isSubmitting: false,
            errorMessage: null,
          ),
        );
        return data;
      case ApiFailure(:final exception):
        emit(
          state.copyWith(
            isSubmitting: false,
            errorMessage: exception.message,
          ),
        );
        return null;
    }
  }
}
