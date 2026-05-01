import 'package:equatable/equatable.dart';

enum GiftSubmitStatus { idle, loading, success, failure }

class GiftSubscriptionState extends Equatable {
  final List<DeliveryOption> deliveryOptions;
  final DeliveryOption selectedDeliveryOption;
  final GiftSubmitStatus submitStatus;
  final String? submitErrorMessage;

  const GiftSubscriptionState({
    required this.deliveryOptions,
    required this.selectedDeliveryOption,
    this.submitStatus = GiftSubmitStatus.idle,
    this.submitErrorMessage,
  });

  GiftSubscriptionState copyWith({
    List<DeliveryOption>? deliveryOptions,
    DeliveryOption? selectedDeliveryOption,
    GiftSubmitStatus? submitStatus,
    String? submitErrorMessage,
    bool clearSubmitError = false,
  }) {
    return GiftSubscriptionState(
      deliveryOptions: deliveryOptions ?? this.deliveryOptions,
      selectedDeliveryOption:
          selectedDeliveryOption ?? this.selectedDeliveryOption,
      submitStatus: submitStatus ?? this.submitStatus,
      submitErrorMessage:
          clearSubmitError ? null : (submitErrorMessage ?? this.submitErrorMessage),
    );
  }

  @override
  List<Object?> get props =>
      [deliveryOptions, selectedDeliveryOption, submitStatus, submitErrorMessage];
}

enum DeliveryOption { instantDelivery, scheduledDelivery }
