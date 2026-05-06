/// Row from `GET /loyalty/challenges/{id}` `data.leaderboard[]` or
/// `GET /loyalty/challenges/{id}/leaderboard` `data[]`.
class LoyaltyLeaderboardEntry {
  const LoyaltyLeaderboardEntry({
    this.rank,
    required this.customerId,
    this.customerName,
    required this.progressValue,
    this.completedAt,
  });

  final int? rank;
  final int customerId;
  final String? customerName;
  final int progressValue;
  final String? completedAt;

  factory LoyaltyLeaderboardEntry.fromJson(Map<String, dynamic> json) {
    return LoyaltyLeaderboardEntry(
      rank: (json['rank'] as num?)?.toInt(),
      customerId: (json['customerId'] as num?)?.toInt() ?? 0,
      customerName: json['customerName']?.toString(),
      progressValue: (json['progressValue'] as num?)?.toInt() ?? 0,
      completedAt: json['completedAt']?.toString(),
    );
  }
}
