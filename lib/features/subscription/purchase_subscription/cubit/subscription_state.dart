part of 'subscription_cubit.dart';

enum SubscriptionStatus { initial, loading, success, error }

class SubscriptionState extends Equatable {
  final SubscriptionStatus status;
  final String selectedPlanId;
  final String selectedBranchId;
  final bool isGift;
  final int currentStep; // 0: Plan, 1: Health Info, 2: Medical History

  // Health Information
  final String name;
  final String age;
  final String height;
  final String weight;
  final String phoneNumber;
  final String email;

  // Medical History (Checkboxes states)
  final Map<String, bool> chronicConditions;
  final Map<String, bool> surgeriesInjuries;
  final Map<String, bool> painBonesMuscles;
  final Map<String, bool> respiratoryProblems;
  final Map<String, bool> medications;


  const SubscriptionState({
    this.status = SubscriptionStatus.initial,
    this.selectedPlanId = 'premium',
    this.selectedBranchId = 'branchA',
    this.isGift = false,
    this.currentStep = 0,
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
  });

  SubscriptionState copyWith({
    SubscriptionStatus? status,
    String? selectedPlanId,
    String? selectedBranchId,
    bool? isGift,
    int? currentStep,
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
  }) {
    return SubscriptionState(
      status: status ?? this.status,
      selectedPlanId: selectedPlanId ?? this.selectedPlanId,
      selectedBranchId: selectedBranchId ?? this.selectedBranchId,
      isGift: isGift ?? this.isGift,
      currentStep: currentStep ?? this.currentStep,
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
    );
  }

  @override
  List<Object> get props => [
        status,
        selectedPlanId,
        selectedBranchId,
        isGift,
        currentStep,
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
      ];
}
