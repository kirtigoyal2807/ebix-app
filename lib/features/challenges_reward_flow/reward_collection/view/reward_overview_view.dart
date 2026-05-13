import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import 'package:pilates_app/config/theme/app_colors.dart';
import 'package:pilates_app/config/theme/app_radius.dart';
import 'package:pilates_app/config/theme/app_spacing.dart';
import 'package:pilates_app/config/theme/app_text_styles.dart';
import 'package:pilates_app/core/localization/arb/app_localizations.dart';
import 'package:pilates_app/core/localization/localization_extension.dart';
import 'package:pilates_app/features/loyalty/data/models/loyalty_points_history_entry.dart';
import 'package:pilates_app/features/loyalty/data/models/loyalty_tier.dart';
import 'package:pilates_app/widgets/app_text.dart';

import '../cubit/loyalty_tiers_cubit.dart';
import '../cubit/loyalty_tiers_state.dart';
import '../cubit/reward_cubit.dart';
import '../cubit/reward_state.dart';
import '../widget/filter_tab_widget.dart';
import '../widget/reward_card.dart';
import '../widget/select_branch_sheet.dart';
import '../widget/sliver_benefit_card.dart';

int? _newestBalanceAfter(List<LoyaltyPointsHistoryEntry> entries) {
  if (entries.isEmpty) return null;
  int order(LoyaltyPointsHistoryEntry e) {
    final parsed = DateTime.tryParse(e.createdAt ?? '');
    if (parsed != null) return parsed.millisecondsSinceEpoch;
    final processed = DateTime.tryParse(e.processedAt ?? '');
    return processed?.millisecondsSinceEpoch ?? 0;
  }
  final sorted = [...entries]..sort((a, b) => order(b).compareTo(order(a)));
  return sorted.first.balanceAfter;
}

LoyaltyTier? _tierAfterSorted(List<LoyaltyTier> sorted, LoyaltyTier? current) {
  if (current == null || current.id.isEmpty) return null;
  final i = sorted.indexWhere((t) => t.id == current.id);
  if (i < 0 || i + 1 >= sorted.length) return null;
  return sorted[i + 1];
}

double? _tierRangeProgressFraction({
  required int balance,
  required LoyaltyTier current,
  required LoyaltyTier? nextTier,
}) {
  final lo = current.pointsMin;
  final hi = nextTier?.pointsMin;
  if (lo == null || hi == null || hi <= lo) return null;
  return ((balance - lo) / (hi - lo)).clamp(0.0, 1.0);
}

class RewardOverviewView extends StatelessWidget {
  const RewardOverviewView({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsetsGeometry.symmetric(vertical: AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _BuildCard(context: context),
            SizedBox(height: AppSpacing.xl),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg),
              child:
              BlocBuilder<LoyaltyTiersCubit, LoyaltyTiersState>(
                buildWhen: (p, c) => p.tiers != c.tiers || p.status != c.status,
                builder: (context, tState) {
                  LoyaltyTier? current;
                  for (final t in tState.tiers) {
                    if (t.isCurrent) {
                      current = t;
                      break;
                    }
                  }
                  final name = current?.name.trim() ?? '';
                  final heading = name.isEmpty
                      ? context.l10n.your_silver_benefits
                      : AppLocalizations.of(
                    context,
                  ).memberTierBenefits(name);
                  return AppText(
                    heading,
                    style: (context) => AppTextStyles.gelasioRegular(context),
                  );
                },
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
            SizedBox(height: AppSpacing.lg),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg),
              child: AppText(
                context.l10n.available_rewards,
                style: (context) => AppTextStyles.gelasioRegular(context),
              ),
            ),
            SizedBox(height: AppSpacing.md),
            BlocBuilder<RewardCubit, RewardState>(
              buildWhen: (p, c) =>
              p.rewardsLoadStatus != c.rewardsLoadStatus ||
                  p.filteredRewards != c.filteredRewards ||
                  p.rewardsError != c.rewardsError ||
                  p.selectedRewardFilter != c.selectedRewardFilter ||
                  p.selectedBranch != c.selectedBranch,
              builder: (context, state) {
                switch (state.rewardsLoadStatus) {
                  case RewardListLoadStatus.initial:
                  case RewardListLoadStatus.loading:
                    return Padding(
                      padding: EdgeInsets.symmetric(vertical: AppSpacing.xl),
                      child: Center(child: CircularProgressIndicator()),
                    );
                  case RewardListLoadStatus.failure:
                    return Padding(
                      padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AppText(
                            state.rewardsError.isNotEmpty
                                ? state.rewardsError
                                : context.l10n.loginErrorGeneric,
                            style: (context) =>
                                AppTextStyles.bodyLightText(context),
                          ),
                          TextButton(
                            onPressed: () =>
                                context.read<RewardCubit>().loadRewards(),
                            child: AppText(
                              context.l10n.retry,
                              style: (c) => AppTextStyles.button(c),
                            ),
                          ),
                        ],
                      ),
                    );
                  case RewardListLoadStatus.loaded:
                    final list = state.filteredRewards;
                    if (list.isEmpty) {
                      return Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: AppSpacing.lg,
                        ),
                        child: AppText(
                          context.l10n.rewardsCatalogSubtitle,
                          style: (context) =>
                              AppTextStyles.bodyLightText(context),
                        ),
                      );
                    }
                    return Column(
                      children: [
                        for (var i = 0; i < list.length; i++) ...[
                          if (i > 0) SizedBox(height: AppSpacing.md),
                          RewardCard(reward: list[i]),
                        ],
                      ],
                    );
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _BuildCard({required BuildContext context}) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final locale = Localizations.localeOf(context).toLanguageTag();
    final numberFormat = NumberFormat.decimalPattern(locale);

