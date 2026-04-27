import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';

import 'package:pilates_app/config/theme/app_spacing.dart';
import 'package:pilates_app/features/booking/data/models/class_slot_view_model.dart';
import 'package:pilates_app/features/my_booking/data/models/booking_resource.dart';
import 'package:pilates_app/widgets/app_text.dart';
import '../../../config/theme/app_colors.dart';
import '../../../config/theme/app_radius.dart';
import '../../../config/theme/app_text_styles.dart';
import '../../../core/localization/arb/app_localizations.dart';
import '../../../widgets/app_button.dart';
import '../../../widgets/dotted_underline.dart';
import '../../home/home_view.dart';
import '../../my_booking/my_booking_view.dart';

class BookingSuccessScreen extends StatelessWidget {
  const BookingSuccessScreen({
    super.key,
    required this.successPage,
    this.slot,
    this.booking,
  });

  final SuccessPage successPage;

  /// Optional slot data — used to display real class details.
  final ClassSlotViewModel? slot;

  /// Optional booking result from the API — used to display waitlist position.
  final BookingResource? booking;

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

            // Container(
            //   height: 100,
            //   width: 100,
            //   alignment: Alignment.center,
            //   decoration: BoxDecoration(
            //     color: AppColors.successColor,
            //     borderRadius: BorderRadius.circular(AppRadius.pillRadius),
            //   ),
            //   child: const Icon(Icons.done, color: Colors.white, size: 80),
            // ),
            Lottie.asset(
              "assets/json/tick.json",
              height: 100,
              width: 100,
              repeat: false,
            ),

            const SizedBox(height: AppSpacing.md),

            AppText(
              successPage == SuccessPage.booking
                  ? l10n.bookingSuccess
                  : l10n.onWaitList,
              style: (context) => AppTextStyles.gelasioMedium(context).copyWith(
                fontSize: 24,
                color: isDark ? AppColors.lightText : const Color(0xff0D0D12),
              ),
            ),

            const SizedBox(height: AppSpacing.sm),

            AppText(
              successPage == SuccessPage.booking
                  ? l10n.successMessage
                  : l10n.onWaitListDescription,
              style: (context) => AppTextStyles.bodyText(context),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: AppSpacing.lg),

            successPage == SuccessPage.booking
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
            l10n.checkIn,
            style: (context) => AppTextStyles.experienceButton(context),
          ),

          const SizedBox(height: AppSpacing.xi),

          AppText(
            l10n.checkInDescription,
            style: (context) => AppTextStyles.bodyText(context),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: AppSpacing.md),

          AppButton(
            label: l10n.checkInButton,
            variant: AppButtonVariant.disable,
            onPressed: () {},
          ),

          const SizedBox(height: AppSpacing.md),

          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(width: 10),
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
    final position = booking?.waitlistPosition;

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
                  color: isDark ? AppColors.darkGreyText : AppColors.lightGrey,
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

    final className = slot?.name ?? booking?.className ?? '--';
    final instructorName = slot?.trainerName ?? booking?.trainerName ?? '--';
    final locationName = slot?.branchName ?? booking?.branchName ?? '--';
    final locationAddress = slot?.branchAddress ?? slot?.branchLocation ?? '';

    String dateLabel = '--';
    String timeLabel = '--';
    if (slot != null) {
      final start = slot!.startAt.toLocal();
      final end = slot!.endAt.toLocal();
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
    } else if (booking?.startAt != null) {
      dateLabel =
          DateFormat('EEEE, MMMM d, yyyy').format(booking!.startAt!.toLocal());
      timeLabel = DateFormat('h:mm a').format(booking!.startAt!.toLocal());
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
                onPressed: () {},
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
                onPressed: () {},
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
                MaterialPageRoute(builder: (_) => MyBookingView()),
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
                  MaterialPageRoute(builder: (_) => HomeView()),
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
