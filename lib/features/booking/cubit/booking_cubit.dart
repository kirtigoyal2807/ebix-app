import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pilates_app/core/network/api_result.dart';
import 'package:pilates_app/features/auth/data/auth_repository.dart';
import 'booking_state.dart';

class BookingCubit extends Cubit<BookingState> {
  BookingCubit({
    required AuthRepository authRepository,
    this.initialTab = BookingTab.classes,
    required String initialLocaleLanguageCode,
  })  : _authRepository = authRepository,
        _classFiltersLocaleCode = initialLocaleLanguageCode,
        super(
          BookingState(
            selectedTab: initialTab,
            trainerTypeList: TrainerType.values,
          ),
        );

  final AuthRepository _authRepository;
  final BookingTab initialTab;

  /// Last locale applied to class filter chips (date, branch, category, gender, search).
  String _classFiltersLocaleCode;

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

  /// Clears cached branch filter data (e.g. after app locale changes).
  void invalidateBranchesCache() {
    if (state.branches.isEmpty &&
        state.branchesLoadStatus == BranchesLoadStatus.initial) {
      return;
    }
    emit(
      state.copyWith(
        branches: const [],
        branchesLoadStatus: BranchesLoadStatus.initial,
      ),
    );
  }

  /// `GET /branches` — options for the booking branch filter chip.
  Future<void> loadBranches({bool force = false}) async {
    if (!force &&
        (state.branchesLoadStatus == BranchesLoadStatus.loading ||
            state.branchesLoadStatus == BranchesLoadStatus.loaded)) {
      return;
    }

    emit(state.copyWith(branchesLoadStatus: BranchesLoadStatus.loading));

    final result = await _authRepository.listBranches(
      queryParameters: const {'page': 1, 'per_page': 50},
    );

    if (isClosed) return;

    switch (result) {
      case ApiSuccess(:final data):
        final branches = data.branches
            .where((b) => b.isActive && b.title.trim().isNotEmpty)
            .toList();
        emit(
          state.copyWith(
            branches: branches,
            branchesLoadStatus: BranchesLoadStatus.loaded,
          ),
        );
      case ApiFailure():
        emit(state.copyWith(branchesLoadStatus: BranchesLoadStatus.failure));
    }
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

  void setTrainer(TrainerType trainerType) {
    emit(state.copyWith(selectedTrainerType: trainerType));
  }

  /// Resets all class filter chips and search to their default values.
  void clearClassFilters() {
    emit(
      state.copyWith(
        searchQuery: '',
        selectedBranch: kAllBranchesFilter,
        selectedDate: 'Today',
        selectedCategory: 'All Categories',
        selectedGender: 'All Gender',
      ),
    );
  }

  /// Clears class filter chips when [languageCode] changes (locale switch).
  void syncClassFiltersForLocale(String languageCode) {
    if (_classFiltersLocaleCode == languageCode) return;
    _classFiltersLocaleCode = languageCode;
    clearClassFilters();
  }

  /// Clears class filters/search and signals the classes list to scroll to top.
  void resetClassFiltersAndScrollToTop() {
    clearClassFilters();
    emit(
      state.copyWith(
        selectedDate: 'All Dates',
        classesScrollToTopNonce: state.classesScrollToTopNonce + 1,
      ),
    );
  }

  /// Trainer Details → full classes catalog with no filters.
  void openBrowseAllClassesFromTrainer() {
    clearClassFilters();
    emit(
      state.copyWith(
        selectedTab: BookingTab.classes,
        selectedDate: 'All Dates',
        classesScrollToTopNonce: state.classesScrollToTopNonce + 1,
      ),
    );
  }
}
