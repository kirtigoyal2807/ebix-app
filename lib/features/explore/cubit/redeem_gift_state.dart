import 'package:equatable/equatable.dart';

enum RedeemCodeValidation { none, empty }

class RedeemGiftState extends Equatable {
  const RedeemGiftState({
    this.isSubmitting = false,
    this.validation = RedeemCodeValidation.none,
    this.serverError,
    this.successPending = false,
    this.redeemedProductId,
  });

  final bool isSubmitting;
  final RedeemCodeValidation validation;
  final String? serverError;
  final bool successPending;

  /// From `POST /gifts/redeem` → `subscription.product.id` when present.
  final int? redeemedProductId;

  RedeemGiftState copyWith({
    bool? isSubmitting,
    RedeemCodeValidation? validation,
    String? serverError,
    bool clearServerError = false,
    bool? successPending,
    int? redeemedProductId,
    bool clearRedeemedProductId = false,
  }) {
    return RedeemGiftState(
      isSubmitting: isSubmitting ?? this.isSubmitting,
      validation: validation ?? this.validation,
      serverError: clearServerError ? null : (serverError ?? this.serverError),
      successPending: successPending ?? this.successPending,
      redeemedProductId: clearRedeemedProductId
          ? null
          : (redeemedProductId ?? this.redeemedProductId),
    );
  }

  @override
  List<Object?> get props => [
    isSubmitting,
    validation,
    serverError,
    successPending,
    redeemedProductId,
  ];
}
