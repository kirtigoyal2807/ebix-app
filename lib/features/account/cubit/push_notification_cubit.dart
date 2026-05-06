import 'package:bloc/bloc.dart';
import 'package:pilates_app/core/network/api_result.dart';
import 'package:pilates_app/features/account/cubit/push_notification_state.dart';
import 'package:pilates_app/features/account/data/notification_preferences_repository.dart';

class PushNotificationCubit extends Cubit<PushNotificationState> {
  PushNotificationCubit({required NotificationPreferencesRepository repository})
    : _repository = repository,
      super(const PushNotificationState());

  final NotificationPreferencesRepository _repository;

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
        emit(
          state.copyWith(
            status: PushNotificationStatus.loaded,
            preferences: data,
            allNotification: data.push,
            beforeClassStart: data.channels['class_reminder']?.push ?? false,
            dayBeforeRemainder: data.channels['class_reminder']?.push ?? false,
            paymentConfirmation:
                data.channels['booking_confirmed']?.push ?? false,
            renewalRemainder: data.channels['booking_confirmed']?.push ?? false,
            promotionOffer: data.channels['promotions']?.push ?? false,
            appUpdate: data.push,
            newChallenges: data.channels['points_earned']?.push ?? false,
          ),
        );
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
        emit(
          state.copyWith(
            status: PushNotificationStatus.loaded,
            preferences: data,
            allNotification: data.push,
            beforeClassStart: data.channels['class_reminder']?.push ?? false,
            dayBeforeRemainder: data.channels['class_reminder']?.push ?? false,
            paymentConfirmation:
                data.channels['booking_confirmed']?.push ?? false,
            renewalRemainder: data.channels['booking_confirmed']?.push ?? false,
            promotionOffer: data.channels['promotions']?.push ?? false,
            appUpdate: data.push,
            newChallenges: data.channels['points_earned']?.push ?? false,
          ),
        );
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
}
