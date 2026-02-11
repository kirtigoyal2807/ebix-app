import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pilates_app/features/view_subscription/cubit/pause_subscription_state.dart';

class PauseSubscriptionCubit extends Cubit<PauseSubscriptionState> {
  PauseSubscriptionCubit()
    : super(
        PauseSubscriptionState(
          startDate: DateTime.now(),
          endDate: DateTime.now().add(const Duration(days: 7)),
        ),
      );

  void setStartDate(DateTime dateTime) {
    emit(state.copyWith(startDate: dateTime));
  }

  void setEndDate(DateTime dateTime) {
    emit(state.copyWith(endDate: dateTime));
  }
}
