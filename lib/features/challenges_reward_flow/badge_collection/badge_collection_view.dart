import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pilates_app/config/theme/app_spacing.dart';
import 'package:pilates_app/core/localization/localization_extension.dart';
import 'package:pilates_app/features/challenges_reward_flow/badge_collection/widget/badge_card.dart';
import 'package:pilates_app/features/challenges_reward_flow/badge_collection/widget/filter_button.dart';
import 'package:pilates_app/widgets/app_app_bar.dart';

import '../../../config/theme/app_colors.dart';
import '../../../config/theme/app_radius.dart';
import '../../../config/theme/app_text_styles.dart';
import '../../../widgets/app_text.dart';
import 'cubit/badge_cubit.dart';
import 'cubit/badge_state.dart';
import 'model/badge_model.dart';

class BadgeCollectionView extends StatelessWidget {
  const BadgeCollectionView({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return BlocProvider(
      create: (context) => BadgeCubit(),
      child: Scaffold(
        appBar: AppAppBar(
          title: context.l10n.badge_collection,
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
                BlocBuilder<BadgeCubit, BadgeState>(
                  buildWhen: (p, c) => p.badgeDataList != c.badgeDataList,
                  builder: (context, badgeState) {
                    final earned = badgeState.badgeDataList
                        .where((b) => b.status == BadgeStatus.earned)
                        .length;
                    final value = earned.toString();
                    return Row(
                      children: [
                        Expanded(
                          child: _totalCard(
                            label: context.l10n.badge_bronze,
                            value: value,
                            isDark: isDark,
                          ),
                        ),
                        SizedBox(width: AppSpacing.md),
                        Expanded(
                          child: _totalCard(
                            label: context.l10n.badge_silver,
                            value: value,
                            isDark: isDark,
                          ),
                        ),
                        SizedBox(width: AppSpacing.md),
                        Expanded(
                          child: _totalCard(
                            label: context.l10n.badge_gold,
                            value: value,
                            isDark: isDark,
                          ),
                        ),
                      ],
                    );
                  },
                ),
                SizedBox(height: AppSpacing.xl),
                FilterButton(),
                SizedBox(height: AppSpacing.lg),
                BadgeCard(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Container _totalCard({
    required String label,
    required String value,
    required bool isDark,
  }) {
    return Container(
      height: 83,
      decoration: BoxDecoration(
        color: isDark ? AppColors.homeBackground : Colors.white,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(
          color: isDark ? AppColors.greyText : AppColors.buttonBorder,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,

        children: [
          AppText(
            value,
            style: (context) => AppTextStyles.bottomSheetTitle(
              context,
            ).copyWith(fontWeight: FontWeight.w600, height: 1.55, fontSize: 24),
          ),
          SizedBox(height: 2),
          AppText(
            label,
            style: (context) => AppTextStyles.caption(
              context,
            ).copyWith(height: 1.55, fontSize: 12),
          ),
        ],
      ),
    );
  }
}
