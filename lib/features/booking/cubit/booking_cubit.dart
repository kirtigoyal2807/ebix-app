import 'package:flutter_bloc/flutter_bloc.dart';
import 'booking_state.dart';

class BookingCubit extends Cubit<BookingState> {
  BookingCubit() : super(  BookingState(

    trainerTypeList: TrainerType.values
  ));

  void setTab(BookingTab tab) {
    emit(state.copyWith(selectedTab: tab));
  }

  void updateSearchQuery(String query) {
    emit(state.copyWith(searchQuery: query));
  }

  void setDate(String date) {
    emit(state.copyWith(selectedDate: date));
  }

  void setCategory(String category) {
    emit(state.copyWith(selectedCategory: category));
  }

  void setBranch(String branch) {
    emit(state.copyWith(selectedBranch: branch));
  }

  void setGender(String gender) {
    emit(state.copyWith(selectedGender: gender));
  }

  void loadClassDetails() {
    emit(state.copyWith(classDetailStatus: ClassDetailStatus.loading));
    // Simulate loading data
    Future.delayed(const Duration(milliseconds: 500), () {
      emit(state.copyWith(classDetailStatus: ClassDetailStatus.loaded));
    });
  }

  void bookClass() {
    // Add booking logic here
  }

  void setTrainer(TrainerType trainerType){
    emit(state.copyWith(selectedTrainerType: trainerType));
  }
}
