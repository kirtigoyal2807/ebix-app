import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:pilates_app/core/network/api_result.dart';
import 'package:pilates_app/features/booking/constants/class_checkout_payment_provider.dart';
import 'package:pilates_app/features/booking/data/classes_repository.dart';

import 'confirm_booking_state.dart';
import 'confirm_booking_submit_result.dart';

class ConfirmBookingCubit extends Cubit<ConfirmBookingState> {
  ConfirmBookingCubit(
    this._repository, {
    required this.calendarEventId,
    required this.usePlanSessionBooking,
    required this.allowSinglePurchaseCheckout,
  }) : super(const ConfirmBookingState());

  final ClassesRepository _repository;
  final String calendarEventId;

  /// `true` when the member books against a package session (§13.6).
  final bool usePlanSessionBooking;

  /// `true` when §13.7 single-session purchase may be offered.
  final bool allowSinglePurchaseCheckout;

  void setAgree() {
    emit(state.copyWith(agreePolicy: !state.agreePolicy));
  }

  /// Package booking when [usePlanSessionBooking], otherwise hosted single-session
  /// purchase when [allowSinglePurchaseCheckout].
  Future<ConfirmBookingSubmitResult> submit() async {
    if (!state.agreePolicy) {
      return const ConfirmBookingSubmitResult();
    }
    emit(state.copyWith(isSubmitting: true, errorMessage: null));

    if (usePlanSessionBooking) {
      final result = await _repository.bookWithPlan(calendarEventId);
      switch (result) {
        case ApiSuccess(:final data):
          emit(state.copyWith(isSubmitting: false, errorMessage: null));
          return ConfirmBookingSubmitResult(confirmedBooking: data);
        case ApiFailure(:final exception):
          emit(
            state.copyWith(
              isSubmitting: false,
              errorMessage: exception.message,
            ),
          );
          return ConfirmBookingSubmitResult(
            errorMessage: exception.message,
          );
      }
    }

    if (!allowSinglePurchaseCheckout) {
      emit(state.copyWith(isSubmitting: false));
      return const ConfirmBookingSubmitResult(
        errorMessage: '_no_checkout_option',
      );
    }

    final purchase = await _repository.purchaseSingleSession(
      calendarEventId,
      kClassSingleSessionPaymentProvider,
    );
    switch (purchase) {
      case ApiSuccess(:final data):
        final url = data.paymentUrl?.trim() ?? '';
        if (url.isEmpty) {
          emit(
            state.copyWith(
              isSubmitting: false,
              errorMessage: null,
            ),
          );
          return const ConfirmBookingSubmitResult(
            errorMessage: '_missing_payment_link',
          );
        }
        emit(state.copyWith(isSubmitting: false, errorMessage: null));
        return ConfirmBookingSubmitResult(pendingHostedPayment: data);
      case ApiFailure(:final exception):
        emit(
          state.copyWith(
            isSubmitting: false,
            errorMessage: exception.message,
          ),
        );
        return ConfirmBookingSubmitResult(
          errorMessage: exception.message,
        );
    }
  }
}
