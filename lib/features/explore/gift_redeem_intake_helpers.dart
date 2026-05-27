import 'package:flutter/material.dart';
import 'package:pilates_app/features/auth/data/models/auth_user.dart';
import 'package:pilates_app/features/explore/view/gift_redeem_health_intake_view.dart';

/// Personal Information → steps 1–6 → Safety & Consent → Terms & Conditions,
/// then runs [onIntakeComplete] when the user taps Continue to Payment on Terms.
///
/// [popsBeforeOpen] closes routes under the intake screen first (e.g. `2` pops
/// [RedeemCardView] and [ReceiveGiftSheet] from the pending-gift home flow).
Future<void> openGiftRedeemHealthIntake({
  required BuildContext context,
  PendingGift? pendingGift,
  required VoidCallback onIntakeComplete,
  int popsBeforeOpen = 0,
}) {
  final navigator = Navigator.of(context);
  for (var i = 0; i < popsBeforeOpen; i++) {
    if (!navigator.canPop()) break;
    navigator.pop();
  }
  return navigator.push<void>(
    MaterialPageRoute<void>(
      builder: (_) => GiftRedeemHealthIntakeView(
        pendingGift: pendingGift ?? const PendingGift(),
        onComplete: onIntakeComplete,
      ),
    ),
  );
}
