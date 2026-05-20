import 'package:equatable/equatable.dart';
import 'package:pilates_app/features/auth/data/models/branch.dart';

enum BookingTab { classes, trainers }

enum ClassDetailStatus { initial, loading, loaded, error }

enum BranchesLoadStatus { initial, loading, loaded, failure }

/// Sentinel for the branch filter chip and local class filtering.
const String kAllBranchesFilter = 'All Branches';

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
  final List<Branch> branches;
  final BranchesLoadStatus branchesLoadStatus;

  const BookingState({
    this.selectedTab = BookingTab.classes,
    this.searchQuery = '',
    this.selectedBranch = kAllBranchesFilter,
    this.selectedDate = 'Today',
    this.selectedCategory = 'All Categories',
    this.selectedGender = 'All Gender',
    this.classDetailStatus = ClassDetailStatus.initial,
    this.selectedTrainerType = TrainerType.allTrainers,
    required this.trainerTypeList,
    this.branches = const [],
    this.branchesLoadStatus = BranchesLoadStatus.initial,
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
    List<Branch>? branches,
    BranchesLoadStatus? branchesLoadStatus,
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
      branches: branches ?? this.branches,
      branchesLoadStatus: branchesLoadStatus ?? this.branchesLoadStatus,
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
    branches,
    branchesLoadStatus,
  ];
}

enum TrainerType { allTrainers, matPilates, reformer, seniorFriendly }
