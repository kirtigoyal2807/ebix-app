import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pilates_app/config/theme/app_colors.dart';
import 'package:pilates_app/config/theme/app_radius.dart';
import 'package:pilates_app/config/theme/app_spacing.dart';
import 'package:pilates_app/config/theme/app_text_styles.dart';
import 'package:pilates_app/features/loyalty/data/models/loyalty_reward.dart';
import 'package:pilates_app/widgets/app_text.dart';

import '../../../../core/localization/localization_extension.dart';
import '../cubit/reward_cubit.dart';
import '../view/redeem_reward_view.dart';

class RewardCard extends StatelessWidget {
  const RewardCard({super.key, required this.reward});

  final LoyaltyReward reward;

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
            reward.name,
            style: (context) =>
                AppTextStyles.experienceButton(context).copyWith(height: 1.4),
          ),
          SizedBox(height: AppSpacing.xs),
          AppText(
            reward.description,
            style: (context) =>
                AppTextStyles.bodyLightText(context).copyWith(height: 1.4),
          ),
          SizedBox(height: AppSpacing.lmd),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              AppText(
                context.l10n.points_short(reward.pointsCost),
                style: (context) => AppTextStyles.boldBody(
                  context,
                ).copyWith(fontSize: 16, height: 1.55),
              ),
              GestureDetector(
                onTap: reward.canRedeem
                    ? () {
                        Navigator.push(
                          context,
                          MaterialPageRoute<void>(
                            builder: (ctx) => BlocProvider.value(
                              value: context.read<RewardCubit>(),
                              child: RedeemRewardView(reward: reward),
                            ),
                          ),
                        );
                      }
                    : null,
                child: Opacity(
                  opacity: reward.canRedeem ? 1 : 0.45,
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
              ),
            ],
          ),
        ],
      ),
    );
  }
}
