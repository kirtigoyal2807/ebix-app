import 'package:flutter/material.dart';
import 'package:pilates_app/config/theme/app_colors.dart';
import 'package:pilates_app/config/theme/app_radius.dart';
import 'package:pilates_app/config/theme/app_spacing.dart';
import 'package:pilates_app/config/theme/app_text_styles.dart';
import 'package:pilates_app/widgets/app_text.dart';

import '../../../../core/localization/localization_extension.dart';
import '../view/redeem_reward_view.dart';

class RewardCard extends StatelessWidget {
  final String title;
  final String subTitle;
  final int point;

  const RewardCard({
    super.key,
    required this.title,
    required this.subTitle,
    required this.point,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      margin: EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      padding: EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: isDark ? AppColors.homeBackground : AppColors.whiteColor,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(
          color: isDark ? AppColors.greyText : AppColors.buttonBorder,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppText(
            title,
            style: (context) => AppTextStyles.experienceButton(context).copyWith(height: 1.4),
          ),
          SizedBox(height: AppSpacing.xs),
          AppText(
            subTitle,
            style: (context) => AppTextStyles.bodyLightText(context).copyWith(height: 1.4),
          ),
          SizedBox(height: AppSpacing.lmd),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              AppText(
          context.l10n.points_short(point),
                style: (context) => AppTextStyles.boldBody(
                  context,
                ).copyWith(fontSize: 16, height: 1.55),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => RedeemRewardView()),
                  );
                },
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: AppSpacing.md,
                    vertical: 6.5,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.splashBackgroundDark,
                    borderRadius: BorderRadius.circular(AppRadius.lg),
                    boxShadow: [
                      BoxShadow(
                        color: Color(0xff0D0D12).withValues(alpha: 0.04),
                        offset: const Offset(0, 1),
                        blurRadius: 2,
                        spreadRadius: 0,
                      ),
                    ],
                  ),
                  child: AppText(
                    context.l10n.reward_redeem,
                    style: (context) =>
                        AppTextStyles.button(context).copyWith(fontSize: 12),
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
