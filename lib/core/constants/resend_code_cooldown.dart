/// Cooldown duration before "Resend code" can be tapped again (shared by all OTP flows).
abstract final class ResendCodeCooldown {
  static const Duration duration = Duration(seconds: 30);
}
