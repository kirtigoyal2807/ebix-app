import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'subscription_state.dart';

class SubscriptionCubit extends Cubit<SubscriptionState> {
  SubscriptionCubit() : super(const SubscriptionState());

  void selectPlan(String planId) {
    emit(state.copyWith(selectedPlanId: planId));
  }

  void selectBranch(String branchId) {
    emit(state.copyWith(selectedBranchId: branchId));
  }

  void toggleGift(bool isGift) {
    emit(state.copyWith(isGift: isGift));
  }
}
