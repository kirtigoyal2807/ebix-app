/// Row from `GET /loyalty/points-history` `data[]`.
class LoyaltyPointsHistoryEntry {
  const LoyaltyPointsHistoryEntry({
    required this.id,
    required this.entryType,
    required this.sourceType,
    required this.sourceId,
    required this.points,
    required this.balanceAfter,
    required this.description,
    this.expiresAt,
    this.processedAt,
    this.createdAt,
  });

  final String id;
  final String entryType;
  final String sourceType;
  final String sourceId;
  final int points;
  final int balanceAfter;
  final String description;
  final String? expiresAt;
  final String? processedAt;
  final String? createdAt;

  bool get isEarned => entryType.toLowerCase() == 'earned';

  factory LoyaltyPointsHistoryEntry.fromJson(Map<String, dynamic> json) {
    return LoyaltyPointsHistoryEntry(
      id: json['id']?.toString() ?? '',
      entryType: json['entryType']?.toString() ?? '',
      sourceType: json['sourceType']?.toString() ?? '',
      sourceId: json['sourceId']?.toString() ?? '',
      points: (json['points'] as num?)?.toInt() ?? 0,
      balanceAfter: (json['balanceAfter'] as num?)?.toInt() ?? 0,
      description: json['description']?.toString() ?? '',
      expiresAt: json['expiresAt']?.toString(),
      processedAt: json['processedAt']?.toString(),
      createdAt: json['createdAt']?.toString(),
    );
  }
}
