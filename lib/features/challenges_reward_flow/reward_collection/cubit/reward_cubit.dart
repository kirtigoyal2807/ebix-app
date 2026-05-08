import 'package:bloc/bloc.dart';
import 'package:pilates_app/core/network/api_result.dart';
import 'package:pilates_app/features/auth/data/auth_repository.dart';
import 'package:pilates_app/features/loyalty/data/loyalty_repository.dart';

import '../model/branch_model.dart';
import 'reward_state.dart';

class RewardCubit extends Cubit<RewardState> {
  RewardCubit(this._loyaltyRepository, this._authRepository)
      : super(RewardState.initial());

  final LoyaltyRepository _loyaltyRepository;
  final AuthRepository _authRepository;

  Future<void> loadBranches() async {
    final result = await _authRepository.listBranches();
    switch (result) {
      case ApiSuccess(:final data):
        final branches = data.branches;
        final totalRewards = branches.fold<int>(
          0,
          (sum, b) => sum + b.rewardsCount,
        );
        emit(
          state.copyWith(
            branchList: [
              BranchModel(
                id: 0,
                title: '',
                rewardsCount: totalRewards,
              ),
              ...branches.map(BranchModel.fromBranch),
            ],
          ),
        );
      case ApiFailure():
        break;
    }
  }

  /// Branch id for `GET loyalty/rewards?branchId=` — `null` means all locations
  /// ([BranchModel.id] `<= 0` is treated as “all”).
  int? get _rewardsQueryBranchId {
    if (state.branchList.isEmpty) return null;
    final i = state.selectedBranch.clamp(0, state.branchList.length - 1);
    final id = state.branchList[i].id;
    if (id <= 0) return null;
    return id;
  }

  Future<void> loadRewards() async {
    emit(
      state.copyWith(
        rewardsLoadStatus: RewardListLoadStatus.loading,
        rewardsError: '',
      ),
    );
    final result = await _loyaltyRepository.getRewards(
      branchId: _rewardsQueryBranchId,
    );
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

  /// Updates the selected row in [RewardState.branchList] (by **index**), then
  /// reloads rewards for that branch when [branchList][n].id > 0.
  void selectBranchAtIndex(int index) {
    if (state.branchList.isEmpty) return;
    final i = index.clamp(0, state.branchList.length - 1);
    emit(state.copyWith(selectedBranch: i));
    loadRewards();
  }
}
