part of 'subscription_cubit.dart';

enum SubscriptionStatus { initial, loading, success, error }

// For Physical Activity Choice
enum PhysicalActivityFrequency { twoDays, threeDays, fourDays, fiveDays }

class SubscriptionState extends Equatable {
  /// Sentinel for [copyWith] — omit updating [healthQuestionnaireId].
  static const Object _unsetQuestionnaireId = Object();

  final SubscriptionStatus status;
  final String selectedPlanId;
  final int? selectedBranchId;
  final bool isGift;

  /// Pending-gift redemption: steps 1–8 only; Terms continue exits to redeem UI
  /// instead of plan details / payment.
  final bool isGiftRedeemIntakeFlow;

  final int
  currentStep; // 0: Plan, 1–6: Health, 7: Safety, 8: Terms, 9: Review, 10: Required info

  /// From catalog `requiresHealthIntake` / checkout session; when `false`, steps 2–6
  /// (medical → declaration) are skipped and `POST …/health-intake` is not sent.
  final bool selectedProductRequiresHealthIntake;

  /// From `POST /checkout/start` — used for coupon, payment, and questionnaire APIs.
  final String checkoutSessionId;
  final int checkoutProductId;
  /// `true` when hosted checkout succeeded but receipt is deferred until
  /// emergency / ID submit (`RequiredInformationView` success banner).
  final bool deferPaymentReceiptPending;

  /// From `GET health-intake/questionnaires/product/{productId}` (or by id).
  final List<ProductHealthQuestion> healthQuestionnaireQuestions;
  final int? healthQuestionnaireId;
  final Map<int, Object?> healthQuestionnaireAnswers;

  /// Per-question explanation for boolean **Yes** (`answers[].answerNote`); optional
  /// when **`allowOther`** is false (server fallback uses [ProductHealthQuestion.defaultAnswerNoteForBooleanYes]).
  final Map<int, String> healthQuestionnaireAnswerNotes;

  /// Extra `personalInformation.*` keys from API-driven fields (non name/age/… slots).
  final Map<String, String> personalInformationDynamicFields;

  // Step 1: Personal Information
  final String name;
  final String age;
  final String height;
  final String weight;
  final String phoneNumber;
  final String email;

  // Step 2: Medical History (Checkboxes states)
  final Map<String, bool> chronicConditions;
  final Map<String, bool> surgeriesInjuries;
  final Map<String, bool> painBonesMuscles;
  final Map<String, bool> respiratoryProblems;
  final Map<String, bool> medications;

  // Step 3: Physical Activity
  final String? exerciseRegularly; // 'yes', 'sometimes', 'no'
  final PhysicalActivityFrequency? activityFrequency;

  // Step 4: Pregnancy
  final bool? isPregnant; // true = Yes, false = No, null = unselected

  // Step 5: Goals
  final String goals;

  // Step 6: Declaration
  final String declarationName;
  final String declarationSignature;
  final String declarationDate;

  // Step 7: Terms & Conditions
  final bool isTermsAccepted;

  // Step 8: Required Information
  final String emergencyContactName;
  final String? emergencyContactRelationship;
  final String emergencyContactPhone;
  final String? idType;
  final String idNumber;

  const SubscriptionState({
    this.status = SubscriptionStatus.initial,
    this.selectedPlanId = '',
    this.selectedBranchId,
    this.isGift = false,
    this.isGiftRedeemIntakeFlow = false,
    this.currentStep = 0,
    this.selectedProductRequiresHealthIntake = false,
    this.checkoutSessionId = '',
    this.checkoutProductId = 0,
    this.deferPaymentReceiptPending = false,
    this.healthQuestionnaireQuestions = const [],
    this.healthQuestionnaireId,
    this.healthQuestionnaireAnswers = const {},
    this.healthQuestionnaireAnswerNotes = const {},
    this.personalInformationDynamicFields = const {},
    this.name = '',
    this.age = '',
    this.height = '',
    this.weight = '',
    this.phoneNumber = '',
    this.email = '',
    this.chronicConditions = const {},
    this.surgeriesInjuries = const {},
    this.painBonesMuscles = const {},
    this.respiratoryProblems = const {},
    this.medications = const {},
    this.exerciseRegularly,
    this.activityFrequency,
    this.isPregnant,
    this.goals = '',
    this.declarationName = '',
    this.declarationSignature = '',
    this.declarationDate = '',
    this.isTermsAccepted = false,
    this.emergencyContactName = '',
    this.emergencyContactRelationship,
    this.emergencyContactPhone = '',
    this.idType,
    this.idNumber = '',
  });

