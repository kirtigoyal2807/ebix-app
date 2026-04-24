import 'package:equatable/equatable.dart';

class ConfirmBookingState extends Equatable {
  const ConfirmBookingState({
    this.agreePolicy = false,
    this.isSubmitting = false,
    this.errorMessage,
  });

  final bool agreePolicy;
  final bool isSubmitting;
  final String? errorMessage;

  static const Object _unset = Object();

  ConfirmBookingState copyWith({
    bool? agreePolicy,
    bool? isSubmitting,
    Object? errorMessage = _unset,
  }) {
    return ConfirmBookingState(
      agreePolicy: agreePolicy ?? this.agreePolicy,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      errorMessage: identical(errorMessage, _unset)
          ? this.errorMessage
          : errorMessage as String?,
    );
  }

  @override
  List<Object?> get props => [agreePolicy, isSubmitting, errorMessage];
}
