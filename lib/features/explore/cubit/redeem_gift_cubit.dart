import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pilates_app/core/network/api_result.dart';
import 'package:pilates_app/core/network/network_exception.dart';

import '../data/gift_repository.dart';
import 'redeem_gift_state.dart';

class RedeemGiftCubit extends Cubit<RedeemGiftState> {
  RedeemGiftCubit(this._repository) : super(const RedeemGiftState());

  final GiftRepository _repository;

  void clearFieldFeedback() {
    if (state.validation == RedeemCodeValidation.none &&
        state.serverError == null) {
      return;
    }
    emit(
      state.copyWith(
        validation: RedeemCodeValidation.none,
        clearServerError: true,
      ),
    );
  }

  void consumeSuccess() {
    if (!state.successPending) return;
    emit(state.copyWith(successPending: false));
  }

  Future<void> redeem(String redemptionCodeRaw) async {
    final code = redemptionCodeRaw.trim();
    if (code.isEmpty) {
      emit(
        state.copyWith(
          validation: RedeemCodeValidation.empty,
          clearServerError: true,
        ),
      );
      return;
    }

    emit(
      state.copyWith(
        isSubmitting: true,
        validation: RedeemCodeValidation.none,
        clearServerError: true,
        successPending: false,
      ),
    );

    final result = await _repository.redeemGift(redemptionCode: code);

    switch (result) {
      case ApiSuccess():
        emit(state.copyWith(isSubmitting: false, successPending: true));
      case ApiFailure(:final exception):
        final fields = _mapFieldErrors(exception);
        final fieldMsg = fields['redemptioncode'] ?? fields['redemption_code'];
        final message = (fieldMsg ?? exception.message ?? '').trim();
        emit(
          state.copyWith(
            isSubmitting: false,
            serverError: message.isNotEmpty ? message : null,
          ),
        );
    }
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