    Widget balanceBlock(RewardState rewardState) {
      switch (rewardState.historyLoadStatus) {
        case RewardListLoadStatus.initial:
        case RewardListLoadStatus.loading:
          return SizedBox(
            height: 48,
            width: 48,
            child: CircularProgressIndicator.adaptive(
              strokeWidth: 3,
              valueColor: AlwaysStoppedAnimation(
                isDark
                    ? AppColors.subscriptionCardGradient2
                    : AppColors.languageIcon,
              ),
            ),
          );
        case RewardListLoadStatus.failure:
          return AppText(
            '—',
            style: (c) =>
                AppTextStyles.appBarText(c).copyWith(fontSize: 40),
          );
        case RewardListLoadStatus.loaded:
          final bal = _newestBalanceAfter(rewardState.pointsHistory) ?? 0;
          return AppText(
            numberFormat.format(bal),
            style: (c) =>
                AppTextStyles.appBarText(c).copyWith(fontSize: 40),
          );
      }
    }

    return BlocBuilder<RewardCubit, RewardState>(
      buildWhen: (p, c) =>
      p.pointsHistory != c.pointsHistory ||
          p.historyLoadStatus != c.historyLoadStatus,
      builder: (context, rewardState) {
        return BlocBuilder<LoyaltyTiersCubit, LoyaltyTiersState>(
          buildWhen: (p, c) => p.tiers != c.tiers || p.status != c.status,
          builder: (context, tiersState) {
            final tiers = tiersState.tiers;

            LoyaltyTier? current;
            for (final t in tiers) {
              if (t.isCurrent) {
                current = t;
                break;
              }
            }

            final next = _tierAfterSorted(tiers, current);
            final balance =
                _newestBalanceAfter(rewardState.pointsHistory) ?? 0;
            double? frac;
            if (current != null) {
              frac = _tierRangeProgressFraction(
                balance: balance,
                current: current,
                nextTier: next,
              );
            }

            final ptsRemain = current?.pointsToNext;
            final showPtsRow =
                ptsRemain != null &&
                    ptsRemain > 0 &&
                    !tiers.isEmpty &&
                    tiersState.status == LoyaltyTiersLoadStatus.loaded;
            final nextName = next?.name.trim();
            final progressLabel =
            nextName != null && nextName.isNotEmpty
                ? '${context.l10n.progress_to_gold}: $nextName'
                : context.l10n.progress_to_gold;

            return Container(
              margin: EdgeInsets.symmetric(horizontal: AppSpacing.lg),
              padding: EdgeInsets.symmetric(
                vertical: AppSpacing.lmd,
                horizontal: AppSpacing.lg,
              ),
              decoration: BoxDecoration(
                color: isDark
                    ? AppColors.primaryDarkButton
                    : AppColors.seekBarLight,
                borderRadius: BorderRadius.circular(AppRadius.md),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppText(
                    context.l10n.your_balance,
                    style: (c) => AppTextStyles.bodyText(c),
                  ),
                  SizedBox(height: 2),
                  balanceBlock(rewardState),
                  SizedBox(height: AppSpacing.lg),
                  AppText(
                    context.l10n.current_tier,
                    style: (c) =>
                        AppTextStyles.bodyText(c).copyWith(fontSize: 12),
                  ),
                  SizedBox(height: 2),
                  if (tiersState.status ==
                      LoyaltyTiersLoadStatus.loading &&
                      tiers.isEmpty)
                    Padding(
                      padding: EdgeInsets.only(top: AppSpacing.sm),
                      child: SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator.adaptive(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation(
                            isDark
                                ? AppColors.subscriptionCardGradient2
                                : AppColors.languageIcon,
                          ),
                        ),
                      ),
                    )
                  else
                    AppText(
                      current?.name.trim().isNotEmpty == true
                          ? current!.name.trim()
                          : AppLocalizations.of(
                        context,
                      ).contentNoDataAvailable,
                      style: (c) =>
                          AppTextStyles.textFieldHeading(c).copyWith(),
                    ),
                  SizedBox(height: AppSpacing.lg),
                  if (showPtsRow) ...[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        AppText(
                          progressLabel,
                          style: (c) =>
                              AppTextStyles.experienceButton(c).copyWith(),
                        ),
                        AppText(
                          context.l10n.points_to_go(ptsRemain),
                          style: (c) =>
                              AppTextStyles.experienceButton(c).copyWith(
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
                        value: frac,
                        minHeight: 6,
                        backgroundColor: isDark
                            ? const Color(0xff1C1917)
                            : AppColors.darkGreyBorder,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          isDark
                              ? AppColors.subscriptionCardGradient2
                              : AppColors.languageIcon,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            );
          },
        );
      },
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
                  BlocBuilder<RewardCubit, RewardState>(
                    buildWhen: (p, c) =>
                    p.selectedBranch != c.selectedBranch ||
                        p.branchList != c.branchList,
                    builder: (context, state) {
                      final branch = state.branchList.isNotEmpty
                          ? state.branchList[state.selectedBranch.clamp(
                        0,
                        state.branchList.length - 1,
                      )]
                          : null;
                      final title = branch == null
                          ? ''
                          : branch.id == 0
                          ? context.l10n.rewards_all_locations_title
                          : branch.title;
                      return AppText(
                        title,
                        maxLines: 2,
                        style: (context) => AppTextStyles.textFieldHeading(
                          context,
                        ).copyWith(height: 1.55, fontSize: 16),
                      );
                    },
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
