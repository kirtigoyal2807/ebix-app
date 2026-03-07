import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pilates_app/config/theme/app_spacing.dart';
import 'package:pilates_app/config/theme/app_text_styles.dart';
import 'package:pilates_app/widgets/app_text.dart';

import '../../../../config/theme/app_colors.dart';
import '../../../../config/theme/app_radius.dart';
import '../../../../core/localization/localization_extension.dart';

class YourMindPractice extends StatelessWidget {
  const YourMindPractice({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          AppText(
            context.l10n.mind_practice_title,
            style: (context) => AppTextStyles.gelasioRegular(context),
          ),
          SizedBox(height: AppSpacing.md),
          Row(
            children: [
              Expanded(
                child: _buildCard(
                  isDark: isDark,
                  title: context.l10n.mind_practice_mindful_value,
                  subTitle: context.l10n.mind_practice_mindful_movement,
                  iconImage:
                      "assets/images/svg/progress_tracking/ic_mindful_movement.svg",
                ),
              ),

              SizedBox(width: AppSpacing.md),
              Expanded(
                child: _buildCard(
                  isDark: isDark,
                  title: "5",
                  subTitle: context.l10n.mind_practice_morning_sessions,
                  iconImage:
                      "assets/images/svg/progress_tracking/ic_morning_sessions.svg",
                ),
              ),
            ],
          ),
          SizedBox(height: AppSpacing.md),
          Row(
            children: [
              Expanded(
                child: _buildCard(
                  isDark: isDark,
                  title: "4",
                  subTitle: context.l10n.mind_practice_flow_instructors,
                  iconImage:
                      "assets/images/svg/progress_tracking/ic_flow_instructors.svg",
                ),
              ),

              SizedBox(width: AppSpacing.md),
              Expanded(
                child: _buildCard(
                  isDark: isDark,
                  title: "+25%",
                  subTitle: context.l10n.mind_practice_inner_peace,
                  iconImage:
                      "assets/images/svg/progress_tracking/ic_inner_peace.svg",
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  _buildCard({
    required bool isDark,
    required String iconImage,
    required String title,
    required String subTitle,
  }) {
    return Container(
      padding: EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: isDark ? AppColors.homeBackground : AppColors.whiteColor,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(
          color: isDark ? AppColors.greyText : AppColors.buttonBorder,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SvgPicture.asset(
            iconImage,
            height: 32,
            width: 32,
            color: isDark ? AppColors.languageIconDark : AppColors.languageIcon,
          ),

          SizedBox(height: AppSpacing.lg),
          AppText(
            title,
            style: (context) => AppTextStyles.appBarTitle(context),
          ),
          SizedBox(height: AppSpacing.sm),
          AppText(
            subTitle.replaceFirst(' ', '\n'),
            style: (context) => AppTextStyles.bodyTextSmall(context).copyWith(height: 1.2),
          ),
        ],
      ),
    );
  }
}
