import 'package:pilates_app/features/checkout/data/models/product_health_question.dart';

import '../cubit/subscription_cubit.dart';

/// JSON-serializable `answer` value for one questionnaire row.
dynamic _encodeHealthAnswerValue(Object? v) {
  if (v is Map) {
    final m = Map<String, dynamic>.from(v as Map<dynamic, dynamic>);
    final sel = m['selected'];
    if (sel is List) {
      return sel.map((e) => e.toString()).toList();
    }
  }
  return v;
}

/// JSON body for [CheckoutRepository.submitHealthIntake].
///
/// Backend validation (422) expects at least:
/// - **`answers`** — list of `{ "id", "questionId", "answer" }` where **`id`** is the
///   question identifier. For boolean **`true`**, the API may require non-empty
///   **`answerNote`**; when [ProductHealthQuestion.allowOther] is false the client sends
///   [ProductHealthQuestion.defaultAnswerNoteForBooleanYes] if the user left no note.
/// - **`consentAccepted`** — must be `true` (maps from [SubscriptionState.isTermsAccepted] after the terms step).
///
/// Emergency contact + ID are sent separately via [CheckoutRepository.submitEmergencyContact]
/// from [RequiredInformationView] (`POST /checkout/{id}/emergency-contact`).
///
/// When a product questionnaire is loaded, [questionnaireId] is included and `answers`
/// is filled from [SubscriptionState.healthQuestionnaireAnswers].
Map<String, dynamic> subscriptionHealthIntakeRequestBody(
  SubscriptionState state,
) {
  final answers = <Map<String, dynamic>>[];
  if (state.healthQuestionnaireQuestions.isNotEmpty) {
    for (final q in state.healthQuestionnaireQuestions) {
      if (q.isPersonalInformationEnvelopeField) {
        continue;
      }
      final qid = q.numericQuestionId;
      if (qid == null) continue;
      final v = state.healthQuestionnaireAnswers[qid];
      if (v == null) continue;
      final encoded = _encodeHealthAnswerValue(v);
      final row = <String, dynamic>{
        'id': qid,
        'questionId': qid,
        'answer': encoded,
      };
      if (v is bool && v == true && q.isBooleanQuestion) {
        var note = state.healthQuestionnaireAnswerNotes[qid]?.trim() ?? '';
        if (note.isEmpty && q.allowOther != true) {
          note = q.defaultAnswerNoteForBooleanYes();
        }
        row['answerNote'] = note;
      }
      answers.add(row);
    }
  }

  final personalInformation = <String, dynamic>{
    'fullName': state.name,
    'age': state.age,
    'height': state.height,
    'weight': state.weight,
    'phoneNumber': state.phoneNumber,
    'email': state.email,
  };
  for (final e in state.personalInformationDynamicFields.entries) {
    final k = e.key.trim();
    if (k.isEmpty || e.value.trim().isEmpty) continue;
    if (!personalInformation.containsKey(k)) {
      personalInformation[k] = e.value;
    }
  }

  final body = <String, dynamic>{
    'personalInformation': personalInformation,
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
    'answers': answers,
    'consentAccepted': state.isTermsAccepted,
  };

  if (state.healthQuestionnaireId != null) {
    body['questionnaireId'] = state.healthQuestionnaireId;
  }

  return body;
}
