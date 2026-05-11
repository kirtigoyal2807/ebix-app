import 'package:flutter_test/flutter_test.dart';
import 'package:pilates_app/core/validation/phone_number_country_validation.dart';

void main() {
  test('SA national number used in auth tests is valid', () {
    expect(
      PhoneNumberCountryValidation.isValidNationalNumber(
        iso3166Alpha2: 'SA',
        nationalDigitsOnly: '501234567',
      ),
      isTrue,
    );
  });

  test('SA local mobile with leading 0 is valid', () {
    expect(
      PhoneNumberCountryValidation.isValidNationalNumber(
        iso3166Alpha2: 'SA',
        nationalDigitsOnly: '0501234567',
      ),
      isTrue,
    );
  });

  test('SA local number validates by country length rules', () {
    expect(
      PhoneNumberCountryValidation.isValidNationalNumber(
        iso3166Alpha2: 'SA',
        nationalDigitsOnly: '0599999999',
      ),
      isTrue,
    );
    expect(
      PhoneNumberCountryValidation.isValidNationalNumber(
        iso3166Alpha2: 'SA',
        nationalDigitsOnly: '0599999',
      ),
      isFalse,
    );
  });
}
