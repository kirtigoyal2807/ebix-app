part of 'subscription_cubit.dart';

enum SubscriptionStatus { initial, loading, success, error }

class SubscriptionState extends Equatable {
  final SubscriptionStatus status;
  final String selectedPlanId;
  final String selectedBranchId;
  final bool isGift;

  const SubscriptionState({
    this.status = SubscriptionStatus.initial,
    this.selectedPlanId = 'premium', // Default to premium as seen in screenshot "Most Popular"
    this.selectedBranchId = 'branchA',
    this.isGift = false,
  });

  SubscriptionState copyWith({
    SubscriptionStatus? status,
    String? selectedPlanId,
    String? selectedBranchId,
    bool? isGift,
  }) {
    return SubscriptionState(
      status: status ?? this.status,
      selectedPlanId: selectedPlanId ?? this.selectedPlanId,
      selectedBranchId: selectedBranchId ?? this.selectedBranchId,
      isGift: isGift ?? this.isGift,
    );
  }

  @override
  List<Object> get props => [status, selectedPlanId, selectedBranchId, isGift];
}
