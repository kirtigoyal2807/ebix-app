import 'package:pilates_app/core/network/api_result.dart';
import 'package:pilates_app/features/auth/data/models/auth_user.dart';
import 'package:pilates_app/features/checkout/data/checkout_repository.dart';
import 'package:pilates_app/features/subscription/purchase_subscription/subscription_api_ids.dart';

/// Product + intake flags used to drive the gift-redeem health wizard (same
/// questionnaire source as Buy Subscription after Continue).
class GiftRedeemIntakeProductContext {
  const GiftRedeemIntakeProductContext({
    required this.planId,
    required this.productId,
    required this.requiresHealthIntake,
  });

  final String planId;
  final int productId;
  final bool requiresHealthIntake;
}

/// Resolves the gifted plan for `GET …/questionnaires/product/{id}`.
///
/// Uses [PendingGift.plan] id, or [redeemedProductId] from `POST /gifts/redeem`
/// when the profile gift payload omits plan id. Never substitutes catalog
/// defaults or product `1`, so questionnaire vs non-questionnaire gifts stay
/// distinct.
Future<GiftRedeemIntakeProductContext> resolveGiftRedeemIntakeProduct({
  required CheckoutRepository checkoutRepository,
  required PendingGift pendingGift,
  int? branchId,
  int? redeemedProductId,
}) async {
  final giftPlanId = pendingGift.plan?.id?.trim() ?? '';
  var productId = subscriptionProductApiId(giftPlanId);
  if (productId <= 0 &&
      redeemedProductId != null &&
      redeemedProductId > 0) {
    productId = redeemedProductId;
  }

  if (productId <= 0) {
    return const GiftRedeemIntakeProductContext(
      planId: '',
      productId: 0,
      requiresHealthIntake: false,
    );
  }

  final productResult = await checkoutRepository.getProduct(
    productId,
    branchId: branchId,
  );

  switch (productResult) {
    case ApiSuccess(:final data):
      return GiftRedeemIntakeProductContext(
        planId: giftPlanId.isNotEmpty ? giftPlanId : productId.toString(),
        productId: productId,
        requiresHealthIntake: data.requiresHealthIntake,
      );
    case ApiFailure():
      return GiftRedeemIntakeProductContext(
        planId: giftPlanId.isNotEmpty ? giftPlanId : productId.toString(),
        productId: productId,
        requiresHealthIntake: false,
      );
  }
}
