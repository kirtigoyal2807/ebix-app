import 'package:equatable/equatable.dart';

enum PersonalInfoSaveStatus { idle, loading, success, failure }

class PersonalInfoState extends Equatable {
  final String? gender;
  final DateTime? dateOfBirth;
  final PersonalInfoSaveStatus saveStatus;
  final String errorMessage;
  final String? selectedAvatarPath;
  final bool removeAvatar;

  const PersonalInfoState({
    this.gender,
    this.dateOfBirth,
    this.saveStatus = PersonalInfoSaveStatus.idle,
    this.errorMessage = '',
    this.selectedAvatarPath,
    this.removeAvatar = false,
  });

  PersonalInfoState copyWith({
    String? gender,
    DateTime? dateOfBirth,
    PersonalInfoSaveStatus? saveStatus,
    String? errorMessage,
    String? selectedAvatarPath,
    bool? removeAvatar,
    bool clearSelectedAvatar = false,
  }) {
    return PersonalInfoState(
      gender: gender ?? this.gender,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      saveStatus: saveStatus ?? this.saveStatus,
      errorMessage: errorMessage ?? this.errorMessage,
      selectedAvatarPath: clearSelectedAvatar
          ? null
          : (selectedAvatarPath ?? this.selectedAvatarPath),
      removeAvatar: removeAvatar ?? this.removeAvatar,
    );
  }

  @override
  List<Object?> get props => [
    gender,
    dateOfBirth,
    saveStatus,
    errorMessage,
    selectedAvatarPath,
    removeAvatar,
  ];
}
