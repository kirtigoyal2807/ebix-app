import 'package:bloc/bloc.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:pilates_app/core/localization/arb/app_localizations.dart';
import 'package:pilates_app/core/network/api_result.dart';
import 'package:pilates_app/core/network/network_exception.dart';
import 'package:pilates_app/core/validation/phone_number_country_validation.dart';

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
        referralHistoryStatus: ReferralHistoryStatus.loading,
        errorMessage: null,
        referralHistoryErrorMessage: null,
        referralHistory: const [],
      ),
    );

    final programFuture = _repository.getProgramDetails();
    final historyFuture = _repository.getReferralHistory();

    final programResult = await programFuture;

    switch (programResult) {
      case ApiSuccess(:final data):
        emit(
          ReferralProgramState(
            status: ReferralProgramStatus.success,
            program: data,
            errorMessage: null,
            referralHistoryStatus: ReferralHistoryStatus.loading,
            referralHistory: const [],
            referralHistoryErrorMessage: null,
            inviteSubmitting: state.inviteSubmitting,
            invitePhoneFieldIssue: state.invitePhoneFieldIssue,
            invitePhoneApiError: state.invitePhoneApiError,
            inviteSuccessSnackPending: state.inviteSuccessSnackPending,
            inviteErrorSnackMessage: state.inviteErrorSnackMessage,
          ),
        );
      case ApiFailure(:final exception):
        emit(
          ReferralProgramState(
            status: ReferralProgramStatus.failure,
            program: state.program,
            errorMessage: exception.message,
            referralHistoryStatus: ReferralHistoryStatus.loading,
            referralHistory: const [],
            referralHistoryErrorMessage: null,
            inviteSubmitting: state.inviteSubmitting,
            invitePhoneFieldIssue: state.invitePhoneFieldIssue,
            invitePhoneApiError: state.invitePhoneApiError,
            inviteSuccessSnackPending: state.inviteSuccessSnackPending,
            inviteErrorSnackMessage: state.inviteErrorSnackMessage,
          ),
        );
    }

    final historyResult = await historyFuture;

    switch (historyResult) {
      case ApiSuccess(:final data):
        emit(
          state.copyWith(
            referralHistoryStatus: ReferralHistoryStatus.success,
            referralHistory: data,
            referralHistoryErrorMessage: null,
          ),
        );
      case ApiFailure(:final exception):
        emit(
          state.copyWith(
            referralHistoryStatus: ReferralHistoryStatus.failure,
            referralHistory: const [],
            referralHistoryErrorMessage: exception.message,
          ),
        );
    }
  }

  Future<void> sendInviteSms({
    required String inviteePhoneRaw,
    required String? inviteeCountryIso,
    String? inviteeNameRaw,
    required AppLocalizations l10n,
  }) async {
    final name = inviteeNameRaw?.trim() ?? '';
    final phone = inviteePhoneRaw.trim();
    final countryIso = inviteeCountryIso ?? 'SA';

    final inviteNameFieldIssue = name.isEmpty
        ? InviteNameFieldIssue.empty
        : InviteNameFieldIssue.none;

    final phoneDigits = phone.replaceAll(RegExp(r'\D'), '');
    final InvitePhoneFieldIssue invitePhoneFieldIssue;
    if (phoneDigits.isEmpty) {
      invitePhoneFieldIssue = InvitePhoneFieldIssue.empty;
    } else if (!PhoneNumberCountryValidation.isValidNationalNumber(
          iso3166Alpha2: countryIso,
          nationalDigitsOnly: phoneDigits,
        )) {
      invitePhoneFieldIssue = InvitePhoneFieldIssue.invalid;
    } else {
      invitePhoneFieldIssue = InvitePhoneFieldIssue.none;
    }

    if (inviteNameFieldIssue != InviteNameFieldIssue.none ||
        invitePhoneFieldIssue != InvitePhoneFieldIssue.none) {
      emit(
        state.copyWith(
          inviteNameFieldIssue: inviteNameFieldIssue,
          inviteNameApiError: null,
          invitePhoneFieldIssue: invitePhoneFieldIssue,
          invitePhoneApiError: null,
        ),
      );
      return;
    }

    // Compose E.164 phone number
    final nationalDigits = PhoneNumberCountryValidation.normalizedNationalDigitsForE164(
      iso3166Alpha2: countryIso,
      rawNationalField: phone,
    );
    final countryCode = CountryCode.tryFromCountryCode(countryIso)?.dialCode ?? '+966';
    final phoneE164 = '$countryCode$nationalDigits';

    emit(
      state.copyWith(
        inviteSubmitting: true,
        inviteNameFieldIssue: InviteNameFieldIssue.none,
        inviteNameApiError: null,
        invitePhoneFieldIssue: InvitePhoneFieldIssue.none,
        invitePhoneApiError: null,
        inviteErrorSnackMessage: null,
      ),
    );

    final result = await _repository.sendInvitation(
      inviteePhone: phoneE164,
      channel: _inviteChannelSms,
      inviteeName: name,
    );

    switch (result) {
      case ApiSuccess():
        emit(
          state.copyWith(
            inviteSubmitting: false,
            inviteSuccessSnackPending: true,
            inviteNameFieldIssue: InviteNameFieldIssue.none,
            inviteNameApiError: null,
            invitePhoneFieldIssue: InvitePhoneFieldIssue.none,
            invitePhoneApiError: null,
            inviteErrorSnackMessage: null,
          ),
        );
      case ApiFailure(:final exception):
        final fields = _mapFieldErrors(exception);
        final phoneErr =
            fields['inviteephone'] ??
            fields['invitee_phone'] ??
            fields['phone'];
        final nameErr =
            fields['inviteename'] ??
            fields['invitee_name'] ??
            fields['name'];
        emit(
          state.copyWith(
            inviteSubmitting: false,
            inviteNameApiError: nameErr,
            invitePhoneApiError: phoneErr,
            inviteErrorSnackMessage: (phoneErr == null && nameErr == null)
                ? exception.message
                : null,
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

  void clearInviteNameFieldFeedback() {
    if (state.inviteNameFieldIssue == InviteNameFieldIssue.none &&
        state.inviteNameApiError == null) {
      return;
    }
    emit(
      state.copyWith(
        inviteNameFieldIssue: InviteNameFieldIssue.none,
        inviteNameApiError: null,
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
