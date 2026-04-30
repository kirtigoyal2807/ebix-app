import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import 'package:pilates_app/features/checkout/data/checkout_repository.dart';
import 'package:pilates_app/features/checkout/data/models/product_health_question.dart';
import 'package:pilates_app/features/checkout/data/models/product_health_questionnaire.dart';

part 'subscription_state.dart';

class SubscriptionCubit extends Cubit<SubscriptionState> {
  SubscriptionCubit({bool initialIsGift = false})
      : super(SubscriptionState(isGift: initialIsGift));

  void selectPlan(String planId, {bool? requiresHealthIntake}) {
    emit(
      state.copyWith(
        selectedPlanId: planId,
        selectedProductRequiresHealthIntake:
            requiresHealthIntake ?? state.selectedProductRequiresHealthIntake,
      ),
    );
  }

  void selectBranch(int branchId) {
    emit(state.copyWith(selectedBranchId: branchId));
  }

  void toggleGift(bool isGift) {
    emit(state.copyWith(isGift: isGift));
  }

  /// Updates [checkoutProductId] only (e.g. after `GET /checkout/{id}`) without
  /// clearing questionnaire answers.
  void setCheckoutProductId(int productId) {
    if (productId <= 0) {
      return;
    }
    emit(state.copyWith(checkoutProductId: productId));
  }

  /// Called after a successful `POST /checkout/start` so later steps can call
  /// getCheckoutDetails, applyCoupon, fetchPaymentIntent, and getQuestionsByProduct.
  ///
  /// When [requiresHealthIntake] is non-null (from session `data`), it overrides
  /// the catalog flag for navigation and `POST …/health-intake`.
  void bindCheckoutSession({
    required String sessionId,
    required int productId,
    bool? requiresHealthIntake,
  }) {
    emit(
      state.copyWith(
        checkoutSessionId: sessionId,
        checkoutProductId: productId,
        selectedProductRequiresHealthIntake:
            requiresHealthIntake ?? state.selectedProductRequiresHealthIntake,
        healthQuestionnaireQuestions: const [],
        healthQuestionnaireId: null,
        healthQuestionnaireAnswers: const {},
      ),
    );
  }

  /// Replaces any prior schema from `GET …/questionnaires/product/{id}`.
  void applyHealthQuestionnaire(ProductHealthQuestionnaire data) {
    emit(
      state.copyWith(
        healthQuestionnaireId: data.questionnaireId,
        healthQuestionnaireQuestions: data.questions,
        healthQuestionnaireAnswers: const {},
      ),
    );
  }

  void setHealthQuestionnaireAnswer(int questionId, Object? value) {
    final m = Map<int, Object?>.from(state.healthQuestionnaireAnswers);
    m[questionId] = value;
    var next = state.copyWith(healthQuestionnaireAnswers: m);
    if (questionId == 2 && value is bool) {
      next = next.copyWith(isPregnant: value);
    }
    emit(next);
  }

  /// Validates required questions in [group] (e.g. only ids for the current step).
  bool validateQuestionnaireGroup(List<ProductHealthQuestion> group) {
    for (final q in group) {
      if (q.isRequired != true) continue;
      final id = q.numericQuestionId;
      if (id == null) return false;
      final v = state.healthQuestionnaireAnswers[id];
      if (v == null) return false;
      if (v is String && v.trim().isEmpty) return false;
    }
    return true;
  }

