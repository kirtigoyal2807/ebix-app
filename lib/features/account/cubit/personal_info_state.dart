import 'package:equatable/equatable.dart';

enum PersonalInfoSaveStatus { idle, loading, success, failure }

class PersonalInfoState extends Equatable {
  final String? gender;
  final DateTime? dateOfBirth;
  final PersonalInfoSaveStatus saveStatus;
  final String errorMessage;

  const PersonalInfoState({
    this.gender,
    this.dateOfBirth,
    this.saveStatus = PersonalInfoSaveStatus.idle,
    this.errorMessage = '',
  });

  PersonalInfoState copyWith({
    String? gender,
    DateTime? dateOfBirth,
    PersonalInfoSaveStatus? saveStatus,
    String? errorMessage,
  }) {
    return PersonalInfoState(
      gender: gender ?? this.gender,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      saveStatus: saveStatus ?? this.saveStatus,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    gender,
    dateOfBirth,
    saveStatus,
    errorMessage,
  ];
}
