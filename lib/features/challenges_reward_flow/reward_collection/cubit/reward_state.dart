import 'package:equatable/equatable.dart';

import '../model/branch_model.dart';

class RewardState extends Equatable {
  final List<RewardFilter> rewardFilterList;
  final RewardFilter selectedRewardFilter;
  final List<BranchModel> branchList;
  final int selectedBranch;

  RewardState({
    required this.rewardFilterList,
    this.selectedRewardFilter = RewardFilter.all,
    required this.branchList,
    this.selectedBranch = 0,
  });

  RewardState copyWith({
    List<RewardFilter>? rewardFilterList,
    RewardFilter? selectedRewardFilter,
    List<BranchModel>? branchList,
    int? selectedBranch,
  }) {
    return RewardState(
      rewardFilterList: rewardFilterList ?? this.rewardFilterList,
      selectedRewardFilter: selectedRewardFilter ?? this.selectedRewardFilter,
      branchList: branchList ?? this.branchList,
      selectedBranch: selectedBranch ?? this.selectedBranch,
    );
  }

  @override
  List<Object> get props => [
        rewardFilterList,
        selectedRewardFilter,
        branchList,
        selectedBranch,
      ];
}

enum RewardFilter { all, experiences, classes, discounts }
