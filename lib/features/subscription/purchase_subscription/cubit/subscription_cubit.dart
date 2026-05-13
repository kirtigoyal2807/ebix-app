import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import 'package:pilates_app/core/validation/contact_validators.dart';
import 'package:pilates_app/core/validation/personal_information_validators.dart';
import 'package:pilates_app/features/checkout/data/checkout_repository.dart';
import 'package:pilates_app/features/checkout/data/models/checkout_payment_intent_result.dart';
import 'package:pilates_app/features/checkout/data/models/product_health_question.dart';
import 'package:pilates_app/features/checkout/data/models/product_health_questionnaire.dart';
import 'package:pilates_app/features/subscription/purchase_subscription/health_questionnaire_query.dart';
import 'package:pilates_app/features/subscription/purchase_subscription/subscription_api_ids.dart';

part 'subscription_state.dart';

class SubscriptionCubit extends Cubit<SubscriptionState> {
  SubscriptionCubit({bool initialIsGift = false})
    : super(SubscriptionState(isGift: initialIsGift));

  /// Last product id used for a successful `GET …/questionnaires/product/{id}`.
  /// Used to skip redundant prefetches when the schema is already in memory.
  int? _cachedQuestionnaireProductId;

  /// After hosted payment succeeds, receipt navigation may be deferred until the user
  /// completes [RequiredInformationView]. Intent + callback are stored here until then.
  CheckoutPaymentIntentResult? _deferredReceiptPaymentIntent;
  Map<String, dynamic>? _deferredReceiptGatewayCallback;

  bool get hasDeferredPostPaymentReceipt =>
      _deferredReceiptPaymentIntent != null;

  CheckoutPaymentIntentResult? get deferredPostPaymentReceiptIntent =>
      _deferredReceiptPaymentIntent;

  Map<String, dynamic>? get deferredPostPaymentGatewayCallback =>
      _deferredReceiptGatewayCallback;

  void setDeferredPostPaymentReceiptContext(
    CheckoutPaymentIntentResult intent, {
    Map<String, dynamic>? gatewayCallback,
  }) {
    _deferredReceiptPaymentIntent = intent;
    _deferredReceiptGatewayCallback = gatewayCallback;
  }

  void clearDeferredPostPaymentReceiptContext() {
    _deferredReceiptPaymentIntent = null;
    _deferredReceiptGatewayCallback = null;
  }

  void selectPlan(String planId, {bool? requiresHealthIntake}) {
    final nextIntake =
        requiresHealthIntake ?? state.selectedProductRequiresHealthIntake;
    final planChanged = planId != state.selectedPlanId;
    final intakeChanged =
        nextIntake != state.selectedProductRequiresHealthIntake;
    final clearQuestionnaire = !nextIntake || planChanged || intakeChanged;

    if (clearQuestionnaire) {
      _cachedQuestionnaireProductId = null;
    }

    emit(
      _resolveHealthWizardState(
        state.copyWith(
          selectedPlanId: planId,
          selectedProductRequiresHealthIntake: nextIntake,
          healthQuestionnaireQuestions: clearQuestionnaire
              ? const []
              : state.healthQuestionnaireQuestions,
          healthQuestionnaireId: clearQuestionnaire
              ? null
              : state.healthQuestionnaireId,
          healthQuestionnaireAnswers: clearQuestionnaire
              ? const {}
              : state.healthQuestionnaireAnswers,
          healthQuestionnaireAnswerNotes: clearQuestionnaire
              ? const {}
              : state.healthQuestionnaireAnswerNotes,
          personalInformationDynamicFields: clearQuestionnaire
              ? const {}
              : state.personalInformationDynamicFields,
        ),
      ),
    );
  }

  /// Product id for `GET …/questionnaires/product/{id}`.
  ///
  /// After [bindCheckoutSession], [SubscriptionState.checkoutProductId] wins so the
  /// form matches the checkout session. Before checkout, uses
  /// [subscriptionProductApiId] on [SubscriptionState.selectedPlanId] (catalog
  /// numeric `id` strings).
  int get resolvedHealthQuestionnaireProductId {
    final cid = state.checkoutProductId;
    if (cid > 0) {
      return cid;
    }
    return subscriptionProductApiId(state.selectedPlanId);
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
    _cachedQuestionnaireProductId = null;
    emit(
      _resolveHealthWizardState(
        state.copyWith(
          checkoutSessionId: sessionId,
          checkoutProductId: productId,
          selectedProductRequiresHealthIntake:
              requiresHealthIntake ?? state.selectedProductRequiresHealthIntake,
          healthQuestionnaireQuestions: const [],
          healthQuestionnaireId: null,
          healthQuestionnaireAnswers: const {},
          healthQuestionnaireAnswerNotes: const {},
          personalInformationDynamicFields: const {},
        ),
      ),
    );
  }

