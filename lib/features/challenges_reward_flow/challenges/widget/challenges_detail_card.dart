import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pilates_app/config/theme/app_colors.dart';
import 'package:pilates_app/config/theme/app_radius.dart';
import 'package:pilates_app/config/theme/app_spacing.dart';
import 'package:pilates_app/config/theme/app_text_styles.dart';
import 'package:pilates_app/core/localization/localization_extension.dart';
import 'package:pilates_app/widgets/app_text.dart';

class ChallengesDetailCard extends StatelessWidget {
  final String imageIcon;
  final String title;
  final String subtitle;

  final int? people;
  final int days;
  final double point;

  const ChallengesDetailCard({
    super.key,
    required this.imageIcon,
    required this.title,
    required this.subtitle,
    this.people,
    required this.days,
    required this.point,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: EdgeInsetsGeometry.symmetric(
        vertical: AppSpacing.lmd,
        horizontal: AppSpacing.lg,
      ),
      decoration: BoxDecoration(
        color: isDark ? AppColors.homeBackground : AppColors.whiteColor,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(
          color: isDark ? AppColors.greyText : AppColors.buttonBorder,
          width: 1,
        ),
      ),
      child: Column(
        children: [
          SvgPicture.asset(imageIcon, height: 64, width: 64),
          SizedBox(height: AppSpacing.md),
          AppText(
            title,
            style: (context) =>
                AppTextStyles.appBarText(context).copyWith(fontSize: 18),
          ),
          SizedBox(height: AppSpacing.sm),
          AppText(
            subtitle,
            style: (context) => AppTextStyles.bodyTextSmall(context),
          ),
          SizedBox(height: AppSpacing.md),

          people == null
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AppText(
                      "$days days left",
                      style: (content) => AppTextStyles.captionText(
                        content,
                      ).copyWith(color: AppColors.lightGrey, fontSize: 14),
                    ),
                    SizedBox(width: AppSpacing.lg),
                    Container(
                      padding: EdgeInsets.symmetric(
                        vertical: 1,
                        horizontal: AppSpacing.sm,
                      ),
                      decoration: BoxDecoration(
                        color: isDark
                            ? Colors.transparent
                            : AppColors.greyContainerBg,
                        borderRadius: BorderRadius.circular(AppRadius.base),
                      ),
                      child: AppText(
                        "+$point pts",
                        style: (context) =>
                            AppTextStyles.splashVersion(context).copyWith(
                              color: isDark
                                  ? AppColors.lightText
                                  : AppColors.darkText,
                            ),
                      ),
                    ),
                  ],
                )
              : Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Icon(
                      Icons.people_alt_outlined,
                      size: 16,
                      color: isDark
                          ? AppColors.lightGrey
                          : AppColors.darkGreyText,
                    ),
                    SizedBox(width: AppSpacing.xs),
                    AppText(
                      context.l10n.people_joined(people!),
                      style: (content) => AppTextStyles.captionText(
                        content,
                      ).copyWith(color: AppColors.lightGrey, fontSize: 14),
                    ),
                    Spacer(),
                    Icon(
                      Icons.schedule,
                      size: 16,
                      color: isDark
                          ? AppColors.lightGrey
                          : AppColors.darkGreyText,
                    ),
                    SizedBox(width: AppSpacing.xs),
                    AppText(
                      context.l10n.days_only(days),
                      style: (content) => AppTextStyles.captionText(
                        content,
                      ).copyWith(color: AppColors.lightGrey, fontSize: 14),
                    ),
                    Spacer(),
                    Container(
                      padding: EdgeInsets.symmetric(
                        vertical: 1,
                        horizontal: AppSpacing.sm,
                      ),
                      decoration: BoxDecoration(
                        color: isDark
                            ? AppColors.switchInactiveDark
                            : AppColors.greyContainerBg,
                        borderRadius: BorderRadius.circular(AppRadius.base),
                      ),
                      child: AppText(
                        "+${context.l10n.points_short(point.toInt())}",
                        style: (context) =>
                            AppTextStyles.splashVersion(context).copyWith(
                              color: isDark
                                  ? AppColors.lightText
                                  : AppColors.darkText,
                            ),
                      ),
                    ),
                  ],
                ),
        ],
      ),
    );
  }
}
