import 'package:pilates_app/core/network/api_result.dart';
import 'package:pilates_app/features/auth/data/models/auth_user.dart';
import 'package:pilates_app/features/checkout/data/checkout_repository.dart';
import 'package:pilates_app/features/checkout/data/models/catalog_product.dart';
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

/// Resolves catalog plan/product for `GET …/questionnaires/product/{id}`.
///
/// Prefers [pendingGift.plan], then the user's branch catalog (same ordering as
/// [SubscriptionView]), then product id `1` as a last resort.
Future<GiftRedeemIntakeProductContext> resolveGiftRedeemIntakeProduct({
  required CheckoutRepository checkoutRepository,
  required PendingGift pendingGift,
  int? branchId,
}) async {
  final giftPlanId = pendingGift.plan?.id?.trim() ?? '';
  var productId = subscriptionProductApiId(giftPlanId);
  var requiresHealthIntake = false;
  var planId = giftPlanId;

  if (productId > 0) {
    final productResult = await checkoutRepository.getProduct(
      productId,
      branchId: branchId,
    );
    switch (productResult) {
      case ApiSuccess(:final data):
        requiresHealthIntake = data.requiresHealthIntake;
      case ApiFailure():
        break;
    }
    return GiftRedeemIntakeProductContext(
      planId: planId.isNotEmpty ? planId : productId.toString(),
      productId: productId,
      requiresHealthIntake: requiresHealthIntake,
    );
  }

  final listResult = await checkoutRepository.listProducts(branchId: branchId);
  switch (listResult) {
    case ApiSuccess(:final data):
      final picked = _pickCatalogProductForHealthIntake(data);
      if (picked != null) {
        return GiftRedeemIntakeProductContext(
          planId: picked.id.toString(),
          productId: picked.id,
          requiresHealthIntake: picked.requiresHealthIntake,
        );
      }
    case ApiFailure():
      break;
  }

  const fallbackId = 1;
  return const GiftRedeemIntakeProductContext(
    planId: '1',
    productId: fallbackId,
    requiresHealthIntake: true,
  );
}

/// Mirrors subscription plan ordering so the default product matches Buy flow.
CatalogProduct? _pickCatalogProductForHealthIntake(List<CatalogProduct> products) {
  final active = products.where((p) => p.isActive).toList();
  if (active.isEmpty) return null;

  final ordered = List<CatalogProduct>.from(active);
  int rank(CatalogProduct p) {
    final et = p.entitlementType.toLowerCase();
    final t = p.type.toLowerCase();
    if (t == 'membership' && et == 'subscription') return 0;
    if (t == 'membership') return 1;
    return 2;
  }

  ordered.sort((a, b) {
    final c = rank(a).compareTo(rank(b));
    if (c != 0) return c;
    if (a.isRecommended != b.isRecommended) {
      return (b.isRecommended ? 1 : 0).compareTo(a.isRecommended ? 1 : 0);
    }
    return a.id.compareTo(b.id);
  });

  for (final p in ordered) {
    if (p.requiresHealthIntake) return p;
  }
  return ordered.first;
}
