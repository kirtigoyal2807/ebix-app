import 'package:equatable/equatable.dart';

enum PersonalInfoSaveStatus { idle, loading, success, failure, phoneVerificationRequired }

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

  const PersonalInfoState({
    this.gender,
    this.dateOfBirth,
    this.saveStatus = PersonalInfoSaveStatus.idle,
    this.errorMessage = '',
    this.fieldErrors = const {},
    this.selectedAvatarPath,
    this.removeAvatar = false,
    this.pendingPhoneNumber,
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
      pendingPhoneNumber: pendingPhoneNumber ?? this.pendingPhoneNumber,
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
  ];
}
