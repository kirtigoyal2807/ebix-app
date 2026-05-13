/// Number of questionnaire shell steps (canonical slots 1…6 below).
///
/// Keeps chrome (progress + “step N of …”) aligned with [SubscriptionHealthWizardStepIndexing].
const int kSubscriptionHealthWizardStepCount = 6;

/// Wizard slices surfaced for [SubscriptionState.currentStep] indices **1–6**
/// (`IndexedStack`: plan = 0, then this flow, then Safety at 7, …).
enum SubscriptionHealthWizardStep {
  personalInformation,
  medicalHistory,
  physicalActivity,
  pregnancy,
  goals,
  declaration,
}

extension SubscriptionHealthWizardStepIndexing on SubscriptionHealthWizardStep {
  /// Matches [IndexedStack] indices **1…6** (health shell only).
  int get questionnaireStepNumber => index + 1;

  /// Progress bar slot **0…5** when **all six** questionnaire steps participate (legacy).
  int get chromeProgressIndex => index;
}
