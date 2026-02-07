import 'package:equatable/equatable.dart';

enum BookingTab { classes, trainers }

class BookingState extends Equatable {
  final BookingTab selectedTab;
  final String searchQuery;
  final String selectedDate;
  final String selectedCategory;
  final String selectedGender;

  const BookingState({
    this.selectedTab = BookingTab.classes,
    this.searchQuery = '',
    this.selectedDate = 'Today',
    this.selectedCategory = 'All Categories',
    this.selectedGender = 'All Gender',
  });

  BookingState copyWith({
    BookingTab? selectedTab,
    String? searchQuery,
    String? selectedDate,
    String? selectedCategory,
    String? selectedGender,
  }) {
    return BookingState(
      selectedTab: selectedTab ?? this.selectedTab,
      searchQuery: searchQuery ?? this.searchQuery,
      selectedDate: selectedDate ?? this.selectedDate,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      selectedGender: selectedGender ?? this.selectedGender,
    );
  }

  @override
  List<Object?> get props => [
        selectedTab,
        searchQuery,
        selectedDate,
        selectedCategory,
        selectedGender,
      ];
}
