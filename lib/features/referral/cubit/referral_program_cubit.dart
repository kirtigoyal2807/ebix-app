import 'package:bloc/bloc.dart';
import 'package:pilates_app/core/network/api_result.dart';

import '../data/referral_repository.dart';
import 'referral_program_state.dart';

class ReferralProgramCubit extends Cubit<ReferralProgramState> {
  ReferralProgramCubit(this._repository) : super(const ReferralProgramState());

  final ReferralRepository _repository;

  Future<void> load() async {
    emit(
      state.copyWith(
        status: ReferralProgramStatus.loading,
        errorMessage: null,
      ),
    );
    final result = await _repository.getProgramDetails();
    switch (result) {
      case ApiSuccess(:final data):
        emit(
          ReferralProgramState(
            status: ReferralProgramStatus.success,
            program: data,
          ),
        );
      case ApiFailure(:final exception):
        emit(
          ReferralProgramState(
            status: ReferralProgramStatus.failure,
            program: state.program,
            errorMessage: exception.message,
          ),
        );
    }
  }
}
