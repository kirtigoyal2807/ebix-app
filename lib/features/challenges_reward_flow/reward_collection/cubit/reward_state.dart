import 'package:equatable/equatable.dart';
import 'package:pilates_app/features/loyalty/data/models/loyalty_points_history_entry.dart';
import 'package:pilates_app/features/loyalty/data/models/loyalty_reward.dart';

import '../model/branch_model.dart';

enum RewardListLoadStatus { initial, loading, loaded, failure }

class RewardState extends Equatable {
  const RewardState({
    required this.rewardFilterList,
    this.selectedRewardFilter = RewardFilter.all,
    required this.branchList,
    this.selectedBranch = 0,
    required this.rewardsLoadStatus,
    required this.rewards,
    required this.rewardsError,
    required this.historyLoadStatus,
    required this.pointsHistory,
    required this.pointsHistoryError,
  });

  final List<RewardFilter> rewardFilterList;
  final RewardFilter selectedRewardFilter;
  final List<BranchModel> branchList;
  final int selectedBranch;

  final RewardListLoadStatus rewardsLoadStatus;
  final List<LoyaltyReward> rewards;
  final String rewardsError;

  final RewardListLoadStatus historyLoadStatus;
  final List<LoyaltyPointsHistoryEntry> pointsHistory;
  final String pointsHistoryError;

  factory RewardState.initial() {
    return RewardState(
      rewardFilterList: RewardFilter.values,
      branchList: [const BranchModel(id: 0, title: '', rewardsCount: 0)],
      rewardsLoadStatus: RewardListLoadStatus.initial,
      rewards: const [],
      rewardsError: '',
      historyLoadStatus: RewardListLoadStatus.initial,
      pointsHistory: const [],
      pointsHistoryError: '',
    );
  }

  List<LoyaltyReward> get filteredRewards {
    return rewards.where(_matchesFilter).toList();
  }

  bool _matchesFilter(LoyaltyReward r) {
    switch (selectedRewardFilter) {
      case RewardFilter.all:
        return true;
      case RewardFilter.classes:
        return r.rewardType == 'free_class';
      case RewardFilter.discounts:
        return r.rewardType == 'discount';
      case RewardFilter.experiences:
        return r.rewardType == 'merchandise';
    }
  }

  RewardState copyWith({
    List<RewardFilter>? rewardFilterList,
    RewardFilter? selectedRewardFilter,
    List<BranchModel>? branchList,
    int? selectedBranch,
    RewardListLoadStatus? rewardsLoadStatus,
    List<LoyaltyReward>? rewards,
    String? rewardsError,
    RewardListLoadStatus? historyLoadStatus,
    List<LoyaltyPointsHistoryEntry>? pointsHistory,
    String? pointsHistoryError,
  }) {
    return RewardState(
      rewardFilterList: rewardFilterList ?? this.rewardFilterList,
      selectedRewardFilter: selectedRewardFilter ?? this.selectedRewardFilter,
      branchList: branchList ?? this.branchList,
      selectedBranch: selectedBranch ?? this.selectedBranch,
      rewardsLoadStatus: rewardsLoadStatus ?? this.rewardsLoadStatus,
      rewards: rewards ?? this.rewards,
      rewardsError: rewardsError ?? this.rewardsError,
      historyLoadStatus: historyLoadStatus ?? this.historyLoadStatus,
      pointsHistory: pointsHistory ?? this.pointsHistory,
      pointsHistoryError: pointsHistoryError ?? this.pointsHistoryError,
    );
  }

  @override
  List<Object?> get props => [
    rewardFilterList,
    selectedRewardFilter,
    branchList,
    selectedBranch,
    rewardsLoadStatus,
    rewards,
    rewardsError,
    historyLoadStatus,
    pointsHistory,
    pointsHistoryError,
  ];
}

enum RewardFilter { all, experiences, classes, discounts }
