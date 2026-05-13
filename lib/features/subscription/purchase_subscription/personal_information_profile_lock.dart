import 'package:pilates_app/core/validation/contact_validators.dart';
import 'package:pilates_app/core/validation/personal_information_validators.dart';
import 'package:pilates_app/features/auth/data/models/auth_user.dart';

/// Locks fixed personal fields on subscription step 1 when profile already carries
/// trustworthy values (`AuthUser`).
abstract final class PersonalInformationProfileLock {
  PersonalInformationProfileLock._();

  static String displayNameFromUser(AuthUser? user) {
    if (user == null) return '';
    final parts = <String>[
      user.firstName?.trim() ?? '',
      user.lastName?.trim() ?? '',
    ].where((e) => e.isNotEmpty).toList();
    if (parts.isNotEmpty) return parts.join(' ');
    return user.name?.trim() ?? '';
  }

  static String profileAgeString(AuthUser? user) {
    final apiAge = user?.ageYears;
    return apiAge != null ? apiAge.toString() : '';
  }

  static bool shouldLockName(AuthUser? user) {
    final n = displayNameFromUser(user).trim();
    return n.isNotEmpty && PersonalInformationValidators.isValidName(n);
  }

  static bool shouldLockAge(AuthUser? user) {
    final age = profileAgeString(user);
    return age.isNotEmpty && PersonalInformationValidators.isValidAge(age);
  }

  static String profileEmail(AuthUser? user) =>
      user?.email?.trim() ?? '';

  static String profilePhoneNational(AuthUser? user) =>
      PersonalInformationValidators.profilePhoneToNationalDigits(user?.phone);

  static bool shouldLockPhone(AuthUser? user) {
    final phone = profilePhoneNational(user);
    return phone.isNotEmpty &&
        PersonalInformationValidators.isTenDigitMobile(phone);
  }

  static bool shouldLockEmail(AuthUser? user) {
    final email = profileEmail(user);
    return email.isNotEmpty && ContactValidators.isValidEmail(email);
  }
}
