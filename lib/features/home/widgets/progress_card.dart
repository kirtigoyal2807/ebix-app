import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pilates_app/config/theme/app_colors.dart';
import 'package:pilates_app/config/theme/app_radius.dart';
import 'package:pilates_app/config/theme/app_spacing.dart';
import 'package:pilates_app/config/theme/app_text_styles.dart';
import 'package:pilates_app/core/localization/localization_extension.dart';
import 'package:pilates_app/widgets/app_text.dart';
import '../cubit/home_state.dart';

class ProgressCard extends StatelessWidget {
  final HomeUserStatus status;
  final int classesDone;
  final double totalHours;
  final int goalClasses;

  const ProgressCard({
    super.key,
    required this.status,
    required this.classesDone,
    required this.totalHours,
    required this.goalClasses,
  });

  @override
  Widget build(BuildContext context) {
    if (status == HomeUserStatus.empty) {
      return _buildEmptyProgress(context);
    }
    return _buildActiveProgress(context);
  }

  Widget _buildEmptyProgress(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final size = MediaQuery.sizeOf(context);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      padding: EdgeInsets.all(size.width * 0.07),
      decoration: BoxDecoration(
        color: isDark ? AppColors.homeBackground : AppColors.whiteColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? AppColors.greyText : AppColors.buttonBorder,
        ),
      ),
      child: Column(
        children: [
          SizedBox(
            height: size.height * 0.06,
            child: SvgPicture.asset(
              isDark
                  ? 'assets/images/svg/ic_pirates_book_dark.svg'
                  : 'assets/images/svg/ic_pirates_book_light.svg',
              height: size.height * 0.06,
              // width: width * 0.6,
              fit: BoxFit.contain,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          AppText(
            context.l10n.startYourPilatesJourney,
            style: (context) => AppTextStyles.body(context).copyWith(
              color: isDark ? AppColors.lightText : AppColors.darkText,
              fontSize: 16,
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),

          const SizedBox(height: AppSpacing.xs),
          AppText(
            context.l10n.bookFirstClassDesc,
            style: AppTextStyles.bodyTextSmall,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: AppSpacing.lg),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.splashBackgroundDark,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppRadius.pillRadius),
              ),
              minimumSize: const Size(double.infinity, 48),
            ),
            child: AppText(
              context.l10n.bookYourFirstClass,
              style: (context) => AppTextStyles.button(context).copyWith(
                fontSize: size.width * 0.04 > 16 ? 16 : size.width * 0.04,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActiveProgress(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final size = MediaQuery.sizeOf(context);
    final progress = classesDone / goalClasses;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      padding: EdgeInsets.all(size.width * 0.05),
      decoration: BoxDecoration(
        color: isDark ? AppColors.homeBackground : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? AppColors.greyText : AppColors.buttonBorder,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SvgPicture.asset(
                isDark
                    ? 'assets/images/svg/ic_monthly_progress_dark.svg'
                    : 'assets/images/svg/ic_monthly_progress_light.svg',
                height: size.height * 0.06,
                fit: BoxFit.contain,
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: AppText(
                  context.l10n.monthlyProgress,
                  style: (context) => AppTextStyles.heading1(context).copyWith(
                    fontSize: size.width * 0.035 > 16 ? 16 : size.width * 0.035,
                  ),
                ),
              ),
               Icon(Icons.chevron_right, color: isDark ? AppColors.lightGrey:AppColors.darkGreyText, size: 24),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                child: _buildProgressStat(
                  context,
                  classesDone.toString(),
                  context.l10n.classes,
                ),
              ),
              Expanded(
                child: _buildProgressStat(
                  context,
                  '${totalHours} h',
                  context.l10n.totalTime,
                ),
              ),
              Expanded(
                child: _buildProgressStat(
                  context,
                  '${(progress * 100).toInt()}%',
                  context.l10n.goal,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          ClipRRect(
            borderRadius: BorderRadius.circular(AppRadius.pillRadius),
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: isDark ? AppColors.lightBlackColor: AppColors.darkGreyBorder,
              color: isDark ? AppColors.languageIconDark:AppColors.languageIcon,
              minHeight: 8,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          AppText(
            context.l10n.ofClassesThisMonth(goalClasses),
            style: (context) => AppTextStyles.helpAndSupportItemSubLabel(context).copyWith(
              fontSize: size.width * 0.03 > 14 ? 14 : size.width * 0.03,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressStat(BuildContext context, String value, String label) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final size = MediaQuery.sizeOf(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText(
          value,
          style: (context) => AppTextStyles.helpAndSupportItemLabel(context).copyWith(
            fontSize: size.width * 0.045 > 18 ? 18 : size.width * 0.045,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        AppText(
          label,
          style: (context) => AppTextStyles.captionText(
            context,
          ).copyWith(fontSize: size.width * 0.03 > 12 ? 12 : size.width * 0.03,
          color: isDark ? AppColors.arrowIcon:AppColors.greyText,fontWeight: FontWeight.w400),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}
