/// Client-side rules for subscription health step 1 (personal information).
abstract final class PersonalInformationValidators {
  PersonalInformationValidators._();

  static String _digitsOnly(String raw) => raw.replaceAll(RegExp(r'\D'), '');

  /// Local mobile: exactly 10 digits (country code entered separately in UI).
  static bool isTenDigitMobile(String raw) => _digitsOnly(raw).length == 10;

  static bool isValidName(String raw) {
    final t = raw.trim();
    return t.length >= 2 && t.length <= 120;
  }

  static bool isValidAge(String raw) {
    final n = int.tryParse(raw.trim());
    return n != null && n >= 1 && n <= 120;
  }

  static double? _parsePositiveDecimal(String raw) {
    final t = raw.trim();
    if (t.isEmpty) return null;
    return double.tryParse(t.replaceAll(',', '.'));
  }

  /// Height in centimetres (50–300). Accepts integers or decimals (e.g. `175`, `175.5`).
  static bool isValidHeightCm(String raw) {
    final n = _parsePositiveDecimal(raw);
    return n != null && n >= 50 && n <= 300;
  }

  /// Weight in kilograms (20–400). Accepts integers or decimals (e.g. `70`, `70.5`).
  static bool isValidWeightKg(String raw) {
    final n = _parsePositiveDecimal(raw);
    return n != null && n >= 20 && n <= 400;
  }

  /// National digits for the subscription health step (max 10), from profile / E.164.
  ///
  /// Strips leading [966] for KSA; if nine digits remain starting with [5], prefixes [0].
  static String profilePhoneToNationalDigits(String? raw) {
    var d = _digitsOnly(raw ?? '');
    if (d.isEmpty) return '';
    if (d.startsWith('966')) {
      d = d.substring(3);
      if (d.length >= 10) {
        return d.substring(0, 10);
      }
      if (d.length == 9 && d.startsWith('5')) {
        return '0$d';
      }
      return d;
    }
    if (d.length > 10) {
      return d.substring(d.length - 10);
    }
    return d;
  }
}
