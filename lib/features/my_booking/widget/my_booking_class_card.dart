import 'package:flutter/material.dart';

import 'package:pilates_app/config/theme/app_colors.dart';
import 'package:pilates_app/config/theme/app_radius.dart';
import 'package:pilates_app/config/theme/app_spacing.dart';
import 'package:pilates_app/config/theme/app_text_styles.dart';
import 'package:pilates_app/core/localization/localization_extension.dart';

import 'package:pilates_app/features/my_booking/widget/rate_sheet.dart';
import 'package:pilates_app/widgets/app_button.dart';
import 'package:pilates_app/widgets/app_text.dart';

import '../my_booking_view.dart';
import 'confirmation_sheet.dart';

class MyBookingClassCard extends StatelessWidget {
  final String title;
  final String trainerName;
  final String studio;
  final String time;
  final String date;
  final double rating;
  final BookingStatus bookingStatus;
  final int? spot;
  final int? position;
  final bool? isRate;

  const MyBookingClassCard({
    super.key,
    required this.title,
    required this.trainerName,
    required this.studio,
    required this.time,
    required this.date,
    this.rating = 4.5,
    this.bookingStatus = BookingStatus.confirmed,
    this.spot = 0,
    this.position = 0,
    this.isRate = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final size = MediaQuery.sizeOf(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      child: Material(
        color: isDark ? AppColors.homeBackground : Colors.white,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        child: InkWell(
          onTap: () {},
          borderRadius: BorderRadius.circular(AppRadius.lg),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppRadius.lg),
              border: Border.all(
                color: isDark ? AppColors.greyText : AppColors.buttonBorder,
              ),
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
                            if (bookingStatus == BookingStatus.confirmed ||
                                bookingStatus == BookingStatus.completed)
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
                                          ? AppColors.successBorderDark
                                          : AppColors.lightGreenBorder,
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
                                            : AppColors.successColor,
                                        size: 12,
                                      ),
                                      const SizedBox(width: AppSpacing.xs),
                                      Flexible(
                                        child: AppText(
                                          bookingStatus ==
                                                  BookingStatus.confirmed
                                              ? context.l10n.confirmed
                                              : context.l10n.completed,
                                          style: (context) =>
                                              AppTextStyles.boldBody(
                                                context,
                                              ).copyWith(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w500,
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
                            if (bookingStatus == BookingStatus.waitListed)
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
                                    border: Border.all(
                                      color: isDark
                                          ? AppColors
                                                .upgradeDarkLockBackgroundColor
                                          : AppColors.warningColor,
                                      width: 1,
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        Icons.error_outline,
                                        color: AppColors.goldStarColor,
                                        size: 14,
                                      ),
                                      const SizedBox(width: 4),
                                      Flexible(
                                        child: AppText(
                                          context.l10n.waitlisted,
                                          style: (context) =>
                                              AppTextStyles.boldBody(
                                                context,
                                              ).copyWith(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w500,
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
                            if (bookingStatus == BookingStatus.cancelled)
                              Flexible(
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: AppSpacing.sm,
                                    vertical: AppSpacing.xs,
                                  ),
                                  decoration: BoxDecoration(
                                    color: isDark
                                        ? AppColors.redLight.withValues(
                                            alpha: 0.16,
                                          )
                                        : AppColors.cardLightBackground,
                                    borderRadius: BorderRadius.circular(16),
                                    border: Border.all(
                                      color: isDark
                                          ? AppColors.redLight
                                          : AppColors.redBorder,
                                      width: 1,
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        Icons.close,
                                        color: isDark
                                            ? AppColors.redText
                                            : AppColors.redLight,
                                        size: 12,
                                      ),
                                      const SizedBox(width: 4),
                                      Flexible(
                                        child: AppText(
                                          context.l10n.cancelled,
                                          style: (context) =>
                                              AppTextStyles.boldBody(
                                                context,
                                              ).copyWith(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w500,
                                                color: isDark
                                                    ? AppColors.redText
                                                    : AppColors.redLight,
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
                      if (bookingStatus == BookingStatus.confirmed ||
                          bookingStatus == BookingStatus.waitListed)
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
                            fontWeight: FontWeight.w500,
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
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: AppSpacing.sm),
                      infoContent(context: context, isDark: isDark),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Column infoContent({required BuildContext context, required bool isDark}) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final size = MediaQuery.sizeOf(context);

    switch (bookingStatus) {
      case (BookingStatus.confirmed):
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppText(
              '$studio • $date',
              style: (context) => AppTextStyles.captionText(context).copyWith(
                fontSize: size.width * 0.03 > 14 ? 14 : size.width * 0.03,
                color: isDark ? AppColors.darkGreyText : AppColors.greyText,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: AppSpacing.sm),
            AppText(
              time,
              style: (context) => AppTextStyles.captionText(context).copyWith(
                fontSize: size.width * 0.03 > 14 ? 14 : size.width * 0.03,
                color: isDark ? AppColors.darkGreyText : AppColors.greyText,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: AppButton(
                    label: context.l10n.checkIn,
                    onPressed: () {},
                    buttonHeight: 32,
                    variant: AppButtonVariant.primary,
                    verticalPadding: 6.5,
                    buttonFontSize: 12,
                  ),
                ),
                SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: AppButton(
                    label: context.l10n.cancel,
                    onPressed: () {
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        backgroundColor: Colors.transparent,
                        builder: (_) => ConfirmationSheet(
                          confirmationText: context.l10n.cancelClassConfirm,
                          buttonText: context.l10n.cancelClassYes,
                        ),
                      );
                    },
                    buttonHeight: 32,
                    buttonColor: AppColors.redLight,
                    verticalPadding: 6.5,
                    buttonFontSize: 12,
                  ),
                ),
              ],
            ),
          ],
        );
      case (BookingStatus.waitListed):
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppText(
              '$studio • $time',
              style: (context) => AppTextStyles.captionText(context).copyWith(
                fontSize: size.width * 0.03 > 14 ? 14 : size.width * 0.03,
                color: isDark ? AppColors.darkGreyText : AppColors.greyText,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: AppSpacing.sm),
            AppText(
              '${context.l10n.spotsLeft(spot ?? 0)} • ${context.l10n.positionOnWaitlist(position ?? 0)}',
              // '$spot spots left • Position #$position on waitlist',
              style: (context) => AppTextStyles.captionText(context).copyWith(
                fontSize: size.width * 0.03 > 14 ? 14 : size.width * 0.03,
                color: isDark ? AppColors.darkGreyText : AppColors.greyText,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 10),
            AppButton(
              label: context.l10n.leaveWaitlist,
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  backgroundColor: Colors.transparent,
                  builder: (_) => ConfirmationSheet(
                    confirmationText: context.l10n.leaveWaitlistConfirm,
                    buttonText: context.l10n.leaveWaitlistYes,
                  ),
                );
              },
              buttonHeight: 32,
              buttonColor: AppColors.redLight,
              verticalPadding: 6.5,
              buttonFontSize: 12,
            ),
          ],
        );
      case (BookingStatus.completed):
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppText(
              '$studio • $date',
              style: (context) => AppTextStyles.captionText(context).copyWith(
                fontSize: size.width * 0.03 > 14 ? 14 : size.width * 0.03,
                color: isDark ? AppColors.darkGreyText : AppColors.greyText,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: AppSpacing.sm),
            AppText(
              time,
              style: (context) => AppTextStyles.captionText(context).copyWith(
                fontSize: size.width * 0.03 > 14 ? 14 : size.width * 0.03,
                color: isDark ? AppColors.darkGreyText : AppColors.greyText,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 10),
            if (isRate == false)
              Container(
                decoration: BoxDecoration(
                  color: isDark ? AppColors.homeBackground : Colors.white,
                ),
                child: AppButton(
                  label: context.l10n.rateThisClass,
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      backgroundColor: Colors.transparent,
                      builder: (_) => const RateSheet(),
                    );
                  },
                  buttonHeight: 34,
                  variant: AppButtonVariant.secondary,
                  verticalPadding: 6.5,
                  buttonFontSize: 12,
                ),
              ),

            if (isRate == true)
              Container(
                margin: EdgeInsets.only(top: AppSpacing.xi),
                padding: EdgeInsets.all(AppSpacing.md),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.homeBackground : Colors.white,
                  border: Border.all(
                    color: isDark ? AppColors.greyText : AppColors.buttonBorder,
                    width: 0.5,
                  ),
                  borderRadius: BorderRadius.circular(AppRadius.md),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.star,
                          color: AppColors.goldStarColor,
                          size: 16,
                        ),
                        const SizedBox(width: 4),
                        AppText(
                          '4.5',
                          style: (context) =>
                              AppTextStyles.boldBody(context).copyWith(
                                fontSize: 14,
                                color: isDark
                                    ? AppColors.lightText
                                    : AppColors.darkText,
                              ),
                        ),
                      ],
                    ),
                    SizedBox(height: AppSpacing.xs),
                    AppText(
                      '''"${context.l10n.reviewExcellent}"''',
                      style: (context) => AppTextStyles.bodyText(context),
                    ),
                  ],
                ),
              ),
          ],
        );
      case (BookingStatus.cancelled):
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppText(
              '$studio • $date',
              style: (context) => AppTextStyles.captionText(context).copyWith(
                fontSize: size.width * 0.03 > 14 ? 14 : size.width * 0.03,
                color: isDark ? AppColors.darkGreyText : AppColors.greyText,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: AppSpacing.sm),
            Divider(
              height: 0.5,
              color: isDark ? AppColors.greyText : AppColors.buttonBorder,
            ),
            const SizedBox(height: AppSpacing.sm),
            AppText(
              context.l10n.cancelledOn('Jan 15', '2:00 PM'),
              style: (context) => AppTextStyles.captionText(context).copyWith(
                fontSize: size.width * 0.03 > 14 ? 14 : size.width * 0.03,
                color: isDark ? AppColors.darkGreyText : AppColors.lightGrey,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        );
    }
  }
}
