import 'package:equatable/equatable.dart';
import 'package:pilates_app/features/loyalty/data/models/loyalty_challenge_detail.dart';

enum ChallengeDetailLoadStatus { initial, loading, loaded, failure }

class ChallengeDetailState extends Equatable {
  const ChallengeDetailState({
    required this.status,
    this.detail,
    required this.errorMessage,
  });

  final ChallengeDetailLoadStatus status;
  final LoyaltyChallengeDetail? detail;
  final String errorMessage;

  factory ChallengeDetailState.initial() => const ChallengeDetailState(
        status: ChallengeDetailLoadStatus.initial,
        detail: null,
        errorMessage: '',
      );

  ChallengeDetailState copyWith({
    ChallengeDetailLoadStatus? status,
    LoyaltyChallengeDetail? detail,
    String? errorMessage,
  }) {
    return ChallengeDetailState(
      status: status ?? this.status,
      detail: detail ?? this.detail,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, detail, errorMessage];
}