  /// Replaces any prior schema from `GET …/questionnaires/product/{id}`.
  ///
  /// Pass [fetchedForProductId] when this data came from that product endpoint so
  /// [prefetchHealthQuestionnaireForSelectedPlan] can avoid duplicate requests.
  void applyHealthQuestionnaire(
    ProductHealthQuestionnaire data, {
    int? fetchedForProductId,
  }) {
    final next = _resolveHealthWizardState(
      state.copyWith(
        healthQuestionnaireId: data.questionnaireId,
        healthQuestionnaireQuestions: data.questions,
        healthQuestionnaireAnswers: const {},
        healthQuestionnaireAnswerNotes: const {},
        personalInformationDynamicFields: const {},
      ),
    );
    emit(next);
    if (next.healthQuestionnaireQuestions.isEmpty) {
      _cachedQuestionnaireProductId = null;
    } else if (fetchedForProductId != null && fetchedForProductId > 0) {
      _cachedQuestionnaireProductId = fetchedForProductId;
    }
  }

  /// Warms questionnaire when [SubscriptionState.selectedProductRequiresHealthIntake]
  /// is true. Uses [resolvedHealthQuestionnaireProductId] (checkout product after
  /// session bind, else selected plan id).
  Future<void> prefetchHealthQuestionnaireForSelectedPlan(
    CheckoutRepository repo,
  ) async {
    if (!state.selectedProductRequiresHealthIntake) {
      return;
    }
    final pid = resolvedHealthQuestionnaireProductId;
    if (pid <= 0) {
      return;
    }
    if (state.healthQuestionnaireQuestions.isNotEmpty &&
        _cachedQuestionnaireProductId == pid) {
      return;
    }
    final r = await repo.getQuestionsByProduct(productId: pid);
    if (r.isSuccess) {
      final data = r.dataOrNull;
      if (data != null) {
        applyHealthQuestionnaire(data, fetchedForProductId: pid);
      }
    }
  }

  /// Loads `GET health-intake/questionnaires/product/{id}` for
  /// [resolvedHealthQuestionnaireProductId] (checkout product when set, else
  /// selected plan id).
  ///
  /// Call after [bindCheckoutSession] (and optionally after catalog prefetch) so the
  /// questionnaire schema is ready before health steps. [bindCheckoutSession] clears
  /// any prior schema until this runs.
  Future<bool> fetchHealthQuestionnaireForCurrentProduct(
    CheckoutRepository repo,
  ) async {
    if (!state.selectedProductRequiresHealthIntake) {
      return true;
    }
    final productId = resolvedHealthQuestionnaireProductId;
    if (productId <= 0) {
      return false;
    }
    final r = await repo.getQuestionsByProduct(productId: productId);
    if (r.isFailure) {
      return false;
    }
    final data = r.dataOrNull;
    if (data == null) {
      return false;
    }
    applyHealthQuestionnaire(data, fetchedForProductId: productId);
    return true;
  }

  void setHealthQuestionnaireAnswer(int questionId, Object? value) {
    final m = Map<int, Object?>.from(state.healthQuestionnaireAnswers);
    m[questionId] = value;
    final notes = Map<int, String>.from(state.healthQuestionnaireAnswerNotes);

    if (value is bool && value == true) {
      final q = _questionnaireQuestionById(questionId);
      if (q != null && q.isBooleanQuestion) {
        final cur = notes[questionId]?.trim() ?? '';
        if (cur.isEmpty) {
          notes[questionId] = q.defaultAnswerNoteForBooleanYes();
        }
      }
    } else if (value is! bool || value == false) {
      notes.remove(questionId);
    }

    var next = state.copyWith(
      healthQuestionnaireAnswers: m,
      healthQuestionnaireAnswerNotes: notes,
    );
    if (questionId == HealthQuestionnaireIds.pregnancy) {
      if (value is bool) {
        next = next.copyWith(isPregnant: value);
      } else if (value == null) {
        next = next.copyWith(isPregnant: null);
      }
    }
    emit(next);
  }

