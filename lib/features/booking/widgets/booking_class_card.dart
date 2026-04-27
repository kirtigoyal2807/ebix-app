import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:pilates_app/config/theme/app_colors.dart';
import 'package:pilates_app/config/theme/app_radius.dart';
import 'package:pilates_app/config/theme/app_spacing.dart';
import 'package:pilates_app/config/theme/app_text_styles.dart';
import 'package:pilates_app/core/localization/localization_extension.dart';
import 'package:pilates_app/features/booking/data/models/class_slot_view_model.dart';
import 'package:pilates_app/features/booking/widgets/upgrade_bottom_sheet.dart';
import 'package:pilates_app/widgets/app_text.dart';
import '../../../widgets/app_shadow.dart';
import '../data/class_booking_preview.dart';
import '../views/class_detail_view.dart';

class BookingClassCard extends StatelessWidget {
  final String title;
  final String trainerName;
  final String studio;
  final String time;
  final int spotsLeft;
  final double rating;
  final bool isInPlan;
  final bool upgradeRequired;
  final String calendarEventId;
  final ClassSlotViewModel? _slot;

  const BookingClassCard({
    super.key,
    required this.title,
    required this.trainerName,
    required this.studio,
    required this.time,
    required this.spotsLeft,
    this.rating = 4.5,
    this.isInPlan = true,
    this.upgradeRequired = false,
    this.calendarEventId = BookingDemoCalendarEvent.id,
  }) : _slot = null;

  /// Construct directly from a [ClassSlotViewModel] returned by the API.
  BookingClassCard.fromSlot(ClassSlotViewModel slot, {super.key})
      : title = slot.name,
        trainerName = slot.trainerName,
        studio = slot.branchName,
        time = _formatSlotTime(slot),
        spotsLeft = slot.slotsLeft ?? 0,
        rating = slot.avgRating ?? 4.5,
        isInPlan = slot.allowPackageBooking,
        upgradeRequired = slot.upgradeRequired,
        calendarEventId = slot.calendarEventId,
        _slot = slot;

