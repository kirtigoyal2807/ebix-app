/// One day in `GET /progress/weekly-activity` `data.week[]`.
class WeeklyActivityDay {
  const WeeklyActivityDay({
    required this.date,
    required this.minutes,
    required this.sessions,
  });

  /// Calendar date `YYYY-MM-DD`.
  final String date;
  final int minutes;
  final int sessions;

  factory WeeklyActivityDay.fromJson(Map<String, dynamic> json) {
    return WeeklyActivityDay(
      date: '${json['date'] ?? ''}',
      minutes: _int(json['minutes']),
      sessions: _int(json['sessions']),
    );
  }

  static int _int(dynamic v) {
    if (v is int) return v;
    if (v is num) return v.toInt();
    return int.tryParse('$v') ?? 0;
  }
}

/// Inner `data` from `GET /progress/weekly-activity`.
class WeeklyActivityResult {
  const WeeklyActivityResult({required this.week});

  final List<WeeklyActivityDay> week;

  factory WeeklyActivityResult.fromJson(Map<String, dynamic> json) {
    final raw = json['week'];
    final list = <WeeklyActivityDay>[];
    if (raw is List<dynamic>) {
      for (final e in raw) {
        if (e is Map<String, dynamic>) {
          list.add(WeeklyActivityDay.fromJson(e));
        } else if (e is Map) {
          list.add(WeeklyActivityDay.fromJson(Map<String, dynamic>.from(e)));
        }
      }
    }
    return WeeklyActivityResult(week: list);
  }

  int get totalMinutes => week.fold<int>(0, (s, d) => s + d.minutes);

  int get totalSessions => week.fold<int>(0, (s, d) => s + d.sessions);
}
