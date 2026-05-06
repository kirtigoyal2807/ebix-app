import 'package:intl/intl.dart';

/// Rules for subscription declaration / safety consent name, signature, and date.
abstract final class SubscriptionDeclarationValidators {
  SubscriptionDeclarationValidators._();

  static final DateFormat _ddMMyyyy = DateFormat('dd-MM-yyyy');

  /// Same bounds as a display name: not empty, 2–120 chars after trim.
  static bool isValidSignature(String raw) {
    final t = raw.trim();
    return t.length >= 2 && t.length <= 120;
  }

  /// Accepts [SubscriptionCalendarDateField] display (`dd-MM-yyyy`) or ISO dates.
  static bool isValidDeclarationDate(String raw) {
    final t = raw.trim();
    if (t.isEmpty) return false;
    final iso = DateTime.tryParse(t);
    if (iso != null) return true;
    try {
      _ddMMyyyy.parseStrict(t);
      return true;
    } catch (_) {
      return false;
    }
  }
}
