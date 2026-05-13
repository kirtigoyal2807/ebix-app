import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pilates_app/core/localization/arb/app_localizations.dart';
import 'package:pilates_app/core/validation/phone_number_country_validation.dart';
import 'package:pilates_app/features/account/cubit/personal_info_state.dart';
import 'package:pilates_app/features/account/data/models/profile_update_result.dart';
import 'package:pilates_app/features/auth/data/auth_repository.dart';
import 'package:pilates_app/features/auth/data/models/auth_user.dart';

class PersonalInfoCubit extends Cubit<PersonalInfoState> {
  PersonalInfoCubit({
    required AuthRepository authRepository,
    String? initialGender,
    DateTime? initialDateOfBirth,
  }) : _authRepository = authRepository,
       _imagePicker = ImagePicker(),
       super(
         PersonalInfoState(
           gender: initialGender,
           dateOfBirth: initialDateOfBirth,
         ),
       );

  final AuthRepository _authRepository;
  final ImagePicker _imagePicker;

  void updateGender(String val) => emit(state.copyWith(gender: val));

  void updateDateOfBirth(DateTime val) =>
      emit(state.copyWith(dateOfBirth: val));

  Future<void> pickImageFromCamera() async {
    final XFile? image = await _imagePicker.pickImage(
      source: ImageSource.camera,
      maxWidth: 1024,
      maxHeight: 1024,
      imageQuality: 85,
    );
    if (image != null) {
      emit(state.copyWith(selectedAvatarPath: image.path, removeAvatar: false));
    }
  }

  Future<void> pickImageFromGallery() async {
    final XFile? image = await _imagePicker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 1024,
      maxHeight: 1024,
      imageQuality: 85,
    );
    if (image != null) {
      emit(state.copyWith(selectedAvatarPath: image.path, removeAvatar: false));
    }
  }

  void removeProfilePicture() {
    emit(state.copyWith(clearSelectedAvatar: true, removeAvatar: true));
  }

  /// Calls `PUT /customers/profile`. On success emits [PersonalInfoSaveStatus.success]
  /// with the refreshed [AuthUser]; on phone change emits [PersonalInfoSaveStatus.phoneVerificationRequired];
  /// on failure emits [PersonalInfoSaveStatus.failure].
  Future<AuthUser?> saveProfile({
    required String firstName,
    required String lastName,
    required String email,
    required String phone,
    required String phoneNationalRaw,
    required String phoneCountryIso3166,
    required AppLocalizations l10n,
  }) async {
    emit(
      state.copyWith(
        saveStatus: PersonalInfoSaveStatus.loading,
        errorMessage: '',
        fieldErrors: {},
        pendingPhoneNumber: null,
      ),
    );

    // Client-side validation
    final trimmedFirst = firstName.trim();
    final trimmedLast = lastName.trim();
    final trimmedEmail = email.trim();

    final fieldErrors = <String, String>{};

    if (trimmedFirst.isEmpty || trimmedFirst.length < 2) {
      fieldErrors['firstName'] = l10n.firstNameTooShort;
    } else if (trimmedFirst.length > 120) {
      fieldErrors['firstName'] = l10n.firstNameTooLong;
    }

    if (trimmedLast.isEmpty || trimmedLast.length < 2) {
      fieldErrors['lastName'] = l10n.lastNameTooShort;
    } else if (trimmedLast.length > 120) {
      fieldErrors['lastName'] = l10n.lastNameTooLong;
    }

    if (trimmedEmail.isNotEmpty) {
      final emailRegex = RegExp(
        r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$",
      );
      if (!emailRegex.hasMatch(trimmedEmail)) {
        fieldErrors['email'] = l10n.enterValidEmail;
      }
    }

    // Matches [PhoneNumberField]: show error only when NSN has enough digits to validate.
    const minNationalDigitsForCountryValidation = 3;
    final iso = phoneCountryIso3166.trim().toUpperCase();
    if (iso.length == 2) {
      final phoneDigits =
          phoneNationalRaw.replaceAll(RegExp(r'\D'), '');
      if (phoneDigits.isNotEmpty &&
          phoneDigits.length >= minNationalDigitsForCountryValidation &&
          !PhoneNumberCountryValidation.isValidNationalNumber(
            iso3166Alpha2: iso,
            nationalDigitsOnly: phoneDigits,
          )) {
        fieldErrors['phone'] = l10n.invalidPhoneForCountry;
      }
    }

    if (fieldErrors.isNotEmpty) {
      emit(
        state.copyWith(
          saveStatus: PersonalInfoSaveStatus.failure,
          fieldErrors: fieldErrors,
          errorMessage: fieldErrors.values.first,
        ),
      );
      return null;
    }

    final result = await _authRepository.updateProfileWithPhoneHandling(
      firstName: trimmedFirst.isNotEmpty ? trimmedFirst : null,
      lastName: trimmedLast.isNotEmpty ? trimmedLast : null,
      email: trimmedEmail.isNotEmpty ? trimmedEmail : null,
      phone: phone.isNotEmpty ? phone : null,
      gender: state.gender,
      dob: state.dateOfBirth,
      avatarPath: state.selectedAvatarPath,
    );

    switch (result) {
      case ProfileUpdateSuccess(:final user):
        emit(
          state.copyWith(
            saveStatus: PersonalInfoSaveStatus.success,
            errorMessage: '',
          ),
        );
        return user;
      case ProfileUpdatePhoneVerificationRequired(:final phone):
        emit(
          state.copyWith(
            saveStatus: PersonalInfoSaveStatus.phoneVerificationRequired,
            pendingPhoneNumber: phone,
            errorMessage: '',
          ),
        );
        return null;
      case ProfileUpdateFailure(:final message, :final fieldErrors):
        emit(
          state.copyWith(
            saveStatus: PersonalInfoSaveStatus.failure,
            errorMessage: message,
            fieldErrors: fieldErrors,
          ),
        );
        return null;
    }
  }

  /// Reset status to idle (useful after navigating to OTP screen).
  void resetStatus() {
    emit(state.copyWith(saveStatus: PersonalInfoSaveStatus.idle));
  }
}
