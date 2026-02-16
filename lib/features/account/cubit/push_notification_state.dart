import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class PushNotificationState extends Equatable {
  final bool allNotification;
  final bool beforeClassStart;
  final bool dayBeforeRemainder;
  final bool paymentConfirmation;
  final bool renewalRemainder;
  final bool promotionOffer;
  final bool appUpdate;
  final bool newChallenges;

  PushNotificationState({
    this.allNotification = false,
    this.beforeClassStart = false,
    this.dayBeforeRemainder = false,
    this.paymentConfirmation = false,
    this.renewalRemainder = false,
    this.promotionOffer = false,
    this.appUpdate = false,
    this.newChallenges = false,
  });

  PushNotificationState copyWith({
    bool? allNotification,

    bool? beforeClassStart,

    bool? dayBeforeRemainder,

    bool? paymentConfirmation,

    bool? renewalRemainder,

    bool? promotionOffer,

    bool? appUpdate,

    bool? newChallenges,
  }) {
    return PushNotificationState(
      allNotification: allNotification ?? this.allNotification,
      beforeClassStart: beforeClassStart ?? this.beforeClassStart,
      dayBeforeRemainder: dayBeforeRemainder ?? this.dayBeforeRemainder,
      paymentConfirmation: paymentConfirmation ?? this.paymentConfirmation,
      renewalRemainder: renewalRemainder ?? this.renewalRemainder,
      promotionOffer: promotionOffer ?? this.promotionOffer,
      appUpdate: appUpdate ?? this.appUpdate,
      newChallenges: newChallenges ?? this.newChallenges,
    );
  }

  @override
  // TODO: implement props
  List<Object?> get props => [
    allNotification,
    beforeClassStart,
    dayBeforeRemainder,
    paymentConfirmation,
    renewalRemainder,
    promotionOffer,
    appUpdate,
    newChallenges,
  ];
}
