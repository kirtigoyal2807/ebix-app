import 'package:pilates_app/core/localization/arb/app_localizations.dart';

/// Maps the edit-goal UI (focus cards + slider steps) to API fields.
class GoalFormMapping {
  GoalFormMapping._();

  static const List<int> monthlySteps = [4, 8, 12, 16, 20, 24];

  static String goalTitleForIndex(AppLocalizations l10n, int index) {
    switch (index.clamp(0, 3)) {
      case 0:
        return l10n.buildStrength;
      case 1:
        return l10n.findMindfulness;
      case 2:
        return l10n.improveFlexibility;
      default:
        return l10n.generalFitness;
    }
  }

  static int indexFromStoredGoal(String? stored, AppLocalizations l10n) {
    final g = stored?.trim().toLowerCase() ?? '';
    if (g == l10n.buildStrength.toLowerCase()) return 0;
    if (g == l10n.findMindfulness.toLowerCase()) return 1;
    if (g == l10n.improveFlexibility.toLowerCase()) return 2;
    if (g == l10n.generalFitness.toLowerCase()) return 3;
    return 0;
  }

  static int nearestMonthlyStep(int monthlyGoal) {
    return monthlySteps.reduce(
      (a, b) =>
          (monthlyGoal - a).abs() <= (monthlyGoal - b).abs() ? a : b,
    );
  }

  static bool matchesPresetTitle(AppLocalizations l10n, String value) {
    final t = value.trim().toLowerCase();
    for (var i = 0; i < 4; i++) {
      if (t == goalTitleForIndex(l10n, i).toLowerCase()) {
        return true;
      }
    }
    return false;
  }
}
