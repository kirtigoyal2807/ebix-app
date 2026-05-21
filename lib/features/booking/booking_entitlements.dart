import 'package:pilates_app/features/auth/data/models/auth_user.dart';

/// Membership from profile and/or plan name persisted from [`GET /home`].
///
/// Use this on routes pushed above the tab navigator (no [HomeCubit] in scope).
bool userHasMembershipPlanHint({
  AuthUser? user,
  String? storedPlanName,
}) {
  final stored = storedPlanName?.trim() ?? '';
  if (stored.isNotEmpty) return true;
  return userShowsPackageMembership(user);
}

/// Active entitlement usable for package booking ("In Your Plan" badge, etc.).
bool subscriptionGrantsPackageAccess(UserSubscription sub) {
  if (sub.isActive == false) return false;
  final status = sub.status?.trim().toLowerCase();
  if (status != null && status.isNotEmpty) {
    const inactive = {'cancelled', 'canceled', 'expired', 'inactive', 'ended'};
    if (inactive.contains(status)) return false;
  }
  final remaining = sub.sessions?.remaining;
  if (remaining != null) return remaining > 0;
  final et = sub.entitlementType?.trim().toLowerCase();
  if (et == 'session_pack' || et == 'subscription') {
    return sub.isActive != false;
  }
  return false;
}

/// True when the logged-in user has sessions or an active subscription/session pack.
///
/// Plan name alone (stale profile text) does **not** count — avoids showing
/// "In Your Plan" when the user has no usable membership.
bool userShowsPackageMembership(AuthUser? user) {
  if (user == null) return false;
  final remaining = user.membershipSessionsRemaining;
  if (remaining != null && remaining > 0) return true;
  final subs = user.subscriptions;
  if (subs == null || subs.isEmpty) return false;
  for (final sub in subs) {
    if (subscriptionGrantsPackageAccess(sub)) return true;
  }
  return false;
}
