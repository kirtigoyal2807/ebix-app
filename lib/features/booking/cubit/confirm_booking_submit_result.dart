import 'package:pilates_app/features/booking/data/classes_repository.dart';
import 'package:pilates_app/features/my_booking/data/models/booking_resource.dart';

/// Outcome of [ConfirmBookingCubit.submit]: package booking confirmation,
/// hosted single-session checkout, or error.
final class ConfirmBookingSubmitResult {
  const ConfirmBookingSubmitResult({
    this.confirmedBooking,
    this.pendingHostedPayment,
    this.errorMessage,
  });

  final BookingResource? confirmedBooking;

  /// When non-null, open [PurchaseSessionResult.paymentUrl] then call
  /// [ClassesRepository.confirmPayment] after a successful PSP return.
  final PurchaseSessionResult? pendingHostedPayment;

  final String? errorMessage;

  bool get hasWork =>
      confirmedBooking != null || pendingHostedPayment != null;
}
