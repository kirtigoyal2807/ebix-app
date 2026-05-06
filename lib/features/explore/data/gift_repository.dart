import 'package:pilates_app/core/network/api_result.dart';
import 'package:pilates_app/core/network/base_repository.dart';

import 'models/subscription_gift_resource.dart';

class GiftRepository extends BaseRepository {
  GiftRepository(super.dio);

  Future<ApiResult<SubscriptionGiftResource>> redeemGift({
    required String redemptionCode,
  }) {
    final trimmed = redemptionCode.trim();
    return post<SubscriptionGiftResource>(
      '/gifts/redeem',
      data: <String, dynamic>{'redemptionCode': trimmed},
      fromJson: (json) =>
          SubscriptionGiftResource.fromJson(json as Map<String, dynamic>),
    );
  }
}
