import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pilates_app/core/network/api_result.dart';
import 'package:pilates_app/features/booking/cubit/classes_state.dart';
import 'package:pilates_app/features/booking/data/classes_repository.dart';

class ClassesCubit extends Cubit<ClassesState> {
  ClassesCubit(this._repository) : super(const ClassesState());

  final ClassesRepository _repository;

  /// Load class list from API. [search] is forwarded as a query param (§13.2).
  Future<void> load({String? search, bool force = false}) async {
    if (state.isLoading) return;
    if (!force && state.isLoaded && errorMessage == null) return;

    emit(state.copyWith(status: ClassesLoadStatus.loading, errorMessage: null));

    final result = await _repository.listClasses(search: search);

    switch (result) {
      case ApiSuccess(:final data):
        emit(
          state.copyWith(
            status: ClassesLoadStatus.loaded,
            allClasses: data,
            errorMessage: null,
          ),
        );
      case ApiFailure(:final exception):
        emit(
          state.copyWith(
            status: ClassesLoadStatus.error,
            errorMessage: exception.message,
          ),
        );
    }
  }

  String? get errorMessage => state.errorMessage;

  Future<void> refresh({String? search}) => load(search: search, force: true);
}
