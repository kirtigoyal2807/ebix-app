import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pilates_app/core/network/api_result.dart';
import 'package:pilates_app/core/network/network_exception.dart';
import 'package:pilates_app/core/storage/token_storage.dart';
import 'package:pilates_app/features/auth/cubit/auth_cubit.dart';
import 'package:pilates_app/features/auth/data/auth_repository.dart';
import 'package:pilates_app/features/auth/data/models/auth_user.dart';
import 'package:pilates_app/features/booking/cubit/booking_state.dart';

import '../data/home_repository.dart';
import '../data/models/home_response.dart';
import 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit({
    required HomeRepository homeRepository,
    required TokenStorage tokenStorage,
    required AuthRepository authRepository,
    required AuthCubit authCubit,
    HomeState? initialState,
  }) : _homeRepository = homeRepository,
       _tokenStorage = tokenStorage,
       _authRepository = authRepository,
       _authCubit = authCubit,
       super(initialState ?? HomeState.initial());

  final HomeRepository _homeRepository;
  final TokenStorage _tokenStorage;
  final AuthRepository _authRepository;
  final AuthCubit _authCubit;

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

  /// Home → trainer details → Browse All Classes (no [BookingCubit] on pushed route).
  void requestBrowseAllClasses() {
    emit(
      state.copyWith(
        currentIndex: 1,
        selectedBookingTab: BookingTab.classes,
        selectedClassCategory: null,
        browseAllClassesNonce: state.browseAllClassesNonce + 1,
      ),
    );
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
        if (await _invalidateSessionIfUserNotFound(exception)) {
          return;
        }
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
        if (await _invalidateSessionIfUserNotFound(exception)) {
          return;
        }
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
        if (await _invalidateSessionIfUserNotFound(exception)) {
          return;
        }
        emit(
          state.copyWith(
            loadStatus: HomeLoadStatus.failure,
            errorMessage: exception.message ?? '',
          ),
        );
    }
  }

  /// Refreshes both home and user (`GET /auth/me`) silently without showing loading indicator.
  /// Used when clicking on home tab to refresh data in background.
  Future<void> refreshHomeAndProfileSilently() async {
    // Only refresh if we already have data (avoid loading state on initial load)
    if (state.data == null) {
      return;
    }

    emit(state.copyWith(errorMessage: ''));

    // Call both APIs in parallel
    final results = await Future.wait([
      _homeRepository.fetchHome(),
      _authRepository.getAuthMe(),
    ]);

    final homeResult = results[0] as ApiResult<HomeResponse>;
    final profileResult = results[1] as ApiResult<AuthUser>;

    // Handle home result
    switch (homeResult) {
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
        if (await _invalidateSessionIfUserNotFound(exception)) {
          return;
        }
        // Silently fail - don't show error or loading state
        break;
    }

    // Handle profile result - save to storage if successful
    switch (profileResult) {
      case ApiSuccess<AuthUser>(:final data):
        await _tokenStorage.saveUser(data);
      case ApiFailure<AuthUser>():
        // Silently fail - keep existing user data
        break;
    }
  }

  Future<bool> _invalidateSessionIfUserNotFound(
    NetworkException exception,
  ) async {
    if (!exception.isUserNotFound) {
      return false;
    }
    await _authCubit.logoutLocally();
    return true;
  }
}
