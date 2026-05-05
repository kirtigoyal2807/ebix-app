import 'package:pilates_app/core/network/api_result.dart';
import 'package:pilates_app/core/network/base_repository.dart';

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
}
