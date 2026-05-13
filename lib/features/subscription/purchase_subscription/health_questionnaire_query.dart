import 'package:pilates_app/features/checkout/data/models/product_health_question.dart';
import 'package:pilates_app/features/subscription/purchase_subscription/view/widgets/subscription_health_wizard_step.dart';

/// Question ids for the default "12 Session Health Form" product schema.
abstract final class HealthQuestionnaireIds {
  static const injuriesSurgeries = 1;
  static const pregnancy = 2;
  static const goals = 3;
  static const medicalConditions = 4;
  static const activityPilates = 5;
}

List<ProductHealthQuestion> pickQuestionsByIds(
  List<ProductHealthQuestion> all,
  List<int> ids,
) {
  final byId = <int, ProductHealthQuestion>{};
  for (final q in all) {
    final n = q.numericQuestionId;
    if (n != null) {
      byId[n] = q;
    }
  }
  return [
    for (final id in ids)
      if (byId[id] != null) byId[id]!,
  ];
}

/// Numeric `questionnaire` ids handled on **[PhysicalActivityView]**,
/// **[PregnancyView]**, and **[GoalsView]** — not on [MedicalHistoryView].
///
/// Keeps API-driven intake aligned with the dedicated subscription wizard steps.
final Set<int> kHealthQuestionnaireNumericIdsDedicatedSubscriptionSteps = {
  HealthQuestionnaireIds.pregnancy,
  HealthQuestionnaireIds.goals,
  HealthQuestionnaireIds.activityPilates,
};

/// API questions for the Medical History step: product questions excluding
/// personal-information envelope rows and excluding ids handled on dedicated
/// later steps ([kHealthQuestionnaireNumericIdsDedicatedSubscriptionSteps]).
///
/// Order matches the API (`order` then numeric id).
List<ProductHealthQuestion> medicalQuestionsFromApi(
  List<ProductHealthQuestion> all,
) {
  final dedicated = kHealthQuestionnaireNumericIdsDedicatedSubscriptionSteps;
  final filtered = all
      .where(
        (q) =>
            !q.isPersonalInformationEnvelopeField &&
            q.numericQuestionId != null &&
            !dedicated.contains(q.numericQuestionId!),
      )
      .toList();
  int sortKey(ProductHealthQuestion q) => q.order ?? q.numericQuestionId ?? 0;
  filtered.sort((a, b) => sortKey(a).compareTo(sortKey(b)));
  return filtered;
}

/// Whether questionnaire shell step [shellStep] (**1…6**) is omitted from navigation/UI.
///
/// Must stay in sync with [SubscriptionCubit] next/back routing:
/// • no intake → entire shell omitted;
/// • intake + questionnaire **loading** (`questionnaireQuestions` empty) → do not omit 2–5;
/// • intake + schema loaded → omit steps whose API slice has no questions.
bool isSubscriptionHealthWizardShellStepSkipped({
  required bool selectedProductRequiresHealthIntake,
  required List<ProductHealthQuestion> questionnaireQuestions,
  required int shellStep,
}) {
  if (shellStep < 1 || shellStep > kSubscriptionHealthWizardStepCount) return false;
  if (!selectedProductRequiresHealthIntake) {
    return shellStep <= kSubscriptionHealthWizardStepCount;
  }
  if (questionnaireQuestions.isEmpty) {
    return false;
  }

  switch (shellStep) {
    case 2:
      return medicalQuestionsFromApi(questionnaireQuestions).isEmpty;
    case 3:
      return pickQuestionsByIds(
        questionnaireQuestions,
        const [HealthQuestionnaireIds.activityPilates],
      ).isEmpty;
    case 4:
      return pickQuestionsByIds(
        questionnaireQuestions,
        const [HealthQuestionnaireIds.pregnancy],
      ).isEmpty;
    case 5:
      return pickQuestionsByIds(questionnaireQuestions, const [
            HealthQuestionnaireIds.goals,
          ]).isEmpty;
    default:
      return false;
  }
}

/// Shell steps (**1…6**) that remain for the stepper after applying [isSubscriptionHealthWizardShellStepSkipped].
List<int> visibleSubscriptionHealthWizardShellSteps({
  required bool selectedProductRequiresHealthIntake,
  required List<ProductHealthQuestion> questionnaireQuestions,
}) {
  return [
    for (var s = 1; s <= kSubscriptionHealthWizardStepCount; s++)
      if (!isSubscriptionHealthWizardShellStepSkipped(
        selectedProductRequiresHealthIntake: selectedProductRequiresHealthIntake,
        questionnaireQuestions: questionnaireQuestions,
        shellStep: s,
      ))
        s,
  ];
}

int _subscriptionHealthWizardStepperIndexForShellStep(
  List<int> visibleShellSlots,
  int shellStepNumber,
) {
  final idx = visibleShellSlots.indexOf(shellStepNumber);
  if (idx >= 0) return idx;

  /// Inactive IndexedStack slice (e.g. skipped step): pick nearest onward slot.
  for (var i = 0; i < visibleShellSlots.length; i++) {
    if (visibleShellSlots[i] >= shellStepNumber) return i;
  }
  return visibleShellSlots.isEmpty ? 0 : visibleShellSlots.length - 1;
}

/// Progress bar fraction + captions for questionnaire chrome on a shell screen.
///
/// [shellStepNumber] is **1…6** for this screen ([SubscriptionHealthWizardStep.questionnaireStepNumber]).
({int progressZeroBased, int totalSteps}) subscriptionHealthWizardStepperChrome({
  required bool selectedProductRequiresHealthIntake,
  required List<ProductHealthQuestion> questionnaireQuestions,
  required int shellStepNumber,
}) {
  final visible = visibleSubscriptionHealthWizardShellSteps(
    selectedProductRequiresHealthIntake: selectedProductRequiresHealthIntake,
    questionnaireQuestions: questionnaireQuestions,
  );

  /// Intake disabled: IndexedStack slices are off-flow; preserve legacy 6-slot chrome.
  if (visible.isEmpty) {
    final legacy = shellStepNumber - 1;
    return (
      progressZeroBased: legacy.clamp(0, kSubscriptionHealthWizardStepCount - 1),
      totalSteps: kSubscriptionHealthWizardStepCount,
    );
  }

  final i = _subscriptionHealthWizardStepperIndexForShellStep(visible, shellStepNumber);

  return (progressZeroBased: i.clamp(0, visible.length - 1), totalSteps: visible.length);
}
