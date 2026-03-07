import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pilates_app/config/theme/app_colors.dart';
import 'package:pilates_app/config/theme/app_radius.dart';
import 'package:pilates_app/config/theme/app_spacing.dart';
import 'package:pilates_app/config/theme/app_text_styles.dart';
import 'package:pilates_app/widgets/app_shadow.dart';
import 'package:pilates_app/widgets/app_text.dart';

class ExperienceOption extends StatelessWidget {
  final String title;
  final String description;
  final String iconPath; // SVG path
  final bool selected;
  final VoidCallback onTap;

  const ExperienceOption({
    super.key,
    required this.title,
    required this.description,
    required this.iconPath,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return
    // Material(
    // color: isDark ? AppColors.homeBackground : Colors.white,
    // elevation: 4,
    // shadowColor: Colors.black.withValues(alpha: 0.2),
    // borderRadius: BorderRadius.circular(16),
    // child:
    InkWell(
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      hoverColor: Colors.transparent,
      focusColor: Colors.transparent,
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadius.md),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.md + 2,
        ),
        decoration: BoxDecoration(
          color: isDark ? AppColors.homeBackground : Colors.white,
          borderRadius: BorderRadius.circular(AppRadius.md),
          border: Border.all(
            color: selected
                ? isDark
                      ? AppColors.languageIconDark
                      : AppColors.languageIconDark
                : theme.dividerColor,
            width: selected ? 1 : 1,
          ),
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
                  AppShadows.heavyShadow,
                  AppShadows.extraHeavyShadow,
                ],
          // color: Colors.white,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            /// SVG ICON
            SvgPicture.asset(
              iconPath,
              width: 64,
              height: 64,
              // colorFilter: ColorFilter.mode(
              //   selected ? theme.colorScheme.primary : theme.hintColor,
              //   BlendMode.srcIn,
              // ),
              alignment: Alignment.center,
            ),

            const SizedBox(width: AppSpacing.md),

            /// TEXT
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppText(
                    title,
                    style: (context) => AppTextStyles.experienceButton(context),
                  ),

                  const SizedBox(height: AppSpacing.xs),
                  AppText(
                    description,
                    style: (context) => AppTextStyles.body(context).copyWith(
                      color: isDark
                          ? AppColors.darkGreyText
                          : AppColors.greyText,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: AppSpacing.lg),

            if (selected)
              Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  color: (isDark
                      ? AppColors.primary
                      : AppColors.languageIcon),
                  borderRadius: BorderRadius.circular(6),
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
      ),
    );
    // );
  }
}
