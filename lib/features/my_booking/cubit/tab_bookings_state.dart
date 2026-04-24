import 'package:equatable/equatable.dart';
import 'package:pilates_app/features/auth/data/models/pagination_meta.dart';
import 'package:pilates_app/features/my_booking/cubit/my_bookings_status_group.dart';
import 'package:pilates_app/features/my_booking/data/models/booking_resource.dart';

class TabBookingsState extends Equatable {
  const TabBookingsState({
    required this.isLoading,
    required this.hasFetched,
    this.errorMessage,
    required this.items,
    this.pagination,
  });

  final bool isLoading;
  final bool hasFetched;
  final String? errorMessage;
  final List<BookingResource> items;
  final PaginationMeta? pagination;

  factory TabBookingsState.initial() => const TabBookingsState(
        isLoading: false,
        hasFetched: false,
        errorMessage: null,
        items: [],
        pagination: null,
      );

  TabBookingsState copyWith({
    bool? isLoading,
    bool? hasFetched,
    String? errorMessage,
    List<BookingResource>? items,
    PaginationMeta? pagination,
    bool clearError = false,
  }) {
    return TabBookingsState(
      isLoading: isLoading ?? this.isLoading,
      hasFetched: hasFetched ?? this.hasFetched,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      items: items ?? this.items,
      pagination: pagination ?? this.pagination,
    );
  }

  @override
  List<Object?> get props => [isLoading, hasFetched, errorMessage, items, pagination];
}

class MyBookingsState extends Equatable {
  const MyBookingsState({
    required this.tabs,
    this.checkInBusyEnrollmentId,
    this.cancelBusyEnrollmentId,
  });

  final List<TabBookingsState> tabs;

  /// When set, the matching enrollment row shows a loading check-in control.
  final String? checkInBusyEnrollmentId;

  /// When set, the matching row shows loading on cancel / leave waitlist.
  final String? cancelBusyEnrollmentId;

  factory MyBookingsState.initial() => MyBookingsState(
        tabs: List.generate(
          MyBookingsStatusGroup.values.length,
          (_) => TabBookingsState.initial(),
        ),
      );

  TabBookingsState tab(MyBookingsStatusGroup g) => tabs[g.tabIndex];

  MyBookingsState copyWith({
    List<TabBookingsState>? tabs,
    String? checkInBusyEnrollmentId,
    bool clearCheckInBusy = false,
    String? cancelBusyEnrollmentId,
    bool clearCancelBusy = false,
  }) {
    return MyBookingsState(
      tabs: tabs ?? this.tabs,
      checkInBusyEnrollmentId: clearCheckInBusy
          ? null
          : (checkInBusyEnrollmentId ?? this.checkInBusyEnrollmentId),
      cancelBusyEnrollmentId: clearCancelBusy
          ? null
          : (cancelBusyEnrollmentId ?? this.cancelBusyEnrollmentId),
    );
  }

  MyBookingsState copyWithTab(
    MyBookingsStatusGroup g,
    TabBookingsState Function(TabBookingsState current) updater,
  ) {
    final i = g.tabIndex;
    final next = List<TabBookingsState>.from(tabs);
    next[i] = updater(next[i]);
    return MyBookingsState(
      tabs: next,
      checkInBusyEnrollmentId: checkInBusyEnrollmentId,
      cancelBusyEnrollmentId: cancelBusyEnrollmentId,
    );
  }

  @override
  List<Object?> get props => [tabs, checkInBusyEnrollmentId, cancelBusyEnrollmentId];
}
