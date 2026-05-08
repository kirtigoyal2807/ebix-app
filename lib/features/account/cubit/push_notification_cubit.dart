import 'package:bloc/bloc.dart';
import 'package:pilates_app/core/network/api_result.dart';
import 'package:pilates_app/features/account/cubit/push_notification_state.dart';
import 'package:pilates_app/features/account/data/models/notification_preferences.dart';
import 'package:pilates_app/features/account/data/notification_preferences_repository.dart';

class PushNotificationCubit extends Cubit<PushNotificationState> {
  PushNotificationCubit({required NotificationPreferencesRepository repository})
    : _repository = repository,
      super(const PushNotificationState());

  final NotificationPreferencesRepository _repository;

  bool _channelPush(
    Map<String, dynamic> channels,
    List<String> keys, {
    bool fallback = false,
  }) {
    for (final key in keys) {
      final value = channels[key];
      if (value is bool) {
        return value;
      }
    }
    return fallback;
  }

  Map<String, dynamic> _pushByChannel(NotificationPreferences data) {
    return data.channels.map((key, value) => MapEntry(key, value.push));
  }

  PushNotificationState _stateFromPreferences(
    PushNotificationState current,
    NotificationPreferences data,
  ) {
    final channelPushValues = _pushByChannel(data);

    return current.copyWith(
      status: PushNotificationStatus.loaded,
      preferences: data,
      allNotification: data.push,
      beforeClassStart: _channelPush(channelPushValues, [
        'before_class_starts',
        'class_reminder',
      ]),
      dayBeforeRemainder: _channelPush(
        channelPushValues,
        [
          'day_before_reminder',
          'class_day_before_reminder',
          'class_reminder_day_before',
        ],
        fallback: _channelPush(channelPushValues, ['class_reminder']),
      ),
      paymentConfirmation: _channelPush(channelPushValues, [
        'payment_confirmation',
        'booking_confirmed',
      ]),
      renewalRemainder: _channelPush(
        channelPushValues,
        ['renewal_reminder', 'subscription_renewal'],
        fallback: _channelPush(channelPushValues, ['booking_confirmed']),
      ),
      promotionOffer: _channelPush(channelPushValues, [
        'promotions',
        'promotions_offers',
        'marketing_updates',
      ]),
      appUpdate: _channelPush(channelPushValues, [
        'app_updates',
        'app_update',
      ], fallback: data.push),
      newChallenges: _channelPush(
        channelPushValues,
        ['new_challenges', 'challenges'],
        fallback: _channelPush(channelPushValues, ['points_earned']),
      ),
      rewardEarn: _channelPush(channelPushValues, [
        'rewards_earned',
        'points_earned',
      ]),
    );
  }

  Future<void> loadPreferences() async {
    emit(
      state.copyWith(
        status: PushNotificationStatus.loading,
        errorMessage: null,
      ),
    );

    final result = await _repository.getPreferences();

    switch (result) {
      case ApiSuccess(:final data):
        emit(_stateFromPreferences(state, data));
      case ApiFailure(:final exception):
        emit(
          state.copyWith(
            status: PushNotificationStatus.error,
            errorMessage: exception.message,
          ),
        );
    }
  }

  Future<void> _updatePreference(Map<String, dynamic> data) async {
    emit(
      state.copyWith(
        status: PushNotificationStatus.updating,
        errorMessage: null,
      ),
    );

    final result = await _repository.updatePreferences(data);

    switch (result) {
      case ApiSuccess(:final data):
        emit(_stateFromPreferences(state, data));
      case ApiFailure(:final exception):
        emit(
          state.copyWith(
            status: PushNotificationStatus.error,
            errorMessage: exception.message,
          ),
        );
    }
  }

  Future<void> changeAllNotification(bool value) async {
    emit(state.copyWith(allNotification: value));
    await _updatePreference({'push': value});
  }

  Future<void> changeBeforeClassStart(bool value) async {
    emit(state.copyWith(beforeClassStart: value));
    await _updatePreference({
      'channels': {
        'class_reminder': {'push': value},
      },
    });
  }

  Future<void> changeDayBeforeRemainder(bool value) async {
    emit(state.copyWith(dayBeforeRemainder: value));
    await _updatePreference({
      'channels': {
        'class_reminder': {'push': value},
      },
    });
  }

  Future<void> changePaymentConfirmation(bool value) async {
    emit(state.copyWith(paymentConfirmation: value));
    await _updatePreference({
      'channels': {
        'booking_confirmed': {'push': value},
      },
    });
  }

  Future<void> changeRenewalRemainder(bool value) async {
    emit(state.copyWith(renewalRemainder: value));
    await _updatePreference({
      'channels': {
        'booking_confirmed': {'push': value},
      },
    });
  }

  Future<void> changePromotionOffer(bool value) async {
    emit(state.copyWith(promotionOffer: value));
    await _updatePreference({
      'channels': {
        'promotions': {'push': value},
      },
    });
  }

  Future<void> changeAppUpdate(bool value) async {
    emit(state.copyWith(appUpdate: value));
    await _updatePreference({'push': value});
  }

  Future<void> changeNewChallenges(bool value) async {
    emit(state.copyWith(newChallenges: value));
    await _updatePreference({
      'channels': {
        'points_earned': {'push': value},
      },
    });
  }

  void changeRewardEarn(bool value) {
    emit(state.copyWith(rewardEarn: value));
  }
}
