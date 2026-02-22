import 'package:flutter/material.dart';
import 'package:pilates_app/config/theme/app_spacing.dart';
import 'package:pilates_app/config/theme/app_text_styles.dart';
import 'package:pilates_app/core/localization/localization_extension.dart';
import 'package:pilates_app/features/challenges_reward_flow/challenges/view/challenges_detail_view.dart';
import 'package:pilates_app/features/challenges_reward_flow/challenges/widget/active_challenges_card.dart';
import 'package:pilates_app/features/challenges_reward_flow/challenges/widget/new_challenges_card.dart';
import 'package:pilates_app/widgets/app_app_bar.dart';
import 'package:pilates_app/widgets/app_text.dart';

class ChallengesView extends StatelessWidget {
  const ChallengesView({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: AppAppBar(
        title: context.l10n.challenges,
        onBack: () => Navigator.of(context).pop(),
        isMoreMenu: false,
      ),
      body: Padding(
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
            ActiveChallengesCard(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ChallengesDetailView(),
                  ),
                );
              },
              imageIcon: isDark
                  ? "assets/images/svg/challenges/ic_dark_classes.svg"
                  : "assets/images/svg/challenges/ic_classes.svg",
              title: context.l10n.challenge_20_classes_title,
              subtitle: context.l10n.challenge_20_classes_subtitle(
                10,
                "February",
              ),
              completePR: 40,
              rank: 18,
              days: 15,
              point: 500,
            ),
            SizedBox(height: AppSpacing.md),
            ActiveChallengesCard(
              imageIcon: isDark
                  ? "assets/images/svg/challenges/ic_dark_streak.svg"
                  : "assets/images/svg/challenges/ic_streak.svg",
              title: context.l10n.challenge_streak_title,
              subtitle: context.l10n.challenge_streak_subtitle(7),
              completePR: 57,
              rank: 7,
              days: 3,
              point: 300,
            ),

            SizedBox(height: AppSpacing.xl),
            AppText(
              context.l10n.new_challenges,
              style: (context) => AppTextStyles.gelasioRegular(context),
            ),
            SizedBox(height: AppSpacing.md),
            NewChallengesCard(
              imageIcon: isDark
                  ? "assets/images/svg/challenges/ic_dark_core_strength.svg"
                  : "assets/images/svg/challenges/ic_strength.svg",
              title: context.l10n.challenge_core_title,
              subtitle: context.l10n.challenge_core_subtitle(15),
              people: 87,

              days: 30,
              point: 500,
            ),

            SizedBox(height: AppSpacing.md),
            NewChallengesCard(
              imageIcon: isDark
                  ? "assets/images/svg/challenges/ic_dark_spring_fitness.svg"
                  : "assets/images/svg/challenges/ic_spring_fitness.svg",
              title: context.l10n.challenge_spring_title,
              subtitle: context.l10n.challenge_spring_subtitle(25),
              people: 142,

              days: 30,
              point: 600,
            ),
          ],
        ),
      ),
    );
  }
}
