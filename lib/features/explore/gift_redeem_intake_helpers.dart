import 'package:flutter/material.dart';
import 'package:pilates_app/features/auth/data/models/auth_user.dart';
import 'package:pilates_app/features/explore/view/gift_redeem_health_intake_view.dart';

/// Personal Information → steps 1–6 → Safety & Consent → Terms & Conditions,
/// then runs [onIntakeComplete] (same action as View Gift after intake).
Future<void> openGiftRedeemHealthIntake({
  required BuildContext context,
  PendingGift? pendingGift,
  required VoidCallback onIntakeComplete,
}) {
  return Navigator.of(context).push<void>(
    MaterialPageRoute<void>(
      builder: (_) => GiftRedeemHealthIntakeView(
        pendingGift: pendingGift ?? const PendingGift(),
        onComplete: onIntakeComplete,
      ),
    ),
  );
}
