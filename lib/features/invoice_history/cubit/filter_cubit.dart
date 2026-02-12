import 'package:bloc/bloc.dart';
import 'filter_state.dart';

class FilterCubit extends Cubit<FilterState> {
  FilterCubit()
    : super(
        FilterState(sortByList: SortBy.values, dateRangeList: DateRange.values),
      );

  void setSelectedSortBy(SortBy value) {
    emit(state.copyWith(selectedSortByValue: value));
  }

  void setSelectedDateRange(DateRange value) {
    emit(state.copyWith(selectedDateRange: value));
  }
}
