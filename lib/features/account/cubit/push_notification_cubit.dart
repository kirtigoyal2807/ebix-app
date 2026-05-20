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

  PushNotificationState _stateFromPreferences(
    PushNotificationState current,
    NotificationPreferences data,
  ) {
    return current.copyWith(
      status: PushNotificationStatus.loaded,
      preferences: data,
      allNotification: data.allNotifications,
      beforeClassStart: data.classNotifications.beforeClassStart,
      dayBeforeRemainder: data.classNotifications.dayBeforeReminder,
      paymentConfirmation: data.subscriptionNotifications.paymentConfirmations,
      renewalRemainder: data.subscriptionNotifications.renewalReminders,
      promotionOffer: data.marketingNotifications.promotions,
      appUpdate: data.marketingNotifications.productUpdates,
      newChallenges: data.loyaltyNotifications.challengeUpdates,
      rewardEarn: data.loyaltyNotifications.pointsEarned,
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

  Future<void> _updatePreference(Map<String, dynamic> preferencesPatch) async {
    final prefs = state.preferences;
    if (prefs == null) return;

    emit(
      state.copyWith(
        status: PushNotificationStatus.updating,
        errorMessage: null,
      ),
    );

    final result = await _repository.updatePreferences(
      push: prefs.rootPush,
      email: prefs.rootEmail,
      preferences: preferencesPatch,
    );

    switch (result) {
      case ApiSuccess():
        await _reloadPreferencesAfterUpdate();
      case ApiFailure(:final exception):
        emit(
          state.copyWith(
            status: PushNotificationStatus.error,
            errorMessage: exception.message,
          ),
        );
    }
  }

  Future<void> _reloadPreferencesAfterUpdate() async {
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

  Future<void> changeAllNotification(bool value) async {
    final prefs = state.preferences;
    if (prefs == null) return;

    emit(
      state.copyWith(
        status: PushNotificationStatus.updating,
        errorMessage: null,
        allNotification: value,
        beforeClassStart: value,
        dayBeforeRemainder: value,
        paymentConfirmation: value,
        renewalRemainder: value,
        promotionOffer: value,
        appUpdate: value,
        newChallenges: value,
        rewardEarn: value,
      ),
    );

    final result = await _repository.updatePreferences(
      push: value,
      email: value,
      preferences: prefs.masterTogglePreferencesPatch(value),
    );

    switch (result) {
      case ApiSuccess():
        await _reloadPreferencesAfterUpdate();
      case ApiFailure(:final exception):
        emit(
          state.copyWith(
            status: PushNotificationStatus.error,
            errorMessage: exception.message,
          ),
        );
        await _reloadPreferencesAfterUpdate();
    }
  }

  Future<void> changeBeforeClassStart(bool value) async {
    emit(state.copyWith(beforeClassStart: value));
    await _updatePreference({
      'classNotifications': {'beforeClassStart': value},
    });
  }

  Future<void> changeDayBeforeRemainder(bool value) async {
    emit(state.copyWith(dayBeforeRemainder: value));
    await _updatePreference({
      'classNotifications': {'dayBeforeReminder': value},
    });
  }

  Future<void> changePaymentConfirmation(bool value) async {
    emit(state.copyWith(paymentConfirmation: value));
    await _updatePreference({
      'subscriptionNotifications': {'paymentConfirmations': value},
    });
  }

  Future<void> changeRenewalRemainder(bool value) async {
    emit(state.copyWith(renewalRemainder: value));
    await _updatePreference({
      'subscriptionNotifications': {'renewalReminders': value},
    });
  }

  Future<void> changePromotionOffer(bool value) async {
    emit(state.copyWith(promotionOffer: value));
    await _updatePreference({
      'marketingNotifications': {'promotions': value},
    });
  }

  Future<void> changeAppUpdate(bool value) async {
    emit(state.copyWith(appUpdate: value));
    await _updatePreference({
      'marketingNotifications': {'productUpdates': value},
    });
  }

  Future<void> changeNewChallenges(bool value) async {
    emit(state.copyWith(newChallenges: value));
    await _updatePreference({
      'loyaltyNotifications': {'challengeUpdates': value},
    });
  }

  Future<void> changeRewardEarn(bool value) async {
    emit(state.copyWith(rewardEarn: value));
    await _updatePreference({
      'loyaltyNotifications': {'pointsEarned': value},
    });
  }
}
