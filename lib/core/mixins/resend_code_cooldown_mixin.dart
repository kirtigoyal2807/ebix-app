import 'dart:async';

import 'package:flutter/material.dart';

import '../constants/resend_code_cooldown.dart';

mixin ResendCodeCooldownMixin<T extends StatefulWidget> on State<T> {
  Timer? _resendCodeCooldownTimer;
  bool _resendCodeCooldownActive = false;
  int _cooldownSecondsRemaining = 0;

  bool get isResendCodeOnCooldown => _resendCodeCooldownActive;

  /// Remaining cooldown, or [Duration.zero] when not active.
  ///
  /// Uses a second counter advanced by [Timer.periodic] so remaining time matches
  /// [WidgetTester.pump] elapsed time in tests (unlike wall-clock [DateTime.now]).
  Duration get resendCodeCooldownRemaining {
    if (!_resendCodeCooldownActive) return Duration.zero;
    return Duration(seconds: _cooldownSecondsRemaining.clamp(0, 86400));
  }

  /// Resets and starts the resend cooldown timer.
  ///
  /// Use [notify: false] when calling from [initState] so the first [build] already
  /// sees the full remaining duration (no extra [setState] before mount completes).
  void startResendCodeCooldown({bool notify = true}) {
    _resendCodeCooldownTimer?.cancel();
    final total = ResendCodeCooldown.duration.inSeconds;
    _resendCodeCooldownActive = true;
    _cooldownSecondsRemaining = total;
    if (notify && mounted) {
      setState(() {});
    }
    _resendCodeCooldownTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted) return;
      setState(() {
        if (_cooldownSecondsRemaining <= 1) {
          _resendCodeCooldownTimer?.cancel();
          _resendCodeCooldownActive = false;
          _cooldownSecondsRemaining = 0;
        } else {
          _cooldownSecondsRemaining--;
        }
      });
    });
  }

  @override
  void dispose() {
    _resendCodeCooldownTimer?.cancel();
    super.dispose();
  }
}
