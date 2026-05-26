import 'package:flutter/material.dart';

/// Supplies the post–Terms & Conditions action for [GiftRedeemHealthIntakeView].
class GiftRedeemIntakeScope extends InheritedWidget {
  const GiftRedeemIntakeScope({
    super.key,
    required this.onComplete,
    required super.child,
  });

  final VoidCallback onComplete;

  static GiftRedeemIntakeScope? maybeOf(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<GiftRedeemIntakeScope>();
  }

  @override
  bool updateShouldNotify(GiftRedeemIntakeScope oldWidget) {
    return onComplete != oldWidget.onComplete;
  }
}
