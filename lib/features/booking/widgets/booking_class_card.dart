import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:pilates_app/config/theme/app_colors.dart';
import 'package:pilates_app/config/theme/app_radius.dart';
import 'package:pilates_app/config/theme/app_spacing.dart';
import 'package:pilates_app/config/theme/app_text_styles.dart';
import 'package:pilates_app/core/localization/localization_extension.dart';
import 'package:pilates_app/features/booking/widgets/upgrade_bottom_sheet.dart';
import 'package:pilates_app/widgets/app_text.dart';
import 'package:pilates_app/features/booking/cubit/booking_cubit.dart';
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
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final size = MediaQuery.sizeOf(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      child: Material(
        color: isDark ? AppColors.surfaceDark : Colors.white,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        child: InkWell(
          onTap: () {
            if (isInPlan) {
              final cubit = BlocProvider.of<BookingCubit>(context);
              cubit.loadClassDetails();
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (newContext) => BlocProvider.value(
                    value: cubit,
                    child: ClassDetailView(classState: ClassState.booking),
                  ),
                ),
              );
            } else {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                builder: (_) => const BranchNotInPlanSheet(),
              );
            }
          },
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
                        height: size.height * 0.22,
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
                                          ? AppColors.successBorderDark
                                          : AppColors.successBorder,
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
                                        size: 14,
                                      ),
                                      const SizedBox(width: AppSpacing.xs),
                                      Flexible(
                                        child: AppText(
                                          context.l10n.inYourPlan,
                                          style: (context) =>
                                              AppTextStyles.boldBody(
                                                context,
                                              ).copyWith(
                                                fontSize: 10,
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
                                    border: Border.all(
                                      color: isDark
                                          ? AppColors
                                                .upgradeDarkLockBackgroundColor
                                          : AppColors
                                                .upgradeDarkLockBackgroundColor,
                                      width: 1,
                                    ),
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
                                                fontSize: 10,
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
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: AppSpacing.sm),
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
                        '$studio • $time • ${context.l10n.spotsLeft(spotsLeft)}',
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
      ),
    );
  }
}
