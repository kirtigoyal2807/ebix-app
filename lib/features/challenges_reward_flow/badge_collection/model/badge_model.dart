class BadgeModel {
  final String image;
  final String darkImage;
  final BadgeData badgeName;
  final BadgeStatus status;

  BadgeModel({
    required this.image,
    required this.darkImage,
    required this.badgeName,
    required this.status,
  });
}

enum BadgeData {
  februaryStreak,
  studioLegend,
  firstStep,
  earlyBird,
  lotusBlossom,
  coreStrength,
  weekWarrior,
  balanceMaster,
}

enum BadgeStatus { earned, locked }
