import 'package:equatable/equatable.dart';

enum HomeUserStatus { empty, existing, expired }

class HomeState extends Equatable {
  final HomeUserStatus status;
  final String userName;
  final int classesDone;
  final double totalHours;
  final int goalClasses;
  final int currentIndex;

  const HomeState({
    required this.status,
    required this.userName,
    required this.classesDone,
    required this.totalHours,
    required this.goalClasses,
    required this.currentIndex,
  });

  factory HomeState.initial() {
    return const HomeState(
      status: HomeUserStatus.existing, // Default for testing all UI elements
      userName: "Rachel",
      classesDone: 12,
      totalHours: 8.5,
      goalClasses: 16,
      currentIndex: 0,
    );
  }

  HomeState copyWith({
    HomeUserStatus? status,
    String? userName,
    int? classesDone,
    double? totalHours,
    int? goalClasses,
    int? currentIndex,
  }) {
    return HomeState(
      status: status ?? this.status,
      userName: userName ?? this.userName,
      classesDone: classesDone ?? this.classesDone,
      totalHours: totalHours ?? this.totalHours,
      goalClasses: goalClasses ?? this.goalClasses,
      currentIndex: currentIndex ?? this.currentIndex,
    );
  }

  @override
  List<Object?> get props => [
    status,
    userName,
    classesDone,
    totalHours,
    goalClasses,
    currentIndex,
  ];
}
