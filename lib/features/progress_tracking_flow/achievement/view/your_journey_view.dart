import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:pilates_app/config/theme/app_spacing.dart';
import 'package:pilates_app/features/loyalty/data/models/loyalty_badge.dart';
import 'package:pilates_app/features/progress_tracking_flow/achievement/cubit/loyalty_achievements_cubit.dart';
import 'package:pilates_app/features/progress_tracking_flow/achievement/cubit/loyalty_achievements_state.dart';
import 'package:pilates_app/widgets/app_text.dart';

import '../../../../config/theme/app_colors.dart';
import '../../../../config/theme/app_radius.dart';
import '../../../../config/theme/app_text_styles.dart';
import '../../../../core/localization/localization_extension.dart';
import '../../../../widgets/app_app_bar.dart';
import '../widget/achievement_card.dart';

/// Full achievements list — uses [LoyaltyAchievementsCubit] from parent (BlocProvider.value).
class YourJourneyView extends StatelessWidget {
  const YourJourneyView({super.key});

  static List<LoyaltyBadge> _sorted(List<LoyaltyBadge> raw) {
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
    return Scaffold(
      appBar: AppAppBar(
        onBack: () => Navigator.of(context).pop(),
        title: context.l10n.yourJourney_title,
        isMoreMenu: false,
      ),
      body: BlocBuilder<LoyaltyAchievementsCubit, LoyaltyAchievementsState>(
        builder: (context, state) {
          final data = state.data;
          if (state.status == LoyaltyAchievementsStatus.loading &&
              data == null) {
            return const Center(child: CircularProgressIndicator());
          }
          if (data == null) {
            return Center(
              child: AppText(
                state.errorMessage ?? '—',
                style: (context) => AppTextStyles.bodyText(context),
              ),
            );
          }
          final badges = _sorted(data.badges);
          final earned = badges.where((b) => b.isEarned).toList();
          final locked = badges.where((b) => !b.isEarned).toList();
          final total = badges.length;
          final earnedCount = data.earnedBadgeCount;
          final progress = total > 0 ? earnedCount / total : 0.0;

          return RefreshIndicator(
            onRefresh: () =>
                context.read<LoyaltyAchievementsCubit>().refresh(),
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: EdgeInsets.symmetric(
                vertical: AppSpacing.md,
                horizontal: AppSpacing.lg,
              ),
              children: [
                AchievementCard(
                  content: context.l10n.yourJourney_achievement_content,
                  showProgressBar: true,
                  earnedBadgeCount: total > 0 ? earnedCount : null,
                  totalBadges: total > 0 ? total : null,
                  progress: total > 0 ? progress : null,
                ),
                SizedBox(height: AppSpacing.xl),
                AppText(
                  context.l10n.yourJourney_achievements_earned,
                  style: (context) => AppTextStyles.gelasioRegular(context),
                ),
                SizedBox(height: AppSpacing.md),
                if (earned.isEmpty)
                  AppText(
                    context.l10n.noClassesYet,
                    style: (context) => AppTextStyles.bodyText(context),
                  )
                else
                  ...earned.map(
                    (b) => Padding(
                      padding: EdgeInsets.only(bottom: AppSpacing.md),
                      child: _JourneyBadgeCard(badge: b, isDark: isDark),
                    ),
                  ),
                SizedBox(height: AppSpacing.xl),
                AppText(
                  context.l10n.yourJourney_on_your_path,
                  style: (context) => AppTextStyles.gelasioRegular(context),
                ),
                SizedBox(height: AppSpacing.md),
                if (locked.isEmpty)
                  AppText(
                    context.l10n.noClassesYet,
                    style: (context) => AppTextStyles.bodyText(context),
                  )
                else
                  ...locked.map(
                    (b) => Padding(
                      padding: EdgeInsets.only(bottom: AppSpacing.md),
                      child: _JourneyBadgeCard(badge: b, isDark: isDark),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _JourneyBadgeCard extends StatelessWidget {
  const _JourneyBadgeCard({required this.badge, required this.isDark});

  final LoyaltyBadge badge;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context).toLanguageTag();
    final subtitle = badge.description?.trim().isNotEmpty == true
        ? badge.description!.trim()
        : badge.badgeType;
    final dateStr = badge.earnedAt != null
        ? DateFormat.yMMMd(locale).format(badge.earnedAt!.toLocal())
        : '';

    return Container(
      padding: EdgeInsets.symmetric(
        vertical: AppSpacing.lmd,
        horizontal: AppSpacing.md,
      ),
      decoration: BoxDecoration(
        color: isDark ? AppColors.homeBackground : Colors.white,
        border: Border.all(
          color: isDark ? AppColors.greyText : AppColors.buttonBorder,
          width: 1,
        ),
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _Leading(badge: badge, isDark: isDark),
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
                      AppTextStyles.textFieldHeading(context).copyWith(
                    height: 1,
                    color: isDark
                        ? AppColors.languageTextDark
                        : AppColors.languageIcon,
                  ),
                ),
                SizedBox(height: AppSpacing.base),
                if (dateStr.isNotEmpty)
                  AppText(
                    dateStr,
                    style: (context) => AppTextStyles.captionText(
                      context,
                    ).copyWith(color: AppColors.lightGrey),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Leading extends StatelessWidget {
  const _Leading({required this.badge, required this.isDark});

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
          errorBuilder: (_, __, ___) => _svg(isDark),
        ),
      );
    }
    return _svg(isDark);
  }

  Widget _svg(bool isDark) {
    return SvgPicture.asset(
      isDark
          ? 'assets/images/svg/progress_tracking/ic_dark_consistency_flow.svg'
          : 'assets/images/svg/progress_tracking/ic_consistency_flow.svg',
      height: 40,
      width: 40,
    );
  }
}
