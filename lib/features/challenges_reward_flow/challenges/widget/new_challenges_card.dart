import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pilates_app/config/theme/app_colors.dart';
import 'package:pilates_app/core/localization/localization_extension.dart';

import '../../../../config/theme/app_radius.dart';
import '../../../../config/theme/app_spacing.dart';
import '../../../../config/theme/app_text_styles.dart';
import '../../../../widgets/app_text.dart';
import 'join_challenge_bottomSheet.dart';

class NewChallengesCard extends StatelessWidget {
  final String imageIcon;
  final String title;
  final String subtitle;

  final int people;
  final int days;
  final double point;

  final void Function()? onCardTap;

  const NewChallengesCard({
    super.key,
    required this.imageIcon,
    required this.title,
    required this.subtitle,
    required this.people,
    required this.days,
    required this.point,
    this.onCardTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return GestureDetector(
      onTap:
          onCardTap ??
          () {
            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              barrierColor: AppColors.bottomSheetShadow,
              builder: (_) => const JoinChallengeBottomSheet(),
            );
          },
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
                SvgPicture.asset(imageIcon, height: 40, width: 40),
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
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(
                  Icons.people_alt_outlined,
                  size: 16,
                  color: isDark ? AppColors.lightGrey : AppColors.darkGreyText,
                ),
                SizedBox(width: AppSpacing.xs),
                AppText(
                  context.l10n.people_joined(people),
                  style: (content) => AppTextStyles.captionText(
                    content,
                  ).copyWith(color: AppColors.lightGrey, fontSize: 14),
                ),
                Spacer(),
                Icon(
                  Icons.schedule,
                  size: 16,
                  color: isDark ? AppColors.lightGrey : AppColors.darkGreyText,
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
