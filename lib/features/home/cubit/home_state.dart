import 'package:equatable/equatable.dart';

import '../data/models/home_response.dart';

enum HomeUserStatus { empty, existing, expired }

enum HomeLoadStatus { initial, loading, loaded, failure }

class HomeState extends Equatable {
  final int currentIndex;
  final HomeLoadStatus loadStatus;
  final String errorMessage;
  final HomeResponse? data;

  const HomeState({
    required this.currentIndex,
    required this.loadStatus,
    required this.errorMessage,
    required this.data,
  });

  factory HomeState.initial() {
    return const HomeState(
      currentIndex: 0,
      loadStatus: HomeLoadStatus.initial,
      errorMessage: '',
      data: null,
    );
  }

  HomeState copyWith({
    int? currentIndex,
    HomeLoadStatus? loadStatus,
    String? errorMessage,
    HomeResponse? data,
    bool clearData = false,
  }) {
    return HomeState(
      currentIndex: currentIndex ?? this.currentIndex,
      loadStatus: loadStatus ?? this.loadStatus,
      errorMessage: errorMessage ?? this.errorMessage,
      data: clearData ? null : (data ?? this.data),
    );
  }

  @override
  List<Object?> get props => [currentIndex, loadStatus, errorMessage, data];
}
