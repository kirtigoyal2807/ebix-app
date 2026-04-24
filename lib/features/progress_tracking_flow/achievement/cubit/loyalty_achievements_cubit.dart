import 'package:bloc/bloc.dart';

import 'package:pilates_app/core/network/api_result.dart';

import 'package:pilates_app/features/loyalty/data/loyalty_repository.dart';
import 'loyalty_achievements_state.dart';

class LoyaltyAchievementsCubit extends Cubit<LoyaltyAchievementsState> {
  LoyaltyAchievementsCubit(this._repository)
    : super(const LoyaltyAchievementsState());

  final LoyaltyRepository _repository;

  /// Reload achievements (e.g. pull-to-refresh).
  Future<void> refresh() async => load();

  Future<void> load() async {
    emit(
      state.copyWith(
        status: LoyaltyAchievementsStatus.loading,
        errorMessage: null,
      ),
    );
    final result = await _repository.getAchievements();
    switch (result) {
      case ApiSuccess(:final data):
        emit(
          LoyaltyAchievementsState(
            status: LoyaltyAchievementsStatus.success,
            data: data,
          ),
        );
      case ApiFailure(:final exception):
        emit(
          LoyaltyAchievementsState(
            status: LoyaltyAchievementsStatus.failure,
            data: state.data,
            errorMessage: exception.message,
          ),
        );
    }
  }
}
