import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pilates_app/config/theme/app_colors.dart';
import 'package:pilates_app/config/theme/app_radius.dart';
import 'package:pilates_app/config/theme/app_spacing.dart';
import 'package:pilates_app/config/theme/app_text_styles.dart';
import 'package:pilates_app/core/localization/localization_extension.dart';
import 'package:pilates_app/features/challenges_reward_flow/challenges/challenge_ui.dart';
import 'package:pilates_app/features/challenges_reward_flow/challenges/cubit/challenge_detail_cubit.dart';
import 'package:pilates_app/features/challenges_reward_flow/challenges/cubit/challenge_detail_state.dart';
import 'package:pilates_app/features/challenges_reward_flow/challenges/widget/challenges_benefit.dart';
import 'package:pilates_app/features/challenges_reward_flow/challenges/widget/challenges_detail_card.dart';
import 'package:pilates_app/features/challenges_reward_flow/challenges/widget/score_card.dart';
import 'package:pilates_app/features/loyalty/data/loyalty_repository.dart';
import 'package:pilates_app/features/loyalty/data/models/loyalty_leaderboard_entry.dart';
import 'package:pilates_app/widgets/app_app_bar.dart';
import 'package:pilates_app/widgets/app_text.dart';

import '../../../../widgets/dotted_underline.dart';

class ChallengesDetailView extends StatelessWidget {
  const ChallengesDetailView({super.key, required this.challengeId});

  final int challengeId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          ChallengeDetailCubit(context.read<LoyaltyRepository>(), challengeId)
            ..load(),
      child: const _ChallengesDetailScaffold(),
    );
  }
}

