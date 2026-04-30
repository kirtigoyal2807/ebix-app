import 'package:pilates_app/core/network/api_result.dart';
import 'package:pilates_app/core/network/base_repository.dart';

import 'models/customer_subscription_resource.dart';

/// Subscription module — Mobile API §9.
///
/// **Stacking:** subscriptions chain by `entitlementType`. Different entitlement types
/// (e.g. `session_pack` + `subscription`) may both be active at once. Purchasing the same
/// type while already active yields a **future** row — see §9.3 list ordering / `startsAt`.
class SubscriptionsRepository extends BaseRepository {
  SubscriptionsRepository(super.dio);

  /// §9.3 — `GET /subscriptions/customer/{customer}` (path segment encoded).
  Future<ApiResult<List<CustomerSubscriptionResource>>> listSubscriptionsForCustomer(
    String customerId,
  ) {
    final id = customerId.trim();
    return get<List<CustomerSubscriptionResource>>(
      'subscriptions/customer/${Uri.encodeComponent(id)}',
      fromJson: _parseSubscriptionsList,
    );
  }

  /// Authenticated shortcut when the backend exposes `me`.
  Future<ApiResult<List<CustomerSubscriptionResource>>> listMySubscriptions() {
    return get<List<CustomerSubscriptionResource>>(
      'subscriptions/me',
      fromJson: _parseSubscriptionsList,
    );
  }

  /// §9.1 — `POST /subscriptions/{subscription}/freeze`
  ///
  /// Body: optional `startDate`, `endDate` as calendar dates (`yyyy-MM-dd`).
  Future<ApiResult<bool>> startFreeze(
    String subscriptionId, {
    DateTime? startDate,
    DateTime? endDate,
  }) {
    final sub = subscriptionId.trim();
    final body = <String, dynamic>{};
    final sd = startDate != null ? _formatApiDate(startDate) : null;
    final ed = endDate != null ? _formatApiDate(endDate) : null;
    if (sd != null) body['startDate'] = sd;
    if (ed != null) body['endDate'] = ed;

    return post<bool>(
      'subscriptions/${Uri.encodeComponent(sub)}/freeze',
      data: body,
      fromJson: (_) => true,
    );
  }

  /// §9.2 — `POST /subscriptions/{subscription}/freeze/{freeze}/cancel`
  Future<ApiResult<bool>> cancelFreeze(
    String subscriptionId,
    String freezeId,
  ) {
    final sub = subscriptionId.trim();
    final fz = freezeId.trim();
    return post<bool>(
      'subscriptions/${Uri.encodeComponent(sub)}/freeze/${Uri.encodeComponent(fz)}/cancel',
      fromJson: (_) => true,
    );
  }

  /// Calendar date only, for JSON bodies (local date, not UTC shift).
  static String _formatApiDate(DateTime d) {
    final local = DateTime(d.year, d.month, d.day);
    final y = local.year.toString().padLeft(4, '0');
    final m = local.month.toString().padLeft(2, '0');
    final day = local.day.toString().padLeft(2, '0');
    return '$y-$m-$day';
  }

  static List<CustomerSubscriptionResource> _parseSubscriptionsList(dynamic json) {
    if (json is! List<dynamic>) return <CustomerSubscriptionResource>[];
    final out = <CustomerSubscriptionResource>[];
    for (final e in json) {
      if (e is Map<String, dynamic>) {
        out.add(CustomerSubscriptionResource.fromJson(e));
      } else if (e is Map) {
        out.add(
          CustomerSubscriptionResource.fromJson(
            Map<String, dynamic>.from(e),
          ),
        );
      }
    }
    return out;
  }
}
