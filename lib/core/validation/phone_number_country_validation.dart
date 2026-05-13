import 'package:phone_numbers_parser/phone_numbers_parser.dart';
import 'package:pilates_app/core/localization/arb/app_localizations.dart';

/// Client-side rules matching [PhoneNumberField] / `phone_numbers_parser` for submitted forms.
abstract final class PhoneNumberCountryValidation {
  PhoneNumberCountryValidation._();

  /// Mobile / fixed-line only — never use untyped [PhoneNumber.isValidLength], which also
  /// accepts toll-free, premium, shared-cost, etc. (e.g. India toll-free allows length 8).
  static bool _hasValidSubscriberLength(PhoneNumber parsed) {
    return parsed.isValidLength(type: PhoneNumberType.mobile) ||
        parsed.isValidLength(type: PhoneNumberType.fixedLine);
  }

  /// Normalizes user-entered digits to the national subscriber number (NSN) for [iso3166Alpha2]:
  /// strips non-digits, optionally removes a redundant leading country calling code when the
  /// selected country's code was pasted together with the NSN, then strips one trunk `0`.
  static String _normalizedNationalDigits({
    required String iso3166Alpha2,
    required String nationalDigitsOnly,
  }) {
    var digits = nationalDigitsOnly.replaceAll(RegExp(r'\D'), '');
    if (digits.isEmpty) return digits;

    IsoCode iso;
    try {
      iso = IsoCode.fromJson(iso3166Alpha2.trim().toUpperCase());
    } catch (_) {
      return digits;
    }

    final cc = PhoneNumber(isoCode: iso, nsn: '0').countryCode;
    if (cc.isNotEmpty &&
        digits.startsWith(cc) &&
        digits.length > cc.length) {
      final withoutCc = digits.substring(cc.length);
      final full = PhoneNumber(isoCode: iso, nsn: digits);
      final stripped = PhoneNumber(isoCode: iso, nsn: withoutCc);
      final fullOk = _hasValidSubscriberLength(full);
      final strippedOk = _hasValidSubscriberLength(stripped);
      if (!fullOk && strippedOk) {
        digits = withoutCc;
      }
    }

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
    final parsed = PhoneNumber(isoCode: iso, nsn: digits);
    return _hasValidSubscriberLength(parsed);
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
