import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pilates_app/core/localization/arb/app_localizations.dart';
import 'package:pilates_app/core/network/network_exception.dart';
import 'package:pilates_app/features/invoice_history/data/subscriptions_repository.dart';
import 'package:pilates_app/features/view_subscription/cubit/pause_subscription_state.dart';

class PauseSubscriptionCubit extends Cubit<PauseSubscriptionState> {
  PauseSubscriptionCubit({
    required this.subscriptionId,
    required SubscriptionsRepository repository,
    required DateTime planStartDateLocal,
    DateTime? planExpiresAtLocal,
    required int maxFreezeDays,
  }) : _repo = repository,
       _planStart = _dateOnly(planStartDateLocal),
       _planExpires = planExpiresAtLocal != null
           ? _dateOnly(planExpiresAtLocal)
           : null,
       _maxFreezeDays = maxFreezeDays < 1 ? 1 : maxFreezeDays,
       super(const PauseSubscriptionState());

  final String subscriptionId;
  final SubscriptionsRepository _repo;

  /// Plan / subscription start (local calendar day).
  final DateTime _planStart;

  /// Plan end (local calendar day), if known.
  final DateTime? _planExpires;

  /// Maximum inclusive calendar days for one pause.
  final int _maxFreezeDays;

  static DateTime _dateOnly(DateTime d) {
    final l = d.toLocal();
    return DateTime(l.year, l.month, l.day);
  }

  DateTime get _today => _dateOnly(DateTime.now());

  /// Earliest day the member may start a pause (plan start vs today).
  DateTime get earliestPauseStart {
    return _planStart.isAfter(_today) ? _planStart : _today;
  }

  /// Latest day a pause may **start** (before or on plan end).
  DateTime get latestPauseStart {
    if (_planExpires == null) {
      return DateTime(2100, 12, 31);
    }
    return _planExpires!.isBefore(earliestPauseStart)
        ? earliestPauseStart
        : _planExpires!;
  }

  /// Last calendar day a pause may **end** for a given start [start].
  DateTime latestPauseEndFor(DateTime start) {
    final s = _dateOnly(start);
    final byQuota = s.add(Duration(days: _maxFreezeDays - 1));
    if (_planExpires == null) return byQuota;
    return byQuota.isBefore(_planExpires!) ? byQuota : _planExpires!;
  }

  static int inclusivePauseDays(DateTime? start, DateTime? end) {
    if (start == null || end == null) return 0;
    final a = _dateOnly(start);
    final b = _dateOnly(end);
    final d = b.difference(a).inDays;
    return d < 0 ? 0 : d + 1;
  }

  void setStartDate(DateTime picked) {
    final d = _dateOnly(picked);
    DateTime? end = state.endDate;
    if (end != null) {
      final last = latestPauseEndFor(d);
      final e = _dateOnly(end);
      if (e.isBefore(d) || e.isAfter(last)) {
        end = null;
      }
    }
    if (end == null && state.endDate != null) {
      emit(
        state.copyWith(
          startDate: d,
          clearEndDate: true,
          clearSubmitError: true,
        ),
      );
    } else if (end != null) {
      emit(state.copyWith(startDate: d, endDate: end, clearSubmitError: true));
    } else {
      emit(state.copyWith(startDate: d, clearSubmitError: true));
    }
  }

  void setEndDate(DateTime picked) {
    final start = state.startDate;
    if (start == null) return;
    final s = _dateOnly(start);
    final last = latestPauseEndFor(s);
    var d = _dateOnly(picked);
    if (d.isBefore(s)) d = s;
    if (d.isAfter(last)) d = last;
    emit(state.copyWith(endDate: d, clearSubmitError: true));
  }

  /// §9.1 — start freeze with optional window (calendar dates sent as `yyyy-MM-dd`).
  Future<bool> confirmFreeze(AppLocalizations l10n) async {
    final start = state.startDate;
    final end = state.endDate;
    if (start == null || end == null) {
      emit(state.copyWith(submitError: l10n.pauseSelectBothDates));
      return false;
    }
    final days = inclusivePauseDays(start, end);
    if (days > _maxFreezeDays) {
      emit(
        state.copyWith(submitError: l10n.pausePeriodTooLong(_maxFreezeDays)),
      );
      return false;
    }
    if (days < 1) {
      emit(state.copyWith(submitError: l10n.pauseSelectBothDates));
      return false;
    }

    final s = _dateOnly(start);
    final e = _dateOnly(end);
    if (s.isBefore(earliestPauseStart) || s.isAfter(latestPauseStart)) {
      emit(state.copyWith(submitError: l10n.pauseSelectBothDates));
      return false;
    }
    final last = latestPauseEndFor(s);
    if (e.isBefore(s) || e.isAfter(last)) {
      emit(state.copyWith(submitError: l10n.pauseSelectBothDates));
      return false;
    }

    emit(state.copyWith(isSubmitting: true, clearSubmitError: true));
    final result = await _repo.startFreeze(
      subscriptionId,
      startDate: start,
      endDate: end,
    );
    return result.when(
      success: (_, __) {
        emit(state.copyWith(isSubmitting: false));
        return true;
      },
      failure: (NetworkException e) {
        emit(state.copyWith(isSubmitting: false, submitError: e.message));
        return false;
      },
    );
  }
}
