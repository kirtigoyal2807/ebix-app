import 'package:bloc/bloc.dart';

import 'reward_state.dart';

import '../model/branch_model.dart';

class RewardCubit extends Cubit<RewardState> {
  RewardCubit()
      : super(
          RewardState(
            rewardFilterList: RewardFilter.values,
            branchList: [
              BranchModel(
                id: 0,
                title: "Balad, Al Al Munawarah",
                subTitle: "5 rewards available",
              ),
              BranchModel(
                id: 1,
                title: "Prince Abdul Majeed Street, Al Hezam",
                subTitle: "4 rewards available",
              ),
              BranchModel(
                id: 2,
                title: "Balad, Al Al Munawarah",
                subTitle: "3 rewards available",
              ),
            ],
          ),
        );

  void setSelectedFilterType(RewardFilter type) {
    emit(state.copyWith(selectedRewardFilter: type));
  }

  void setSelectedBranch(int branchId) {
    emit(state.copyWith(selectedBranch: branchId));
  }
}