  SubscriptionState copyWith({
    SubscriptionStatus? status,
    String? selectedPlanId,
    int? selectedBranchId,
    bool? isGift,
    bool? isGiftRedeemIntakeFlow,
    int? currentStep,
    bool? selectedProductRequiresHealthIntake,
    String? checkoutSessionId,
    int? checkoutProductId,
    bool? deferPaymentReceiptPending,
    List<ProductHealthQuestion>? healthQuestionnaireQuestions,
    Object? healthQuestionnaireId = _unsetQuestionnaireId,
    Map<int, Object?>? healthQuestionnaireAnswers,
    Map<int, String>? healthQuestionnaireAnswerNotes,
    Map<String, String>? personalInformationDynamicFields,
    String? name,
    String? age,
    String? height,
    String? weight,
    String? phoneNumber,
    String? email,
    Map<String, bool>? chronicConditions,
    Map<String, bool>? surgeriesInjuries,
    Map<String, bool>? painBonesMuscles,
    Map<String, bool>? respiratoryProblems,
    Map<String, bool>? medications,
    String? exerciseRegularly,
    PhysicalActivityFrequency? activityFrequency,
    bool? isPregnant,
    String? goals,
    String? declarationName,
    String? declarationSignature,
    String? declarationDate,
    bool? isTermsAccepted,
    String? emergencyContactName,
    String? emergencyContactRelationship,
    String? emergencyContactPhone,
    String? idType,
    String? idNumber,
  }) {
    return SubscriptionState(
      status: status ?? this.status,
      selectedPlanId: selectedPlanId ?? this.selectedPlanId,
      selectedBranchId: selectedBranchId ?? this.selectedBranchId,
      isGift: isGift ?? this.isGift,
      isGiftRedeemIntakeFlow:
          isGiftRedeemIntakeFlow ?? this.isGiftRedeemIntakeFlow,
      currentStep: currentStep ?? this.currentStep,
      selectedProductRequiresHealthIntake:
          selectedProductRequiresHealthIntake ??
          this.selectedProductRequiresHealthIntake,
      checkoutSessionId: checkoutSessionId ?? this.checkoutSessionId,
      checkoutProductId: checkoutProductId ?? this.checkoutProductId,
      deferPaymentReceiptPending:
          deferPaymentReceiptPending ?? this.deferPaymentReceiptPending,
      healthQuestionnaireQuestions:
          healthQuestionnaireQuestions ?? this.healthQuestionnaireQuestions,
      healthQuestionnaireId:
          identical(healthQuestionnaireId, _unsetQuestionnaireId)
          ? this.healthQuestionnaireId
          : healthQuestionnaireId as int?,
      healthQuestionnaireAnswers:
          healthQuestionnaireAnswers ?? this.healthQuestionnaireAnswers,
      healthQuestionnaireAnswerNotes:
          healthQuestionnaireAnswerNotes ?? this.healthQuestionnaireAnswerNotes,
      personalInformationDynamicFields:
          personalInformationDynamicFields ??
          this.personalInformationDynamicFields,
      name: name ?? this.name,
      age: age ?? this.age,
      height: height ?? this.height,
      weight: weight ?? this.weight,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      email: email ?? this.email,
      chronicConditions: chronicConditions ?? this.chronicConditions,
      surgeriesInjuries: surgeriesInjuries ?? this.surgeriesInjuries,
      painBonesMuscles: painBonesMuscles ?? this.painBonesMuscles,
      respiratoryProblems: respiratoryProblems ?? this.respiratoryProblems,
      medications: medications ?? this.medications,
      exerciseRegularly: exerciseRegularly ?? this.exerciseRegularly,
      activityFrequency: activityFrequency ?? this.activityFrequency,
      isPregnant: isPregnant ?? this.isPregnant,
      goals: goals ?? this.goals,
      declarationName: declarationName ?? this.declarationName,
      declarationSignature: declarationSignature ?? this.declarationSignature,
      declarationDate: declarationDate ?? this.declarationDate,
      isTermsAccepted: isTermsAccepted ?? this.isTermsAccepted,
      emergencyContactName: emergencyContactName ?? this.emergencyContactName,
      emergencyContactRelationship:
          emergencyContactRelationship ?? this.emergencyContactRelationship,
      emergencyContactPhone:
          emergencyContactPhone ?? this.emergencyContactPhone,
      idType: idType ?? this.idType,
      idNumber: idNumber ?? this.idNumber,
    );
  }

  @override
  List<Object?> get props => [
    status,
    selectedPlanId,
    selectedBranchId,
    isGift,
    isGiftRedeemIntakeFlow,
    currentStep,
    selectedProductRequiresHealthIntake,
    checkoutSessionId,
    checkoutProductId,
    deferPaymentReceiptPending,
    healthQuestionnaireQuestions,
    healthQuestionnaireId,
    healthQuestionnaireAnswers,
    healthQuestionnaireAnswerNotes,
    personalInformationDynamicFields,
    name,
    age,
    height,
    weight,
    phoneNumber,
    email,
    chronicConditions,
    surgeriesInjuries,
    painBonesMuscles,
    respiratoryProblems,
    medications,
    exerciseRegularly,
    activityFrequency,
    isPregnant,
    goals,
    declarationName,
    declarationSignature,
    declarationDate,
    isTermsAccepted,
    emergencyContactName,
    emergencyContactRelationship,
    emergencyContactPhone,
    idType,
    idNumber,
  ];
}
