import '../cubit/subscription_cubit.dart';

/// JSON body for [CheckoutRepository.submitHealthIntake].
///
/// Backend validation (422) expects at least:
/// - **`answers`** — list of `{ "questionId", "answer" }` (empty when no questionnaire
///   or when [SubscriptionState.selectedProductRequiresHealthIntake] is false).
/// - **`consentAccepted`** — must be `true` (maps from [SubscriptionState.isTermsAccepted] after the terms step).
///
/// When a product questionnaire is loaded, [questionnaireId] is included and `answers`
/// is filled from [SubscriptionState.healthQuestionnaireAnswers].
Map<String, dynamic> subscriptionHealthIntakeRequestBody(
  SubscriptionState state,
) {
  final answers = <Map<String, dynamic>>[];
  if (state.healthQuestionnaireQuestions.isNotEmpty) {
    for (final q in state.healthQuestionnaireQuestions) {
      final qid = q.numericQuestionId;
      if (qid == null) continue;
      final v = state.healthQuestionnaireAnswers[qid];
      if (v == null) continue;
      if (v is bool) {
        answers.add(<String, dynamic>{'questionId': qid, 'answer': v});
      } else if (v is String) {
        answers.add(<String, dynamic>{'questionId': qid, 'answer': v});
      } else {
        answers.add(<String, dynamic>{'questionId': qid, 'answer': v});
      }
    }
  }

  final body = <String, dynamic>{
    'personalInformation': <String, dynamic>{
      'fullName': state.name,
      'age': state.age,
      'height': state.height,
      'weight': state.weight,
      'phoneNumber': state.phoneNumber,
      'email': state.email,
    },
    'medicalHistory': <String, dynamic>{
      'chronicConditions': Map<String, bool>.from(state.chronicConditions),
      'surgeriesInjuries': Map<String, bool>.from(state.surgeriesInjuries),
      'painBonesMuscles': Map<String, bool>.from(state.painBonesMuscles),
      'respiratoryProblems': Map<String, bool>.from(state.respiratoryProblems),
      'medications': Map<String, bool>.from(state.medications),
    },
    'physicalActivity': <String, dynamic>{
      'exerciseRegularly': state.exerciseRegularly,
      'activityFrequency': state.activityFrequency?.name,
    },
    'pregnancy': <String, dynamic>{
      'isPregnant': state.isPregnant,
    },
    'goals': state.goals,
    'declaration': <String, dynamic>{
      'name': state.declarationName,
      'signature': state.declarationSignature,
      'date': state.declarationDate,
    },
    'requiredInformation': <String, dynamic>{
      'emergencyContactName': state.emergencyContactName,
      'emergencyContactRelationship': state.emergencyContactRelationship,
      'emergencyContactPhone': state.emergencyContactPhone,
      'idType': state.idType,
      'idNumber': state.idNumber,
    },
    'answers': answers,
    'consentAccepted': state.isTermsAccepted,
  };

  if (state.healthQuestionnaireId != null) {
    body['questionnaireId'] = state.healthQuestionnaireId;
  }

  return body;
}
