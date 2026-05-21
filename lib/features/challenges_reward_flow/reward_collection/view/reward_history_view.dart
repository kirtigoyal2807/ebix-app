import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:pilates_app/config/theme/app_spacing.dart';
import 'package:pilates_app/config/theme/app_text_styles.dart';
import 'package:pilates_app/features/loyalty/data/models/loyalty_points_history_entry.dart';
import 'package:pilates_app/widgets/app_text.dart';
import 'package:pilates_app/widgets/app_loading_indicator.dart';

import '../../../../core/localization/localization_extension.dart';
import '../cubit/reward_cubit.dart';
import '../cubit/reward_state.dart';
import '../widget/reward_history_card.dart';

class RewardHistoryView extends StatelessWidget {
  const RewardHistoryView({super.key});

  static String _formatDate(BuildContext context, String? iso) {
    if (iso == null || iso.isEmpty) return '';
    try {
      final d = DateTime.parse(iso).toLocal();
      final locale = Localizations.localeOf(context).toString();
      return DateFormat.yMMMd(locale).format(d);
    } catch (_) {
      return iso;
    }
  }

  static String _subtitleForEntry(
    BuildContext context,
    LoyaltyPointsHistoryEntry e,
  ) {
    final dateStr = _formatDate(context, e.processedAt ?? e.createdAt);
    if (e.isEarned) {
      return context.l10n.badge_earned_on(dateStr);
    }
    return context.l10n.redeemed_on(dateStr);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RewardCubit, RewardState>(
      buildWhen: (p, c) =>
          p.historyLoadStatus != c.historyLoadStatus ||
          p.pointsHistory != c.pointsHistory ||
          p.pointsHistoryError != c.pointsHistoryError,
      builder: (context, state) {
        switch (state.historyLoadStatus) {
          case RewardListLoadStatus.initial:
          case RewardListLoadStatus.loading:
            return const AppLoadingIndicator();
          case RewardListLoadStatus.failure:
            return ListView(
              padding: EdgeInsetsGeometry.all(AppSpacing.lg),
              children: [
                AppText(
                  context.l10n.rewards_history,
                  style: (context) => AppTextStyles.gelasioRegular(context),
                ),
                SizedBox(height: AppSpacing.md),
                AppText(
                  state.pointsHistoryError.isNotEmpty
                      ? state.pointsHistoryError
                      : context.l10n.loginErrorGeneric,
                  style: (context) => AppTextStyles.bodyLightText(context),
                ),
                TextButton(
                  onPressed: () =>
                      context.read<RewardCubit>().loadPointsHistory(),
                  child: AppText(
                    context.l10n.retry,
                    style: (c) => AppTextStyles.button(c),
                  ),
                ),
              ],
            );
          case RewardListLoadStatus.loaded:
            final list = state.pointsHistory;
            if (list.isEmpty) {
              return ListView(
                padding: EdgeInsetsGeometry.all(AppSpacing.lg),
                children: [
                  AppText(
                    context.l10n.rewards_history,
                    style: (context) => AppTextStyles.gelasioRegular(context),
                  ),
                  SizedBox(height: AppSpacing.md),
                  AppText(
                    context.l10n.rewardsCatalogSubtitle,
                    style: (context) => AppTextStyles.bodyLightText(context),
                  ),
                ],
              );
            }
            return ListView.separated(
              padding: EdgeInsetsGeometry.all(AppSpacing.lg),
              itemCount: list.length + 1,
              separatorBuilder: (_, _) => SizedBox(height: AppSpacing.md),
              itemBuilder: (context, i) {
                if (i == 0) {
                  return AppText(
                    context.l10n.rewards_history,
                    style: (context) => AppTextStyles.gelasioRegular(context),
                  );
                }
                final e = list[i - 1];
                return RewardHistoryCard(
                  title: e.description,
                  subTitle: _subtitleForEntry(context, e),
                  pointsDelta: e.points,
                  balanceAfter: e.balanceAfter,
                );
              },
            );
        }
      },
    );
  }
}
