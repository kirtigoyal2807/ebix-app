import 'package:pilates_app/core/network/api_result.dart';
import 'package:pilates_app/core/network/base_repository.dart';

import 'models/referral_history_item.dart';
import 'models/referral_program_details.dart';

/// Pilates API — referral module (16.x).
class ReferralRepository extends BaseRepository {
  ReferralRepository(super.dio);

  /// 16.1 Get program details (JWT). Creates code on first share.
  Future<ApiResult<ReferralProgramDetails>> getProgramDetails() {
    return get<ReferralProgramDetails>(
      '/referral/program',
      fromJson: (json) =>
          ReferralProgramDetails.fromJson(json as Map<String, dynamic>),
    );
  }

  /// Referral history — people referred and reward status (JWT).
  Future<ApiResult<List<ReferralHistoryItem>>> getReferralHistory() {
    return get<List<ReferralHistoryItem>>(
      '/referral/history',
      fromJson: (json) {
        if (json == null) {
          return <ReferralHistoryItem>[];
        }
        if (json is! List) {
          return <ReferralHistoryItem>[];
        }
        final list = json;
        return list
            .map((e) => ReferralHistoryItem.fromJson(e as Map<String, dynamic>))
            .toList();
      },
    );
  }

  /// Records an invitation; `channel`: `sms` (dispatch SMS) or `link` (record only).
  Future<ApiResult<bool>> sendInvitation({
    required String inviteePhone,
    required String channel,
    String? inviteeName,
  }) {
    final trimmedPhone = inviteePhone.trim();
    final trimmedName = inviteeName?.trim();
    final body = <String, dynamic>{
      'inviteePhone': trimmedPhone,
      'channel': channel,
    };
    if (trimmedName != null && trimmedName.isNotEmpty) {
      body['inviteeName'] = trimmedName.length > 100
          ? trimmedName.substring(0, 100)
          : trimmedName;
    }
    return post<bool>('/referral/invite', data: body, fromJson: (_) => true);
  }
}
