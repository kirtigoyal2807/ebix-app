import 'package:equatable/equatable.dart';

class GiftSubscriptionState extends Equatable {
  final List<DeliveryOption> deliveryOptions;
  final DeliveryOption selectedDeliveryOption;

  const GiftSubscriptionState({
    required this.deliveryOptions,
    required this.selectedDeliveryOption,
  });

  GiftSubscriptionState copyWith({
    List<DeliveryOption>? deliveryOptions,
    DeliveryOption? selectedDeliveryOption,
  }) {
    return GiftSubscriptionState(
      deliveryOptions: deliveryOptions ?? this.deliveryOptions,
      selectedDeliveryOption:
          selectedDeliveryOption ?? this.selectedDeliveryOption,
    );
  }

  @override
  // TODO: implement props
  List<Object?> get props => [deliveryOptions, selectedDeliveryOption];
}

enum DeliveryOption { instantDelivery, scheduledDelivery }
