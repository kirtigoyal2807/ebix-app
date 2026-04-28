import 'dart:async';

import 'package:add_2_calendar/add_2_calendar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:pilates_app/config/theme/app_spacing.dart';
import 'package:pilates_app/core/constants/check_in_policy.dart';
import 'package:pilates_app/core/network/api_result.dart';
import 'package:pilates_app/features/booking/data/models/class_slot_view_model.dart';
import 'package:pilates_app/features/my_booking/data/models/booking_resource.dart';
import 'package:pilates_app/features/my_booking/data/my_bookings_repository.dart';
import 'package:pilates_app/widgets/app_text.dart';

import '../../../config/theme/app_colors.dart';
import '../../../config/theme/app_radius.dart';
import '../../../config/theme/app_text_styles.dart';
import '../../../core/localization/arb/app_localizations.dart';
import '../../../widgets/app_button.dart';
import '../../../widgets/dotted_underline.dart';
import '../../home/home_view.dart';
import '../../my_booking/my_booking_view.dart';

class BookingSuccessScreen extends StatefulWidget {
  const BookingSuccessScreen({
    super.key,
    required this.successPage,
    this.slot,
    this.booking,
  });

  final SuccessPage successPage;

  /// Optional slot data — used to display real class details.
  final ClassSlotViewModel? slot;

  /// Optional booking result from the API — used to display waitlist position /
  /// enrollment id for check-in.
  final BookingResource? booking;

  @override
  State<BookingSuccessScreen> createState() => _BookingSuccessScreenState();
}

class _BookingSuccessScreenState extends State<BookingSuccessScreen> {
  Timer? _clock;
  bool _checkedInUi = false;
  bool _checkInBusy = false;

