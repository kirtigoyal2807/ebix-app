import 'package:equatable/equatable.dart';

import '../data/models/referral_program_details.dart';

enum ReferralProgramStatus { initial, loading, success, failure }

enum InvitePhoneFieldIssue { none, empty, tooLong }

class ReferralProgramState extends Equatable {
  const ReferralProgramState({
    this.status = ReferralProgramStatus.initial,
    this.program,
    this.errorMessage,
    this.inviteSubmitting = false,
    this.invitePhoneFieldIssue = InvitePhoneFieldIssue.none,
    this.invitePhoneApiError,
    this.inviteSuccessSnackPending = false,
    this.inviteErrorSnackMessage,
  });

  final ReferralProgramStatus status;
  final ReferralProgramDetails? program;
  final String? errorMessage;

  final bool inviteSubmitting;
  final InvitePhoneFieldIssue invitePhoneFieldIssue;
  final String? invitePhoneApiError;
  final bool inviteSuccessSnackPending;
  final String? inviteErrorSnackMessage;

  static const Object _unset = Object();

  ReferralProgramState copyWith({
    ReferralProgramStatus? status,
    ReferralProgramDetails? program,
    Object? errorMessage = _unset,
    bool? inviteSubmitting,
    InvitePhoneFieldIssue? invitePhoneFieldIssue,
    Object? invitePhoneApiError = _unset,
    bool? inviteSuccessSnackPending,
    Object? inviteErrorSnackMessage = _unset,
  }) {
    return ReferralProgramState(
      status: status ?? this.status,
      program: program ?? this.program,
      errorMessage: identical(errorMessage, _unset)
          ? this.errorMessage
          : errorMessage as String?,
      inviteSubmitting: inviteSubmitting ?? this.inviteSubmitting,
      invitePhoneFieldIssue: invitePhoneFieldIssue ?? this.invitePhoneFieldIssue,
      invitePhoneApiError: identical(invitePhoneApiError, _unset)
          ? this.invitePhoneApiError
          : invitePhoneApiError as String?,
      inviteSuccessSnackPending:
          inviteSuccessSnackPending ?? this.inviteSuccessSnackPending,
      inviteErrorSnackMessage: identical(inviteErrorSnackMessage, _unset)
          ? this.inviteErrorSnackMessage
          : inviteErrorSnackMessage as String?,
    );
  }

  @override
  List<Object?> get props => [
        status,
        program,
        errorMessage,
        inviteSubmitting,
        invitePhoneFieldIssue,
        invitePhoneApiError,
        inviteSuccessSnackPending,
        inviteErrorSnackMessage,
      ];
}
