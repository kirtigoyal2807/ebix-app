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
  final plan = user?.membershipPlanName?.trim() ?? '';
  if (plan.isNotEmpty) return true;
  if (user?.membershipTotalSessions != null ||
      user?.membershipSessionsRemaining != null) {
    return true;
  }
  return userShowsPackageMembership(user);
}

/// Uses profile-derived signals so UI does not show "in plan" when the guest has
/// no membership record on the device.
bool userShowsPackageMembership(AuthUser? user) {
  if (user == null) return false;
  final plan = user.membershipPlanName?.trim();
  if (plan != null && plan.isNotEmpty) return true;
  final remaining = user.membershipSessionsRemaining;
  if (remaining != null && remaining > 0) return true;
  final subs = user.subscriptions;
  return subs != null && subs.isNotEmpty;
}
