import 'package:flutter/scheduler.dart';
import 'package:flutter/material.dart';

/// Posted after [Navigator.popUntil] to [Route.isFirst] so the active [HomeView]
/// (under [AuthRootView]) switches to the booking / Classes tab.
final ValueNotifier<bool> openClassesBookingTabAfterPopToRoot =
    ValueNotifier(false);

/// Pops the entire stack above the app root, then requests the Classes tab.
void popBookingFlowToClassesTab(BuildContext context) {
  Navigator.of(context).popUntil((route) => route.isFirst);
  SchedulerBinding.instance.addPostFrameCallback((_) {
    openClassesBookingTabAfterPopToRoot.value = true;
  });
}
