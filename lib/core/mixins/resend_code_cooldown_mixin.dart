import 'dart:async';

import 'package:flutter/material.dart';

import '../constants/resend_code_cooldown.dart';

mixin ResendCodeCooldownMixin<T extends StatefulWidget> on State<T> {
  Timer? _resendCodeCooldownTimer;
  bool _resendCodeCooldownActive = false;

  bool get isResendCodeOnCooldown => _resendCodeCooldownActive;

  void startResendCodeCooldown() {
    _resendCodeCooldownTimer?.cancel();
    _resendCodeCooldownTimer = Timer(ResendCodeCooldown.duration, () {
      if (!mounted) return;
      setState(() => _resendCodeCooldownActive = false);
    });
    setState(() => _resendCodeCooldownActive = true);
  }

  @override
  void dispose() {
    _resendCodeCooldownTimer?.cancel();
    super.dispose();
  }
}
