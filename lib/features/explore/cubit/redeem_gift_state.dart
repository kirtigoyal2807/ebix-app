import 'package:equatable/equatable.dart';

enum RedeemCodeValidation { none, empty }

class RedeemGiftState extends Equatable {
  const RedeemGiftState({
    this.isSubmitting = false,
    this.validation = RedeemCodeValidation.none,
    this.serverError,
    this.successPending = false,
  });

  final bool isSubmitting;
  final RedeemCodeValidation validation;
  final String? serverError;
  final bool successPending;

  RedeemGiftState copyWith({
    bool? isSubmitting,
    RedeemCodeValidation? validation,
    String? serverError,
    bool clearServerError = false,
    bool? successPending,
  }) {
    return RedeemGiftState(
      isSubmitting: isSubmitting ?? this.isSubmitting,
      validation: validation ?? this.validation,
      serverError: clearServerError ? null : (serverError ?? this.serverError),
      successPending: successPending ?? this.successPending,
    );
  }

  @override
  List<Object?> get props => [
    isSubmitting,
    validation,
    serverError,
    successPending,
  ];
}