  @override
  void initState() {
    super.initState();
    _checkedInUi = widget.booking?.checkedInAt != null;
    _clock = Timer.periodic(const Duration(seconds: 20), (_) {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _clock?.cancel();
    super.dispose();
  }

  DateTime? _classStart() => widget.slot?.startAt ?? widget.booking?.startAt;

  DateTime? _classEnd() => widget.slot?.endAt ?? widget.booking?.endAt;

  /// API may omit [endAt]; infer for calendar when we have start + duration from slot.
  DateTime? _classEndForCalendar() {
    final explicit = _classEnd();
    if (explicit != null) return explicit;
    final start = _classStart();
    if (start == null) return null;
    final minutes = widget.slot?.durationMinutes;
    if (minutes != null && minutes > 0) {
      return start.add(Duration(minutes: minutes));
    }
    return start.add(const Duration(hours: 1));
  }

  String _eventTitle(BuildContext context) {
    final slot = widget.slot;
    final booking = widget.booking;
    final name = slot?.name ?? booking?.className;
    if (name != null && name.isNotEmpty) return name;
    return AppLocalizations.of(context).classTxt;
  }

  String _mapsLocationQuery() {
    final slot = widget.slot;
    final booking = widget.booking;
    final name = (slot?.branchName ?? booking?.branchName ?? '').trim();
    final addr =
        (slot?.branchAddress ?? slot?.branchLocation ?? '').trim();
    if (name.isNotEmpty && addr.isNotEmpty) return '$name, $addr';
    if (addr.isNotEmpty) return addr;
    return name;
  }

  int? _displayWaitlistPosition() {
    final api = widget.booking?.waitlistPosition;
    if (api != null) return api;
    final wc = widget.slot?.waitlistCount;
    if (wc != null && wc >= 0) {
      return wc + 1;
    }
    return null;
  }

  Future<void> _onAddToCalendar(BuildContext context) async {
    final l10n = AppLocalizations.of(context);
    final start = _classStart();
    final end = _classEndForCalendar();
    if (start == null || end == null) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.somethingWentWrong)),
      );
      return;
    }

    final title = _eventTitle(context);
    final locationQuery = _mapsLocationQuery();
    try {
      final ok = await Add2Calendar.addEvent2Cal(
        Event(
          title: title,
          startDate: start.toLocal(),
          endDate: end.toLocal(),
          location: locationQuery.isNotEmpty ? locationQuery : null,
        ),
      );
      if (!context.mounted) return;
      if (!ok) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.somethingWentWrong)),
        );
      }
    } catch (_) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.somethingWentWrong)),
      );
    }
  }

  Future<void> _onOpenDirections(BuildContext context) async {
    final l10n = AppLocalizations.of(context);
    final q = _mapsLocationQuery().trim();
    if (q.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.somethingWentWrong)),
      );
      return;
    }
    final uri = Uri.parse(
      'https://www.google.com/maps/search/?api=1&query=${Uri.encodeComponent(q)}',
    );
    try {
      final launched = await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );
      if (!context.mounted) return;
      if (!launched) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.somethingWentWrong)),
        );
      }
    } catch (_) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.somethingWentWrong)),
      );
    }
  }

  String _formatTime(BuildContext context, DateTime t) {
    final locale = Localizations.localeOf(context).toLanguageTag();
    return DateFormat.jm(locale).format(t.toLocal());
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: isDark ? AppColors.homeBackground : AppColors.whiteColor,
      body: SingleChildScrollView(
        padding: EdgeInsetsDirectional.only(
          top: MediaQuery.of(context).viewPadding.top,
          bottom: MediaQuery.of(context).viewPadding.bottom,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: AppSpacing.xl),

            Lottie.asset(
              "assets/json/tick.json",
              height: 100,
              width: 100,
              repeat: false,
            ),

            const SizedBox(height: AppSpacing.md),

            AppText(
              widget.successPage == SuccessPage.booking
                  ? l10n.bookingSuccess
                  : l10n.onWaitList,
              style: (context) => AppTextStyles.gelasioMedium(context).copyWith(
                    fontSize: 24,
                    color: isDark ? AppColors.lightText : const Color(0xff0D0D12),
                  ),
            ),

            const SizedBox(height: AppSpacing.sm),

            AppText(
              widget.successPage == SuccessPage.booking
                  ? l10n.successMessage
                  : l10n.onWaitListDescription,
              style: (context) => AppTextStyles.bodyText(context),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: AppSpacing.lg),

            widget.successPage == SuccessPage.booking
                ? _buildCheckInSection(context, isDark)
                : _buildPositionCard(context, isDark),

            const SizedBox(height: AppSpacing.lg),

            _buildClassDetailsSection(context, isDark),

            const SizedBox(height: AppSpacing.lg),

            _buildActionButtons(context, isDark),

            const SizedBox(height: AppSpacing.lg),

            Padding(
              padding: const EdgeInsetsDirectional.symmetric(
                horizontal: AppSpacing.lg,
              ),
              child: AppText(
                l10n.cancelBooking,
                style: (context) =>
                    AppTextStyles.helpAndSupportItemSubLabel(context),
                textAlign: TextAlign.start,
              ),
            ),

            const SizedBox(height: AppSpacing.lg),
            _buildFooterLinks(context, isDark),
          ],
        ),
      ),
    );
  }

  Widget _buildCheckInSection(BuildContext context, bool isDark) {
    final l10n = AppLocalizations.of(context);
    final start = _classStart();
    final end = _classEnd();
    final enrollmentId = widget.booking?.id;

    final now = DateTime.now();
    final band = start != null
        ? CheckInPolicy.timeBandFor(
            nowLocal: now,
            classStartUtcOrLocal: start,
            classEndUtcOrLocal: end,
          )
        : CheckInTimeBand.inWindow;

    final opensFormatted = start != null
        ? _formatTime(context, CheckInPolicy.opensAt(start))
        : '--';

    final minutesBefore = CheckInPolicy.kOpensBeforeStart.inMinutes;

    final String description;
    if (start == null) {
      description = l10n.checkInLongDescription;
    } else {
      switch (band) {
        case CheckInTimeBand.tooEarly:
          description =
              l10n.checkInWindowExplanationSchedule(minutesBefore, opensFormatted);
        case CheckInTimeBand.inWindow:
          description = l10n.checkInActiveWindowBody;
        case CheckInTimeBand.tooLate:
          description = l10n.checkInEndedForThisClass;
      }
    }

    final bool canTapCheckIn =
        !_checkedInUi &&
        !_checkInBusy &&
        enrollmentId != null &&
        enrollmentId.isNotEmpty &&
        start != null &&
        band == CheckInTimeBand.inWindow;

    String buttonLabel;
    if (_checkedInUi) {
      buttonLabel = l10n.checkedIn;
    } else if (start == null) {
      buttonLabel = l10n.checkIn;
    } else {
      switch (band) {
        case CheckInTimeBand.tooEarly:
          buttonLabel =
              l10n.checkInButtonOpensAtDynamic(opensFormatted);
        case CheckInTimeBand.inWindow:
          buttonLabel = l10n.checkIn;
        case CheckInTimeBand.tooLate:
          buttonLabel = l10n.checkInClosedShort;
      }
    }

    return Container(
      margin: const EdgeInsetsDirectional.symmetric(horizontal: AppSpacing.lg),
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: isDark ? AppColors.primaryDarkContainer : AppColors.seekBarLight,
        borderRadius: BorderRadius.circular(AppRadius.base),
        border: isDark ? null : Border.all(color: AppColors.darkGreyBorder),
      ),
      child: Column(
        children: [
          SvgPicture.asset("assets/images/svg/ic_clock.svg"),
          const SizedBox(height: AppSpacing.md),

          AppText(
            _checkedInUi ? l10n.checkedIn : l10n.checkIn,
            style: (context) => AppTextStyles.experienceButton(context),
          ),

          const SizedBox(height: AppSpacing.xi),

          AppText(
            description,
            style: (context) => AppTextStyles.bodyText(context),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: AppSpacing.md),

          AppButton(
            label: buttonLabel,
            variant: canTapCheckIn
                ? AppButtonVariant.primary
                : AppButtonVariant.disable,
            isLoading: _checkInBusy,
            onPressed: canTapCheckIn
                ? () async {
                    final id = widget.booking?.id;
                    if (id == null || id.isEmpty) return;
                    setState(() => _checkInBusy = true);
                    final repo = context.read<MyBookingsRepository>();
                    final result = await repo.checkIn(id);
                    if (!context.mounted) return;
                    setState(() => _checkInBusy = false);
                    final messenger = ScaffoldMessenger.of(context);
                    switch (result) {
                      case ApiSuccess():
                        setState(() => _checkedInUi = true);
                        messenger.showSnackBar(
                          SnackBar(content: Text(l10n.checkInSuccess)),
                        );
                      case ApiFailure(:final exception):
                        messenger.showSnackBar(
                          SnackBar(
                            content: Text(
                              exception.message ?? l10n.somethingWentWrong,
                            ),
                            backgroundColor: AppColors.redLight,
                          ),
                        );
                    }
                  }
                : () {},
          ),

          const SizedBox(height: AppSpacing.md),

          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(width: 10),
              Icon(
                Icons.warning_amber_rounded,
                size: 16,
                color: isDark
                    ? AppColors.languageIconDark
                    : AppColors.languageIcon,
              ),
              const SizedBox(width: AppSpacing.xs),
              Expanded(
                child: AppText(
                  l10n.checkInLongDescription,
                  style: (context) =>
                      AppTextStyles.helpAndSupportItemSubLabel(context),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPositionCard(BuildContext context, bool isDark) {
    final l10n = AppLocalizations.of(context);
    final position = _displayWaitlistPosition();

    return Column(
      children: [
        Divider(color: isDark ? AppColors.greyText : AppColors.buttonBorder),
        const SizedBox(height: AppSpacing.lg),
        Container(
          width: double.infinity,
          margin: const EdgeInsetsDirectional.symmetric(
            horizontal: AppSpacing.lg,
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.md,
          ),
          decoration: BoxDecoration(
            color: isDark
                ? AppColors.primaryDarkContainer
                : AppColors.seekBarLight,
            borderRadius: BorderRadius.circular(AppRadius.base),
            border: isDark
                ? null
                : Border.all(width: 1, color: AppColors.darkGreyBorder),
          ),
          child: Column(
            children: [
              AppText(
                l10n.yourPosition,
                style: (ctx) =>
                    AppTextStyles.captionText(
                      ctx,
                      fontWeight: FontWeight.w500,
                    ).copyWith(
                      color: isDark
                          ? AppColors.darkGreyText
                          : AppColors.lightGrey,
                    ),
              ),
              const SizedBox(height: AppSpacing.md),
              AppText(
                position != null ? '#$position' : '--',
                style: (ctx) =>
                    AppTextStyles.appBarText(ctx).copyWith(fontSize: 32),
              ),
              const SizedBox(height: AppSpacing.sm),
              AppText(
                l10n.inLine,
                style: (ctx) => AppTextStyles.captionText(ctx).copyWith(
                      color:
                          isDark ? AppColors.darkGreyText : AppColors.lightGrey,
                    ),
              ),
            ],
          ),
        ),

        const SizedBox(height: AppSpacing.lg),
        Divider(color: isDark ? AppColors.greyText : AppColors.buttonBorder),
      ],
    );
  }

  Widget _buildClassDetailsSection(BuildContext context, bool isDark) {
    final l10n = AppLocalizations.of(context);

    final slot = widget.slot;
    final booking = widget.booking;

    final className = slot?.name ?? booking?.className ?? '--';
    final instructorName =
        slot?.trainerName ?? booking?.trainerName ?? '--';
    final locationName = slot?.branchName ?? booking?.branchName ?? '--';
    final locationAddress = slot?.branchAddress ?? slot?.branchLocation ?? '';

    String dateLabel = '--';
    String timeLabel = '--';
    if (slot != null) {
      final start = slot.startAt.toLocal();
      final end = slot.endAt.toLocal();
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      final slotDay = DateTime(start.year, start.month, start.day);
      if (slotDay == today) {
        dateLabel = 'Today, ${DateFormat('MMMM d, yyyy').format(start)}';
      } else {
        dateLabel = DateFormat('EEEE, MMMM d, yyyy').format(start);
      }
      timeLabel =
          '${DateFormat('h:mm a').format(start)} – ${DateFormat('h:mm a').format(end)}';
    } else {
      final bkStart = booking?.startAt;
      if (bkStart != null) {
        final bs = bkStart.toLocal();
        dateLabel = DateFormat('EEEE, MMMM d, yyyy').format(bs);
        timeLabel = DateFormat('h:mm a').format(bs);
      }
    }

    return Container(
      margin: const EdgeInsetsDirectional.symmetric(horizontal: AppSpacing.lg),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? AppColors.homeBackground : AppColors.whiteColor,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(
          color: isDark ? AppColors.greyText : AppColors.buttonBorder,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppText(
            l10n.classDetail,
            style: (ctx) => AppTextStyles.gelasioMedium(ctx),
          ),

          const SizedBox(height: AppSpacing.lmd),

          _buildClassDetailRow(
            label: l10n.classTxt,
            value: className,
            isDark: isDark,
          ),

          const SizedBox(height: AppSpacing.sm),

          _buildClassDetailRow(
            label: l10n.instructor,
            value: instructorName,
            isDark: isDark,
          ),

          const SizedBox(height: AppSpacing.sm),

          _buildClassDetailRow(
            label: l10n.date,
            value: dateLabel,
            isDark: isDark,
          ),

          const SizedBox(height: AppSpacing.sm),

          _buildClassDetailRow(
            label: l10n.time,
            value: timeLabel,
            isDark: isDark,
          ),

          const SizedBox(height: AppSpacing.sm),

          _buildClassDetailRow(
            label: l10n.location,
            value: locationAddress.isNotEmpty
                ? '$locationName, $locationAddress'
                : locationName,
            isMultiLine: true,
            isBorder: false,
            isDark: isDark,
          ),
        ],
      ),
    );
  }

  Widget _buildClassDetailRow({
    required String label,
    required String value,
    bool isMultiLine = false,
    bool isBorder = true,
    required bool isDark,
  }) {
    return SizedBox(
      width: double.infinity,
      child: CustomPaint(
        painter: isBorder
            ? DashedUnderlinePainter(
                color: isDark ? AppColors.greyText : AppColors.buttonBorder,
              )
            : null,
        child: Padding(
          padding: EdgeInsets.only(bottom: isBorder ? AppSpacing.sm : 0),
          child: Row(
            crossAxisAlignment: isMultiLine
                ? CrossAxisAlignment.start
                : CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: 100,
                child: AppText(
                  "$label:",
                  style: (context) => AppTextStyles.textFieldHeading(context),
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: AppText(
                  value,
                  style: (context) => AppTextStyles.bodyText(context),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context, bool isDark) {
    final l10n = AppLocalizations.of(context);

    return Padding(
      padding: const EdgeInsetsDirectional.symmetric(horizontal: AppSpacing.lg),
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: isDark ? AppColors.homeBackground : Colors.white,
                borderRadius: BorderRadius.circular(AppRadius.xl),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.shadowColor.withValues(alpha: 0.06),
                    offset: const Offset(0, 1),
                    blurRadius: 2,
                    spreadRadius: 0,
                  ),
                ],
              ),
              child: AppButton(
                label: l10n.addToCalender,
                onPressed: () => _onAddToCalendar(context),
                variant: AppButtonVariant.secondary,
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.xi),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: isDark ? AppColors.homeBackground : Colors.white,
                borderRadius: BorderRadius.circular(AppRadius.xl),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.shadowColor.withValues(alpha: 0.06),
                    offset: const Offset(0, 1),
                    blurRadius: 2,
                    spreadRadius: 0,
                  ),
                ],
              ),
              child: AppButton(
                label: l10n.getDirection,
                onPressed: () => _onOpenDirections(context),
                variant: AppButtonVariant.secondary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFooterLinks(BuildContext context, bool isDark) {
    final l10n = AppLocalizations.of(context);

    return Padding(
      padding: const EdgeInsetsDirectional.only(start: 24, end: 24, bottom: 34),
      child: Column(
        children: [
          AppButton(
            label: l10n.viewMyBooking,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const MyBookingView()),
              );
            },
            variant: AppButtonVariant.primary,
          ),
          const SizedBox(height: AppSpacing.sm),
          Container(
            decoration: BoxDecoration(
              color: isDark ? AppColors.homeBackground : Colors.white,
              borderRadius: BorderRadius.circular(AppRadius.xl),
              boxShadow: [
                BoxShadow(
                  color: AppColors.shadowColor.withValues(alpha: 0.06),
                  offset: const Offset(0, 1),
                  blurRadius: 2,
                  spreadRadius: 0,
                ),
              ],
            ),
            child: AppButton(
              label: l10n.browseMoreClasses,
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const HomeView(initialNavIndex: 1),
                  ),
                );
              },
              variant: AppButtonVariant.secondary,
            ),
          ),
        ],
      ),
    );
  }
}

enum SuccessPage { booking, waitList }
