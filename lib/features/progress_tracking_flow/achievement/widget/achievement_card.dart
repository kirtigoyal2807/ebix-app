import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pilates_app/core/localization/localization_extension.dart';

import '../../../../config/theme/app_colors.dart';
import '../../../../config/theme/app_radius.dart';
import '../../../../config/theme/app_spacing.dart';
import '../../../../config/theme/app_text_styles.dart';
import '../../../../widgets/app_shadow.dart';
import '../../../../widgets/app_text.dart';

class AchievementCard extends StatelessWidget {
  final String content;
  final bool showProgressBar;

  const AchievementCard({
    super.key,
    required this.content,
    this.showProgressBar = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: EdgeInsets.symmetric(vertical: 20),
      width: double.infinity,
      decoration: BoxDecoration(
        color: isDark ? AppColors.primaryDarkButton : AppColors.seekBarLight,
        borderRadius: BorderRadius.circular(AppRadius.base),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          //achievement
          Container(
            padding: EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: isDark ? AppColors.homeBackground : Colors.white,
              shape: BoxShape.circle,
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
            ),
            child: SvgPicture.asset(
              "assets/images/svg/progress_tracking/ic_achievement.svg",
              color: isDark
                  ? AppColors.subscriptionCardGradient2
                  : AppColors.languageIcon,
            ),
          ),
          SizedBox(height: AppSpacing.md),
          AppText(
            "8 ${context.l10n.achievements}",
            style: (context) => AppTextStyles.appBarTitle(
              context,
            ).copyWith(fontWeight: FontWeight.w600, height: 1),
          ),
          SizedBox(height: 2),
          AppText(content, style: (context) => AppTextStyles.bodyText(context)),

          Visibility(
            visible: showProgressBar,
            child: Padding(
              padding: EdgeInsets.only(
                top: AppSpacing.base,
                right: AppSpacing.lg,
                left: AppSpacing.lg,
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(AppRadius.sm),
                child: LinearProgressIndicator(
                  value: 0.6,
                  minHeight: 6,
                  backgroundColor: isDark
                      ? AppColors.progressBGColor
                      : AppColors.darkGreyBorder,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    isDark
                        ? AppColors.subscriptionCardGradient2
                        : AppColors.languageIconDark,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
