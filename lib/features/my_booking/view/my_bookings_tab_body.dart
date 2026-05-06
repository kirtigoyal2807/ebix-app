import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';

import 'package:pilates_app/core/constants/check_in_policy.dart';
import 'package:pilates_app/config/theme/app_colors.dart';
import 'package:pilates_app/config/theme/app_spacing.dart';
import 'package:pilates_app/config/theme/app_text_styles.dart';
import 'package:pilates_app/core/localization/localization_extension.dart';
import 'package:pilates_app/features/my_booking/cubit/my_bookings_cubit.dart';
import 'package:pilates_app/features/my_booking/cubit/my_bookings_status_group.dart';
import 'package:pilates_app/features/my_booking/cubit/tab_bookings_state.dart';
import 'package:pilates_app/features/my_booking/data/models/booking_resource.dart';
import 'package:pilates_app/features/my_booking/my_booking_view.dart';
import 'package:pilates_app/features/my_booking/widget/my_booking_class_card.dart';
import 'package:pilates_app/widgets/app_button.dart';
import 'package:pilates_app/widgets/app_text.dart';

/// One tab: loads [GET /my-bookings](status_group) and shows loading / empty / error / list.
class MyBookingsTabBody extends StatelessWidget {
  const MyBookingsTabBody({super.key, required this.group});

  final MyBookingsStatusGroup group;

  static String _emptyTitle(BuildContext context, MyBookingsStatusGroup group) {
    final l10n = context.l10n;
    switch (group) {
      case MyBookingsStatusGroup.upcoming:
        return l10n.noUpcomingClasses;
      case MyBookingsStatusGroup.current:
        return l10n.noCurrentClasses;
      case MyBookingsStatusGroup.past:
        return l10n.noPastClasses;
      case MyBookingsStatusGroup.cancelled:
        return l10n.noCancelledClasses;
    }
  }

  static String _emptyDescription(
    BuildContext context,
    MyBookingsStatusGroup group,
  ) {
    final l10n = context.l10n;
    switch (group) {
      case MyBookingsStatusGroup.upcoming:
        return l10n.noUpcomingClassesDescription;
      case MyBookingsStatusGroup.current:
        return l10n.noCurrentClassesDescription;
      case MyBookingsStatusGroup.past:
        return l10n.noPastClassesDescription;
      case MyBookingsStatusGroup.cancelled:
        return l10n.noCancelledClassesDescription;
    }
  }

  static BookingStatus _cardStatus(String status) {
    final s = status.toLowerCase();
    switch (s) {
      case 'waitlisted':
        return BookingStatus.waitListed;
      case 'cancelled':
      case 'canceled':
        return BookingStatus.cancelled;
      case 'attended':
      case 'no_show':
        return BookingStatus.completed;
      case 'booked':
        return BookingStatus.confirmed;
      default:
        return BookingStatus.confirmed;
    }
  }

  /// Matches server rules plus [CheckInPolicy]: check-in unlocks [kOpensBeforeStart]
  /// minutes before class and closes after session end (or at start if end unknown).
  static bool _bookingStatusAllowsCheckIn(BookingResource b) {
    if (b.checkedInAt != null) return false;
    final s = b.status.toLowerCase();
    if (s == 'attended' ||
        s == 'cancelled' ||
        s == 'canceled' ||
        s == 'waitlisted') {
      return false;
    }
    return true;
  }

  static bool _canSubmitCheckIn(BookingResource b) {
    if (!_bookingStatusAllowsCheckIn(b)) return false;
    final start = b.startAt;
    if (start == null) return true;
    return CheckInPolicy.nowIsWithinWindow(
      nowLocal: DateTime.now(),
      classStartUtcOrLocal: start,
      classEndUtcOrLocal: b.endAt,
    );
  }

  static String? _checkInButtonLabelHint(
    BuildContext context,
    BookingResource b,
  ) {
    if (b.checkedInAt != null) return null;
    if (!_bookingStatusAllowsCheckIn(b)) return null;
    final start = b.startAt;
    if (start == null) return null;
    final locale = Localizations.localeOf(context).toLanguageTag();
    final band = CheckInPolicy.timeBandFor(
      nowLocal: DateTime.now(),
      classStartUtcOrLocal: start,
      classEndUtcOrLocal: b.endAt,
    );
    final opens = CheckInPolicy.opensAt(start);
    final opensStr = DateFormat.jm(locale).format(opens.toLocal());
    return switch (band) {
      CheckInTimeBand.tooEarly => context.l10n.checkInOpensAtHint(opensStr),
      CheckInTimeBand.tooLate => context.l10n.checkInClosedShort,
      CheckInTimeBand.inWindow => null,
    };
  }

  /// §13.10 — `DELETE /enrollments/{id}` for booked, waitlisted, or pending payment.
  static bool _canCancelEnrollment(BookingResource b) {
    final s = b.status.toLowerCase();
    if (s == 'cancelled' || s == 'canceled') return false;
    if (s == 'attended' || s == 'no_show') return false;
    return s == 'booked' || s == 'waitlisted' || s == 'pending_payment';
  }

  static String? _cancelledDetailLine(BuildContext context, BookingResource b) {
    final at = b.cancelledAt;
    if (at == null) return null;
    final locale = Localizations.localeOf(context).toLanguageTag();
    return context.l10n.cancelledOn(
      DateFormat.yMMMMd(locale).format(at.toLocal()),
      DateFormat.jm(locale).format(at.toLocal()),
    );
  }

