import 'package:equatable/equatable.dart';

class ClassDetailState extends Equatable {
  const ClassDetailState();

  @override
  List<Object?> get props => [];
}

class ClassDetailInitial extends ClassDetailState {}

class ClassDetailLoading extends ClassDetailState {}

class ClassDetailLoaded extends ClassDetailState {
  // We can add class data here later. For now, it's just a placeholder to follow the request.
  const ClassDetailLoaded();
}

class ClassDetailError extends ClassDetailState {
  final String message;
  const ClassDetailError(this.message);

  @override
  List<Object?> get props => [message];
}
