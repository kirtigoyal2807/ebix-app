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

  static bool isValidHeightCm(String raw) {
    final n = int.tryParse(raw.trim());
    return n != null && n >= 50 && n <= 300;
  }

  static bool isValidWeightKg(String raw) {
    final n = int.tryParse(raw.trim());
    return n != null && n >= 20 && n <= 400;
  }
}
