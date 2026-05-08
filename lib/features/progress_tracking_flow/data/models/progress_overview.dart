/// Response `data` from `GET /progress/overview`.
class ProgressOverview {
  const ProgressOverview({
    required this.goal,
    required this.mtdAttendedClasses,
    required this.mtdAttendedMinutes,
    required this.goalPercent,
    required this.currentStreak,
    required this.longestStreak,
    required this.attendanceRate,
    this.mtdMorningSessions = 0,
    this.flowInstructors = 0,
    this.innerPeacePercent = 0,
    this.favoriteTrainer,
    this.favoriteBranch,
  });

  final int goal;
  final int mtdAttendedClasses;
  final int mtdAttendedMinutes;
  final double goalPercent;
  final int currentStreak;
  final int longestStreak;
  final double attendanceRate;

  /// Month-to-date morning session count from overview API.
  final int mtdMorningSessions;

  /// Distinct flow instructors engaged with this month.
  final int flowInstructors;

  /// Inner peace score as a percentage (0–100 scale from API).
  final double innerPeacePercent;
  final String? favoriteTrainer;
  final String? favoriteBranch;

  factory ProgressOverview.fromJson(Map<String, dynamic> json) {
    return ProgressOverview(
      goal: _int(json['goal']),
      mtdAttendedClasses: _int(json['mtdAttendedClasses']),
      mtdAttendedMinutes: _int(json['mtdAttendedMinutes']),
      goalPercent: _double(json['goalPercent']),
      currentStreak: _int(json['currentStreak']),
      longestStreak: _int(json['longestStreak']),
      attendanceRate: _double(json['attendanceRate']),
      mtdMorningSessions: _int(json['mtdMorningSessions']),
      flowInstructors: _int(json['flowInstructors']),
      innerPeacePercent: _double(json['innerPeacePercent']),
      favoriteTrainer: json['favoriteTrainer'] as String?,
      favoriteBranch: json['favoriteBranch'] as String?,
    );
  }

  static int _int(dynamic v) {
    if (v is int) return v;
    if (v is num) return v.toInt();
    return int.tryParse('$v') ?? 0;
  }

  static double _double(dynamic v) {
    if (v is double) return v;
    if (v is int) return v.toDouble();
    if (v is num) return v.toDouble();
    return double.tryParse('$v') ?? 0;
  }
}
