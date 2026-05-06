import 'package:bloc/bloc.dart';
import 'package:pilates_app/core/network/api_result.dart';
import 'package:pilates_app/features/loyalty/data/loyalty_repository.dart';

import 'challenge_detail_state.dart';

class ChallengeDetailCubit extends Cubit<ChallengeDetailState> {
  ChallengeDetailCubit(this._loyaltyRepository, this.challengeId)
    : super(ChallengeDetailState.initial());

  final LoyaltyRepository _loyaltyRepository;
  final int challengeId;

  Future<void> load() async {
    emit(
      state.copyWith(
        status: ChallengeDetailLoadStatus.loading,
        errorMessage: '',
      ),
    );
    final result = await _loyaltyRepository.getChallengeDetail(challengeId);
    switch (result) {
      case ApiSuccess(:final data):
        emit(
          state.copyWith(
            status: ChallengeDetailLoadStatus.loaded,
            detail: data,
          ),
        );
      case ApiFailure(:final exception):
        emit(
          state.copyWith(
            status: ChallengeDetailLoadStatus.failure,
            errorMessage: exception.message ?? '',
          ),
        );
    }
  }
}