class _ChallengesDetailScaffold extends StatelessWidget {
  const _ChallengesDetailScaffold();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: AppAppBar(
        title: context.l10n.challenge_detail,
        onBack: () => Navigator.of(context).pop(),
        isMoreMenu: false,
      ),
      body: BlocBuilder<ChallengeDetailCubit, ChallengeDetailState>(
        builder: (context, state) {
          if (state.status == ChallengeDetailLoadStatus.loading ||
              state.status == ChallengeDetailLoadStatus.initial) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state.status == ChallengeDetailLoadStatus.failure) {
            return Center(
              child: Padding(
                padding: EdgeInsets.all(AppSpacing.lg),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    AppText(
                      state.errorMessage.isNotEmpty
                          ? state.errorMessage
                          : context.l10n.loginErrorGeneric,
                      textAlign: TextAlign.center,
                      style: (context) => AppTextStyles.bodyLightText(context),
                    ),
                    TextButton(
                      onPressed: () =>
                          context.read<ChallengeDetailCubit>().load(),
                      child: AppText(
                        context.l10n.retry,
                        style: (c) => AppTextStyles.button(c),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          final detail = state.detail!;
          final cc = detail.challenge;
          final icon = challengeTypeIconAsset(cc.challengeType, isDark: isDark);
          final frac = challengeProgressFraction(cc);
          final pct = challengePercentComplete(cc);
          final remaining = (cc.targetValue - cc.progressValue).clamp(
            0,
            cc.targetValue,
          );

          return SingleChildScrollView(
            child: Padding(
              padding: EdgeInsetsGeometry.symmetric(
                vertical: AppSpacing.md,
                horizontal: AppSpacing.lg,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ChallengesDetailCard(
                    imageIcon: icon,
                    title: cc.name,
                    subtitle: cc.description,
                    days: daysUntilEndUtc(cc.endAt),
                    point: cc.rewardValue,
                    people: null,
                  ),
                  SizedBox(height: AppSpacing.xl),
                  AppText(
                    context.l10n.your_progress,
                    style: (context) => AppTextStyles.gelasioRegular(context),
                  ),
                  SizedBox(height: AppSpacing.md),
                  _ProgressCard(
                    isDark: isDark,
                    progressLabel: '${cc.progressValue} / ${cc.targetValue}',
                    percent: pct,
                    remaining: remaining,
                    fraction: frac,
                  ),
                  SizedBox(height: AppSpacing.xl),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      AppText(
                        context.l10n.leaderboard,
                        style: (context) =>
                            AppTextStyles.gelasioRegular(context),
                      ),
                    ],
                  ),
                  SizedBox(height: AppSpacing.md),
                  ..._leaderboardWidgets(
                    context,
                    isDark,
                    detail.leaderboard,
                    cc.targetValue,
                  ),
                  SizedBox(height: AppSpacing.xl),
                  AppText(
                    context.l10n.rewards,
                    style: (context) => AppTextStyles.gelasioRegular(context),
                  ),
                  SizedBox(height: AppSpacing.md),
                  ChallengesBenefit(),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  static List<Widget> _leaderboardWidgets(
    BuildContext context,
    bool isDark,
    List<LoyaltyLeaderboardEntry> entries,
    int targetValue,
  ) {
    if (entries.isEmpty) {
      return [
        AppText(
          context.l10n.challengesSubtitle,
          style: (context) => AppTextStyles.bodyLightText(context),
        ),
      ];
    }
    final widgets = <Widget>[];
    for (var i = 0; i < entries.length && i < 20; i++) {
      final e = entries[i];
      final rank = e.rank ?? (i + 1);
      widgets.add(
        ScoreCard(
          index: rank,
          sortName: leaderboardInitials(e),
          name: leaderboardDisplayName(e),
          attendedClasses: '${e.progressValue}/$targetValue',
        ),
      );
      widgets.add(SizedBox(height: AppSpacing.base));
    }
    if (widgets.isNotEmpty) widgets.removeLast();
    if (widgets.isNotEmpty) {
      widgets.add(
        SizedBox(
          width: double.infinity,
          child: CustomPaint(
            painter: DashedUnderlinePainter(
              color: isDark ? AppColors.greyText : AppColors.darkGreyBorder,
              dashWidth: 3,
              dashSpace: 3,
            ),
          ),
        ),
      );
      widgets.add(SizedBox(height: AppSpacing.base));
    }
    return widgets;
  }
}

class _ProgressCard extends StatelessWidget {
  const _ProgressCard({
    required this.isDark,
    required this.progressLabel,
    required this.percent,
    required this.remaining,
    required this.fraction,
  });

  final bool isDark;
  final String progressLabel;
  final int percent;
  final int remaining;
  final double fraction;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: AppSpacing.lmd,
        horizontal: AppSpacing.lg,
      ),
      decoration: BoxDecoration(
        color: isDark ? AppColors.primaryDarkButton : AppColors.seekBarLight,
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          AppText(
            progressLabel,
            style: (context) => AppTextStyles.appBarText(
              context,
            ).copyWith(fontSize: 32, height: 1.2),
          ),
          SizedBox(height: AppSpacing.xs),
          AppText(
            context.l10n.classes_completed,
            style: (context) =>
                AppTextStyles.bodyText(context).copyWith(height: 1),
          ),
          SizedBox(height: AppSpacing.lg),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AppText(
                context.l10n.percent_complete(percent),
                style: (context) =>
                    AppTextStyles.bodyLightText(context).copyWith(
                      color: isDark
                          ? AppColors.darkGreyText
                          : AppColors.lightGrey,
                    ),
              ),
              AppText(
                context.l10n.more_classes_to_go(remaining),
                style: (context) => AppTextStyles.boldBody(context),
              ),
            ],
          ),
          SizedBox(height: AppSpacing.md),
          ClipRRect(
            borderRadius: BorderRadius.circular(AppRadius.sm),
            child: LinearProgressIndicator(
              value: fraction.clamp(0.0, 1.0),
              minHeight: 6,
              backgroundColor: isDark
                  ? Color(0xff1C1917)
                  : AppColors.darkGreyBorder,
              valueColor: AlwaysStoppedAnimation<Color>(
                isDark ? AppColors.languageIconDark : AppColors.languageIcon,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
