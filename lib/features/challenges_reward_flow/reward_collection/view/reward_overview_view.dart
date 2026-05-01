import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pilates_app/config/theme/app_colors.dart';
import 'package:pilates_app/config/theme/app_radius.dart';
import 'package:pilates_app/config/theme/app_spacing.dart';
import 'package:pilates_app/config/theme/app_text_styles.dart';
import 'package:pilates_app/core/localization/localization_extension.dart';
import 'package:pilates_app/widgets/app_text.dart';

import '../cubit/reward_cubit.dart';
import '../widget/filter_tab_widget.dart';
import '../widget/reward_card.dart';
import '../widget/select_branch_sheet.dart';
import '../widget/sliver_benefit_card.dart';

class RewardOverviewView extends StatelessWidget {
  const RewardOverviewView({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsetsGeometry.symmetric(
          vertical: AppSpacing.lg,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _BuildCard(context: context),
            SizedBox(height: AppSpacing.xl),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg),
              child: AppText(
                context.l10n.your_silver_benefits,
                style: (context) => AppTextStyles.gelasioRegular(context),
              ),
            ),
            SizedBox(height: AppSpacing.md),
            SliverBenefitCard(),
            SizedBox(height: AppSpacing.lg),
            Divider(
              color: isDark ? AppColors.greyText : AppColors.buttonBorder,
              height: 1,
            ),
            SizedBox(height: AppSpacing.lg),
            _currentBranch(context: context, cubitContext: context),
            SizedBox(height: AppSpacing.md),
            FilterTabButton(),
            SizedBox(height: AppSpacing.lmd),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg),
              child: AppText(
                context.l10n.available_rewards,
                style: (context) => AppTextStyles.gelasioRegular(context),
              ),
            ),
            SizedBox(height: AppSpacing.md),
            RewardCard(
              title: context.l10n.priority_booking_week,
              subTitle: context.l10n.priority_booking_desc,
              point: 200,
            ),
            SizedBox(height: AppSpacing.md),
            RewardCard(
              title: context.l10n.exclusive_workshop,
              subTitle: context.l10n.exclusive_workshop_desc,
              point: 400,
            ),
            SizedBox(height: AppSpacing.md),
            RewardCard(
              title: context.l10n.guest_pass_3,
              subTitle: context.l10n.guest_pass_desc,
              point: 350,
            ),
            SizedBox(height: AppSpacing.md),
            RewardCard(
              title: context.l10n.meditation_session,
              subTitle: context.l10n.meditation_session_desc,
              point: 300,
            ),
          ],
        ),
      ),
    );
  }

  Widget _BuildCard({required BuildContext context}) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      margin: EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      padding: EdgeInsets.symmetric(
        vertical: AppSpacing.lmd,
        horizontal: AppSpacing.lg,
      ),
      decoration: BoxDecoration(
        color: isDark ? AppColors.primaryDarkButton : AppColors.seekBarLight,
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppText(
            context.l10n.your_balance,
            style: (context) => AppTextStyles.bodyText(context),
          ),
          SizedBox(height: 2),
          AppText(
            "1,440",
            style: (context) =>
                AppTextStyles.appBarText(context).copyWith(fontSize: 40),
          ),
          SizedBox(height: AppSpacing.lg),
          AppText(
            context.l10n.current_tier,
            style: (context) =>
                AppTextStyles.bodyText(context).copyWith(fontSize: 12),
          ),
          SizedBox(height: 2),
          AppText(
            context.l10n.silver_member,
            style: (context) =>
                AppTextStyles.textFieldHeading(context).copyWith(),
          ),
          SizedBox(height: AppSpacing.lg),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AppText(
                context.l10n.progress_to_gold,
                style: (context) =>
                    AppTextStyles.experienceButton(context).copyWith(),
              ),
              AppText(
                context.l10n.points_to_go(750),
                style: (context) =>
                    AppTextStyles.experienceButton(context).copyWith(
                      color: isDark
                          ? AppColors.languageTextDark
                          : AppColors.languageIcon,
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
                  ? Color(0xff1C1917)
                  : AppColors.darkGreyBorder,
              valueColor: AlwaysStoppedAnimation<Color>(
                isDark
                    ? AppColors.subscriptionCardGradient2
                    : AppColors.languageIcon,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _currentBranch({
    required BuildContext context,
    required BuildContext cubitContext,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      margin: EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      padding: EdgeInsets.symmetric(
        vertical: AppSpacing.lmd,
        horizontal: AppSpacing.lmd,
      ),
      decoration: BoxDecoration(
        color: isDark ? AppColors.homeBackground : AppColors.whiteColor,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(
          color: isDark ? AppColors.greyText : AppColors.buttonBorder,
          width: 1,
        ),
      ),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(Icons.home_outlined, color: AppColors.languageIcon, size: 24),
            SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppText(
                    context.l10n.showing_rewards_from,
                    style: (context) => AppTextStyles.textFieldHeading(
                      context,
                    ).copyWith(color: AppColors.placeHolderText),
                  ),
                  SizedBox(height: AppSpacing.xs),
                  AppText(
                    "Branch 1",
                    style: (context) => AppTextStyles.textFieldHeading(
                      context,
                    ).copyWith(height: 1.55, fontSize: 16),
                  ),
                ],
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: GestureDetector(
                onTap: () {
                  final rewardCubit = context.read<RewardCubit>();
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    barrierColor: AppColors.bottomSheetShadow,
                    builder: (_) => BlocProvider.value(
                      value: rewardCubit,
                      child: SelectBranchSheet(),
                    ),
                  );
                },
                child: AppText(
                  context.l10n.change,
                  style: (context) => AppTextStyles.body(context)
                      .copyWith(height: 1.55)
                      .copyWith(color: AppColors.languageIcon),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
