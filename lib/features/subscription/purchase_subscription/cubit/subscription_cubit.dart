import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'subscription_state.dart';

class SubscriptionCubit extends Cubit<SubscriptionState> {
  SubscriptionCubit() : super(const SubscriptionState());

  void selectPlan(String planId) {
    emit(state.copyWith(selectedPlanId: planId));
  }

  void selectBranch(String branchId) {
    emit(state.copyWith(selectedBranchId: branchId));
  }

  void toggleGift(bool isGift) {
    emit(state.copyWith(isGift: isGift));
  }

  // Navigation
  void nextStep() {
    // Current assumption: 6 steps total (0-5 index? Start index 0 is Plan. Then Health Steps 1-6. Total 7 steps? or 0 is Plan, 1 is Name, 2 is Medical, 3 is Physical, 4 is Pregnancy, 5 is Goals, 6 is Declaration)
    // The design shows "Step 3 of 6" for "Physical Activity Level". So 6 health steps?
    // Let's assume:
    // Step 0: Plan Selection
    // Step 1: Personal Info
    // Step 2: Medical History
    // Step 3: Physical Activity
    // Step 4: Pregnancy
    // Step 5: Goals
    // Step 6: Declaration
    if (state.currentStep < 6) {
      emit(state.copyWith(currentStep: state.currentStep + 1));
    } else {
      // Finish flow
    }
  }

  void previousStep() {
    if (state.currentStep > 0) {
      emit(state.copyWith(currentStep: state.currentStep - 1));
    }
  }
  
  // Health Info Updates - Step 1
  void updateName(String val) => emit(state.copyWith(name: val));
  void updateAge(String val) => emit(state.copyWith(age: val));
  void updateHeight(String val) => emit(state.copyWith(height: val));
  void updateWeight(String val) => emit(state.copyWith(weight: val));
  void updatePhone(String val) => emit(state.copyWith(phoneNumber: val));
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
  void updateExerciseRegularly(String val) => emit(state.copyWith(exerciseRegularly: val));
  void updateActivityFrequency(PhysicalActivityFrequency val) => emit(state.copyWith(activityFrequency: val));

  // Pregnancy Updates - Step 4
  void updateIsPregnant(bool val) => emit(state.copyWith(isPregnant: val));

  // Goals Updates - Step 5
  void updateGoals(String val) => emit(state.copyWith(goals: val));

  // Declaration Updates - Step 6
  void updateDeclarationName(String val) => emit(state.copyWith(declarationName: val));
  void updateDeclarationSignature(String val) => emit(state.copyWith(declarationSignature: val));
  void updateDeclarationDate(String val) => emit(state.copyWith(declarationDate: val));
}
