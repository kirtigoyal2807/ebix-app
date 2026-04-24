import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pilates_app/core/network/api_result.dart';

import 'package:pilates_app/features/my_booking/cubit/my_bookings_status_group.dart';
import 'package:pilates_app/features/my_booking/cubit/tab_bookings_state.dart';
import 'package:pilates_app/features/my_booking/data/models/booking_resource.dart';
import 'package:pilates_app/features/my_booking/data/my_bookings_repository.dart';

class MyBookingsCubit extends Cubit<MyBookingsState> {
  MyBookingsCubit(this._repository) : super(MyBookingsState.initial());

  final MyBookingsRepository _repository;

  Future<void> ensureLoaded(MyBookingsStatusGroup group) =>
      load(group, force: false);

  Future<void> refresh(MyBookingsStatusGroup group) =>
      load(group, force: true);

  Future<void> load(MyBookingsStatusGroup group, {bool force = false}) async {
    final current = state.tab(group);
    if (current.isLoading) return;
    if (!force && current.hasFetched && current.errorMessage == null) return;

    emit(
      state.copyWithTab(
        group,
        (t) => t.copyWith(isLoading: true, clearError: true),
      ),
    );

    final result = await _repository.listMyBookings(
      statusGroup: group.apiValue,
    );

    switch (result) {
      case ApiSuccess(:final data):
        emit(
          state.copyWithTab(
            group,
            (t) => t.copyWith(
              isLoading: false,
              hasFetched: true,
              clearError: true,
              items: data.items,
              pagination: data.pagination,
            ),
          ),
        );
      case ApiFailure(:final exception):
        emit(
          state.copyWithTab(
            group,
            (t) => t.copyWith(
              isLoading: false,
              hasFetched: false,
              errorMessage: exception.message,
            ),
          ),
        );
    }
  }

  /// §13.11 — returns `null` on success, or a user-facing error message.
  Future<String?> checkIn(String enrollmentId) async {
    final id = enrollmentId.trim();
    if (id.isEmpty) return 'Invalid booking';

    emit(state.copyWith(checkInBusyEnrollmentId: id));

    final result = await _repository.checkIn(id);

    switch (result) {
      case ApiSuccess(:final data):
        emit(
          _mergeBookingAcrossTabs(state, data).copyWith(clearCheckInBusy: true),
        );
        return null;
      case ApiFailure(:final exception):
        emit(state.copyWith(clearCheckInBusy: true));
        final msg = exception.message;
        return (msg == null || msg.isEmpty) ? 'Check-in failed' : msg;
    }
  }

  /// §13.10 — returns `null` on success, or a user-facing error message.
  Future<String?> cancelEnrollment(String enrollmentId) async {
    final id = enrollmentId.trim();
    if (id.isEmpty) return 'Invalid booking';

    emit(state.copyWith(cancelBusyEnrollmentId: id));

    final result = await _repository.cancelEnrollment(id);

    switch (result) {
      case ApiSuccess(:final data):
        emit(
          _applyCancellationAcrossTabs(state, data).copyWith(
            clearCancelBusy: true,
          ),
        );
        return null;
      case ApiFailure(:final exception):
        emit(state.copyWith(clearCancelBusy: true));
        final msg = exception.message;
        return (msg == null || msg.isEmpty) ? 'Cancellation failed' : msg;
    }
  }

  static MyBookingsState _mergeBookingAcrossTabs(
    MyBookingsState current,
    BookingResource updated,
  ) {
    final nextTabs = <TabBookingsState>[];
    for (final tab in current.tabs) {
      if (!tab.items.any((b) => b.id == updated.id)) {
        nextTabs.add(tab);
        continue;
      }
      nextTabs.add(
        tab.copyWith(
          items: tab.items
              .map((b) => b.id == updated.id ? updated : b)
              .toList(),
        ),
      );
    }
    return MyBookingsState(
      tabs: nextTabs,
      checkInBusyEnrollmentId: current.checkInBusyEnrollmentId,
      cancelBusyEnrollmentId: current.cancelBusyEnrollmentId,
    );
  }

  /// Removes the enrollment from non-cancelled tabs; inserts updated row on Cancelled if loaded.
  static MyBookingsState _applyCancellationAcrossTabs(
    MyBookingsState current,
    BookingResource cancelled,
  ) {
    final nextTabs = <TabBookingsState>[];
    for (var i = 0; i < current.tabs.length; i++) {
      final g = MyBookingsStatusGroup.values[i];
      final tab = current.tabs[i];
      if (g == MyBookingsStatusGroup.cancelled && tab.hasFetched) {
        final rest = tab.items.where((b) => b.id != cancelled.id).toList();
        nextTabs.add(tab.copyWith(items: [cancelled, ...rest]));
      } else {
        nextTabs.add(
          tab.copyWith(
            items: tab.items.where((b) => b.id != cancelled.id).toList(),
          ),
        );
      }
    }
    return MyBookingsState(
      tabs: nextTabs,
      checkInBusyEnrollmentId: current.checkInBusyEnrollmentId,
      cancelBusyEnrollmentId: current.cancelBusyEnrollmentId,
    );
  }
}