  /// Loads product questionnaire when missing (e.g. static medical fallback),
  /// then maps legacy subscription fields into [healthQuestionnaireAnswers] so
  /// `POST …/health-intake` can send a non-empty `answers` list.
  Future<bool> ensureHealthQuestionnaireForIntake(CheckoutRepository repo) async {
    if (!state.selectedProductRequiresHealthIntake) {
      return true;
    }
    var productId = state.checkoutProductId;
    if (productId <= 0) {
      final sid = state.checkoutSessionId.trim();
      if (sid.isNotEmpty) {
        final detail = await repo.getCheckoutDetails(sid);
        if (detail.isSuccess) {
          final session = detail.dataOrNull!;
          final fromSession = session.resolvedProductId;
          if (fromSession != null && fromSession > 0) {
            setCheckoutProductId(fromSession);
            productId = fromSession;
          }
          final intake = session.requiresHealthIntake;
          if (intake != null) {
            emit(state.copyWith(selectedProductRequiresHealthIntake: intake));
          }
        }
      }
    }
    if (!state.selectedProductRequiresHealthIntake) {
      return true;
    }
    if (productId <= 0) {
      syncHealthIntakeAnswersFromLegacy();
      return true;
    }
    if (state.healthQuestionnaireQuestions.isEmpty) {
      final r = await repo.getQuestionsByProduct(productId: productId);
      if (r.isFailure) {
        return false;
      }
      final data = r.dataOrNull!;
      applyHealthQuestionnaire(data);
    }
    syncHealthIntakeAnswersFromLegacy();
    return true;
  }

  /// Fills missing [healthQuestionnaireAnswers] from the classic health steps
  /// (checkbox maps, pregnancy, goals, activity). Known ids **1–5** match the
  /// default 12-session product form; other ids stay unchanged.
  void syncHealthIntakeAnswersFromLegacy() {
    if (state.healthQuestionnaireQuestions.isEmpty) {
      return;
    }
    final m = Map<int, Object?>.from(state.healthQuestionnaireAnswers);
    for (final q in state.healthQuestionnaireQuestions) {
      final id = q.numericQuestionId;
      if (id == null) continue;
      if (m[id] != null) continue;

      switch (id) {
        case 1:
          m[id] = _anySectionTrueExcludingNone(state.surgeriesInjuries) ||
              _anySectionTrueExcludingNone(state.painBonesMuscles);
          break;
        case 2:
          m[id] = state.isPregnant ?? false;
          break;
        case 3:
          final g = state.goals.trim();
          if (g.isNotEmpty) {
            m[id] = g;
          }
          break;
        case 4:
          m[id] = _anySectionTrueExcludingNone(state.chronicConditions);
          break;
        case 5:
          final ex = state.exerciseRegularly?.trim();
          if (ex != null && ex.isNotEmpty) {
            m[id] = ex;
          }
          break;
      }
    }

    for (final q in state.healthQuestionnaireQuestions) {
      final id = q.numericQuestionId;
      if (id == null) continue;
      if (m[id] != null) continue;
      if (q.isRequired == true && q.isBooleanQuestion) {
        m[id] = false;
      }
    }

    emit(state.copyWith(healthQuestionnaireAnswers: m));
  }

  bool _anySectionTrueExcludingNone(Map<String, bool> map) {
    for (final e in map.entries) {
      if (e.key == 'none') continue;
      if (e.value == true) return true;
    }
    return false;
  }

  /// Steps 2–6 are medical → declaration; skipped when [SubscriptionState.selectedProductRequiresHealthIntake] is false.
  bool _shouldSkipHealthQuestionnaireStep(int step) =>
      !state.selectedProductRequiresHealthIntake && step >= 2 && step <= 6;

  void nextStep() {
    if (state.currentStep >= 10) {
      return;
    }
    var step = state.currentStep + 1;
    while (_shouldSkipHealthQuestionnaireStep(step) && step < 10) {
      step++;
    }
    emit(state.copyWith(currentStep: step.clamp(0, 10)));
  }

  void previousStep() {
    if (state.currentStep <= 0) {
      return;
    }
    var step = state.currentStep - 1;
    while (_shouldSkipHealthQuestionnaireStep(step) && step > 0) {
      step--;
    }
    emit(state.copyWith(currentStep: step.clamp(0, 10)));
  }

  // Health Info Updates - Step 1
  void updateName(String val) => emit(state.copyWith(name: val));

