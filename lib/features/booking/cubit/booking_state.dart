import 'package:equatable/equatable.dart';

enum BookingTab { classes, trainers }

enum ClassDetailStatus { initial, loading, loaded, error }

class BookingState extends Equatable {
  final BookingTab selectedTab;
  final String searchQuery;
  final String selectedBranch;
  final String selectedDate;
  final String selectedCategory;
  final String selectedGender;
  final ClassDetailStatus classDetailStatus;
  final List<TrainerType> trainerTypeList;
  final TrainerType selectedTrainerType;

  const BookingState({
    this.selectedTab = BookingTab.classes,
    this.searchQuery = '',
    this.selectedBranch = 'All Branches',
    this.selectedDate = 'Today',
    this.selectedCategory = 'All Categories',
    this.selectedGender = 'All Gender',
    this.classDetailStatus = ClassDetailStatus.initial,
    this.selectedTrainerType = TrainerType.allTrainers,
    required this.trainerTypeList,
  });

  BookingState copyWith({
    BookingTab? selectedTab,
    String? searchQuery,
    String? selectedBranch,
    String? selectedDate,
    String? selectedCategory,
    String? selectedGender,
    ClassDetailStatus? classDetailStatus,
    TrainerType? selectedTrainerType,
  }) {
    return BookingState(
      selectedTab: selectedTab ?? this.selectedTab,
      searchQuery: searchQuery ?? this.searchQuery,
      selectedBranch: selectedBranch ?? this.selectedBranch,
      selectedDate: selectedDate ?? this.selectedDate,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      selectedGender: selectedGender ?? this.selectedGender,
      classDetailStatus: classDetailStatus ?? this.classDetailStatus,
      selectedTrainerType: selectedTrainerType ?? this.selectedTrainerType,
      trainerTypeList: trainerTypeList,
    );
  }

  @override
  List<Object?> get props => [
    selectedTab,
    searchQuery,
    selectedBranch,
    selectedDate,
    selectedCategory,
    selectedGender,
    classDetailStatus,
    selectedTrainerType,
    trainerTypeList,
  ];
}

enum TrainerType { allTrainers, matPilates, reformer, seniorFriendly }
