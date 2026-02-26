import 'package:flutter/material.dart';
import 'package:pilates_app/config/theme/app_colors.dart';
import 'package:pilates_app/config/theme/app_radius.dart';
import 'package:pilates_app/config/theme/app_spacing.dart';
import 'package:pilates_app/config/theme/app_text_styles.dart';
import 'package:pilates_app/core/localization/localization_extension.dart';
import 'package:pilates_app/widgets/app_text.dart';

import '../../../../widgets/app_app_bar.dart';
import '../../../../widgets/dotted_underline.dart';
import '../widget/challenges_benefit.dart';
import '../widget/challenges_detail_card.dart';
import '../widget/score_card.dart';

class ChallengesDetailView extends StatelessWidget {
  const ChallengesDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: AppAppBar(
        title: context.l10n.challenge_detail,
        onBack: () => Navigator.of(context).pop(),
        isMoreMenu: false,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsetsGeometry.symmetric(
            vertical: AppSpacing.md,
            horizontal: AppSpacing.lg,
          ),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ChallengesDetailCard(
                imageIcon: isDark
                    ? "assets/images/svg/challenges/ic_dark_classes.svg"
                    : "assets/images/svg/challenges/ic_classes.svg",
                title: context.l10n.twenty_classes_month,
                subtitle: context.l10n.complete_classes_feb,
                days: 15,
                point: 500,
              ),
              SizedBox(height: AppSpacing.xl),
              AppText(
                context.l10n.your_progress,
                style: (context) => AppTextStyles.gelasioRegular(context),
              ),
              SizedBox(height: AppSpacing.md),
              _progressCard(context: context),
              SizedBox(height: AppSpacing.xl),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  AppText(
                    context.l10n.leaderboard,
                    style: (context) => AppTextStyles.gelasioRegular(context),
                  ),
                  AppText(
                    context.l10n.seeAll,
                    style: (context) => AppTextStyles.body(context),
                  ),
                ],
              ),
              SizedBox(height: AppSpacing.md),
              ScoreCard(
                index: 1,
                sortName: "JD",
                name: "Jessica Davis",
                attendedClasses: "20/20",
              ),
              SizedBox(height: AppSpacing.base),
              ScoreCard(
                index: 2,
                sortName: "SL",
                name: "Sarah Lee",
                attendedClasses: "18/20",
              ),
              SizedBox(height: AppSpacing.base),
              ScoreCard(
                index: 3,
                sortName: "TK",
                name: "Teressa Khaled",
                attendedClasses: "17/20",
              ),
              SizedBox(height: AppSpacing.base),
              SizedBox(
                width: double.infinity,
                child: CustomPaint(
                  painter: DashedUnderlinePainter(
                    color: isDark
                        ? AppColors.greyText
                        : AppColors.darkGreyBorder,
                    dashWidth: 3,
                    dashSpace: 3,
                  ),
                ),
              ),
              SizedBox(height: AppSpacing.base),
              ScoreCard(
                index: 18,
                sortName: "YU",
                name: "You",
                attendedClasses: "8/20",
              ),

              SizedBox(height: AppSpacing.xl),
              AppText(
                context.l10n.rewards,
                style: (context) => AppTextStyles.gelasioRegular(context),
              ),
              SizedBox(height: AppSpacing.md),
              ChallengesBenefit(),
            ],
          ),
        ),
      ),
    );
  }

  _progressCard({required BuildContext context}) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: AppSpacing.lmd,
        horizontal: AppSpacing.lg,
      ),
      decoration: BoxDecoration(
        color: isDark ? AppColors.primaryDarkButton : AppColors.seekBarLight,
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          AppText(
            '8 / 20',
            style: (context) => AppTextStyles.appBarText(
              context,
            ).copyWith(fontSize: 32, height: 1.2),
          ),
          SizedBox(height: AppSpacing.xs),
          AppText(
            context.l10n.classes_completed,
            style: (context) =>
                AppTextStyles.bodyText(context).copyWith(height: 1),
          ),
          SizedBox(height: AppSpacing.lg),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AppText(
                context.l10n.percent_complete(40),
                style: (context) =>
                    AppTextStyles.bodyLightText(context).copyWith(
                      color: isDark
                          ? AppColors.darkGreyText
                          : AppColors.lightGrey,
                    ),
              ),
              AppText(
                context.l10n.more_classes_to_go(12),
                style: (context) => AppTextStyles.boldBody(context),
              ),
            ],
          ),
          SizedBox(height: AppSpacing.md),
          ClipRRect(
            borderRadius: BorderRadius.circular(AppRadius.sm),
            child: LinearProgressIndicator(
              value: 0.6,
              minHeight: 6,
              backgroundColor: isDark
                  ? Color(0xff1C1917)
                  : AppColors.darkGreyBorder,
              valueColor: AlwaysStoppedAnimation<Color>(
                isDark ? AppColors.languageIconDark : AppColors.languageIcon,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
