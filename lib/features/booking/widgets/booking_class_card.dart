import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import 'package:pilates_app/features/auth/cubit/auth_cubit.dart';
import 'package:pilates_app/features/auth/data/models/auth_user.dart';
import 'package:pilates_app/features/booking/booking_entitlements.dart';

import 'package:pilates_app/config/theme/app_colors.dart';
import 'package:pilates_app/config/theme/app_radius.dart';
import 'package:pilates_app/config/theme/app_spacing.dart';
import 'package:pilates_app/config/theme/app_text_styles.dart';
import 'package:pilates_app/core/localization/localization_extension.dart';
import 'package:pilates_app/features/booking/data/models/class_slot_view_model.dart';
import 'package:pilates_app/features/booking/data/classes_repository.dart';
import 'package:pilates_app/features/booking/utils/class_single_session_checkout.dart';
import 'package:pilates_app/features/booking/views/booking_success_view.dart';
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
  final double? avgRating;
  final bool isInPlan;
  final bool upgradeRequired;
  final String calendarEventId;
  final String classId;
  final String? imageUrl;
  final ClassSlotViewModel? _slot;

  const BookingClassCard({
    super.key,
    required this.title,
    required this.trainerName,
    required this.studio,
    required this.time,
    required this.spotsLeft,
    this.avgRating,
    this.isInPlan = true,
    this.upgradeRequired = false,
    this.calendarEventId = BookingDemoCalendarEvent.id,
    this.classId = BookingDemoClass.id,
    this.imageUrl,
  }) : _slot = null;

  /// Construct directly from a [ClassSlotViewModel] returned by the API.
  BookingClassCard.fromSlot(ClassSlotViewModel slot, {super.key})
    : title = slot.name,
      trainerName = slot.trainerName,
      studio = slot.branchName,
      time = _formatSlotTime(slot),
      spotsLeft = slot.slotsLeft ?? 0,
      avgRating = slot.avgRating,
      isInPlan = slot.allowPackageBooking,
      upgradeRequired = slot.upgradeRequired,
      calendarEventId = slot.calendarEventId,
      classId = slot.classId,
      imageUrl = _nonEmptyUrl(slot.imageUrl),
      _slot = slot;

  static String? _nonEmptyUrl(String? raw) {
    final u = raw?.trim();
    if (u == null || u.isEmpty) return null;
    return u;
  }

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
    final user = context.select<AuthCubit, AuthUser?>((c) => c.state.user);

    final slot = _slot;
    final showInPlanBadge = slot != null
        ? (slot.allowPackageBooking && userShowsPackageMembership(user))
        : isInPlan;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      // child:
      // Material(
      // color: isDark ? AppColors.surfaceDark : Colors.white,
      // borderRadius: BorderRadius.circular(AppRadius.lg),
      child: InkWell(
        onTap: () {
          if (upgradeRequired) {
            final slot = _slot;
            BranchNotInPlanSheet.show(
              context,
              singleClassPrice: slot?.basePrice,
              showPaySingleClass:
                  slot != null && slot.allowSinglePurchase,
              onPaySingleClass: slot != null && slot.allowSinglePurchase
                  ? () async {
                      await ClassSingleSessionCheckout.run(
                        context: context,
                        repository: context.read<ClassesRepository>(),
                        calendarEventId: slot.calendarEventId,
                        l10n: context.l10n,
                        onSuccess: (booking) {
                          if (!context.mounted) return;
                          Navigator.of(context).push(
                            MaterialPageRoute<void>(
                              builder: (_) => BookingSuccessScreen(
                                successPage: SuccessPage.booking,
                                slot: slot,
                                booking: booking,
                              ),
                            ),
                          );
                        },
                      );
                    }
                  : null,
            );
          } else {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (newContext) =>
                    ClassDetailView(classId: classId, preloadedSlot: _slot),
              ),
            );
          }
        },
        borderRadius: BorderRadius.circular(AppRadius.md),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            color: isDark ? AppColors.surfaceDark : Colors.white,

            border: Border.all(
              color: isDark ? AppColors.greyText : Colors.transparent,
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
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(AppRadius.md),
                  topRight: Radius.circular(AppRadius.md),
                ),
                child: _classListImage(
                  imageUrl: imageUrl,
                  height: size.height * 0.18,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
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
                          if (showInPlanBadge)
                            Flexible(
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: AppSpacing.sm,
                                  vertical: AppSpacing.xs,
                                ),
                                margin: EdgeInsets.only(right: AppSpacing.xs),
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
                                    SizedBox(width: AppSpacing.xs),
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
                                padding: EdgeInsets.symmetric(
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
                                    SizedBox(width: 4),
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
                    if (avgRating != null) ...[
                      SizedBox(width: AppSpacing.xs),
                      _BookingClassCardRatingRow(
                        avgRating: avgRating!,
                        isDark: isDark,
                      ),
                    ],
                  ],
                ),
              ),

              // Info part
              Padding(
                padding: EdgeInsets.only(
                  right: AppSpacing.md,
                  left: AppSpacing.md,
                  bottom: AppSpacing.md,
                  top: AppSpacing.sm,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // SizedBox(height: AppSpacing.sm),
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

                    SizedBox(height: AppSpacing.xs),
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

  static const String _fallbackClassImageAsset =
      'assets/images/demo images/Class Image.png';

  static Widget _classListImage({
    required String? imageUrl,
    required double height,
  }) {
    if (imageUrl != null && imageUrl.isNotEmpty) {
      return Image.network(
        imageUrl,
        height: height,
        width: double.infinity,
        fit: BoxFit.cover,
        errorBuilder: (_, _, _) => Image.asset(
          _fallbackClassImageAsset,
          height: height,
          width: double.infinity,
          fit: BoxFit.cover,
        ),
      );
    }
    return Image.asset(
      _fallbackClassImageAsset,
      height: height,
      width: double.infinity,
      fit: BoxFit.cover,
    );
  }
}

class _BookingClassCardRatingRow extends StatelessWidget {
  const _BookingClassCardRatingRow({
    required this.avgRating,
    required this.isDark,
  });

  final double avgRating;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final label = _ratingLabel(avgRating);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(Icons.star, color: Color(0xFFEAB308), size: 16),
        const SizedBox(width: 4),
        AppText(
          label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: (context) => AppTextStyles.boldBody(
            context,
          ).copyWith(color: isDark ? AppColors.lightText : AppColors.darkText),
        ),
      ],
    );
  }

  static String _ratingLabel(double r) {
    if (r == r.roundToDouble()) return r.round().toString();
    return r.toStringAsFixed(1);
  }
}
