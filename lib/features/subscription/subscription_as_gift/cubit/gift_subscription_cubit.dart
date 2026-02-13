import 'package:bloc/bloc.dart';

import 'gift_subscription_state.dart';

class GiftSubscriptionCubit extends Cubit<GiftSubscriptionState> {
  GiftSubscriptionCubit()
    : super(
        GiftSubscriptionState(
          deliveryOptions: DeliveryOption.values,
          selectedDeliveryOption: DeliveryOption.instantDelivery,
        ),
      );

  void changeDeliveryOption(DeliveryOption value) {
    emit(state.copyWith(selectedDeliveryOption: value));
  }
}
