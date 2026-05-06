import 'package:bloc/bloc.dart';
import 'package:pilates_app/core/network/api_result.dart';
import 'package:pilates_app/features/loyalty/data/loyalty_repository.dart';

import 'loyalty_tiers_state.dart';

class LoyaltyTiersCubit extends Cubit<LoyaltyTiersState> {
  LoyaltyTiersCubit(this._repository) : super(LoyaltyTiersState.initial());

  final LoyaltyRepository _repository;

  Future<void> load() async {
    emit(
      state.copyWith(status: LoyaltyTiersLoadStatus.loading, errorMessage: ''),
    );
    final result = await _repository.getTiers();
    switch (result) {
      case ApiSuccess(:final data):
        final sorted = [...data]
          ..sort((a, b) => a.sortOrder.compareTo(b.sortOrder));
        emit(
          state.copyWith(status: LoyaltyTiersLoadStatus.loaded, tiers: sorted),
        );
      case ApiFailure(:final exception):
        emit(
          state.copyWith(
            status: LoyaltyTiersLoadStatus.failure,
            errorMessage: exception.message ?? '',
          ),
        );
    }
  }
}
