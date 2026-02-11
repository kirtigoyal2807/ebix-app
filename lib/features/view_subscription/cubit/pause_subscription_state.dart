import 'package:equatable/equatable.dart';

class PauseSubscriptionState extends Equatable {
  final DateTime? startDate;
  final DateTime? endDate;

  const PauseSubscriptionState({this.startDate, this.endDate});

  PauseSubscriptionState copyWith({DateTime? startDate, DateTime? endDate}) {
    return PauseSubscriptionState(
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
    );
  }

  @override
  List<Object?> get props => [startDate, endDate];
}
