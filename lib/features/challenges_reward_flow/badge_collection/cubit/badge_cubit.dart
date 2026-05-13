import 'package:bloc/bloc.dart';

import 'package:pilates_app/core/network/api_result.dart';
import 'package:pilates_app/features/loyalty/data/loyalty_repository.dart';

import 'badge_state.dart';

class BadgeCubit extends Cubit<BadgeState> {
  BadgeCubit(this._repository) : super(const BadgeState());

  final LoyaltyRepository _repository;

  Future<void> load() async {
    emit(
      state.copyWith(
        status: BadgeCollectionStatus.loading,
        clearErrorMessage: true,
      ),
    );

    /// Achievements payload (`loyalty/achievements`) returns every badge with correct
    /// earned vs locked flags for the member. `loyalty/badges` can be incomplete for
    /// new accounts (e.g. only rows they’ve progressed), so collection uses achievements.
    final result = await _repository.getAchievements();

    switch (result) {
      case ApiSuccess(:final data):
        emit(
          BadgeState(
            status: BadgeCollectionStatus.success,
            badges: data.badges,
            selectedBadgeTypeKey: state.selectedBadgeTypeKey,
          ),
        );
      case ApiFailure(:final exception):
        emit(
          state.copyWith(
            status: BadgeCollectionStatus.failure,
            errorMessage: exception.message,
          ),
        );
    }
  }

  Future<void> refresh() async => load();

  void setBadgeTypeFilter(String? badgeTypeKey) {
    if (badgeTypeKey == null) {
      emit(state.copyWith(clearBadgeTypeFilter: true));
    } else {
      emit(state.copyWith(selectedBadgeTypeKey: badgeTypeKey));
    }
  }
}
