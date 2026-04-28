import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pilates_app/core/network/api_result.dart';
import 'package:pilates_app/features/booking/cubit/booking_state.dart';

import '../data/home_repository.dart';
import '../data/models/home_response.dart';
import 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit({
    required HomeRepository homeRepository,
    HomeState? initialState,
  }) : _homeRepository = homeRepository,
       super(initialState ?? HomeState.initial());

  final HomeRepository _homeRepository;

  void setTab(int index, {BookingTab? bookingTab}) {
    emit(
      state.copyWith(
        currentIndex: index,
        selectedBookingTab:
            bookingTab ??
            (index == 1 ? BookingTab.classes : state.selectedBookingTab),
      ),
    );
  }

  Future<void> loadHome() async {
    emit(state.copyWith(loadStatus: HomeLoadStatus.loading, errorMessage: ''));

    final result = await _homeRepository.fetchHome();
    switch (result) {
      case ApiSuccess<HomeResponse>(:final data):
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