  static String _formatSlotTime(ClassSlotViewModel slot) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final slotDay = DateTime(
      slot.startAt.year,
      slot.startAt.month,
      slot.startAt.day,
    );
    final timeStr = DateFormat('h:mm a').format(slot.startAt.toLocal());
    if (slotDay == today) {
      return 'Today, $timeStr';
    }
    final tomorrow = today.add(const Duration(days: 1));
    if (slotDay == tomorrow) {
      return 'Tomorrow, $timeStr';
    }
    return '${DateFormat('EEE, MMM d').format(slot.startAt.toLocal())}, $timeStr';
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final size = MediaQuery.sizeOf(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      // child:
      // Material(
      // color: isDark ? AppColors.surfaceDark : Colors.white,
      // borderRadius: BorderRadius.circular(AppRadius.lg),
      child: InkWell(
        onTap: () {
          if (upgradeRequired) {
            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              backgroundColor: Colors.transparent,
              barrierColor: AppColors.bottomSheetShadow,
              builder: (_) => const BranchNotInPlanSheet(),
            );
          } else {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (newContext) => ClassDetailView(
                  calendarEventId: calendarEventId,
                  preloadedSlot: _slot,
                ),
              ),
            );
          }
        },
        borderRadius: BorderRadius.circular(AppRadius.lg),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppRadius.lg),
            color: isDark ? AppColors.surfaceDark : Colors.white,

            border: Border.all(
              color: isDark ? AppColors.greyText : AppColors.buttonBorder,
            ),
            boxShadow: [
              AppShadows.lightShadow,
              AppShadows.mediumShadow,
              AppShadows.mediumHeavyShadow,
              BoxShadow(
                color: AppColors.shadowColor.withValues(alpha: 0.01),
                offset: const Offset(0, 64),
                blurRadius: 25,
                spreadRadius: 0,
              ),
              BoxShadow(
                color: AppColors.shadowColor.withValues(alpha: 0.00),
                offset: const Offset(0, 99),
                blurRadius: 28,
                spreadRadius: 0,
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image part with tags
              ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(AppRadius.lg),
                ),
                child:
                    // SvgPicture.asset(
                    //   'assets/images/svg/ic_yoga.svg',
                    //   height: size.height * 0.22,
                    //   // width: width * 0.6,
                    //   fit: BoxFit.fill,
                    // ),
                    Image.asset(
                      "assets/images/demo images/Class Image.png",
                      height: size.height * 0.18,
                      // width: width * 0.6,
                      fit: BoxFit.fill,
                    ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  right: AppSpacing.md,
                  left: AppSpacing.md,
                  top: AppSpacing.base,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          if (isInPlan)
                            Flexible(
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: AppSpacing.sm,
                                  vertical: AppSpacing.xs,
                                ),
                                margin: const EdgeInsets.only(
                                  right: AppSpacing.xs,
                                ),
                                decoration: BoxDecoration(
                                  color: isDark
                                      ? AppColors.successColor.withValues(
                                          alpha: 0.36,
                                        )
                                      : AppColors.featuredTagBackgroundColor,
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(
                                    color: isDark
                                        ? Colors.transparent
                                        : AppColors.featuredTagBackgroundColor,
                                    width: 1,
                                  ),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.check,
                                      color: isDark
                                          ? AppColors.lightGreyColor
                                          : AppColors.GreyColor,
                                      size: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    const SizedBox(width: AppSpacing.xs),
                                    Flexible(
                                      child: AppText(
                                        context.l10n.inYourPlan,
                                        style: (context) =>
                                            AppTextStyles.boldBody(
                                              context,
                                            ).copyWith(
                                              fontSize: 12,
                                              color: isDark
                                                  ? AppColors.lightGreyColor
                                                  : AppColors.GreyColor,
                                            ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          if (upgradeRequired)
                            Flexible(
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: AppSpacing.sm,
                                  vertical: AppSpacing.xs,
                                ),
                                decoration: BoxDecoration(
                                  color: isDark
                                      ? AppColors.upgradeDarkBackgroundColor
                                            .withValues(alpha: 0.11)
                                      : AppColors.upgradeLightBackgroundColor,
                                  borderRadius: BorderRadius.circular(16),
                                  // border: Border.all(
                                  //   color: isDark
                                  //       ? Colors.transparent
                                  //       : AppColors
                                  //             .upgradeDarkLockBackgroundColor,
                                  //   width: 1,
                                  // ),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.lock_outline,
                                      color: isDark
                                          ? AppColors
                                                .upgradeDarkLockBackgroundColor
                                          : AppColors.lightRedColor,
                                      size: 14,
                                    ),
                                    const SizedBox(width: 4),
                                    Flexible(
                                      child: AppText(
                                        context.l10n.upgradeRequired,
                                        style: (context) =>
                                            AppTextStyles.boldBody(
                                              context,
                                            ).copyWith(
                                              fontSize: 12,
                                              color: isDark
                                                  ? AppColors
                                                        .upgradeDarkLockBackgroundColor
                                                  : AppColors
                                                        .upgradeDarkLockBackgroundColor,
                                            ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                    const SizedBox(width: AppSpacing.xs),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.star,
                          color: Color(0xFFEAB308),
                          size: 16,
                        ),
                        const SizedBox(width: 4),
                        AppText(
                          rating.toString(),
                          style: (context) =>
                              AppTextStyles.boldBody(context).copyWith(
                                color: isDark
                                    ? AppColors.lightText
                                    : AppColors.darkText,
                              ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Info part
              Padding(
                padding: const EdgeInsets.only(
                  right: AppSpacing.md,
                  left: AppSpacing.md,
                  bottom: AppSpacing.md,
                  top: AppSpacing.sm,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // const SizedBox(height: AppSpacing.sm),
                    // AppText(
                    //   '$title ${context.l10n.withKey} ${context.l10n.withTrainer(trainerName)}',
                    //   style: (context) =>
                    //       AppTextStyles.boldBody(context).copyWith(
                    //         fontSize: size.width * 0.04 > 16
                    //             ? 16
                    //             : size.width * 0.04,
                    //         color: isDark
                    //             ? AppColors.lightText
                    //             : AppColors.darkText,
                    //       ),
                    // ),
                    RichText(
                      text: TextSpan(
                        text: '$title ',
                        style: AppTextStyles.boldBody(context).copyWith(
                          fontSize: size.width * 0.04 > 16
                              ? 16
                              : size.width * 0.04,
                          color: isDark
                              ? AppColors.lightText
                              : AppColors.darkText,
                        ),
                        children: [
                          TextSpan(
                            text: "${context.l10n.withKey} ",
                            style: AppTextStyles.bodyText(context).copyWith(
                              fontSize: size.width * 0.04 > 16
                                  ? 16
                                  : size.width * 0.04,
                              // highlight
                            ),
                          ),
                          TextSpan(
                            text: context.l10n.withTrainer(trainerName),
                            style: AppTextStyles.boldBody(context).copyWith(
                              fontSize: size.width * 0.04 > 16
                                  ? 16
                                  : size.width * 0.04,
                              color: isDark
                                  ? AppColors.lightText
                                  : AppColors.darkText,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: AppSpacing.xs),
                    AppText(
                      upgradeRequired
                          ? '$studio • $time'
                          : '$studio • $time • ${context.l10n.spotsLeft(spotsLeft)}',
                      style: (context) =>
                          AppTextStyles.captionText(context).copyWith(
                            fontSize: size.width * 0.03 > 14
                                ? 14
                                : size.width * 0.03,
                            color: isDark
                                ? AppColors.darkGreyText
                                : AppColors.lightGrey,
                          ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),

      // ),
    );
  }
}
