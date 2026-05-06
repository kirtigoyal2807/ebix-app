import 'package:equatable/equatable.dart';

enum GiftSubmitStatus { idle, loading, success, failure }

class GiftSubscriptionState extends Equatable {
  final List<DeliveryOption> deliveryOptions;
  final DeliveryOption selectedDeliveryOption;

  /// `yyyy-MM-dd` when [selectedDeliveryOption] is [DeliveryOption.scheduledDelivery].
  final String? scheduledDeliveryDateIso;
  final GiftSubmitStatus submitStatus;
  final String? submitErrorMessage;

  /// Filled when [submitGift] succeeds — used after payment for the success UI.
  final String? submittedRecipientName;
  final String? submittedRecipientEmail;

  const GiftSubscriptionState({
    required this.deliveryOptions,
    required this.selectedDeliveryOption,
    this.scheduledDeliveryDateIso,
    this.submitStatus = GiftSubmitStatus.idle,
    this.submitErrorMessage,
    this.submittedRecipientName,
    this.submittedRecipientEmail,
  });

  GiftSubscriptionState copyWith({
    List<DeliveryOption>? deliveryOptions,
    DeliveryOption? selectedDeliveryOption,
    String? scheduledDeliveryDateIso,
    bool clearScheduledDeliveryDateIso = false,
    GiftSubmitStatus? submitStatus,
    String? submitErrorMessage,
    bool clearSubmitError = false,
    String? submittedRecipientName,
    String? submittedRecipientEmail,
    bool clearSubmittedRecipient = false,
  }) {
    return GiftSubscriptionState(
      deliveryOptions: deliveryOptions ?? this.deliveryOptions,
      selectedDeliveryOption:
          selectedDeliveryOption ?? this.selectedDeliveryOption,
      scheduledDeliveryDateIso: clearScheduledDeliveryDateIso
          ? null
          : (scheduledDeliveryDateIso ?? this.scheduledDeliveryDateIso),
      submitStatus: submitStatus ?? this.submitStatus,
      submitErrorMessage: clearSubmitError
          ? null
          : (submitErrorMessage ?? this.submitErrorMessage),
      submittedRecipientName: clearSubmittedRecipient
          ? null
          : (submittedRecipientName ?? this.submittedRecipientName),
      submittedRecipientEmail: clearSubmittedRecipient
          ? null
          : (submittedRecipientEmail ?? this.submittedRecipientEmail),
    );
  }

  @override
  List<Object?> get props => [
    deliveryOptions,
    selectedDeliveryOption,
    scheduledDeliveryDateIso,
    submitStatus,
    submitErrorMessage,
    submittedRecipientName,
    submittedRecipientEmail,
  ];
}

enum DeliveryOption { instantDelivery, scheduledDelivery }
