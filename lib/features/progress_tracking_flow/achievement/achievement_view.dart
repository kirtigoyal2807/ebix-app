import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pilates_app/config/theme/app_colors.dart';
import 'package:pilates_app/config/theme/app_text_styles.dart';
import 'package:pilates_app/core/localization/localization_extension.dart';
import 'package:pilates_app/features/progress_tracking_flow/achievement/view/your_journey_view.dart';
import 'package:pilates_app/features/progress_tracking_flow/achievement/widget/achievement_card.dart';
import 'package:pilates_app/widgets/app_button.dart';
import 'package:pilates_app/widgets/app_text.dart';

import '../../../config/theme/app_radius.dart';
import '../../../config/theme/app_spacing.dart';
import '../../../widgets/app_shadow.dart';

class AchievementView extends StatelessWidget {
  const AchievementView({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.lg,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppText(
            context.l10n.yourJourney_your_progress,
            style: (context) => AppTextStyles.gelasioRegular(context),
          ),
          SizedBox(height: AppSpacing.base),
          AchievementCard(content:context.l10n.achievement_content),
          SizedBox(height: AppSpacing.lg),
          _buildCard(
            isDark: isDark,
            image: isDark
                ? "assets/images/svg/progress_tracking/ic_dark_consistency_flow.svg"
                : "assets/images/svg/progress_tracking/ic_consistency_flow.svg",
            title: context.l10n.achievement_consistency_title,
            subtitle: context.l10n.achievement_consistency_subtitle
          ),
          SizedBox(height: AppSpacing.md),
          _buildCard(
            isDark: isDark,
            image: isDark
                ? "assets/images/svg/progress_tracking/ic_dark_foundation_builder.svg"
                : "assets/images/svg/progress_tracking/ic_foundation_builder.svg",
            title: context.l10n.achievement_foundation_title,
            subtitle: context.l10n.achievement_foundation_subtitle,
          ),
          SizedBox(height: AppSpacing.md),
          _buildCard(
            isDark: isDark,
            image: isDark
                ? "assets/images/svg/progress_tracking/ic_dark_monthly_dedication.svg"
                : "assets/images/svg/progress_tracking/ic_monthly_dedication.svg",
            title: context.l10n.achievement_monthly_title,
            subtitle: context.l10n.achievement_monthly_subtitle,
            isShowProgress: true,
          ),
          Spacer(),
          AppButton(
            label: context.l10n.achievement_view_all_button,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => YourJourneyView()),
              );
            },
            variant: AppButtonVariant.primary,
          ),
        ],
      ),
    );
  }

  _buildCard({
    required bool isDark,
    required String image,
    required String title,
    required String subtitle,
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
        crossAxisAlignment: isShowProgress
            ? CrossAxisAlignment.start
            : CrossAxisAlignment.center,
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
                      AppTextStyles.bodyText(context).copyWith(height: 1),
                ),

                Visibility(
                  visible: isShowProgress,
                  child: Padding(
                    padding: EdgeInsets.only(top: AppSpacing.base),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(AppRadius.sm),
                      child: LinearProgressIndicator(
                        value: 0.6,
                        minHeight: 6,
                        backgroundColor: isDark
                            ? AppColors.primaryDarkButton
                            : AppColors.goalTrackColor,
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
          ),
        ],
      ),
    );
  }
}
