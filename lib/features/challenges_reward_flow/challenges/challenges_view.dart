import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pilates_app/config/theme/app_colors.dart';
import 'package:pilates_app/config/theme/app_spacing.dart';
import 'package:pilates_app/config/theme/app_text_styles.dart';
import 'package:pilates_app/core/localization/localization_extension.dart';
import 'package:pilates_app/features/challenges_reward_flow/challenges/challenge_ui.dart';
import 'package:pilates_app/features/challenges_reward_flow/challenges/cubit/challenges_cubit.dart';
import 'package:pilates_app/features/challenges_reward_flow/challenges/cubit/challenges_state.dart';
import 'package:pilates_app/features/challenges_reward_flow/challenges/view/challenges_detail_view.dart';
import 'package:pilates_app/features/challenges_reward_flow/challenges/widget/active_challenges_card.dart';
import 'package:pilates_app/features/challenges_reward_flow/challenges/widget/join_challenge_bottomSheet.dart';
import 'package:pilates_app/features/challenges_reward_flow/challenges/widget/new_challenges_card.dart';
import 'package:pilates_app/features/loyalty/data/loyalty_repository.dart';
import 'package:pilates_app/widgets/app_app_bar.dart';
import 'package:pilates_app/widgets/app_text.dart';
import 'package:pilates_app/widgets/app_loading_indicator.dart';

class ChallengesView extends StatelessWidget {
  const ChallengesView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          ChallengesCubit(context.read<LoyaltyRepository>())..load(),
      child: const _ChallengesViewBody(),
    );
  }
}

class _ChallengesViewBody extends StatelessWidget {
  const _ChallengesViewBody();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: AppAppBar(
        title: context.l10n.challenges,
        onBack: () => Navigator.of(context).pop(),
        isMoreMenu: false,
      ),
      body: BlocBuilder<ChallengesCubit, ChallengesState>(
        builder: (context, state) {
          if (state.status == ChallengesLoadStatus.loading ||
              state.status == ChallengesLoadStatus.initial) {
            return const AppLoadingIndicator();
          }
          if (state.status == ChallengesLoadStatus.failure) {
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
                      onPressed: () => context.read<ChallengesCubit>().load(),
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

          final active = state.activeChallenges;
          final fresh = state.newChallenges;

          return RefreshIndicator(
            onRefresh: () => context.read<ChallengesCubit>().load(),
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: EdgeInsetsGeometry.symmetric(
                vertical: AppSpacing.md,
                horizontal: AppSpacing.lg,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppText(
                    context.l10n.my_active_challenges,
                    style: (context) => AppTextStyles.gelasioRegular(context),
                  ),
                  SizedBox(height: AppSpacing.md),
                  if (active.isEmpty)
                    Padding(
                      padding: EdgeInsets.only(bottom: AppSpacing.md),
                      child: AppText(
                        context.l10n.challengesSubtitle,
                        style: (context) =>
                            AppTextStyles.bodyLightText(context),
                      ),
                    )
                  else
                    for (final c in active) ...[
                      ActiveChallengesCard(
                        onTap: () {
                          Navigator.push<void>(
                            context,
                            MaterialPageRoute<void>(
                              builder: (_) =>
                                  ChallengesDetailView(challengeId: c.id),
                            ),
                          );
                        },
                        imageIcon: challengeTypeIconAsset(
                          c.challengeType,
                          isDark: isDark,
                        ),
                        title: c.name,
                        subtitle: c.description,
                        completePR: challengePercentComplete(c).toDouble(),
                        rank: null,
                        days: daysUntilEndUtc(c.endAt),
                        point: c.rewardValue.toDouble(),
                        linearProgress: challengeProgressFraction(c),
                      ),
                      SizedBox(height: AppSpacing.md),
                    ],
                  SizedBox(height: AppSpacing.xl),
                  AppText(
                    context.l10n.new_challenges,
                    style: (context) => AppTextStyles.gelasioRegular(context),
                  ),
                  SizedBox(height: AppSpacing.md),
                  if (fresh.isEmpty)
                    AppText(
                      context.l10n.newChallengesSubtitle,
                      style: (context) => AppTextStyles.bodyLightText(context),
                    )
                  else
                    for (final c in fresh) ...[
                      NewChallengesCard(
                        imageIcon: challengeTypeIconAsset(
                          c.challengeType,
                          isDark: isDark,
                        ),
                        title: c.name,
                        subtitle: c.description,
                        people: 0,
                        days: daysUntilEndUtc(c.endAt),
                        point: c.rewardValue.toDouble(),
                        onCardTap: () {
                          showModalBottomSheet<void>(
                            context: context,
                            isScrollControlled: true,
                            barrierColor: AppColors.bottomSheetShadow,
                            builder: (sheetContext) => JoinChallengeBottomSheet(
                              challenge: c,
                              imageIcon: challengeTypeIconAsset(
                                c.challengeType,
                                isDark: isDark,
                              ),
                              onJoinConfirmed: () async {
                                final msg = await context
                                    .read<ChallengesCubit>()
                                    .joinChallenge(c.id);
                                if (!context.mounted) return;
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      msg == null || msg.isEmpty
                                          ? 'Joined challenge'
                                          : msg,
                                    ),
                                  ),
                                );
                              },
                            ),
                          );
                        },
                      ),
                      SizedBox(height: AppSpacing.md),
                    ],
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
