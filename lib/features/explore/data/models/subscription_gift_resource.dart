import 'package:pilates_app/features/invoice_history/data/models/customer_subscription_resource.dart';

/// Response data from `POST /gifts/redeem` (gift envelope + nested subscription).
class SubscriptionGiftResource {
  const SubscriptionGiftResource({
    this.id,
    this.redemptionCode,
    this.subscription,
  });

  final String? id;
  final String? redemptionCode;
  final CustomerSubscriptionResource? subscription;

  factory SubscriptionGiftResource.fromJson(Map<String, dynamic> json) {
    CustomerSubscriptionResource? sub;
    final subRaw = json['subscription'];
    if (subRaw is Map) {
      sub = CustomerSubscriptionResource.fromJson(
        Map<String, dynamic>.from(subRaw),
      );
    }
    return SubscriptionGiftResource(
      id: json['id']?.toString(),
      redemptionCode:
          '${json['redemptionCode'] ?? json['redemption_code'] ?? ''}'
              .trim()
              .isEmpty
          ? null
          : '${json['redemptionCode'] ?? json['redemption_code']}',
      subscription: sub,
    );
  }
}
