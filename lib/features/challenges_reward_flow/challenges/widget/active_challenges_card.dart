import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pilates_app/config/theme/app_colors.dart';

import '../../../../config/theme/app_radius.dart';
import '../../../../config/theme/app_spacing.dart';
import '../../../../config/theme/app_text_styles.dart';
import '../../../../core/localization/localization_extension.dart';
import '../../../../widgets/app_text.dart';

class ActiveChallengesCard extends StatelessWidget {
  final String imageIcon;
  final String title;
  final String subtitle;
  final double completePR;
  final int? rank;
  final int days;
  final double point;
  final double linearProgress;
  final void Function()? onTap;

  const ActiveChallengesCard({
    super.key,
    required this.imageIcon,
    required this.title,
    required this.subtitle,
    required this.completePR,
    this.rank,
    required this.days,
    required this.point,
    this.linearProgress = 0.6,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(AppSpacing.lmd),
        decoration: BoxDecoration(
          color: isDark ? AppColors.homeBackground : AppColors.whiteColor,
          border: Border.all(
            color: isDark ? AppColors.greyText : AppColors.borderLight,
            width: 1,
          ),
          borderRadius: BorderRadius.circular(AppRadius.md),
        ),
        child: Column(
          children: [
            Row(
              children: [
                SvgPicture.asset(imageIcon, height: 48, width: 48),
                SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      AppText(
                        title,
                        style: (context) => AppTextStyles.textFieldHeading(
                          context,
                        ).copyWith(height: 1.2, fontSize: 16),
                      ),
                      SizedBox(height: AppSpacing.xs),
                      AppText(
                        subtitle,
                        style: (context) => AppTextStyles.bodyText(
                          context,
                        ).copyWith(height: 1.4),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: AppSpacing.lg),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                AppText(
                  context.l10n.percent_complete(completePR.toInt()),
                  style: (context) => AppTextStyles.bodyLightText(context),
                ),
                if (rank != null)
                  AppText(
                    context.l10n.rank_number(rank!),
                    style: (context) => AppTextStyles.boldBody(context),
                  ),
              ],
            ),
            SizedBox(height: AppSpacing.sm),
            ClipRRect(
              borderRadius: BorderRadius.circular(AppRadius.sm),
              child: LinearProgressIndicator(
                value: linearProgress.clamp(0.0, 1.0),
                minHeight: 6,
                backgroundColor: isDark
                    ? AppColors.lightBlackColor
                    : AppColors.goalTrackColor,
                valueColor: AlwaysStoppedAnimation<Color>(
                  isDark
                      ? AppColors.subscriptionCardGradient2
                      : AppColors.languageIconDark,
                ),
              ),
            ),
            SizedBox(height: AppSpacing.sm),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                AppText(
                  context.l10n.days_left(days),
                  style: (content) => AppTextStyles.captionText(
                    content,
                  ).copyWith(color: AppColors.lightGrey, fontSize: 14),
                ),
                Container(
                  padding: EdgeInsets.symmetric(
                    vertical: 1,
                    horizontal: AppSpacing.sm,
                  ),
                  decoration: BoxDecoration(
                    color: isDark
                        ? AppColors.primaryDarkButton
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
      ),
    );
  }
}
