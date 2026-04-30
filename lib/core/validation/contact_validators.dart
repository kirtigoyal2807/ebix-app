/// Shared client-side validation for checkout & gift flows.
abstract final class ContactValidators {
  ContactValidators._();

  static final RegExp _emailPattern = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$');

  /// Typical person / recipient display name (no empty, not huge).
  static bool isValidPersonName(String raw) {
    final t = raw.trim();
    if (t.length < 2) return false;
    if (t.length > 120) return false;
    return true;
  }

  static bool isValidEmail(String raw) {
    final t = raw.trim();
    if (t.isEmpty) return false;
    return _emailPattern.hasMatch(t);
  }

  /// Empty is allowed (optional field). If provided, expect plausible phone digits.
  static bool isValidOptionalPhone(String raw) {
    final t = raw.trim();
    if (t.isEmpty) return true;
    final digits = t.replaceAll(RegExp(r'\D'), '');
    return digits.length >= 8 && digits.length <= 15;
  }
}
