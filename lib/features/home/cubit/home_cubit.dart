import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pilates_app/core/network/api_result.dart';
import 'package:pilates_app/core/storage/token_storage.dart';
import 'package:pilates_app/features/booking/cubit/booking_state.dart';

import '../data/home_repository.dart';
import '../data/models/home_response.dart';
import 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit({
    required HomeRepository homeRepository,
    required TokenStorage tokenStorage,
    HomeState? initialState,
  }) : _homeRepository = homeRepository,
       _tokenStorage = tokenStorage,
       super(initialState ?? HomeState.initial());

  final HomeRepository _homeRepository;
  final TokenStorage _tokenStorage;

  void setTab(int index, {BookingTab? bookingTab, String? classCategory}) {
    emit(
      state.copyWith(
        currentIndex: index,
        selectedBookingTab:
            bookingTab ??
            (index == 1 ? BookingTab.classes : state.selectedBookingTab),
        selectedClassCategory: classCategory,
      ),
    );
  }

  void clearSelectedClassCategory() {
    if (state.selectedClassCategory == null) return;
    emit(state.copyWith(selectedClassCategory: null));
  }

  Future<void> loadHome() async {
    emit(state.copyWith(loadStatus: HomeLoadStatus.loading, errorMessage: ''));

    final result = await _homeRepository.fetchHome();
    switch (result) {
      case ApiSuccess<HomeResponse>(:final data):
        final planName = data.membership?.planName?.trim() ?? '';
        if (planName.isNotEmpty) {
          await _tokenStorage.saveMembershipPlanName(planName);
        }
        emit(
          state.copyWith(
            loadStatus: HomeLoadStatus.loaded,
            errorMessage: '',
            data: data,
          ),
        );
      case ApiFailure<HomeResponse>(:final exception):
        emit(
          state.copyWith(
            loadStatus: HomeLoadStatus.failure,
            errorMessage: exception.message ?? '',
          ),
        );
    }
  }

  /// Re-fetches home without switching to [HomeLoadStatus.loading] when
  /// [HomeState.data] is already available (keeps current UI during pull-to-refresh).
  Future<void> refreshHome() async {
    if (state.data == null) {
      await loadHome();
      return;
    }

    emit(state.copyWith(errorMessage: ''));
    final result = await _homeRepository.fetchHome();
    switch (result) {
      case ApiSuccess<HomeResponse>(:final data):
        final planName = data.membership?.planName?.trim() ?? '';
        if (planName.isNotEmpty) {
          await _tokenStorage.saveMembershipPlanName(planName);
        }
        emit(
          state.copyWith(
            loadStatus: HomeLoadStatus.loaded,
            errorMessage: '',
            data: data,
          ),
        );
      case ApiFailure<HomeResponse>(:final exception):
        emit(
          state.copyWith(
            loadStatus: HomeLoadStatus.failure,
            errorMessage: exception.message ?? '',
          ),
        );
    }
  }

  /// Re-fetches home with loading state shown (used for locale changes).
  Future<void> refreshHomeWithLoading() async {
    emit(state.copyWith(loadStatus: HomeLoadStatus.loading, errorMessage: ''));

    final result = await _homeRepository.fetchHome();
    switch (result) {
      case ApiSuccess<HomeResponse>(:final data):
        final planName = data.membership?.planName?.trim() ?? '';
        if (planName.isNotEmpty) {
          await _tokenStorage.saveMembershipPlanName(planName);
        }
        emit(
          state.copyWith(
            loadStatus: HomeLoadStatus.loaded,
            errorMessage: '',
            data: data,
          ),
        );
      case ApiFailure<HomeResponse>(:final exception):
        emit(
          state.copyWith(
            loadStatus: HomeLoadStatus.failure,
            errorMessage: exception.message ?? '',
          ),
        );
    }
  }
}
