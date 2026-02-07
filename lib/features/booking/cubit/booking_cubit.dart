import 'package:flutter_bloc/flutter_bloc.dart';
import 'booking_state.dart';

class BookingCubit extends Cubit<BookingState> {
  BookingCubit() : super(const BookingState());

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

  void setGender(String gender) {
    emit(state.copyWith(selectedGender: gender));
  }
}
