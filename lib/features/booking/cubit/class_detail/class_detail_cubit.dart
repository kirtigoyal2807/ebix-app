import 'package:flutter_bloc/flutter_bloc.dart';
import 'class_detail_state.dart';

class ClassDetailCubit extends Cubit<ClassDetailState> {
  ClassDetailCubit() : super(ClassDetailInitial());

  void loadClassDetails() {
    emit(ClassDetailLoading());
    // Simulate loading data
    Future.delayed(const Duration(milliseconds: 500), () {
      emit(const ClassDetailLoaded());
    });
  }

  void bookClass() {
    // Add booking logic here
  }
}
