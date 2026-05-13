import 'package:equatable/equatable.dart';

import 'package:pilates_app/features/loyalty/data/models/loyalty_badge.dart';

enum BadgeCollectionStatus { initial, loading, success, failure }

class BadgeState extends Equatable {
  const BadgeState({
    this.status = BadgeCollectionStatus.initial,
    this.badges = const [],
    this.selectedBadgeTypeKey,
    this.errorMessage,
  });

  final BadgeCollectionStatus status;
  final List<LoyaltyBadge> badges;

  /// `null` shows every badge; otherwise filters [badges] where `badgeType` matches (case-insensitive).
  final String? selectedBadgeTypeKey;

  final String? errorMessage;

  int get earnedCount => badges.where((b) => b.isEarned).length;

  int get totalCount => badges.length;

  int get lockedCount => totalCount - earnedCount;

  List<LoyaltyBadge> get filteredBadges {
    final key = selectedBadgeTypeKey;
    if (key == null || key.isEmpty) return badges;
    return badges
        .where((b) => b.badgeType.toLowerCase() == key.toLowerCase())
        .toList();
  }

  List<String> get distinctBadgeTypes {
    final types = badges
        .map((b) => b.badgeType.trim())
        .where((t) => t.isNotEmpty)
        .toSet()
        .toList()
      ..sort();
    return types;
  }

  BadgeState copyWith({
    BadgeCollectionStatus? status,
    List<LoyaltyBadge>? badges,
    String? selectedBadgeTypeKey,
    String? errorMessage,
    bool clearBadgeTypeFilter = false,
    bool clearErrorMessage = false,
  }) {
    return BadgeState(
      status: status ?? this.status,
      badges: badges ?? this.badges,
      selectedBadgeTypeKey: clearBadgeTypeFilter
          ? null
          : (selectedBadgeTypeKey ?? this.selectedBadgeTypeKey),
      errorMessage:
          clearErrorMessage ? null : (errorMessage ?? this.errorMessage),
    );
  }

  @override
  List<Object?> get props => [
        status,
        badges,
        selectedBadgeTypeKey,
        errorMessage,
      ];
}
