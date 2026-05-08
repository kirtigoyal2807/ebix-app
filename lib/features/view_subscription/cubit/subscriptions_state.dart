import 'package:equatable/equatable.dart';

import 'package:pilates_app/features/invoice_history/data/models/customer_subscription_resource.dart';

enum SubscriptionsLoadStatus { initial, loading, success, failure }

class SubscriptionsState extends Equatable {
  const SubscriptionsState({
    this.status = SubscriptionsLoadStatus.initial,
    this.errorMessage,
    this.subscriptions = const [],
  });

  final SubscriptionsLoadStatus status;
  final String? errorMessage;
  final List<CustomerSubscriptionResource> subscriptions;

  /// Prefer active membership, then session pack; otherwise first active or first row.
  ///
  /// **§9 stacking:** Different `entitlementType` values may be active concurrently.
  /// Same-type renewals while active appear as additional rows (often future `startsAt`).
  CustomerSubscriptionResource? get primarySubscription {
    if (subscriptions.isEmpty) return null;
    final active = subscriptions.where((s) => s.isActive).toList();
    final pool = active.isNotEmpty ? active : subscriptions;
    final membership = pool
        .where((s) => s.entitlementType == 'subscription')
        .toList();
    if (membership.isNotEmpty) return membership.first;
    final packs = pool
        .where((s) => s.entitlementType == 'session_pack')
        .toList();
    if (packs.isNotEmpty) return packs.first;
    return pool.first;
  }

  SubscriptionsState copyWith({
    SubscriptionsLoadStatus? status,
    String? errorMessage,
    bool clearErrorMessage = false,
    List<CustomerSubscriptionResource>? subscriptions,
  }) {
    return SubscriptionsState(
      status: status ?? this.status,
      errorMessage: clearErrorMessage
          ? null
          : (errorMessage ?? this.errorMessage),
      subscriptions: subscriptions ?? this.subscriptions,
    );
  }

  @override
  List<Object?> get props => [status, errorMessage, subscriptions];
}
