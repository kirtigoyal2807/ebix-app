import 'package:flutter/material.dart';
import 'package:pilates_app/config/theme/app_spacing.dart';
import 'package:pilates_app/config/theme/app_text_styles.dart';
import 'package:pilates_app/widgets/app_text.dart';

import '../../../../core/localization/localization_extension.dart';
import '../widget/reward_history_card.dart';

class RewardHistoryView extends StatelessWidget {
  const RewardHistoryView({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsetsGeometry.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppText(
            context.l10n.rewards_history,
            style: (context) => AppTextStyles.gelasioRegular(context),
          ),
          SizedBox(height: AppSpacing.md),
          RewardHistoryCard(
            title: context.l10n.studio_water_bottle,
            subTitle: context.l10n.redeemed_on("Feb 8, 2026"),
            point: 300,
          ),
          SizedBox(height: AppSpacing.md),
          RewardHistoryCard(
            title: context.l10n.free_class_pass,
            subTitle: context.l10n.redeemed_on("Jan 22, 2026"),
            point: 2300,
          ),
          SizedBox(height: AppSpacing.md),
          RewardHistoryCard(
            title: context.l10n.studio_water_bottle,
            subTitle: context.l10n.redeemed_on("Feb 8, 2026"),
            point: 300,
          ),
          SizedBox(height: AppSpacing.md),
          RewardHistoryCard(
            title: context.l10n.free_class_pass,
            subTitle: context.l10n.redeemed_on("Jan 22, 2026"),
            point: 200,
          ),
        ],
      ),
    );
  }
}
