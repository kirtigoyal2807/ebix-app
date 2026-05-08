import 'package:bloc/bloc.dart';
import 'package:pilates_app/core/network/api_result.dart';
import 'package:pilates_app/features/loyalty/data/loyalty_repository.dart';

import 'reward_state.dart';

class RewardCubit extends Cubit<RewardState> {
  RewardCubit(this._loyaltyRepository) : super(RewardState.initial());

  final LoyaltyRepository _loyaltyRepository;

  Future<void> loadRewards() async {
    emit(
      state.copyWith(
        rewardsLoadStatus: RewardListLoadStatus.loading,
        rewardsError: '',
      ),
    );
    final result = await _loyaltyRepository.getRewards();
    switch (result) {
      case ApiSuccess(:final data):
        emit(
          state.copyWith(
            rewardsLoadStatus: RewardListLoadStatus.loaded,
            rewards: data,
          ),
        );
      case ApiFailure(:final exception):
        emit(
          state.copyWith(
            rewardsLoadStatus: RewardListLoadStatus.failure,
            rewardsError: exception.message ?? '',
          ),
        );
    }
  }

  Future<void> loadPointsHistory() async {
    emit(
      state.copyWith(
        historyLoadStatus: RewardListLoadStatus.loading,
        pointsHistoryError: '',
      ),
    );
    final result = await _loyaltyRepository.getPointsHistory();
    switch (result) {
      case ApiSuccess(:final data):
        emit(
          state.copyWith(
            historyLoadStatus: RewardListLoadStatus.loaded,
            pointsHistory: data,
          ),
        );
      case ApiFailure(:final exception):
        emit(
          state.copyWith(
            historyLoadStatus: RewardListLoadStatus.failure,
            pointsHistoryError: exception.message ?? '',
          ),
        );
    }
  }

  void setSelectedFilterType(RewardFilter type) {
    emit(state.copyWith(selectedRewardFilter: type));
  }

  void setSelectedBranch(int branchId) {
    emit(state.copyWith(selectedBranch: branchId));
  }
}
