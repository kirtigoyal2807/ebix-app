import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pilates_app/config/theme/app_colors.dart';
import 'package:pilates_app/config/theme/app_radius.dart';
import 'package:pilates_app/config/theme/app_spacing.dart';
import 'package:pilates_app/config/theme/app_text_styles.dart';
import 'package:pilates_app/core/localization/localization_extension.dart';
import 'package:pilates_app/features/challenges_reward_flow/reward_collection/cubit/loyalty_tiers_cubit.dart';
import 'package:pilates_app/features/challenges_reward_flow/reward_collection/cubit/loyalty_tiers_state.dart';
import 'package:pilates_app/features/loyalty/data/loyalty_repository.dart';
import 'package:pilates_app/features/loyalty/data/models/loyalty_tier.dart';
import 'package:pilates_app/widgets/app_app_bar.dart';
import 'package:pilates_app/widgets/app_text.dart';

/// Loyalty tier catalog from [LoyaltyRepository.getTiers] (`GET loyalty/tiers`).
class LoyaltyTiersView extends StatelessWidget {
  const LoyaltyTiersView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          LoyaltyTiersCubit(context.read<LoyaltyRepository>())..load(),
      child: const _LoyaltyTiersScaffold(),
    );
  }
}

class _LoyaltyTiersScaffold extends StatelessWidget {
  const _LoyaltyTiersScaffold();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppAppBar(
        title: context.l10n.viewAllTiers,
        onBack: () => Navigator.of(context).pop(),
        isMoreMenu: false,
      ),
      body: BlocBuilder<LoyaltyTiersCubit, LoyaltyTiersState>(
        builder: (context, state) {
          switch (state.status) {
            case LoyaltyTiersLoadStatus.initial:
            case LoyaltyTiersLoadStatus.loading:
              return const Center(child: CircularProgressIndicator());
            case LoyaltyTiersLoadStatus.failure:
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      AppText(
                        state.errorMessage.isNotEmpty
                            ? state.errorMessage
                            : context.l10n.loginErrorGeneric,
                        textAlign: TextAlign.center,
                        style: (c) => AppTextStyles.bodyLightText(c),
                      ),
                      TextButton(
                        onPressed: () =>
                            context.read<LoyaltyTiersCubit>().load(),
                        child: AppText(
                          context.l10n.retry,
                          style: (c) => AppTextStyles.button(c),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            case LoyaltyTiersLoadStatus.loaded:
              if (state.tiers.isEmpty) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(AppSpacing.lg),
                    child: AppText(
                      context.l10n.rewardsCatalogSubtitle,
                      textAlign: TextAlign.center,
                      style: (c) => AppTextStyles.bodyLightText(c),
                    ),
                  ),
                );
              }
              final isDark = Theme.of(context).brightness == Brightness.dark;
              return ListView.separated(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.lg,
                  vertical: AppSpacing.md,
                ),
                itemCount: state.tiers.length,
                separatorBuilder: (_, __) => SizedBox(height: AppSpacing.lg),
                itemBuilder: (context, i) {
                  return _TierSection(isDark: isDark, tier: state.tiers[i]);
                },
              );
          }
        },
      ),
    );
  }
}

class _TierSection extends StatelessWidget {
  const _TierSection({required this.isDark, required this.tier});

  final bool isDark;
  final LoyaltyTier tier;

  String _introText() {
    final parts = <String>[];
    final d = tier.description.trim();
    if (d.isNotEmpty) parts.add(d);
    final pts = _pointsRangeLabel();
    if (pts != null) parts.add(pts);
    if (parts.isEmpty) return '';
    return parts.join('\n\n');
  }

  String? _pointsRangeLabel() {
    final next = tier.pointsToNext;
    if (next != null && next > 0) {
      return '$next pts to next tier';
    }
    if (tier.pointsMin != null && tier.pointsMax != null) {
      return '${tier.pointsMin} – ${tier.pointsMax} pts';
    }
    if (tier.pointsMin != null) {
      final min = tier.pointsMin!;
      if (min <= 0) return null;
      return '$min+ pts';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final intro = _introText();
    final benefits = tier.benefits
        .where(
          (b) => b.title.trim().isNotEmpty || b.description.trim().isNotEmpty,
        )
        .toList();

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(AppSpacing.lmd),
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
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: AppText(
                  tier.name.trim().isNotEmpty ? tier.name : (tier.key ?? ''),
                  style: (ctx) => AppTextStyles.gelasioRegular(
                    ctx,
                  ).copyWith(fontSize: 18, fontWeight: FontWeight.w600),
                ),
              ),
              if (tier.isCurrent) ...[
                SizedBox(width: AppSpacing.sm),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.sm,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: isDark
                        ? AppColors.primaryDarkButton
                        : AppColors.seekBarLight,
                    borderRadius: BorderRadius.circular(AppRadius.base),
                    border: Border.all(
                      color: isDark
                          ? AppColors.greyText
                          : AppColors.buttonBorder,
                    ),
                  ),
                  child: AppText(
                    context.l10n.current_tier,
                    style: (ctx) =>
                        AppTextStyles.captionText(ctx).copyWith(fontSize: 11),
                  ),
                ),
              ],
            ],
          ),
          if (intro.isNotEmpty) ...[
            SizedBox(height: AppSpacing.xs),
            AppText(
              intro,
              style: (ctx) =>
                  AppTextStyles.bodyLightText(ctx).copyWith(height: 1.4),
            ),
          ],
          if (benefits.isNotEmpty) ...[
            SizedBox(height: AppSpacing.md),
            for (var j = 0; j < benefits.length; j++) ...[
              if (j > 0) SizedBox(height: AppSpacing.base),
              _BenefitRow(
                isDark: isDark,
                title: benefits[j].title.trim().isNotEmpty
                    ? benefits[j].title
                    : benefits[j].description,
                subtitle: benefits[j].title.trim().isNotEmpty
                    ? benefits[j].description
                    : '',
              ),
            ],
          ],
        ],
      ),
    );
  }
}

class _BenefitRow extends StatelessWidget {
  const _BenefitRow({
    required this.isDark,
    required this.title,
    required this.subtitle,
  });

  final bool isDark;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          Icons.check_circle_outline_rounded,
          size: 24,
          color: isDark ? AppColors.successBorderDark : AppColors.successColor,
        ),
        SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppText(
                title,
                style: (ctx) => AppTextStyles.body(ctx).copyWith(
                  color: isDark ? AppColors.lightText : AppColors.darkText,
                ),
              ),
              if (subtitle.trim().isNotEmpty) ...[
                SizedBox(height: AppSpacing.xs),
                AppText(
                  subtitle,
                  style: (ctx) =>
                      AppTextStyles.bodyLightText(ctx).copyWith(fontSize: 12),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}
