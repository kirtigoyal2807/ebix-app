import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pilates_app/core/network/api_result.dart';
import 'package:pilates_app/features/account/cubit/personal_info_state.dart';
import 'package:pilates_app/features/auth/data/auth_repository.dart';
import 'package:pilates_app/features/auth/data/models/auth_user.dart';

class PersonalInfoCubit extends Cubit<PersonalInfoState> {
  PersonalInfoCubit({
    required AuthRepository authRepository,
    String? initialGender,
    DateTime? initialDateOfBirth,
  }) : _authRepository = authRepository,
       super(
         PersonalInfoState(
           gender: initialGender,
           dateOfBirth: initialDateOfBirth,
         ),
       );

  final AuthRepository _authRepository;

  void updateGender(String val) => emit(state.copyWith(gender: val));

  void updateDateOfBirth(DateTime val) =>
      emit(state.copyWith(dateOfBirth: val));

  /// Calls `PUT /customers/profile`. On success emits [PersonalInfoSaveStatus.success]
  /// with the refreshed [AuthUser]; on failure emits [PersonalInfoSaveStatus.failure].
  Future<AuthUser?> saveProfile({
    required String firstName,
    required String lastName,
    required String phone,
  }) async {
    emit(
      state.copyWith(
        saveStatus: PersonalInfoSaveStatus.loading,
        errorMessage: '',
      ),
    );

    final fullName = [firstName.trim(), lastName.trim()]
        .where((s) => s.isNotEmpty)
        .join(' ');

    final result = await _authRepository.updateProfile(
      name: fullName.isNotEmpty ? fullName : null,
      phone: phone.isNotEmpty ? phone : null,
      gender: state.gender,
      dob: state.dateOfBirth,
    );

    switch (result) {
      case ApiSuccess<AuthUser>(:final data):
        emit(
          state.copyWith(
            saveStatus: PersonalInfoSaveStatus.success,
            errorMessage: '',
          ),
        );
        return data;
      case ApiFailure<AuthUser>(:final exception):
        emit(
          state.copyWith(
            saveStatus: PersonalInfoSaveStatus.failure,
            errorMessage: exception.message ?? 'Failed to update profile.',
          ),
        );
        return null;
    }
  }
}
