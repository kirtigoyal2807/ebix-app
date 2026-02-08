import 'package:equatable/equatable.dart';

class ConfirmBookingState extends Equatable {
  final bool agreePolicy;

  const ConfirmBookingState({this.agreePolicy = false});

  ConfirmBookingState copyWith({bool? agreePolicy}) {
    return ConfirmBookingState(agreePolicy: agreePolicy ?? this.agreePolicy);
  }

  @override
  List<Object?> get props => [agreePolicy];
}
