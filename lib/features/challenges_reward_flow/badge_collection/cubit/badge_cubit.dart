import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';

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
              badgeName: BadgeData.februaryStreak,
              status:BadgeStatus.earned
            ),

            BadgeModel(
              image: "assets/images/svg/challenges/ic_studio_legend.svg",
              badgeName: BadgeData.studioLegend,
              status:BadgeStatus.earned,
            ),
            BadgeModel(
              image: "assets/images/svg/challenges/ic_first_step.svg",
              badgeName: BadgeData.firstStep,
              status: BadgeStatus.earned,
            ),
            BadgeModel(
              image: "assets/images/svg/challenges/ic_early_bird.svg",
              badgeName: BadgeData.earlyBird,
              status: BadgeStatus.earned,
            ),
            BadgeModel(
              image: "assets/images/svg/challenges/ic_lotus_blossom.svg",
              badgeName: BadgeData.lotusBlossom,
              status:BadgeStatus.earned
            ),
            BadgeModel(
              image: "assets/images/svg/challenges/ic_core_strength.svg",
              badgeName: BadgeData.coreStrength,
              status: BadgeStatus.earned,
            ),
            BadgeModel(
              image: "assets/images/svg/challenges/ic_week_warrior.svg",
              badgeName: BadgeData.weekWarrior,
              status:BadgeStatus.locked,
            ),
            BadgeModel(
              image: "assets/images/svg/challenges/ic_balance_master.svg",
              badgeName: BadgeData.balanceMaster,
              status: BadgeStatus.locked,
            ),
          ],
        ),
      );

  void setSelectedBadgeType(BadgeType type) {
    emit(state.copyWith(selectedBadge: type));
  }
}
