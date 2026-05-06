import 'package:bloc/bloc.dart';
import 'package:pilates_app/core/network/api_result.dart';
import 'package:pilates_app/features/loyalty/data/loyalty_repository.dart';

import 'challenges_state.dart';

class ChallengesCubit extends Cubit<ChallengesState> {
  ChallengesCubit(this._loyaltyRepository) : super(ChallengesState.initial());

  final LoyaltyRepository _loyaltyRepository;

  Future<void> load() async {
    emit(
      state.copyWith(status: ChallengesLoadStatus.loading, errorMessage: ''),
    );
    final result = await _loyaltyRepository.getChallenges();
    switch (result) {
      case ApiSuccess(:final data):
        emit(
          state.copyWith(status: ChallengesLoadStatus.loaded, challenges: data),
        );
      case ApiFailure(:final exception):
        emit(
          state.copyWith(
            status: ChallengesLoadStatus.failure,
            errorMessage: exception.message ?? '',
          ),
        );
    }
  }

  /// Returns `null` on success, or an error message on failure.
  Future<String?> joinChallenge(int id) async {
    final result = await _loyaltyRepository.joinChallenge(id);
    switch (result) {
      case ApiSuccess():
        await load();
        return null;
      case ApiFailure(:final exception):
        return exception.message ?? '';
    }
  }
}
