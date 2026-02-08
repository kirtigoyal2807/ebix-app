import 'package:flutter_bloc/flutter_bloc.dart';
import 'booking_state.dart';
import 'confirm_booking_state.dart';

class ConfirmBookingCubit extends Cubit<ConfirmBookingState> {
  ConfirmBookingCubit() : super(const ConfirmBookingState());

  void setAgree() {
    emit(state.copyWith(agreePolicy: !state.agreePolicy));
  }
}
