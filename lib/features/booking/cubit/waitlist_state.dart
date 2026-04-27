import 'package:equatable/equatable.dart';
import 'package:pilates_app/features/my_booking/data/models/booking_resource.dart';

class WaitlistState extends Equatable {
  const WaitlistState({
    this.isSubmitting = false,
    this.errorMessage,
    this.bookingResult,
  });

  final bool isSubmitting;
  final String? errorMessage;

  /// Populated after successful waitlist join.
  final BookingResource? bookingResult;

  static const Object _unset = Object();

  WaitlistState copyWith({
    bool? isSubmitting,
    Object? errorMessage = _unset,
    BookingResource? bookingResult,
  }) {
    return WaitlistState(
      isSubmitting: isSubmitting ?? this.isSubmitting,
      errorMessage: identical(errorMessage, _unset)
          ? this.errorMessage
          : errorMessage as String?,
      bookingResult: bookingResult ?? this.bookingResult,
    );
  }

  @override
  List<Object?> get props => [isSubmitting, errorMessage, bookingResult];
}
