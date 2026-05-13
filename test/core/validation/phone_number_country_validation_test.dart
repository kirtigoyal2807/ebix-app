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

  test(
    'SA validates NSN only when country calling code was pasted into the field',
    () {
      expect(
        PhoneNumberCountryValidation.isValidNationalNumber(
          iso3166Alpha2: 'SA',
          nationalDigitsOnly: '966501234567',
        ),
        isTrue,
      );
    },
  );

  test('IN rejects short NSN that only matched toll-free length metadata', () {
    expect(
      PhoneNumberCountryValidation.isValidNationalNumber(
        iso3166Alpha2: 'IN',
        nationalDigitsOnly: '98765432',
      ),
      isFalse,
    );
    expect(
      PhoneNumberCountryValidation.isValidNationalNumber(
        iso3166Alpha2: 'IN',
        nationalDigitsOnly: '9876543210',
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
