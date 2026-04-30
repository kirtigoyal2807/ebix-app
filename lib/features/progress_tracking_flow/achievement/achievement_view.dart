import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pilates_app/config/theme/app_colors.dart';
import 'package:pilates_app/config/theme/app_text_styles.dart';
import 'package:pilates_app/core/localization/localization_extension.dart';
import 'package:pilates_app/features/loyalty/data/models/loyalty_achievement_rule.dart';
import 'package:pilates_app/features/loyalty/data/models/loyalty_badge.dart';
import 'package:pilates_app/features/progress_tracking_flow/achievement/cubit/loyalty_achievements_cubit.dart';
import 'package:pilates_app/features/progress_tracking_flow/achievement/cubit/loyalty_achievements_state.dart';
import 'package:pilates_app/features/progress_tracking_flow/achievement/view/your_journey_view.dart';
import 'package:pilates_app/features/progress_tracking_flow/achievement/widget/achievement_card.dart';
import 'package:pilates_app/widgets/app_button.dart';
import 'package:pilates_app/widgets/app_text.dart';

import '../../../config/theme/app_radius.dart';
import '../../../config/theme/app_spacing.dart';

class AchievementView extends StatelessWidget {
  const AchievementView({super.key});

  static List<LoyaltyBadge> _sortedBadges(List<LoyaltyBadge> raw) {
    final list = List<LoyaltyBadge>.from(raw);
    list.sort((a, b) {
      if (a.isEarned == b.isEarned) {
        return a.name.compareTo(b.name);
      }
      return a.isEarned ? -1 : 1;
    });
    return list;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return BlocBuilder<LoyaltyAchievementsCubit, LoyaltyAchievementsState>(
      builder: (context, state) {
        if (state.status == LoyaltyAchievementsStatus.loading &&
            state.data == null) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state.status == LoyaltyAchievementsStatus.failure &&
            state.data == null) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AppText(
                    state.errorMessage ?? context.l10n.loginErrorGeneric,
                    textAlign: TextAlign.center,
                    style: (context) => AppTextStyles.bodyText(context),
                  ),
                  SizedBox(height: AppSpacing.md),
                  AppButton(
                    label: context.l10n.retry,
                    expanded: false,
                    onPressed: () =>
                        context.read<LoyaltyAchievementsCubit>().refresh(),
                  ),
                ],
              ),
            ),
          );
        }

        final data = state.data;
        final badges =
            data == null ? <LoyaltyBadge>[] : _sortedBadges(data.badges);
        final total = badges.length;
        final earned = data?.earnedBadgeCount ?? 0;
        final progress = total > 0 ? earned / total : 0.0;
        final preview = badges.take(3).toList();

        return RefreshIndicator(
          onRefresh: () =>
              context.read<LoyaltyAchievementsCubit>().refresh(),
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: EdgeInsets.symmetric(
              horizontal: AppSpacing.lg,
              vertical: AppSpacing.lg,
            ),
            children: [
              AppText(
                context.l10n.achievement_your_achievements,
                style: (context) => AppTextStyles.gelasioRegular(context),
              ),
              SizedBox(height: AppSpacing.base),
              AchievementCard(
                content: context.l10n.achievement_content,
                earnedBadgeCount: data != null ? earned : null,
                totalBadges: data != null ? total : null,
                progress: data != null && total > 0 ? progress : null,
              ),
              SizedBox(height: AppSpacing.lg),
              if (preview.isEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 24),
                  child: AppText(
                    context.l10n.noClassesYet,
                    style: (context) => AppTextStyles.bodyText(context),
                  ),
                )
              else
                ...preview.map(
                  (b) => Padding(
                    padding: EdgeInsets.only(bottom: AppSpacing.md),
                    child: _BadgeRowCard(
                      badge: b,
                      rule: data?.ruleMatchingBadge(b),
                      isDark: isDark,
                    ),
                  ),
                ),
              SizedBox(height: AppSpacing.lg),
              AppButton(
                label: context.l10n.achievement_view_all_button,
                onPressed: () {
                  final cubit = context.read<LoyaltyAchievementsCubit>();
                  Navigator.push<void>(
                    context,
                    MaterialPageRoute<void>(
                      builder: (_) => BlocProvider.value(
                        value: cubit,
                        child: const YourJourneyView(),
                      ),
                    ),
                  );
                },
                variant: AppButtonVariant.primary,
              ),
            ],
          ),
        );
      },
    );
  }
}

class _BadgeRowCard extends StatelessWidget {
  const _BadgeRowCard({
    required this.badge,
    this.rule,
    required this.isDark,
  });

  final LoyaltyBadge badge;
  final LoyaltyAchievementRule? rule;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final matchedRule = rule;
    final subtitle = badge.description?.trim().isNotEmpty == true
        ? badge.description!.trim()
        : badge.badgeType;
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: AppSpacing.lmd,
        horizontal: AppSpacing.md,
      ),
      decoration: BoxDecoration(
        color: isDark ? AppColors.homeBackground : Colors.white,
        border: Border.all(
          color: badge.isEarned
              ? (isDark ? AppColors.darkGreyBorder : AppColors.primary)
              : (isDark ? AppColors.greyText : AppColors.buttonBorder),
          width: 1,
        ),
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _BadgeLeading(badge: badge, isDark: isDark),
          SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText(
                  badge.name.isEmpty ? badge.badgeKey : badge.name,
                  style: (context) => AppTextStyles.textFieldHeading(
                    context,
                  ).copyWith(height: 1),
                ),
                SizedBox(height: AppSpacing.xs),
                AppText(
                  subtitle,
                  style: (context) =>
                      AppTextStyles.bodyText(context).copyWith(height: 1),
                ),
                if (matchedRule != null && matchedRule.rewardPoints > 0) ...[
                  SizedBox(height: AppSpacing.xs),
                  AppText(
                    context.l10n.points_short(matchedRule.rewardPoints),
                    style: (context) =>
                        AppTextStyles.captionText(context).copyWith(
                      color: AppColors.languageIcon,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ],
            ),
          ),
          if (badge.isEarned)
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: AppSpacing.sm,
                vertical: 2,
              ),
              decoration: BoxDecoration(
                color: isDark
                    ? AppColors.successColor.withValues(alpha: 0.36)
                    : AppColors.featuredTagBackgroundColor,
                borderRadius: BorderRadius.circular(AppRadius.base),
              ),
              child: AppText(
                context.l10n.session_card_status_completed,
                style: (context) =>
                    AppTextStyles.splashVersion(context).copyWith(
                  color: isDark
                      ? AppColors.successBorderDark
                      : AppColors.successColor,
                  height: 1.6,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _BadgeLeading extends StatelessWidget {
  const _BadgeLeading({required this.badge, required this.isDark});

  final LoyaltyBadge badge;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final url = badge.iconUrl;
    if (url != null && url.isNotEmpty) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.network(
          url,
          height: 40,
          width: 40,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => _fallbackSvg(isDark),
        ),
      );
    }
    return _fallbackSvg(isDark);
  }

  Widget _fallbackSvg(bool isDark) {
    return SvgPicture.asset(
      isDark
          ? 'assets/images/svg/progress_tracking/ic_dark_consistency_flow.svg'
          : 'assets/images/svg/progress_tracking/ic_consistency_flow.svg',
      height: 40,
      width: 40,
    );
  }
}
