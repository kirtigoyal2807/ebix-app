import 'package:equatable/equatable.dart';

class PauseSubscriptionState extends Equatable {
  final DateTime? startDate;
  final DateTime? endDate;
  final bool isSubmitting;
  final String? submitError;

  const PauseSubscriptionState({
    this.startDate,
    this.endDate,
    this.isSubmitting = false,
    this.submitError,
  });

  PauseSubscriptionState copyWith({
    DateTime? startDate,
    DateTime? endDate,
    bool? isSubmitting,
    String? submitError,
    bool clearSubmitError = false,
  }) {
    return PauseSubscriptionState(
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      submitError:
          clearSubmitError ? null : (submitError ?? this.submitError),
    );
  }

  @override
  List<Object?> get props =>
      [startDate, endDate, isSubmitting, submitError];
}
