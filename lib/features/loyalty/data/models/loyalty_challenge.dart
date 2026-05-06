/// Row from `GET /loyalty/challenges` or nested `challenge` in
/// `GET /loyalty/challenges/{id}` `data`.
class LoyaltyChallenge {
  const LoyaltyChallenge({
    required this.id,
    required this.name,
    required this.description,
    required this.challengeType,
    required this.scopeType,
    required this.startAt,
    required this.endAt,
    required this.targetValue,
    required this.progressValue,
    required this.rewardType,
    required this.rewardValue,
    required this.leaderboardEnabled,
    required this.isJoined,
    required this.isCompleted,
    this.joinedAt,
  });

  final int id;
  final String name;
  final String description;
  final String challengeType;
  final String scopeType;
  final String startAt;
  final String endAt;
  final int targetValue;
  final int progressValue;
  final String rewardType;
  final int rewardValue;
  final bool leaderboardEnabled;
  final bool isJoined;
  final bool isCompleted;
  final String? joinedAt;

  factory LoyaltyChallenge.fromJson(Map<String, dynamic> json) {
    return LoyaltyChallenge(
      id: (json['id'] as num).toInt(),
      name: json['name']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      challengeType: json['challengeType']?.toString() ?? '',
      scopeType: json['scopeType']?.toString() ?? '',
      startAt: json['startAt']?.toString() ?? '',
      endAt: json['endAt']?.toString() ?? '',
      targetValue: (json['targetValue'] as num?)?.toInt() ?? 0,
      progressValue: (json['progressValue'] as num?)?.toInt() ?? 0,
      rewardType: json['rewardType']?.toString() ?? '',
      rewardValue: (json['rewardValue'] as num?)?.toInt() ?? 0,
      leaderboardEnabled: json['leaderboardEnabled'] == true,
      isJoined: json['isJoined'] == true,
      isCompleted: json['isCompleted'] == true,
      joinedAt: json['joinedAt']?.toString(),
    );
  }
}
