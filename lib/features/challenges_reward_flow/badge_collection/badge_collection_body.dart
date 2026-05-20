import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pilates_app/config/theme/app_spacing.dart';
import 'package:pilates_app/core/localization/localization_extension.dart';
import 'package:pilates_app/features/challenges_reward_flow/badge_collection/widget/badge_card.dart';
import 'package:pilates_app/features/challenges_reward_flow/badge_collection/widget/filter_button.dart';
import 'package:pilates_app/widgets/app_button.dart';
import 'package:pilates_app/widgets/app_text.dart';
import 'package:pilates_app/widgets/app_loading_indicator.dart';

import '../../../config/theme/app_colors.dart';
import '../../../config/theme/app_radius.dart';
import '../../../config/theme/app_text_styles.dart';
import 'cubit/badge_cubit.dart';
import 'cubit/badge_state.dart';

class BadgeCollectionBody extends StatelessWidget {
  const BadgeCollectionBody({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return BlocBuilder<BadgeCubit, BadgeState>(
      buildWhen: (p, c) =>
          p.status != c.status ||
          p.badges != c.badges ||
          p.selectedBadgeTypeKey != c.selectedBadgeTypeKey ||
          p.errorMessage != c.errorMessage,
      builder: (context, state) {
        return RefreshIndicator(
          onRefresh: () => context.read<BadgeCubit>().refresh(),
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: EdgeInsetsGeometry.symmetric(
              vertical: AppSpacing.md,
              horizontal: AppSpacing.lg,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if ((state.status == BadgeCollectionStatus.initial ||
                        state.status == BadgeCollectionStatus.loading) &&
                    state.badges.isEmpty)
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: AppSpacing.xxl),
                    child: const AppLoadingIndicator(),
                  )
                else ...[
                  Row(
                    children: [
                      Expanded(
                        child: _statCard(
                          value: '${state.earnedCount}',
                          label: context.l10n.earned,
                          isDark: isDark,
                        ),
                      ),
                      SizedBox(width: AppSpacing.md),
                      Expanded(
                        child: _statCard(
                          value: '${state.lockedCount}',
                          label: context.l10n.locked,
                          isDark: isDark,
                        ),
                      ),
                      SizedBox(width: AppSpacing.md),
                      Expanded(
                        child: _statCard(
                          value: '${state.totalCount}',
                          label: context.l10n.total,
                          isDark: isDark,
                        ),
                      ),
                    ],
                  ),
                  if (state.status == BadgeCollectionStatus.failure &&
                      state.errorMessage != null &&
                      state.errorMessage!.isNotEmpty) ...[
                    SizedBox(height: AppSpacing.md),
                    AppText(
                      state.errorMessage!,
                      style: (c) =>
                          AppTextStyles.bodyLightText(c).copyWith(height: 1.4),
                    ),
                    SizedBox(height: AppSpacing.sm),
                    AppButton(
                      label: context.l10n.retry,
                      expanded: false,
                      onPressed: () => context.read<BadgeCubit>().load(),
                    ),
                  ],
                  SizedBox(height: AppSpacing.xl),
                  const FilterButton(),
                  SizedBox(height: AppSpacing.lg),
                  const BadgeCard(),
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _statCard({
    required String value,
    required String label,
    required bool isDark,
  }) {
    return AspectRatio(
      aspectRatio: 1.1,
      child: Container(
        decoration: BoxDecoration(
          color: isDark ? Colors.transparent : AppColors.whiteColor,
          borderRadius: BorderRadius.circular(AppRadius.base),
          border: Border.all(
            color: isDark ? AppColors.greyText : AppColors.buttonBorder,
            width: 1,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AppText(
              value,
              style: (ctx) => AppTextStyles.bottomSheetTitle(ctx).copyWith(
                fontWeight: FontWeight.w600,
                fontSize: 24,
                height: 1,
                color: isDark ? AppColors.lightText : AppColors.darkText,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: AppSpacing.sm),
            AppText(
              label,
              style: (ctx) => AppTextStyles.captionText(ctx).copyWith(
                fontSize: 12,
                height: 1.2,
                fontWeight: FontWeight.w400,
                color: isDark ? AppColors.darkGreyText : AppColors.lightGrey,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
