import 'package:phone_numbers_parser/phone_numbers_parser.dart';
import 'package:pilates_app/core/localization/arb/app_localizations.dart';

/// Client-side rules matching [PhoneNumberField] / `phone_numbers_parser` for submitted forms.
abstract final class PhoneNumberCountryValidation {
  PhoneNumberCountryValidation._();

  static String _normalizedNationalDigits({
    required String iso3166Alpha2,
    required String nationalDigitsOnly,
  }) {
    var digits = nationalDigitsOnly.replaceAll(RegExp(r'\D'), '');
    // Remove optional single leading zero for validation (common trunk prefix).
    // Example: 09876543210 -> 9876543210 for length validation.
    if (digits.startsWith('0') && digits.length > 1) {
      digits = digits.substring(1);
    }
    return digits;
  }

  static bool isValidNationalNumber({
    required String iso3166Alpha2,
    required String nationalDigitsOnly,
  }) {
    final upper = iso3166Alpha2.trim().toUpperCase();
    if (upper.length != 2) return false;
    late final IsoCode iso;
    try {
      iso = IsoCode.fromJson(upper);
    } catch (_) {
      return false;
    }
    final digits = _normalizedNationalDigits(
      iso3166Alpha2: upper,
      nationalDigitsOnly: nationalDigitsOnly,
    );
    if (digits.isEmpty) return false;
    try {
      final parsed = PhoneNumber.parse(digits, callerCountry: iso);
      final hasSubscriberLength =
          parsed.isValidLength(type: PhoneNumberType.mobile) ||
          parsed.isValidLength(type: PhoneNumberType.fixedLine);
      if (hasSubscriberLength) return true;
      return parsed.isValidLength();
    } catch (_) {
      return false;
    }
  }

  /// Null when the user may proceed (complete, valid national number for the country).
  static String? submitErrorMessage({
    required AppLocalizations l10n,
    required String rawNationalField,
    String? countryIso3166Alpha2,
  }) {
    final digits = rawNationalField.replaceAll(RegExp(r'\D'), '');
    if (digits.isEmpty) return l10n.pleaseEnterPhone;
    final iso = countryIso3166Alpha2 ?? 'SA';
    if (!isValidNationalNumber(
          iso3166Alpha2: iso,
          nationalDigitsOnly: digits,
        )) {
      return l10n.invalidPhoneForCountry;
    }
    return null;
  }

  /// Normalized digits to append after country dial code when building E.164.
  static String normalizedNationalDigitsForE164({
    required String iso3166Alpha2,
    required String rawNationalField,
  }) {
    return _normalizedNationalDigits(
      iso3166Alpha2: iso3166Alpha2,
      nationalDigitsOnly: rawNationalField,
    );
  }
}
