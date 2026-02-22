import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pilates_app/config/theme/app_spacing.dart';
import 'package:pilates_app/widgets/app_text.dart';

import '../../../../config/theme/app_colors.dart';
import '../../../../config/theme/app_radius.dart';
import '../../../../config/theme/app_text_styles.dart';
import '../../../../core/localization/localization_extension.dart';
import '../../../../widgets/app_app_bar.dart';
import '../widget/achievement_card.dart';

class YourJourneyView extends StatelessWidget {
  const YourJourneyView({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: AppAppBar(
        onBack: () => Navigator.of(context).pop(),
        title: context.l10n.yourJourney_title,
        isMoreMenu: false,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(
            vertical: AppSpacing.md,
            horizontal: AppSpacing.lg,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AchievementCard(
                content: context.l10n.yourJourney_achievement_content,
                showProgressBar: true,
              ),
              SizedBox(height: AppSpacing.xl),
              AppText(
                context.l10n.yourJourney_achievements_earned,
                style: (context) => AppTextStyles.gelasioRegular(context),
              ),
              SizedBox(height: AppSpacing.md),
              _buildCard(
                image: isDark
                    ? "assets/images/svg/progress_tracking/ic_dark_consistency_flow.svg"
                    : "assets/images/svg/progress_tracking/ic_consistency_flow.svg",
                title: context.l10n.yourJourney_consistency_title,
                subtitle: context.l10n.yourJourney_consistency_subtitle,
                content: context.l10n.yourJourney_consistency_content,
                isDark: isDark,
                date: context.l10n.yourJourney_consistency_date,
                context: context,
              ),
              SizedBox(height: AppSpacing.md),
              _buildCard(
                image: isDark
                    ? "assets/images/svg/progress_tracking/ic_dark_foundation_builder.svg"
                    : "assets/images/svg/progress_tracking/ic_foundation_builder.svg",
                title: context.l10n.yourJourney_foundation_title,
                subtitle: context.l10n.yourJourney_foundation_subtitle,
                content: context.l10n.yourJourney_foundation_content,
                isDark: isDark,
                date: context.l10n.yourJourney_foundation_date,
                context: context,
              ),
              SizedBox(height: AppSpacing.xl),
              AppText(
                context.l10n.yourJourney_on_your_path,
                style: (context) => AppTextStyles.gelasioRegular(context),
              ),
              SizedBox(height: AppSpacing.md),
              _buildCard(
                image: isDark
                    ? "assets/images/svg/progress_tracking/ic_dark_monthly_dedication.svg"
                    : "assets/images/svg/progress_tracking/ic_monthly_dedication.svg",
                title: context.l10n.yourJourney_monthly_title,
                subtitle: context.l10n.yourJourney_monthly_subtitle,
                content: context.l10n.yourJourney_monthly_content,
                isDark: isDark,
                isShowProgress: true,
                date: context.l10n.yourJourney_monthly_date,
                context: context,
              ),
              SizedBox(height: AppSpacing.md),
              _buildCard(
                image: isDark
                    ? "assets/images/svg/progress_tracking/ic_dark_community_spirit.svg"
                    : "assets/images/svg/progress_tracking/ic_community_spirit.svg",
                title: context.l10n.yourJourney_community_title,
                subtitle: context.l10n.yourJourney_community_subtitle,
                content: context.l10n.yourJourney_community_content,
                isDark: isDark,
                isShowProgress: true,
                date: context.l10n.yourJourney_community_date,
                context: context,
              ),
            ],
          ),
        ),
      ),
    );
  }

  _buildCard({
    required bool isDark,
    required String image,
    required String title,
    required String subtitle,
    required String content,
    required String date,
    required BuildContext context,
    bool isShowProgress = false,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: AppSpacing.lmd,
        horizontal: AppSpacing.md,
      ),
      decoration: BoxDecoration(
        color: isDark ? AppColors.homeBackground : Colors.white,
        border: Border.all(
          color: isDark ? AppColors.greyText : AppColors.buttonBorder,
          width: 1,
        ),
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          SvgPicture.asset(image, height: 40, width: 40),
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
                  ).copyWith(height: 1),
                ),
                SizedBox(height: AppSpacing.xs),
                AppText(
                  subtitle,
                  style: (context) =>
                      AppTextStyles.textFieldHeading(context).copyWith(
                        height: 1,
                        color: isDark
                            ? AppColors.languageTextDark
                            : AppColors.languageIcon,
                      ),
                ),
                SizedBox(height: AppSpacing.base),
                AppText(
                  content,
                  style: (context) => AppTextStyles.bodyText(
                    context,
                  ).copyWith(height: 1.4, color: AppColors.lightGrey),
                ),

                SizedBox(height: AppSpacing.lmd),

                Visibility(
                  visible: isShowProgress,
                  child: Padding(
                    padding: EdgeInsets.only(bottom: AppSpacing.lmd),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            AppText(
                              context.l10n.yourJourney_your_progress,
                              style: (context) => AppTextStyles.captionText(
                                context,
                              ).copyWith(color: AppColors.lightGrey),
                            ),

                            AppText(
                              context.l10n.yourJourney_progress_count,
                              style: (context) =>
                                  AppTextStyles.captionText(context).copyWith(
                                    color: isDark
                                        ? AppColors.languageTextDark
                                        : AppColors.languageIcon,
                                    fontWeight: FontWeight.w600,
                                  ),
                            ),
                          ],
                        ),
                        SizedBox(height: AppSpacing.base),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(AppRadius.sm),
                          child: LinearProgressIndicator(
                            value: 0.6,
                            minHeight: 6,
                            backgroundColor: isDark
                                ? AppColors.primaryDarkButton
                                : AppColors.goalTrackColor,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              isDark
                                  ? AppColors.languageIconDark
                                  : AppColors.languageIconDark,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    AppText(
                      context.l10n.yourJourney_consistency_date,
                      style: (content) => AppTextStyles.captionText(
                        content,
                      ).copyWith(color: AppColors.lightGrey),
                    ),
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
                        context.l10n.yourJourney_points,
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
        ],
      ),
    );
  }
}
