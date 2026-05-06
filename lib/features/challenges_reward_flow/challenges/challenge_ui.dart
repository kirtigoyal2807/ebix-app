import 'package:pilates_app/features/loyalty/data/models/loyalty_challenge.dart';
import 'package:pilates_app/features/loyalty/data/models/loyalty_leaderboard_entry.dart';

/// Asset for list / detail cards from [LoyaltyChallenge.challengeType].
String challengeTypeIconAsset(String challengeType, {required bool isDark}) {
  switch (challengeType) {
    case 'streak':
      return isDark
          ? 'assets/images/svg/challenges/ic_dark_streak.svg'
          : 'assets/images/svg/challenges/ic_streak.svg';
    case 'referral_count':
      return isDark
          ? 'assets/images/svg/challenges/ic_dark_core_strength.svg'
          : 'assets/images/svg/challenges/ic_strength.svg';
    case 'attendance_count':
    default:
      return isDark
          ? 'assets/images/svg/challenges/ic_dark_classes.svg'
          : 'assets/images/svg/challenges/ic_classes.svg';
  }
}

int daysUntilEndUtc(String? iso) {
  if (iso == null || iso.isEmpty) return 0;
  try {
    final end = DateTime.parse(iso).toUtc();
    final now = DateTime.now().toUtc();
    final d = end.difference(now).inDays;
    return d < 0 ? 0 : d;
  } catch (_) {
    return 0;
  }
}

double challengeProgressFraction(LoyaltyChallenge c) {
  if (c.targetValue <= 0) return 0;
  return (c.progressValue / c.targetValue).clamp(0.0, 1.0);
}

int challengePercentComplete(LoyaltyChallenge c) {
  return (challengeProgressFraction(c) * 100).round();
}

String leaderboardDisplayName(LoyaltyLeaderboardEntry e) {
  final n = e.customerName?.trim();
  if (n != null && n.isNotEmpty) return n;
  return 'Member ${e.customerId}';
}

String leaderboardInitials(LoyaltyLeaderboardEntry e) {
  final n = e.customerName?.trim();
  if (n != null && n.isNotEmpty) {
    final parts = n.split(RegExp(r'\s+')).where((p) => p.isNotEmpty).toList();
    if (parts.length >= 2) {
      final a = parts[0][0];
      final b = parts[1][0];
      return ('$a$b').toUpperCase();
    }
    if (parts.isNotEmpty && parts[0].length >= 2) {
      return parts[0].substring(0, 2).toUpperCase();
    }
    if (parts.isNotEmpty) {
      return parts[0].substring(0, 1).toUpperCase();
    }
  }
  final id = e.customerId.toString();
  return id.length >= 2 ? id.substring(id.length - 2) : id;
}
