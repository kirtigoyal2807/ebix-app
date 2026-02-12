import 'package:equatable/equatable.dart';

class FilterState extends Equatable {
  final List<SortBy> sortByList;
  final SortBy selectedSortByValue;

  final List<DateRange> dateRangeList;
  final DateRange selectedDateRange;

  const FilterState({
    required this.sortByList,
    required this.dateRangeList,
    this.selectedSortByValue = SortBy.newest,
    this.selectedDateRange = DateRange.last30Days,
  });

  FilterState copyWith({
    SortBy? selectedSortByValue,
    DateRange? selectedDateRange,
  }) {
    return FilterState(
      sortByList: sortByList,
      dateRangeList: dateRangeList,
      selectedSortByValue: selectedSortByValue ?? this.selectedSortByValue,
      selectedDateRange: selectedDateRange ?? this.selectedDateRange,
    );
  }

  @override
  List<Object> get props => [
    sortByList,
    selectedSortByValue,
    dateRangeList,
    selectedDateRange,
  ];
}

enum SortBy { newest, oldest, priceHighToLow, priceLowToHigh }

enum DateRange { last30Days, last3Months, last6Months, thisYear, allTime }
