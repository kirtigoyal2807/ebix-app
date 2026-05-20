import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pilates_app/core/network/api_result.dart';
import 'package:pilates_app/features/auth/data/auth_repository.dart';
import 'booking_state.dart';

class BookingCubit extends Cubit<BookingState> {
  BookingCubit({
    required AuthRepository authRepository,
    this.initialTab = BookingTab.classes,
  })  : _authRepository = authRepository,
        super(
          BookingState(
            selectedTab: initialTab,
            trainerTypeList: TrainerType.values,
          ),
        );

  final AuthRepository _authRepository;
  final BookingTab initialTab;

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
}
