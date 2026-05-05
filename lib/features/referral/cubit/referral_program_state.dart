import 'package:equatable/equatable.dart';

import '../data/models/referral_program_details.dart';

enum ReferralProgramStatus { initial, loading, success, failure }

class ReferralProgramState extends Equatable {
  const ReferralProgramState({
    this.status = ReferralProgramStatus.initial,
    this.program,
    this.errorMessage,
  });

  final ReferralProgramStatus status;
  final ReferralProgramDetails? program;
  final String? errorMessage;

  static const Object _unset = Object();

  ReferralProgramState copyWith({
    ReferralProgramStatus? status,
    ReferralProgramDetails? program,
    Object? errorMessage = _unset,
  }) {
    return ReferralProgramState(
      status: status ?? this.status,
      program: program ?? this.program,
      errorMessage: identical(errorMessage, _unset)
          ? this.errorMessage
          : errorMessage as String?,
    );
  }

  @override
  List<Object?> get props => [status, program, errorMessage];
}
