import 'package:pilates_app/core/localization/arb/app_localizations.dart';

/// `data` from `GET /progress/goal` (15.4).
class ProgressGoalSettings {
  const ProgressGoalSettings({
    required this.monthlyGoal,
    this.experience,
    this.goal,
  });

  final int monthlyGoal;
  final String? experience;
  final String? goal;

  factory ProgressGoalSettings.fromJson(Map<String, dynamic> json) {
    return ProgressGoalSettings(
      monthlyGoal: _int(json['monthlyGoal']),
      experience: json['experience'] as String?,
      goal: json['goal'] as String?,
    );
  }

  static int _int(dynamic v) {
    if (v is int) return v;
    if (v is num) return v.toInt();
    return int.tryParse('$v') ?? 0;
  }

  /// Localized label for API `experience` (beginner / intermediate / advanced).
  static String experienceLabel(AppLocalizations l10n, String? experience) {
    final e = experience?.trim().toLowerCase() ?? '';
    switch (e) {
      case 'beginner':
        return l10n.experienceBeginner;
      case 'intermediate':
        return l10n.experienceIntermediate;
      case 'advanced':
        return l10n.experienceAdvanced;
      default:
        if (experience == null || experience.isEmpty) {
          return l10n.experienceIntermediate;
        }
        return experience;
    }
  }
}
