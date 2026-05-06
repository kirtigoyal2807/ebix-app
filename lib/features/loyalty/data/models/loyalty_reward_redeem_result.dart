/// `data` from `POST /loyalty/rewards/{id}/redeem`.
class LoyaltyRewardRedeemResult {
  const LoyaltyRewardRedeemResult({
    required this.redemptionId,
    required this.status,
    required this.redemptionCode,
    required this.pointsSpent,
    required this.remainingPoints,
  });

  final String redemptionId;
  final String status;
  final String redemptionCode;
  final int pointsSpent;
  final int remainingPoints;

  factory LoyaltyRewardRedeemResult.fromJson(Map<String, dynamic> json) {
    return LoyaltyRewardRedeemResult(
      redemptionId: json['redemptionId']?.toString() ?? '',
      status: json['status']?.toString() ?? '',
      redemptionCode: json['redemptionCode']?.toString() ?? '',
      pointsSpent: (json['pointsSpent'] as num?)?.toInt() ?? 0,
      remainingPoints: (json['remainingPoints'] as num?)?.toInt() ?? 0,
    );
  }
}
