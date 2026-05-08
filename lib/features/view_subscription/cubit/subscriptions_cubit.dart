import 'package:bloc/bloc.dart';
import 'package:pilates_app/core/network/api_result.dart';
import 'package:pilates_app/features/auth/cubit/auth_cubit.dart';
import 'package:pilates_app/features/invoice_history/data/models/customer_subscription_resource.dart';
import 'package:pilates_app/features/invoice_history/data/subscriptions_repository.dart';

import 'subscriptions_state.dart';

/// Loads §9.3 subscription list — tries `/subscriptions/customer/{id}` when profile id exists,
/// falls back to `/subscriptions/me` on 404.
class SubscriptionsCubit extends Cubit<SubscriptionsState> {
  SubscriptionsCubit(this._repository, this._authCubit)
    : super(const SubscriptionsState());

  final SubscriptionsRepository _repository;
  final AuthCubit _authCubit;

  Future<void> load() async {
    emit(
      state.copyWith(
        status: SubscriptionsLoadStatus.loading,
        clearErrorMessage: true,
      ),
    );

    final userId = _authCubit.state.user?.id?.trim();

    ApiResult<List<CustomerSubscriptionResource>> result;
    if (userId != null && userId.isNotEmpty) {
      result = await _repository.listSubscriptionsForCustomer(userId);
      if (result.isFailure) {
        final code = result.exceptionOrNull?.statusCode;
        if (code == 404) {
          result = await _repository.listMySubscriptions();
        }
      }
    } else {
      result = await _repository.listMySubscriptions();
    }

    final data = result.dataOrNull;
    if (data != null) {
      emit(
        state.copyWith(
          status: SubscriptionsLoadStatus.success,
          clearErrorMessage: true,
          subscriptions: data,
        ),
      );
      return;
    }

    final raw = result.exceptionOrNull?.message?.trim();
    emit(
      state.copyWith(
        status: SubscriptionsLoadStatus.failure,
        errorMessage: (raw != null && raw.isNotEmpty) ? raw : null,
      ),
    );
  }
}
