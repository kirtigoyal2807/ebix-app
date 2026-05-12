import 'package:pilates_app/features/auth/data/models/auth_user.dart';

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
