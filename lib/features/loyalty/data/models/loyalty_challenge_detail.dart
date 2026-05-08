import 'loyalty_challenge.dart';
import 'loyalty_leaderboard_entry.dart';

/// `data` from `GET /loyalty/challenges/{id}`.
class LoyaltyChallengeDetail {
  const LoyaltyChallengeDetail({
    required this.challenge,
    required this.leaderboard,
  });

  final LoyaltyChallenge challenge;
  final List<LoyaltyLeaderboardEntry> leaderboard;

  factory LoyaltyChallengeDetail.fromJson(Map<String, dynamic> json) {
    final rawChallenge = json['challenge'];
    final challenge = LoyaltyChallenge.fromJson(
      Map<String, dynamic>.from(rawChallenge as Map),
    );

    final list = <LoyaltyLeaderboardEntry>[];
    final rawBoard = json['leaderboard'];
    if (rawBoard is List) {
      for (final e in rawBoard) {
        if (e is Map<String, dynamic>) {
          list.add(LoyaltyLeaderboardEntry.fromJson(e));
        } else if (e is Map) {
          list.add(
            LoyaltyLeaderboardEntry.fromJson(Map<String, dynamic>.from(e)),
          );
        }
      }
    }

    return LoyaltyChallengeDetail(challenge: challenge, leaderboard: list);
  }
}