  void updateAge(String val) => emit(state.copyWith(age: val));

  void updateHeight(String val) => emit(state.copyWith(height: val));

  void updateWeight(String val) => emit(state.copyWith(weight: val));

  void updatePhone(String val) => emit(state.copyWith(phoneNumber: val));

  /// Alias for [updatePhone] (some call sites use this name).
  void updatePhoneNumber(String val) => updatePhone(val);

  void updateEmail(String val) => emit(state.copyWith(email: val));

  // Medical History Updates - Step 2 (Generic helper for checkbox maps)
  void updateChronicCondition(String key, bool? val) {
    final newMap = Map<String, bool>.from(state.chronicConditions);
    newMap[key] = val ?? false;
    emit(state.copyWith(chronicConditions: newMap));
  }

  void updateSurgeryInjury(String key, bool? val) {
    final newMap = Map<String, bool>.from(state.surgeriesInjuries);
    newMap[key] = val ?? false;
    emit(state.copyWith(surgeriesInjuries: newMap));
  }

  void updatePainBoneMuscle(String key, bool? val) {
    final newMap = Map<String, bool>.from(state.painBonesMuscles);
    newMap[key] = val ?? false;
    emit(state.copyWith(painBonesMuscles: newMap));
  }

  void updateRespiratoryProblem(String key, bool? val) {
    final newMap = Map<String, bool>.from(state.respiratoryProblems);
    newMap[key] = val ?? false;
    emit(state.copyWith(respiratoryProblems: newMap));
  }

  void updateMedication(String key, bool? val) {
    final newMap = Map<String, bool>.from(state.medications);
    newMap[key] = val ?? false;
    emit(state.copyWith(medications: newMap));
  }

  // Physical Activity Updates - Step 3
  void updateExerciseRegularly(String val) =>
      emit(state.copyWith(exerciseRegularly: val));

  void updateActivityFrequency(PhysicalActivityFrequency val) =>
      emit(state.copyWith(activityFrequency: val));

  // Pregnancy Updates - Step 4
  void updateIsPregnant(bool val) {
    final m = Map<int, Object?>.from(state.healthQuestionnaireAnswers);
    final hasQ2 =
        state.healthQuestionnaireQuestions.any((q) => q.numericQuestionId == 2);
    if (hasQ2) {
      m[2] = val;
    }
    emit(state.copyWith(isPregnant: val, healthQuestionnaireAnswers: m));
  }

  // Goals Updates - Step 5
  void updateGoals(String val) {
    final hasQ3 =
        state.healthQuestionnaireQuestions.any((q) => q.numericQuestionId == 3);
    if (!hasQ3) {
      emit(state.copyWith(goals: val));
      return;
    }
    final m = Map<int, Object?>.from(state.healthQuestionnaireAnswers);
    m[3] = val;
    emit(state.copyWith(goals: val, healthQuestionnaireAnswers: m));
  }

  // Declaration Updates - Step 6
  void updateDeclarationName(String val) =>
      emit(state.copyWith(declarationName: val));

  void updateDeclarationSignature(String val) =>
      emit(state.copyWith(declarationSignature: val));

  void updateDeclarationDate(String val) =>
      emit(state.copyWith(declarationDate: val));

  // Terms & Conditions Updates - Step 8
  void toggleTermsAccepted(bool val) =>
      emit(state.copyWith(isTermsAccepted: val));

  // Required Information Updates - Step 9
  void updateEmergencyContactName(String val) =>
      emit(state.copyWith(emergencyContactName: val));

  void updateEmergencyContactRelationship(String val) =>
      emit(state.copyWith(emergencyContactRelationship: val));

  void updateEmergencyContactPhone(String val) =>
      emit(state.copyWith(emergencyContactPhone: val));

  void updateIdType(String val) => emit(state.copyWith(idType: val));

  void updateIdNumber(String val) => emit(state.copyWith(idNumber: val));
}
