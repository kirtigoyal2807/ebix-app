import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pilates_app/config/theme/app_colors.dart';
import 'package:pilates_app/config/theme/app_radius.dart';
import 'package:pilates_app/config/theme/app_spacing.dart';
import 'package:pilates_app/config/theme/app_text_styles.dart';
import 'package:pilates_app/widgets/app_text.dart';

import '../../../../core/localization/localization_extension.dart';
import '../../../../widgets/app_shadow.dart';

class BranchOption extends StatelessWidget {
  final String title;
  final String city;
  final String distance;
  final String type; // Premium / Standard
  final bool selected;
  final VoidCallback onTap;
  final bool isOnBoarding;

  const BranchOption({
    super.key,
    required this.title,
    required this.city,
    required this.distance,
    required this.type,
    required this.selected,
    required this.onTap,
    this.isOnBoarding = true,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final theme = Theme.of(context);
    final borderColor = selected
        ? isDark
              ? AppColors.greyText
              : Colors.transparent
        : isDark
        ? AppColors.greyText
        : Colors.transparent;

    return
    // Material(
    // color: isDark ? AppColors.homeBackground : Colors.white,
    // color: Colors.transparent,
    // child:
    InkWell(
      onTap: onTap,
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      hoverColor: Colors.transparent,
      focusColor: Colors.transparent,
      borderRadius: BorderRadius.circular(AppRadius.md),
      child: Container(
        // padding: const EdgeInsets.all(AppSpacing.lg),
        decoration: BoxDecoration(
          color: isDark ? AppColors.homeBackground : Colors.white,
          borderRadius: BorderRadius.circular(AppRadius.md),
          border: Border.all(color: borderColor, width: selected ? 1 : 1),
          boxShadow: isDark
              ? [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.06),
                    offset: const Offset(0, 4),
                    blurRadius: 8,
                    spreadRadius: 0,
                  ),
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.04),
                    offset: const Offset(0, 0),
                    blurRadius: 4,
                    spreadRadius: 0,
                  ),
                ]
              : [
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

          // color:Colors.white,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadiusGeometry.only(
                topLeft: Radius.circular(AppRadius.md),
                topRight: Radius.circular(AppRadius.md),
              ),
              child: Image.asset(
                "assets/images/png/ic_branch.png",
                fit: BoxFit.fill,
                width: MediaQuery.of(context).size.width,
                height: 127,
              ),
            ),

            /// TOP ROW: TITLE + CHIP
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: AppSpacing.base,
                horizontal: AppSpacing.md,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            AppText(
                              title,
                              style: AppTextStyles.textFieldHeading,
                            ),
                            const SizedBox(height: AppSpacing.xs),

                            /// CITY
                            AppText(
                              city,
                              style: (context) => AppTextStyles.bodyTextSmall(
                                context,
                              ).copyWith(fontSize: 12, height: 1.4),
                            ),
                          ],
                        ),
                      ),
                      if (selected)
                        Container(
                          width: 20,
                          height: 20,
                          decoration: BoxDecoration(
                            color: isOnBoarding
                                ? (isDark
                                      ? AppColors.primary
                                      : AppColors.languageIcon)
                                : AppColors.primary,
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(
                              color: isDark && isOnBoarding
                                  ? AppColors.darkGreyBorder
                                  : Colors.transparent,
                              width: 1,
                            ),
                          ),
                          child: Center(
                            child: SvgPicture.asset(
                              "assets/images/svg/ic_checkbox_white.svg",
                              width: 10,
                              height: 10,
                              fit: BoxFit.contain,
                              // colorFilter: ColorFilter.mode(
                              //   selected ? theme.colorScheme.primary : theme.hintColor,
                              //   BlendMode.srcIn,
                              // ),
                              alignment: Alignment.center,
                            ),
                          ),
                          // child: const Icon(Icons.check, color: Colors.white, size: 14),
                        )
                      else
                        const SizedBox(width: 20),
                    ],
                  ),

                  const SizedBox(height: AppSpacing.md),

                  /// DISTANCE
                  Row(
                    children: [
                      Icon(
                        Icons.location_on_outlined,
                        size: 16,
                        color: theme.hintColor,
                      ),
                      const SizedBox(width: 4),
                      AppText(
                        distance,
                        style: (context) => AppTextStyles.bodyTextSmall(
                          context,
                        ).copyWith(fontSize: 12, height: 1.4),
                      ),
                      Spacer(),

                      isOnBoarding
                          ? _BranchTypeChip(type: type)
                          : Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: AppSpacing.xi,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: isDark
                                    ? AppColors.successColor.withValues(
                                        alpha: 0.36,
                                      )
                                    : AppColors.featuredTagBackgroundColor,
                                borderRadius: BorderRadius.circular(
                                  AppRadius.base,
                                ),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.done,
                                    color: isDark
                                        ? AppColors.successBorderDark
                                        : AppColors.GreyColor,
                                    size: 11,
                                  ),
                                  SizedBox(width: 5),
                                  AppText(
                                      context.l10n.branchTitle,
                                    style: (context) =>
                                        AppTextStyles.splashVersion(
                                          context,
                                        ).copyWith(
                                          color: isDark
                                              ? AppColors.successBorderDark
                                              : AppColors.GreyColor,
                                          height: 1.8,
                                        ),
                                  ),
                                ],
                              ),
                            ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
    // );
  }
}

class _BranchTypeChip extends StatelessWidget {
  final String type;

  const _BranchTypeChip({required this.type});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark
              ? (type == 'Premium'
                    ? AppColors.languageIcon
                    : AppColors.blueTagValue)
              : (type == 'Premium'
                    ? AppColors.darkGreyBorder
                    : AppColors.branchTagLightStandardBorder),
        ),
        color: isDark
            ? (type == 'Premium'
                  ? AppColors.badgeBackground
                  : Color(0x299DCEFF))
            : (type == 'Premium'
                  ? AppColors.branchTagLight
                  : AppColors.branchTagLightStandard),
      ),
      child: Text(
        type,
        // style: AppTextStyles.headingSmall,
        style: AppTextStyles.headingSmall(context).copyWith(
          color: isDark
              ? (type == 'Premium'
                    ? AppColors.languageTextDark
                    : AppColors.blueTagDarkText)
              : (type == 'Premium'
                    ? AppColors.languageIcon
                    : AppColors.blueTagText),
        ),
      ),
    );
  }
}
