import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../model/badge_model.dart';

class BadgeState extends Equatable {
  final List<BadgeType> badgeList;
  final BadgeType selectedBadge;
  final List<BadgeModel> badgeDataList;

  const BadgeState({
    required this.badgeList,
    this.selectedBadge = BadgeType.all,
    required this.badgeDataList,
  });

  BadgeState copyWith({List<BadgeType>? badgeList, BadgeType? selectedBadge}) {
    return BadgeState(
      badgeList: badgeList ?? this.badgeList,
      selectedBadge: selectedBadge ?? this.selectedBadge,
      badgeDataList: badgeDataList,
    );
  }

  @override
  List<Object> get props => [badgeList, selectedBadge, badgeDataList];
}

enum BadgeType { all, bronze, silver, gold }

