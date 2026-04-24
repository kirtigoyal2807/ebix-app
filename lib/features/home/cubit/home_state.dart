import 'package:equatable/equatable.dart';
import 'package:pilates_app/features/booking/cubit/booking_state.dart';

import '../data/models/home_response.dart';

enum HomeUserStatus { empty, existing, expired }

enum HomeLoadStatus { initial, loading, loaded, failure }

class HomeState extends Equatable {
  final int currentIndex;
  final HomeLoadStatus loadStatus;
  final String errorMessage;
  final HomeResponse? data;
  final BookingTab selectedBookingTab;

  const HomeState({
    required this.currentIndex,
    required this.loadStatus,
    required this.errorMessage,
    required this.data,
    required this.selectedBookingTab,
  });

  factory HomeState.initial() {
    return const HomeState(
      currentIndex: 0,
      loadStatus: HomeLoadStatus.initial,
      errorMessage: '',
      data: null,
      selectedBookingTab: BookingTab.classes,
    );
  }

  HomeState copyWith({
    int? currentIndex,
    HomeLoadStatus? loadStatus,
    String? errorMessage,
    HomeResponse? data,
    BookingTab? selectedBookingTab,
    bool clearData = false,
  }) {
    return HomeState(
      currentIndex: currentIndex ?? this.currentIndex,
      loadStatus: loadStatus ?? this.loadStatus,
      errorMessage: errorMessage ?? this.errorMessage,
      data: clearData ? null : (data ?? this.data),
      selectedBookingTab: selectedBookingTab ?? this.selectedBookingTab,
    );
  }

  @override
  List<Object?> get props => [
    currentIndex,
    loadStatus,
    errorMessage,
    data,
    selectedBookingTab,
  ];
}