  static String _dateLine(BuildContext context, BookingResource b) {
    final start = b.startAt;
    if (start == null) return '—';
    final locale = Localizations.localeOf(context).toLanguageTag();
    return DateFormat.yMMMMd(locale).format(start.toLocal());
  }

  static String _timeLine(BuildContext context, BookingResource b) {
    final start = b.startAt;
    final end = b.endAt;
    final locale = Localizations.localeOf(context).toLanguageTag();
    if (start == null) return '—';
    final a = DateFormat.jm(locale).format(start.toLocal());
    if (end == null) return a;
    final c = DateFormat.jm(locale).format(end.toLocal());
    return '$a - $c';
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return BlocBuilder<MyBookingsCubit, MyBookingsState>(
      buildWhen: (prev, next) =>
          prev.tab(group) != next.tab(group) ||
          prev.checkInBusyEnrollmentId != next.checkInBusyEnrollmentId ||
          prev.cancelBusyEnrollmentId != next.cancelBusyEnrollmentId,
      builder: (context, state) {
        final tab = state.tab(group);
        if (tab.errorMessage != null && !tab.isLoading) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  AppText(
                    tab.errorMessage!,
                    textAlign: TextAlign.center,
                    style: (context) => AppTextStyles.bodyText(context),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  AppButton(
                    label: context.l10n.retry,
                    expanded: false,
                    onPressed: () =>
                        context.read<MyBookingsCubit>().refresh(group),
                  ),
                ],
              ),
            ),
          );
        }
        if (tab.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (!tab.hasFetched && tab.errorMessage == null) {
          return const SizedBox.shrink();
        }
        if (tab.hasFetched && tab.items.isEmpty) {
          return RefreshIndicator(
            onRefresh: () => context.read<MyBookingsCubit>().refresh(group),
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(vertical: AppSpacing.lg),
              children: [
                const SizedBox(height: 80),
                Center(
                  child: isDark
                      ? SvgPicture.asset(
                          'assets/images/svg/ic_dark_no_class.svg',
                        )
                      : SvgPicture.asset('assets/images/svg/ic_no_class.svg'),
                ),
                const SizedBox(height: AppSpacing.lmd),
                AppText(
                  _emptyTitle(context, group),
                  textAlign: TextAlign.center,
                  style: (context) => AppTextStyles.gelasioMedium(
                    context,
                  ).copyWith(height: 1.55),
                ),
                const SizedBox(height: AppSpacing.xs),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.lg,
                  ),
                  child: AppText(
                    _emptyDescription(context, group),
                    textAlign: TextAlign.center,
                    style: (context) => AppTextStyles.bodyText(
                      context,
                    ).copyWith(fontSize: 16, height: 1.55),
                  ),
                ),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: () => context.read<MyBookingsCubit>().refresh(group),
          child: ListView.separated(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(vertical: AppSpacing.lg),
            itemCount: tab.items.length,
            separatorBuilder: (context, _) =>
                const SizedBox(height: AppSpacing.md),
            itemBuilder: (context, index) {
              final b = tab.items[index];
              final wl = b.waitlistPosition;
              final checkedIn =
                  b.checkedInAt != null || b.status.toLowerCase() == 'attended';
              final canCheckIn = _canSubmitCheckIn(b);
              final checkInLabelOverride = _checkInButtonLabelHint(context, b);
              final canCancel = _canCancelEnrollment(b);
              final busy = state.checkInBusyEnrollmentId == b.id;
              final cancelBusy = state.cancelBusyEnrollmentId == b.id;
              return MyBookingClassCard(
                title: b.className.isEmpty ? '—' : b.className,
                trainerName: b.trainerName.isEmpty ? '—' : b.trainerName,
                studio: b.branchName.isEmpty ? '—' : b.branchName,
                time: _timeLine(context, b),
                date: _dateLine(context, b),
                bookingStatus: _cardStatus(b.status),
                spot: wl,
                position: wl,
                isRate:
                    group == MyBookingsStatusGroup.past &&
                    b.status == 'attended',
                coverImageUrl: b.classImageUrl,
                checkInLabel: checkedIn
                    ? context.l10n.checkedIn
                    : checkInLabelOverride,
                isCheckInBusy: busy,
                onCheckIn: canCheckIn
                    ? () async {
                        final messenger = ScaffoldMessenger.of(context);
                        final err = await context
                            .read<MyBookingsCubit>()
                            .checkIn(b.id);
                        if (!context.mounted) return;
                        messenger.showSnackBar(
                          SnackBar(
                            content: Text(err ?? context.l10n.checkInSuccess),
                            backgroundColor: err == null
                                ? null
                                : AppColors.redLight,
                          ),
                        );
                      }
                    : null,
                onConfirmCancelEnrollment: canCancel
                    ? () async {
                        final cubit = context.read<MyBookingsCubit>();
                        final messenger = ScaffoldMessenger.of(context);
                        final err = await cubit.cancelEnrollment(b.id);
                        if (!context.mounted) return;
                        messenger.showSnackBar(
                          SnackBar(
                            content: Text(
                              err ?? context.l10n.cancelEnrollmentSuccess,
                            ),
                            backgroundColor: err == null
                                ? null
                                : AppColors.redLight,
                          ),
                        );
                      }
                    : null,
                isCancelBusy: cancelBusy,
                cancelledDetailLine: _cancelledDetailLine(context, b),
              );
            },
          ),
        );
      },
    );
  }
}
