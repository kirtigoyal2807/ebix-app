/// One row from `GET /progress/session-history` inner `data` list.
class ProgressSessionHistoryItem {
  const ProgressSessionHistoryItem({
    required this.className,
    this.trainerName,
    this.branchName,
    required this.startTime,
    required this.endTime,
    required this.durationMinutes,
    required this.status,
  });

  final String className;
  final String? trainerName;
  final String? branchName;
  final DateTime startTime;
  final DateTime endTime;
  final int durationMinutes;
  final String status;

  factory ProgressSessionHistoryItem.fromJson(Map<String, dynamic> json) {
    return ProgressSessionHistoryItem(
      className: '${json['className'] ?? ''}',
      trainerName: json['trainerName'] as String?,
      branchName: json['branchName'] as String?,
      startTime: DateTime.tryParse('${json['startTime']}') ?? DateTime.fromMillisecondsSinceEpoch(0),
      endTime: DateTime.tryParse('${json['endTime']}') ?? DateTime.fromMillisecondsSinceEpoch(0),
      durationMinutes: _int(json['durationMinutes']),
      status: '${json['status'] ?? ''}',
    );
  }

  static int _int(dynamic v) {
    if (v is int) return v;
    if (v is num) return v.toInt();
    return int.tryParse('$v') ?? 0;
  }
}
