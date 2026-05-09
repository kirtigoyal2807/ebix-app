import 'package:pilates_app/features/subscription/purchase_subscription/cubit/subscription_cubit.dart';

/// Maps subscription UI id-type labels to API `idType` strings (`POST …/emergency-contact`).
String subscriptionEmergencyContactIdTypeApiValue(String? uiIdType) {
  switch (uiIdType?.trim()) {
    case 'National ID':
      return 'national_id';
    case 'Passport':
      return 'passport';
    case 'Driver License':
      return 'driver_license';
    default:
      return uiIdType?.trim() ?? '';
  }
}

/// JSON body for [CheckoutRepository.submitEmergencyContact].
///
/// [formattedEmergencyPhone] must include dial code (e.g. `+966…`), max **30** characters.
Map<String, dynamic> subscriptionEmergencyContactBody({
  required SubscriptionState state,
  required String formattedEmergencyPhone,
}) {
  return <String, dynamic>{
    'emergencyContactName': state.emergencyContactName.trim(),
    'emergencyContactPhone': formattedEmergencyPhone.trim(),
    'emergencyContactRelationship': state.emergencyContactRelationship!.trim(),
    'idType': subscriptionEmergencyContactIdTypeApiValue(state.idType),
    'idNumber': state.idNumber.trim(),
  };
}
