import 'package:flutter/material.dart';

import 'package:pilates_app/config/theme/app_colors.dart';
import 'package:pilates_app/config/theme/app_radius.dart';
import 'package:pilates_app/config/theme/app_spacing.dart';
import 'package:pilates_app/config/theme/app_text_styles.dart';
import 'package:pilates_app/core/localization/localization_extension.dart';
import 'package:pilates_app/widgets/app_text.dart';

class FeaturedClassCard extends StatelessWidget {
  const FeaturedClassCard({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final size = MediaQuery.sizeOf(context);
    final imageHeight = size.height * 0.18;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : Colors.white,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(
          color: isDark ? AppColors.greyText : AppColors.buttonBorder,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(AppRadius.lg),
            ),
            child:
                // SvgPicture.asset(
                //   'assets/images/svg/ic_yoga.svg',
                //   height: imageHeight,
                //   // width: width * 0.6,
                //   fit: BoxFit.fill,
                // ),
                Image.asset(
                  "assets/images/demo images/Class Image.png",
                  height: imageHeight,
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
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.sm,
                vertical: AppSpacing.xs,
              ),
              margin: const EdgeInsets.only(right: AppSpacing.xs),
              decoration: BoxDecoration(
                color: isDark
                    ? AppColors.successColor.withValues(alpha: 0.36)
                    : AppColors.featuredTagBackgroundColor,
                borderRadius: BorderRadius.circular(16),
                // border: Border.all(
                //   color: isDark
                //       ? AppColors.successBorderDark
                //       : AppColors.featuredTagBackgroundColor,
                //   width: 1,
                // ),
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
                  ),
                  const SizedBox(width: AppSpacing.xs),
                  Flexible(
                    child: AppText(
                      context.l10n.inYourPlan,
                      style: (context) =>
                          AppTextStyles.boldBody(context).copyWith(
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
                // AppText(
                //   '${context.l10n.powerPilates} ${context.l10n.withTrainer("Aisha Sherin")}',
                //   style: (context) => AppTextStyles.boldBody(context).copyWith(
                //     fontSize: size.width * 0.04 > 16 ? 16 : size.width * 0.04,
                //     color: isDark ? AppColors.lightText : AppColors.darkText,
                //   ),
                // ),
                RichText(
                  text: TextSpan(
                    text: context.l10n.powerPilates,
                    style: AppTextStyles.boldBody(context).copyWith(
                      fontSize: size.width * 0.04 > 16 ? 16 : size.width * 0.04,
                      color: isDark ? AppColors.lightText : AppColors.darkText,
                    ),
                    children: [
                      TextSpan(
                        text: " ${context.l10n.withKey} ",
                        style: AppTextStyles.bodyText(context).copyWith(
                          fontSize: size.width * 0.04 > 16
                              ? 16
                              : size.width * 0.04,
                          // highlight
                        ),
                      ),
                      TextSpan(
                        text: context.l10n.withTrainer("Aisha Sherin"),
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
                  '${context.l10n.branchDowntown} • ${context.l10n.today} • ${context.l10n.spotsLeft(3)}',
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
                const SizedBox(height: AppSpacing.sm),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.splashBackgroundDark,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppRadius.xl),
                    ),
                    minimumSize: const Size(double.infinity, 40),
                  ),
                  child: AppText(
                    context.l10n.bookClass,
                    style: (context) =>
                        AppTextStyles.boldBody(context).copyWith(
                          color: Colors.white,
                          fontSize: size.width * 0.035 > 14
                              ? 14
                              : size.width * 0.035,
                        ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
