import 'package:equatable/equatable.dart';
import 'package:pilates_app/features/loyalty/data/models/loyalty_challenge.dart';

enum ChallengesLoadStatus { initial, loading, loaded, failure }

class ChallengesState extends Equatable {
  const ChallengesState({
    required this.status,
    required this.challenges,
    required this.errorMessage,
  });

  final ChallengesLoadStatus status;
  final List<LoyaltyChallenge> challenges;
  final String errorMessage;

  factory ChallengesState.initial() => const ChallengesState(
        status: ChallengesLoadStatus.initial,
        challenges: [],
        errorMessage: '',
      );

  List<LoyaltyChallenge> get activeChallenges =>
      challenges.where((c) => c.isJoined && !c.isCompleted).toList();

  List<LoyaltyChallenge> get newChallenges =>
      challenges.where((c) => !c.isJoined).toList();

  ChallengesState copyWith({
    ChallengesLoadStatus? status,
    List<LoyaltyChallenge>? challenges,
    String? errorMessage,
  }) {
    return ChallengesState(
      status: status ?? this.status,
      challenges: challenges ?? this.challenges,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, challenges, errorMessage];
}
