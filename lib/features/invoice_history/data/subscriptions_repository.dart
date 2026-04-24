import 'package:pilates_app/core/network/api_result.dart';
import 'package:pilates_app/core/network/base_repository.dart';

import 'models/customer_subscription_resource.dart';

/// `GET /subscriptions/me` — customer subscriptions (Mobile API §9.3).
///
/// Invoice history uses `InvoicesRepository` (`GET /invoices`) instead. Register this if you
/// add a feature that needs subscription rows from this endpoint.
class SubscriptionsRepository extends BaseRepository {
  SubscriptionsRepository(super.dio);

  Future<ApiResult<List<CustomerSubscriptionResource>>> listMySubscriptions() {
    return get<List<CustomerSubscriptionResource>>(
      '/subscriptions/me',
      fromJson: (json) {
        if (json is! List<dynamic>) return <CustomerSubscriptionResource>[];
        final out = <CustomerSubscriptionResource>[];
        for (final e in json) {
          if (e is Map<String, dynamic>) {
            out.add(CustomerSubscriptionResource.fromJson(e));
          } else if (e is Map) {
            out.add(CustomerSubscriptionResource.fromJson(
              Map<String, dynamic>.from(e),
            ));
          }
        }
        return out;
      },
    );
  }
}
