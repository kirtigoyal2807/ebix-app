import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:pilates_app/features/account/cubit/push_notification_state.dart';

class PushNotificationCubit extends Cubit<PushNotificationState> {
  PushNotificationCubit() : super(PushNotificationState());

  void changeAllNotification(bool value) {
    emit(state.copyWith(allNotification: value));
  }

  void changeBeforeClassStart(bool value) {
    emit(state.copyWith(beforeClassStart: value));
  }

  void changeDayBeforeRemainder(bool value) {
    emit(state.copyWith(dayBeforeRemainder: value));
  }

  void changePaymentConfirmation(bool value) {
    emit(state.copyWith(paymentConfirmation: value));
  }

  void changeRenewalRemainder(bool value) {
    emit(state.copyWith(renewalRemainder: value));
  }

  void changePromotionOffer(bool value) {
    emit(state.copyWith(promotionOffer: value));
  }

  void changeAppUpdate(bool value) {
    emit(state.copyWith(appUpdate: value));
  }

  void changeNewChallenges(bool value) {
    emit(state.copyWith(newChallenges: value));
  }
}
