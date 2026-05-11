import 'package:bloc/bloc.dart';

import '../model/badge_model.dart';
import 'badge_state.dart';

class BadgeCubit extends Cubit<BadgeState> {
  BadgeCubit()
    : super(
        BadgeState(
          badgeList: BadgeType.values,
          badgeDataList: [
            BadgeModel(
              image: "assets/images/svg/challenges/ic_february_streak.svg",
              darkImage:
                  "assets/images/svg/challenges/ic_dark_february_streak.svg",
              badgeName: BadgeData.februaryStreak,
              status: BadgeStatus.earned,
            ),

            BadgeModel(
              image: "assets/images/svg/challenges/ic_studio_legend.svg",
              badgeName: BadgeData.studioLegend,
              status: BadgeStatus.earned,
              darkImage:
                  "assets/images/svg/challenges/ic_dark_studio_legend.svg",
            ),
            BadgeModel(
              image: "assets/images/svg/challenges/ic_first_step.svg",
              badgeName: BadgeData.firstStep,
              status: BadgeStatus.earned,
              darkImage: "assets/images/svg/challenges/ic_dark_first_step.svg",
            ),
            BadgeModel(
              image: "assets/images/svg/challenges/ic_early_bird.svg",
              badgeName: BadgeData.earlyBird,
              status: BadgeStatus.earned,
              darkImage: "assets/images/svg/challenges/ic_dark_early_bird.svg",
            ),
            BadgeModel(
              image: "assets/images/svg/challenges/ic_lotus_blossom.svg",
              badgeName: BadgeData.lotusBlossom,
              status: BadgeStatus.earned,
              darkImage:
                  "assets/images/svg/challenges/ic_dark_lotus_blossom.svg",
            ),
            BadgeModel(
              image: "assets/images/svg/challenges/ic_core_strength.svg",
              badgeName: BadgeData.coreStrength,
              status: BadgeStatus.earned,
              darkImage:
                  "assets/images/svg/challenges/ic_dark _2_core_strength.svg",
            ),
            BadgeModel(
              image: "assets/images/svg/challenges/ic_week_warrior.svg",
              badgeName: BadgeData.weekWarrior,
              status: BadgeStatus.locked,
              darkImage:
                  "assets/images/svg/challenges/ic_dark_week_warrior.svg",
            ),
            BadgeModel(
              image: "assets/images/svg/challenges/ic_balance_master.svg",
              badgeName: BadgeData.balanceMaster,
              status: BadgeStatus.locked,
              darkImage:
                  "assets/images/svg/challenges/ic_dark_balance_master.svg",
            ),
          ],
        ),
      );

  void setSelectedBadgeType(BadgeType type) {
    emit(state.copyWith(selectedBadge: type));
  }
}