  ProductHealthQuestion? _questionnaireQuestionById(int questionId) {
    for (final q in state.healthQuestionnaireQuestions) {
      if (q.numericQuestionId == questionId) {
        return q;
      }
    }
    return null;
  }

  /// Free-text notes for API `answerNote` (e.g. checkbox **Other**). Boolean **Yes**
  /// uses [setHealthQuestionnaireAnswer] to auto-fill [defaultAnswerNoteForBooleanYes]
  /// when no custom note is set.
  void setHealthQuestionnaireAnswerNote(int questionId, String text) {
    final trimmed = text.trim();
    final notes = Map<int, String>.from(state.healthQuestionnaireAnswerNotes);
    if (trimmed.isEmpty) {
      notes.remove(questionId);
    } else {
      notes[questionId] = trimmed;
    }
    emit(state.copyWith(healthQuestionnaireAnswerNotes: notes));
  }

  /// Validates questions in [group] for the current step (required fields, etc.).
  ///
  /// When [requireEveryQuestionInGroup] is `true`, every question in [group] must
  /// have a valid answer (treats optional API questions as required on that step).
  bool validateQuestionnaireGroup(
    List<ProductHealthQuestion> group, {
    bool requireEveryQuestionInGroup = false,
  }) {
    for (final q in group) {
      final id = q.numericQuestionId;
      if (id == null) return false;
      final v = state.healthQuestionnaireAnswers[id];
      final required = requireEveryQuestionInGroup || (q.isRequired == true);

      if (required) {
        if (v == null) return false;
        if (v is String && v.trim().isEmpty) return false;
        if (v is List && v.isEmpty) return false;
        if (v is Map) {
          final selected = v['selected'];
          final other = v['other'];
          final hasSelected = selected is List && selected.isNotEmpty;
          final hasOther = other is String && other.trim().isNotEmpty;
          if (!hasSelected && !(q.allowOther == true && hasOther)) {
            return false;
          }
        }
      } else {
        if (v == null) continue;
      }
    }
    return true;
  }

  /// Toggles one option for a multi-select / checkbox API question.
  void toggleHealthQuestionnaireOption(
    int questionId,
    String optionKey, {
    required bool selected,
  }) {
    final m = Map<int, Object?>.from(state.healthQuestionnaireAnswers);
    final cur = m[questionId];
    List<String> list;
    if (cur is List<String>) {
      list = List<String>.from(cur);
    } else if (cur is List) {
      list = cur.map((e) => e.toString()).toList();
    } else if (cur is Map) {
      final inner = cur['selected'];
      if (inner is List) {
        list = inner.map((e) => e.toString()).toList();
      } else {
        list = [];
      }
    } else {
      list = [];
    }
    if (selected) {
      if (!list.contains(optionKey)) {
        list = [...list, optionKey];
      }
    } else {
      list = list.where((e) => e != optionKey).toList();
    }
    if (cur is Map) {
      m[questionId] = <String, dynamic>{
        ...Map<String, dynamic>.from(cur),
        'selected': list,
      };
    } else {
      m[questionId] = list;
    }
    emit(state.copyWith(healthQuestionnaireAnswers: m));
  }

  /// Updates the free-text part for a checkbox question with [allowOther].
  void setHealthQuestionnaireOtherText(int questionId, String text) {
    final m = Map<int, Object?>.from(state.healthQuestionnaireAnswers);
    final cur = m[questionId];
    List<String> list;
    if (cur is List) {
      list = cur.map((e) => e.toString()).toList();
      m[questionId] = <String, dynamic>{'selected': list, 'other': text};
    } else if (cur is Map) {
      final mm = Map<String, dynamic>.from(cur);
      mm['other'] = text;
      m[questionId] = mm;
    } else {
      m[questionId] = <String, dynamic>{'selected': <String>[], 'other': text};
    }
    emit(state.copyWith(healthQuestionnaireAnswers: m));
  }

