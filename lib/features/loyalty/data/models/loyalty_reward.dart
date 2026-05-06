/// Row from `GET /loyalty/rewards` or `GET /loyalty/rewards/{id}` `data`.
class LoyaltyReward {
  const LoyaltyReward({
    required this.id,
    required this.name,
    required this.description,
    required this.pointsCost,
    required this.rewardType,
    this.rewardValue,
    this.imageUrl,
    required this.canRedeem,
    required this.sortOrder,
  });

  final int id;
  final String name;
  final String description;
  final int pointsCost;
  final String rewardType;
  final int? rewardValue;
  final String? imageUrl;
  final bool canRedeem;
  final int sortOrder;

  factory LoyaltyReward.fromJson(Map<String, dynamic> json) {
    return LoyaltyReward(
      id: (json['id'] as num).toInt(),
      name: json['name']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      pointsCost: (json['pointsCost'] as num?)?.toInt() ?? 0,
      rewardType: json['rewardType']?.toString() ?? '',
      rewardValue: (json['rewardValue'] as num?)?.toInt(),
      imageUrl: json['imageUrl']?.toString(),
      canRedeem: json['canRedeem'] == true,
      sortOrder: (json['sortOrder'] as num?)?.toInt() ?? 0,
    );
  }
}
