import 'package:bloc/bloc.dart';
import 'package:pilates_app/core/network/api_result.dart';
import 'package:pilates_app/core/network/network_exception.dart';

import '../data/referral_repository.dart';
import 'referral_program_state.dart';

class ReferralProgramCubit extends Cubit<ReferralProgramState> {
  ReferralProgramCubit(this._repository) : super(const ReferralProgramState());

  final ReferralRepository _repository;

  static const String _inviteChannelSms = 'sms';

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

  Future<void> sendInviteSms({
    required String inviteePhoneRaw,
    String? inviteeNameRaw,
  }) async {
    final phone = inviteePhoneRaw.trim();
    if (phone.isEmpty) {
      emit(
        state.copyWith(
          invitePhoneFieldIssue: InvitePhoneFieldIssue.empty,
          invitePhoneApiError: null,
        ),
      );
      return;
    }
    if (phone.length > 30) {
      emit(
        state.copyWith(
          invitePhoneFieldIssue: InvitePhoneFieldIssue.tooLong,
          invitePhoneApiError: null,
        ),
      );
      return;
    }

    emit(
      state.copyWith(
        inviteSubmitting: true,
        invitePhoneFieldIssue: InvitePhoneFieldIssue.none,
        invitePhoneApiError: null,
        inviteErrorSnackMessage: null,
      ),
    );

    final result = await _repository.sendInvitation(
      inviteePhone: phone,
      channel: _inviteChannelSms,
      inviteeName: inviteeNameRaw,
    );

    switch (result) {
      case ApiSuccess():
        emit(
          state.copyWith(
            inviteSubmitting: false,
            inviteSuccessSnackPending: true,
            invitePhoneFieldIssue: InvitePhoneFieldIssue.none,
            invitePhoneApiError: null,
            inviteErrorSnackMessage: null,
          ),
        );
      case ApiFailure(:final exception):
        final fields = _mapFieldErrors(exception);
        final phoneErr =
            fields['inviteephone'] ?? fields['invitee_phone'] ?? fields['phone'];
        emit(
          state.copyWith(
            inviteSubmitting: false,
            invitePhoneApiError: phoneErr,
            inviteErrorSnackMessage:
                phoneErr == null ? exception.message : null,
          ),
        );
    }
  }

  void consumeInviteSuccessSnack() {
    emit(state.copyWith(inviteSuccessSnackPending: false));
  }

  void consumeInviteErrorSnack() {
    emit(state.copyWith(inviteErrorSnackMessage: null));
  }

  void clearInvitePhoneFieldFeedback() {
    if (state.invitePhoneFieldIssue == InvitePhoneFieldIssue.none &&
        state.invitePhoneApiError == null) {
      return;
    }
    emit(
      state.copyWith(
        invitePhoneFieldIssue: InvitePhoneFieldIssue.none,
        invitePhoneApiError: null,
      ),
    );
  }

  Map<String, String> _mapFieldErrors(NetworkException exception) {
    final fields = <String, String>{};
    final raw = exception.fieldErrors;
    if (raw != null) {
      for (final entry in raw.entries) {
        if (entry.value.isNotEmpty) {
          fields[entry.key.toLowerCase()] = entry.value.first;
        }
      }
    }
    return fields;
  }
}
