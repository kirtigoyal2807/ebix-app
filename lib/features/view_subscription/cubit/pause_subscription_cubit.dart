import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pilates_app/core/network/network_exception.dart';
import 'package:pilates_app/features/invoice_history/data/subscriptions_repository.dart';
import 'package:pilates_app/features/view_subscription/cubit/pause_subscription_state.dart';

class PauseSubscriptionCubit extends Cubit<PauseSubscriptionState> {
  PauseSubscriptionCubit({
    required this.subscriptionId,
    required SubscriptionsRepository repository,
    DateTime? initialStart,
    DateTime? initialEnd,
  })  : _repo = repository,
        super(
          PauseSubscriptionState(
            startDate: initialStart ?? DateTime.now(),
            endDate: initialEnd ?? DateTime.now().add(const Duration(days: 7)),
          ),
        );

  final String subscriptionId;
  final SubscriptionsRepository _repo;

  void setStartDate(DateTime dateTime) {
    emit(state.copyWith(startDate: dateTime, clearSubmitError: true));
  }

  void setEndDate(DateTime dateTime) {
    emit(state.copyWith(endDate: dateTime, clearSubmitError: true));
  }

  /// §9.1 — start freeze with optional window (calendar dates sent as `yyyy-MM-dd`).
  Future<bool> confirmFreeze() async {
    emit(state.copyWith(isSubmitting: true, clearSubmitError: true));
    final result = await _repo.startFreeze(
      subscriptionId,
      startDate: state.startDate,
      endDate: state.endDate,
    );
    return result.when(
      success: (_, __) {
        emit(state.copyWith(isSubmitting: false));
        return true;
      },
      failure: (NetworkException e) {
        emit(
          state.copyWith(
            isSubmitting: false,
            submitError: e.message,
          ),
        );
        return false;
      },
    );
  }
}
