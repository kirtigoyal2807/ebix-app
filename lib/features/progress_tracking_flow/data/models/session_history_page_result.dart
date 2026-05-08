import 'progress_session_history_item.dart';

/// Inner `data` object from `GET /progress/session-history` (list + pagination).
class SessionHistoryPageResult {
  const SessionHistoryPageResult({
    required this.items,
    required this.currentPage,
    required this.lastPage,
    required this.perPage,
    required this.total,
  });

  final List<ProgressSessionHistoryItem> items;
  final int currentPage;
  final int lastPage;
  final int perPage;
  final int total;

  factory SessionHistoryPageResult.fromJson(Map<String, dynamic> json) {
    final rawList = json['data'];
    final list = <ProgressSessionHistoryItem>[];
    if (rawList is List<dynamic>) {
      for (final e in rawList) {
        if (e is Map<String, dynamic>) {
          list.add(ProgressSessionHistoryItem.fromJson(e));
        } else if (e is Map) {
          list.add(
            ProgressSessionHistoryItem.fromJson(Map<String, dynamic>.from(e)),
          );
        }
      }
    }
    return SessionHistoryPageResult(
      items: list,
      currentPage: _int(json['currentPage'], 1),
      lastPage: _int(json['lastPage'], 1),
      perPage: _int(json['perPage'], 20),
      total: _int(json['total'], 0),
    );
  }

  static int _int(dynamic v, int fallback) {
    if (v is int) return v;
    if (v is num) return v.toInt();
    return int.tryParse('$v') ?? fallback;
  }
}
