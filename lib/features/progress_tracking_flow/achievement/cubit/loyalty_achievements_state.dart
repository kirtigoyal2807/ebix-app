import 'package:equatable/equatable.dart';

import 'package:pilates_app/features/loyalty/data/models/loyalty_achievements_result.dart';

enum LoyaltyAchievementsStatus { initial, loading, success, failure }

class LoyaltyAchievementsState extends Equatable {
  const LoyaltyAchievementsState({
    this.status = LoyaltyAchievementsStatus.initial,
    this.data,
    this.errorMessage,
  });

  final LoyaltyAchievementsStatus status;
  final LoyaltyAchievementsResult? data;
  final String? errorMessage;

  static const Object _unset = Object();

  LoyaltyAchievementsState copyWith({
    LoyaltyAchievementsStatus? status,
    LoyaltyAchievementsResult? data,
    Object? errorMessage = _unset,
  }) {
    return LoyaltyAchievementsState(
      status: status ?? this.status,
      data: data ?? this.data,
      errorMessage: identical(errorMessage, _unset)
          ? this.errorMessage
          : errorMessage as String?,
    );
  }

  @override
  List<Object?> get props => [status, data, errorMessage];
}
