import 'package:equatable/equatable.dart';
import 'package:pilates_app/features/booking/cubit/booking_state.dart';

import '../data/models/home_response.dart';

enum HomeUserStatus { empty, existing, expired }

enum HomeLoadStatus { initial, loading, loaded, failure }

const Object _unsetClassCategory = Object();

class HomeState extends Equatable {
  final int currentIndex;
  final HomeLoadStatus loadStatus;
  final String errorMessage;
  final HomeResponse? data;
  final BookingTab selectedBookingTab;
  final String? selectedClassCategory;

  /// Bumped when trainer details (opened from home) requests classes with all filters cleared.
  final int browseAllClassesNonce;

  const HomeState({
    required this.currentIndex,
    required this.loadStatus,
    required this.errorMessage,
    required this.data,
    required this.selectedBookingTab,
    required this.selectedClassCategory,
    required this.browseAllClassesNonce,
  });

  factory HomeState.initial() {
    return const HomeState(
      currentIndex: 0,
      loadStatus: HomeLoadStatus.initial,
      errorMessage: '',
      data: null,
      selectedBookingTab: BookingTab.classes,
      selectedClassCategory: null,
      browseAllClassesNonce: 0,
    );
  }

  HomeState copyWith({
    int? currentIndex,
    HomeLoadStatus? loadStatus,
    String? errorMessage,
    HomeResponse? data,
    BookingTab? selectedBookingTab,
    Object? selectedClassCategory = _unsetClassCategory,
    int? browseAllClassesNonce,
    bool clearData = false,
  }) {
    return HomeState(
      currentIndex: currentIndex ?? this.currentIndex,
      loadStatus: loadStatus ?? this.loadStatus,
      errorMessage: errorMessage ?? this.errorMessage,
      data: clearData ? null : (data ?? this.data),
      selectedBookingTab: selectedBookingTab ?? this.selectedBookingTab,
      selectedClassCategory: selectedClassCategory == _unsetClassCategory
          ? this.selectedClassCategory
          : selectedClassCategory as String?,
      browseAllClassesNonce:
          browseAllClassesNonce ?? this.browseAllClassesNonce,
    );
  }

  @override
  List<Object?> get props => [
    currentIndex,
    loadStatus,
    errorMessage,
    data,
    selectedBookingTab,
    selectedClassCategory,
    browseAllClassesNonce,
  ];
}
