import 'package:equatable/equatable.dart';

import '../data/models/notification_preferences.dart';

enum PushNotificationStatus { initial, loading, loaded, updating, error }

class PushNotificationState extends Equatable {
  final PushNotificationStatus status;
  final NotificationPreferences? preferences;
  final String? errorMessage;

  final bool allNotification;
  final bool beforeClassStart;
  final bool dayBeforeRemainder;
  final bool paymentConfirmation;
  final bool renewalRemainder;
  final bool promotionOffer;
  final bool appUpdate;
  final bool newChallenges;

  const PushNotificationState({
    this.status = PushNotificationStatus.initial,
    this.preferences,
    this.errorMessage,
    this.allNotification = false,
    this.beforeClassStart = false,
    this.dayBeforeRemainder = false,
    this.paymentConfirmation = false,
    this.renewalRemainder = false,
    this.promotionOffer = false,
    this.appUpdate = false,
    this.newChallenges = false,
  });

  bool get isLoading =>
      status == PushNotificationStatus.loading ||
      status == PushNotificationStatus.updating;

  PushNotificationState copyWith({
    PushNotificationStatus? status,
    NotificationPreferences? preferences,
    String? errorMessage,
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
      status: status ?? this.status,
      preferences: preferences ?? this.preferences,
      errorMessage: errorMessage,
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
  List<Object?> get props => [
        status,
        preferences,
        errorMessage,
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
