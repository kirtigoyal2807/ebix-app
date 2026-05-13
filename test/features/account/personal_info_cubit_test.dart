import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pilates_app/core/localization/arb/app_localizations.dart';
import 'package:pilates_app/features/account/cubit/personal_info_cubit.dart';
import 'package:pilates_app/features/account/cubit/personal_info_state.dart';
import 'package:pilates_app/features/account/data/models/profile_update_result.dart';
import 'package:pilates_app/features/auth/data/auth_repository.dart';
import 'package:pilates_app/features/auth/data/models/auth_user.dart';

class _FakeL10n implements AppLocalizations {
  @override
  String get firstNameTooShort => 'First name must be at least 2 characters';

  @override
  String get firstNameTooLong => 'First name must be at most 120 characters';

  @override
  String get lastNameTooShort => 'Last name must be at least 2 characters';

  @override
  String get lastNameTooLong => 'Last name must be at most 120 characters';

  @override
  String get enterValidEmail => 'Please enter a valid email address';

  @override
  String get invalidPhoneForCountry => 'Invalid phone for country';

  @override
  String get profileUpdateFailed => 'Failed to update profile.';

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  group('PersonalInfoCubit', () {
    final l10n = _FakeL10n();

    test('saveProfile sends firstName, lastName, email and phone', () async {
      final repository = _TestAuthRepository();
      final cubit = PersonalInfoCubit(authRepository: repository);

      final result = await cubit.saveProfile(
        firstName: 'Noor',
        lastName: 'Ali',
        email: 'noor@example.com',
        phone: '+966500000001',
        phoneNationalRaw: '500000001',
        phoneCountryIso3166: 'SA',
        l10n: l10n,
      );

      expect(repository.updateCalls, 1);
      expect(repository.lastFirstName, 'Noor');
      expect(repository.lastLastName, 'Ali');
      expect(repository.lastEmail, 'noor@example.com');
      expect(repository.lastPhone, '+966500000001');
      expect(cubit.state.saveStatus, PersonalInfoSaveStatus.success);
      expect(result, isNotNull);

      await cubit.close();
    });

    test('saveProfile validates empty firstName', () async {
      final repository = _TestAuthRepository();
      final cubit = PersonalInfoCubit(authRepository: repository);

      final result = await cubit.saveProfile(
        firstName: '',
        lastName: 'Ali',
        email: 'noor@example.com',
        phone: '+966500000001',
        phoneNationalRaw: '500000001',
        phoneCountryIso3166: 'SA',
        l10n: l10n,
      );

      expect(repository.updateCalls, 0);
      expect(result, isNull);
      expect(cubit.state.saveStatus, PersonalInfoSaveStatus.failure);
      expect(cubit.state.fieldErrors['firstName'], l10n.firstNameTooShort);

      await cubit.close();
    });

    test('saveProfile validates invalid email', () async {
      final repository = _TestAuthRepository();
      final cubit = PersonalInfoCubit(authRepository: repository);

      final result = await cubit.saveProfile(
        firstName: 'Noor',
        lastName: 'Ali',
        email: 'invalid-email',
        phone: '+966500000001',
        phoneNationalRaw: '500000001',
        phoneCountryIso3166: 'SA',
        l10n: l10n,
      );

      expect(repository.updateCalls, 0);
      expect(result, isNull);
      expect(cubit.state.saveStatus, PersonalInfoSaveStatus.failure);
      expect(cubit.state.fieldErrors['email'], l10n.enterValidEmail);

      await cubit.close();
    });

    test('saveProfile validates invalid national phone for country', () async {
      final repository = _TestAuthRepository();
      final cubit = PersonalInfoCubit(authRepository: repository);

      final result = await cubit.saveProfile(
        firstName: 'Noor',
        lastName: 'Ali',
        email: 'noor@example.com',
        phone: '+1123',
        phoneNationalRaw: '123',
        phoneCountryIso3166: 'US',
        l10n: l10n,
      );

      expect(repository.updateCalls, 0);
      expect(result, isNull);
      expect(cubit.state.saveStatus, PersonalInfoSaveStatus.failure);
      expect(cubit.state.fieldErrors['phone'], l10n.invalidPhoneForCountry);

      await cubit.close();
    });

    test('saveProfile includes gender and dob from state', () async {
      final repository = _TestAuthRepository();
      final cubit = PersonalInfoCubit(
        authRepository: repository,
        initialGender: 'female',
        initialDateOfBirth: DateTime(1995, 1, 20),
      );

      await cubit.saveProfile(
        firstName: 'Noor',
        lastName: 'Ali',
        email: 'noor@example.com',
        phone: '+966500000001',
        phoneNationalRaw: '500000001',
        phoneCountryIso3166: 'SA',
        l10n: l10n,
      );

      expect(repository.lastGender, 'female');
      expect(repository.lastDob, DateTime(1995, 1, 20));

      await cubit.close();
    });
  });
}

class _TestAuthRepository extends AuthRepository {
  _TestAuthRepository()
    : super(Dio(BaseOptions(baseUrl: 'https://test.local/')));

  int updateCalls = 0;
  String? lastFirstName;
  String? lastLastName;
  String? lastEmail;
  String? lastPhone;
  DateTime? lastDob;
  String? lastGender;
  String? lastAvatarPath;

  @override
  Future<ProfileUpdateResult> updateProfileWithPhoneHandling({
    String? firstName,
    String? lastName,
    String? email,
    String? phone,
    String? gender,
    DateTime? dob,
    String? avatarPath,
  }) async {
    updateCalls++;
    lastFirstName = firstName;
    lastLastName = lastName;
    lastEmail = email;
    lastPhone = phone;
    lastDob = dob;
    lastGender = gender;
    lastAvatarPath = avatarPath;
    return ProfileUpdateSuccess(
      AuthUser(
        name: '$firstName $lastName',
        firstName: firstName ?? 'Noor',
        lastName: lastName ?? 'Ali',
        email: email ?? 'noor@example.com',
        phone: phone ?? '+966500000001',
        dateOfBirth: dob ?? DateTime(1995, 1, 20),
        gender: gender ?? 'female',
        avatar: 'https://cdn.example.com/noor.jpg',
      ),
    );
  }
}
