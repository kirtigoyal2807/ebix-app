import 'package:flutter_bloc/flutter_bloc.dart';
import 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(HomeState.initial());

  void setStatus(HomeUserStatus status) {
    emit(state.copyWith(status: status));
  }

  void setTab(int index) {
    emit(state.copyWith(currentIndex: index));
  }
}
