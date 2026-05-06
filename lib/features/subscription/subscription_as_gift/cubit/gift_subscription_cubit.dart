import 'package:bloc/bloc.dart';

import 'package:pilates_app/core/network/api_result.dart';
import 'package:pilates_app/core/network/network_exception.dart';
import 'package:pilates_app/features/checkout/data/checkout_repository.dart';

import 'gift_subscription_state.dart';

class GiftSubscriptionCubit extends Cubit<GiftSubscriptionState> {
  GiftSubscriptionCubit(
    this._checkoutRepository, {
    required this.checkoutId,
  }) : super(
          const GiftSubscriptionState(
            deliveryOptions: DeliveryOption.values,
            selectedDeliveryOption: DeliveryOption.instantDelivery,
            scheduledDeliveryDateIso: null,
          ),
        );

  final CheckoutRepository _checkoutRepository;

  /// Checkout session id from the purchase flow.
  final String? checkoutId;

  void selectInstantDelivery() {
    emit(
      state.copyWith(
        selectedDeliveryOption: DeliveryOption.instantDelivery,
        clearScheduledDeliveryDateIso: true,
      ),
    );
  }

  void selectScheduledDeliveryWithDate(String yyyyMmDd) {
    emit(
      state.copyWith(
        selectedDeliveryOption: DeliveryOption.scheduledDelivery,
        scheduledDeliveryDateIso: yyyyMmDd,
      ),
    );
  }

  /// `POST .../checkout/{id}/gift` — envelope `message` (e.g. `"Not a gift"`) on failure.
  Future<void> submitGift({
    /// Prefer this when resolving the session id at tap time (avoids stale cubit id).
    String? checkoutSessionId,
    required String recipientName,
    required String recipientEmail,
    required String recipientPhone,
    required String message,
    String? deliveryDate,
  }) async {
    final id = (checkoutSessionId ?? checkoutId)?.trim();
    if (id == null || id.isEmpty) {
      emit(
        state.copyWith(
          submitStatus: GiftSubmitStatus.failure,
          submitErrorMessage: 'Missing checkout session',
        ),
      );
      return;
    }

    emit(
      state.copyWith(
        submitStatus: GiftSubmitStatus.loading,
        clearSubmitError: true,
      ),
    );

    final result = await _checkoutRepository.submitGiftDetails(
      checkoutId: id,
      recipientName: recipientName,
      recipientEmail: recipientEmail,
      recipientPhone: recipientPhone,
      message: message,
      deliveryDate: deliveryDate,
    );

    if (result.isSuccess) {
      emit(
        state.copyWith(
          submitStatus: GiftSubmitStatus.success,
          clearSubmitError: true,
          submittedRecipientName: recipientName.trim(),
          submittedRecipientEmail: recipientEmail.trim(),
        ),
      );
      return;
    }

    final ex = result.exceptionOrNull;
    final raw = ex != null ? _giftFailureMessageFromException(ex) : null;
    emit(
      state.copyWith(
        submitStatus: GiftSubmitStatus.failure,
        submitErrorMessage:
            (raw != null && raw.isNotEmpty) ? raw : 'Request failed',
      ),
    );
  }

  /// Prefers API `errors` map (e.g. `dependent`, `recipientEmail`) over top-level `message`.
  static String _giftFailureMessageFromException(NetworkException e) {
    final fe = e.fieldErrors;
    if (fe != null && fe.isNotEmpty) {
      const priority = <String>[
        'dependent',
        'recipientName',
        'recipientEmail',
        'recipientPhone',
        'deliveryDate',
        'message',
      ];
      for (final key in priority) {
        final list = fe[key];
        if (list == null) continue;
        for (final item in list) {
          final s = item.trim();
          if (s.isNotEmpty) return s;
        }
      }
      for (final list in fe.values) {
        for (final item in list) {
          final s = item.trim();
          if (s.isNotEmpty) return s;
        }
      }
    }
    return e.message?.trim() ?? '';
  }

  void resetSubmitStatus() {
    emit(
      state.copyWith(
        submitStatus: GiftSubmitStatus.idle,
        clearSubmitError: true,
      ),
    );
  }
}
