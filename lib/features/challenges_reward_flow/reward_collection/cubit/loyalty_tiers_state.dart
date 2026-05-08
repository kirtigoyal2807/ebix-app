import 'package:equatable/equatable.dart';
import 'package:pilates_app/features/loyalty/data/models/loyalty_tier.dart';

enum LoyaltyTiersLoadStatus { initial, loading, loaded, failure }

class LoyaltyTiersState extends Equatable {
  const LoyaltyTiersState({
    required this.status,
    required this.tiers,
    required this.errorMessage,
  });

  final LoyaltyTiersLoadStatus status;
  final List<LoyaltyTier> tiers;
  final String errorMessage;

  factory LoyaltyTiersState.initial() => const LoyaltyTiersState(
    status: LoyaltyTiersLoadStatus.initial,
    tiers: [],
    errorMessage: '',
  );

  LoyaltyTiersState copyWith({
    LoyaltyTiersLoadStatus? status,
    List<LoyaltyTier>? tiers,
    String? errorMessage,
  }) {
    return LoyaltyTiersState(
      status: status ?? this.status,
      tiers: tiers ?? this.tiers,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, tiers, errorMessage];
}
