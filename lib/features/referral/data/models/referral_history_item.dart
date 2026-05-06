class ReferralHistoryItem {
  const ReferralHistoryItem({
    required this.referredCustomerId,
    required this.status,
    required this.rewardEarned,
    required this.qualifiedAt,
    required this.date,
  });

  final int referredCustomerId;
  final String status;
  final bool rewardEarned;
  final String? qualifiedAt;
  final String date;

  factory ReferralHistoryItem.fromJson(Map<String, dynamic> json) {
    final idRaw = json['referredCustomerId'];
    final id = idRaw is int
        ? idRaw
        : int.tryParse(idRaw?.toString() ?? '') ?? 0;

    final statusRaw = json['status'];
    final status = statusRaw?.toString() ?? '';

    final rewardRaw = json['rewardEarned'];
    final rewardEarned =
        rewardRaw == true ||
        rewardRaw == 1 ||
        rewardRaw?.toString().toLowerCase() == 'true';

    final qualified = json['qualifiedAt'];
    final qualifiedAt = qualified == null
        ? null
        : qualified.toString().trim().isEmpty
        ? null
        : qualified.toString();

    final dateRaw = json['date'];
    final date = dateRaw?.toString() ?? '';

    return ReferralHistoryItem(
      referredCustomerId: id,
      status: status,
      rewardEarned: rewardEarned,
      qualifiedAt: qualifiedAt,
      date: date,
    );
  }

  /// Line-separated values as returned / recorded by the API (no extra formatting).
  String get apiSubtitleLines {
    final lines = <String>[status];
    if (date.isNotEmpty) {
      lines.add(date);
    }
    final q = qualifiedAt;
    if (q != null && q.isNotEmpty) {
      lines.add(q);
    }
    return lines.join('\n');
  }
}
