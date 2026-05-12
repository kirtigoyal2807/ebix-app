import 'package:bloc/bloc.dart';

import 'badge_state.dart';

class BadgeCubit extends Cubit<BadgeState> {
  BadgeCubit()
    : super(
        BadgeState(
          badgeList: BadgeType.values,
          badgeDataList: const [],
        ),
      );

  void setSelectedBadgeType(BadgeType type) {
    emit(state.copyWith(selectedBadge: type));
  }
}
