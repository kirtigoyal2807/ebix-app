import 'package:equatable/equatable.dart';

enum PersonalInfoSaveStatus {
  idle,
  loading,
  success,
  failure,
  phoneVerificationRequired,
  emailVerificationRequired,
}

enum PersonalInfoResendStatus {
  idle,
  loading,
}

/// Last profile fields sent to the API — used to resend OTP via the same update call.
class ProfileUpdateResendPayload {
  const ProfileUpdateResendPayload({
    this.firstName,
    this.lastName,
    this.email,
    this.phone,
  });

  final String? firstName;
  final String? lastName;
  final String? email;
  final String? phone;
}

class PersonalInfoState extends Equatable {
  final String? gender;
  final DateTime? dateOfBirth;
  final PersonalInfoSaveStatus saveStatus;
  final String errorMessage;
  final Map<String, String> fieldErrors;
  final String? selectedAvatarPath;
  final bool removeAvatar;

  /// Phone number that requires OTP verification (when saveStatus is phoneVerificationRequired)
  final String? pendingPhoneNumber;

  /// Email pending verification (when saveStatus is emailVerificationRequired)
  final String? pendingEmail;

  final ProfileUpdateResendPayload? lastProfileUpdatePayload;
  final PersonalInfoResendStatus resendStatus;
  final String resendErrorMessage;

  const PersonalInfoState({
    this.gender,
    this.dateOfBirth,
    this.saveStatus = PersonalInfoSaveStatus.idle,
    this.errorMessage = '',
    this.fieldErrors = const {},
    this.selectedAvatarPath,
    this.removeAvatar = false,
    this.pendingPhoneNumber,
    this.pendingEmail,
    this.lastProfileUpdatePayload,
    this.resendStatus = PersonalInfoResendStatus.idle,
    this.resendErrorMessage = '',
  });

  PersonalInfoState copyWith({
    String? gender,
    DateTime? dateOfBirth,
    PersonalInfoSaveStatus? saveStatus,
    String? errorMessage,
    Map<String, String>? fieldErrors,
    String? selectedAvatarPath,
    bool? removeAvatar,
    bool clearSelectedAvatar = false,
    String? pendingPhoneNumber,
    bool resetPendingPhone = false,
    String? pendingEmail,
    bool resetPendingEmail = false,
    ProfileUpdateResendPayload? lastProfileUpdatePayload,
    bool clearLastProfileUpdatePayload = false,
    PersonalInfoResendStatus? resendStatus,
    String? resendErrorMessage,
  }) {
    return PersonalInfoState(
      gender: gender ?? this.gender,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      saveStatus: saveStatus ?? this.saveStatus,
      errorMessage: errorMessage ?? this.errorMessage,
      fieldErrors: fieldErrors ?? this.fieldErrors,
      selectedAvatarPath: clearSelectedAvatar
          ? null
          : (selectedAvatarPath ?? this.selectedAvatarPath),
      removeAvatar: removeAvatar ?? this.removeAvatar,
      pendingPhoneNumber: resetPendingPhone
          ? null
          : (pendingPhoneNumber ?? this.pendingPhoneNumber),
      pendingEmail: resetPendingEmail
          ? null
          : (pendingEmail ?? this.pendingEmail),
      lastProfileUpdatePayload: clearLastProfileUpdatePayload
          ? null
          : (lastProfileUpdatePayload ?? this.lastProfileUpdatePayload),
      resendStatus: resendStatus ?? this.resendStatus,
      resendErrorMessage: resendErrorMessage ?? this.resendErrorMessage,
    );
  }

  @override
  List<Object?> get props => [
    gender,
    dateOfBirth,
    saveStatus,
    errorMessage,
    fieldErrors,
    selectedAvatarPath,
    removeAvatar,
    pendingPhoneNumber,
    pendingEmail,
    lastProfileUpdatePayload,
    resendStatus,
    resendErrorMessage,
  ];
}