  /// Loads product questionnaire when missing (e.g. static medical fallback),
  /// then maps legacy subscription fields into [healthQuestionnaireAnswers] so
  /// `POST …/health-intake` can send a non-empty `answers` list.
  Future<bool> ensureHealthQuestionnaireForIntake(
    CheckoutRepository repo,
  ) async {
    if (!state.selectedProductRequiresHealthIntake) {
      return true;
    }
    if (state.checkoutProductId <= 0) {
      final sid = state.checkoutSessionId.trim();
      if (sid.isNotEmpty) {
        final detail = await repo.getCheckoutDetails(sid);
        if (detail.isSuccess) {
          final session = detail.dataOrNull!;
          final fromSession = session.resolvedProductId;
          if (fromSession != null && fromSession > 0) {
            setCheckoutProductId(fromSession);
          }
          final intake = session.resolvedRequiresHealthIntake;
          if (intake != null) {
            emit(state.copyWith(selectedProductRequiresHealthIntake: intake));
          }
        }
      }
    }
    if (!state.selectedProductRequiresHealthIntake) {
      return true;
    }
    final idForFetch = resolvedHealthQuestionnaireProductId;
    if (idForFetch <= 0) {
      syncHealthIntakeAnswersFromLegacy();
      return true;
    }
    if (state.healthQuestionnaireQuestions.isEmpty) {
      final r = await repo.getQuestionsByProduct(productId: idForFetch);
      if (r.isFailure) {
        return false;
      }
      final data = r.dataOrNull!;
      applyHealthQuestionnaire(data, fetchedForProductId: idForFetch);
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
          if (!q.isCheckboxQuestion) {
            m[id] =
                _anySectionTrueExcludingNone(state.surgeriesInjuries) ||
                _anySectionTrueExcludingNone(state.painBonesMuscles);
          }
          break;
        case 2:
          m[id] = state.isPregnant ?? false;
          break;
        case 3:
          if (!q.isCheckboxQuestion) {
            final g = state.goals.trim();
            if (g.isNotEmpty) {
              m[id] = g;
            }
          }
          break;
        case 4:
          if (!q.isCheckboxQuestion) {
            m[id] = _anySectionTrueExcludingNone(state.chronicConditions);
          }
          break;
        case 5:
          if (q.isBooleanQuestion) {
            final ex = state.exerciseRegularly?.trim().toLowerCase();
            if (ex == 'yes' || ex == 'sometimes') {
              m[id] = true;
            } else if (ex == 'no') {
              m[id] = false;
            }
          } else {
            final ex = state.exerciseRegularly?.trim();
            if (ex != null && ex.isNotEmpty) {
              m[id] = ex;
            }
          }
          break;
      }
    }

