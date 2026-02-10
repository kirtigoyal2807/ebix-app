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
    if (state.currentStep < 2) {
      emit(state.copyWith(currentStep: state.currentStep + 1));
    }
  }

  void previousStep() {
    if (state.currentStep > 0) {
      emit(state.copyWith(currentStep: state.currentStep - 1));
    }
  }
  
  // Health Info Updates
  void updateName(String val) => emit(state.copyWith(name: val));
  void updateAge(String val) => emit(state.copyWith(age: val));
  void updateHeight(String val) => emit(state.copyWith(height: val));
  void updateWeight(String val) => emit(state.copyWith(weight: val));
  void updatePhone(String val) => emit(state.copyWith(phoneNumber: val));
  void updateEmail(String val) => emit(state.copyWith(email: val));

  // Medical History Updates (Generic helper for checkbox maps)
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
}