    for (final q in state.healthQuestionnaireQuestions) {
      final id = q.numericQuestionId;
      if (id == null) continue;
      if (m[id] != null) continue;
      if (q.isRequired == true &&
          q.isBooleanQuestion &&
          !q.isCheckboxQuestion) {
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

  /// First step after the six-slot health wizard (`PersonalInfo`→`Declaration`).
  static const int _safetyConsentStepIndex = 7;

  /// Steps 1–6 are the questionnaire shell; skipped entirely when intake is false.
  /// When intake is true and the product questionnaire has loaded, steps 2–5 are skipped if
  /// that slice has no questions (matches per-screen API blocks).
  bool _subscriptionWizardStepSkipped(SubscriptionState st, int step) {
    return isSubscriptionHealthWizardShellStepSkipped(
      selectedProductRequiresHealthIntake:
          st.selectedProductRequiresHealthIntake,
      questionnaireQuestions: st.healthQuestionnaireQuestions,
      shellStep: step,
    );
  }

  SubscriptionState _clampOutOfBandHealthWizardIfNoIntake(SubscriptionState s) {
    if (s.selectedProductRequiresHealthIntake) return s;
    if (s.currentStep >= 1 && s.currentStep <= 6) {
      return s.copyWith(currentStep: _safetyConsentStepIndex);
    }
    return s;
  }

  /// After loading questionnaire data, advances past steps 2–5 that have no API questions.
  SubscriptionState _withWizardStepSkippingEmptySlices(SubscriptionState base) {
    var s = base;
    final qs = s.healthQuestionnaireQuestions;
    if (!s.selectedProductRequiresHealthIntake || qs.isEmpty) {
      return s;
    }
    while (s.currentStep >= 2 &&
        s.currentStep <= 5 &&
        _subscriptionWizardStepSkipped(s, s.currentStep)) {
      final nextStep = s.currentStep + 1;
      if (nextStep > 10) break;
      s = s.copyWith(currentStep: nextStep);
    }
    return s;
  }

  SubscriptionState _resolveHealthWizardState(SubscriptionState draft) {
    return _clampOutOfBandHealthWizardIfNoIntake(
      _withWizardStepSkippingEmptySlices(draft),
    );
  }

  void nextStep() {
    if (state.currentStep >= 10) {
      return;
    }
    var step = state.currentStep + 1;
    while (step <= 10 && _subscriptionWizardStepSkipped(state, step)) {
      step++;
    }
    emit(state.copyWith(currentStep: step.clamp(0, 10)));
  }

  void previousStep() {
    if (state.currentStep <= 0) {
      return;
    }
    var step = state.currentStep - 1;
    while (step >= 1 && _subscriptionWizardStepSkipped(state, step)) {
      step--;
    }
    emit(state.copyWith(currentStep: step.clamp(0, 10)));
  }

  /// Current value for an API-driven personal field (step 1).
  String apiPersonalFieldValue(ProductHealthQuestion q) {
    final slot = q.personalInformationStateSlot;
    if (slot != null) {
      switch (slot) {
        case 'name':
          return state.name;
        case 'age':
          return state.age;
        case 'height':
          return state.height;
        case 'weight':
          return state.weight;
        case 'phoneNumber':
          return state.phoneNumber;
        case 'email':
          return state.email;
      }
    }
    return state.personalInformationDynamicFields[q
            .dynamicPersonalStorageKey] ??
        '';
  }

  /// Maps API personal questions into [SubscriptionState] name/age/… or [personalInformationDynamicFields].
  void applyApiPersonalInformationAnswer(
    ProductHealthQuestion q,
    String value,
  ) {
    final slot = q.personalInformationStateSlot;
    if (slot != null) {
      switch (slot) {
        case 'name':
          updateName(value);
          return;
        case 'age':
          updateAge(value);
          return;
        case 'height':
          updateHeight(value);
          return;
        case 'weight':
          updateWeight(value);
          return;
        case 'phoneNumber':
          updatePhoneNumber(value);
          return;
        case 'email':
          updateEmail(value);
          return;
      }
    }
    final key = q.dynamicPersonalStorageKey;
    final next = Map<String, String>.from(
      state.personalInformationDynamicFields,
    );
    if (value.trim().isEmpty) {
      next.remove(key);
    } else {
      next[key] = value;
    }
    emit(state.copyWith(personalInformationDynamicFields: next));
  }

  /// Validates the given API personal questions (required text/email/phone rules).
  bool validateApiPersonalInformationQuestions(
    List<ProductHealthQuestion> questions,
  ) {
    for (final q in questions) {
      final v = apiPersonalFieldValue(q);
      final trimmed = v.trim();
      if (trimmed.isEmpty) {
        if (q.isRequired == true) {
          return false;
        }
        continue;
      }
      if (q.personalInformationStateSlot == 'email' || q.isEmailInputQuestion) {
        if (!ContactValidators.isValidEmail(trimmed)) {
          return false;
        }
      }
      if (q.personalInformationStateSlot == 'phoneNumber' ||
          q.isPhoneInputQuestion) {
        if (!PersonalInformationValidators.isTenDigitMobile(trimmed)) {
          return false;
        }
      }
    }
    return true;
  }

  // Health Info Updates - Step 1
  void updateName(String val) => emit(state.copyWith(name: val));

  void updateAge(String val) => emit(state.copyWith(age: val));

  void updateHeight(String val) => emit(state.copyWith(height: val));

  void updateWeight(String val) => emit(state.copyWith(weight: val));

  void updatePhone(String val) {
    final digits = val.replaceAll(RegExp(r'\D'), '');
    final limited = digits.length > 10 ? digits.substring(0, 10) : digits;
    emit(state.copyWith(phoneNumber: limited));
  }

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
    final hasQ2 = state.healthQuestionnaireQuestions.any(
      (q) => q.numericQuestionId == 2,
    );
    if (hasQ2) {
      setHealthQuestionnaireAnswer(2, val);
    } else {
      emit(state.copyWith(isPregnant: val));
    }
  }

  // Goals Updates - Step 5
  void updateGoals(String val) {
    final hasQ3 = state.healthQuestionnaireQuestions.any(
      (q) => q.numericQuestionId == 3,
    );
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

  void updateEmergencyContactPhone(String val) {
    final digits = val.replaceAll(RegExp(r'\D'), '');
    final limited = digits.length > 10 ? digits.substring(0, 10) : digits;
    emit(state.copyWith(emergencyContactPhone: limited));
  }

  void updateIdType(String val) => emit(state.copyWith(idType: val));

  void updateIdNumber(String val) => emit(state.copyWith(idNumber: val));
}
