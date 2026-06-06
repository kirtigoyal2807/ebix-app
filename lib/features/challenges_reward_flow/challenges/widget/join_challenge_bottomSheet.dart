import 'package:flutter/material.dart';
import 'package:pilates_app/config/theme/app_radius.dart';
import 'package:pilates_app/config/theme/app_spacing.dart';
import 'package:pilates_app/config/theme/app_text_styles.dart';
import 'package:pilates_app/config/theme/app_colors.dart';
import 'package:pilates_app/core/localization/localization_extension.dart';
import 'package:pilates_app/features/challenges_reward_flow/challenges/challenge_ui.dart';
import 'package:pilates_app/features/loyalty/data/models/loyalty_challenge.dart';

import '../../../../widgets/app_button.dart';
import '../../../../widgets/app_text.dart';
import '../../badge_collection/badge_collection_view.dart';
import 'challenges_benefit.dart';
import 'challenges_detail_card.dart';

class JoinChallengeBottomSheet extends StatelessWidget {
  const JoinChallengeBottomSheet({
    super.key,
    this.challenge,
    this.imageIcon,
    this.onJoinConfirmed,
  });

  /// When set, sheet shows API challenge copy and calls [onJoinConfirmed] on Join.
  final LoyaltyChallenge? challenge;

  final String? imageIcon;
  final Future<void> Function()? onJoinConfirmed;

  @override
  Widget build(BuildContext context) {
    final isRTL = Directionality.of(context) == TextDirection.rtl;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    if (challenge != null && imageIcon != null && onJoinConfirmed != null) {
      final c = challenge!;
      final days = daysUntilEndUtc(c.endAt);
      return Material(
        color: isDarkMode ? AppColors.homeBackground : Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        child: SafeArea(
          top: false,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(vertical: AppSpacing.lg),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(
                        left: isRTL ? AppSpacing.base : AppSpacing.lg,
                        right: isRTL ? AppSpacing.lg : AppSpacing.base,
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: AppText(
                              context.l10n.join_challenge,
                              style: AppTextStyles.bottomSheetTitle,
                            ),
                          ),
                          IconButton(
                            icon: const Icon(
                              Icons.close,
                              color: AppColors.arrowIcon,
                            ),
                            onPressed: () => Navigator.of(context).pop(),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: AppSpacing.lg),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ChallengesDetailCard(
                            imageIcon: imageIcon!,
                            title: c.name,
                            subtitle: c.description,
                            days: days,
                            point: c.rewardValue,
                            people: null,
                          ),
                          SizedBox(height: AppSpacing.lg),
                          AppText(
                            context.l10n.challenge_details,
                            style: (context) =>
                                AppTextStyles.gelasioMedium(context),
                          ),
                          SizedBox(height: AppSpacing.md),
                          Container(
                            width: MediaQuery.of(context).size.width,
                            padding: EdgeInsets.all(AppSpacing.lmd),
                            decoration: BoxDecoration(
                              color: isDarkMode
                                  ? AppColors.homeBackground
                                  : AppColors.whiteColor,
                              borderRadius: BorderRadius.circular(AppRadius.md),
                              border: Border.all(
                                color: isDarkMode
                                    ? AppColors.greyText
                                    : AppColors.buttonBorder,
                                width: 1,
                              ),
                            ),
                            child: AppText(
                              c.description,
                              style: (context) => AppTextStyles.bodyLightText(
                                context,
                              ).copyWith(height: 1.4),
                              maxLines: 6,
                            ),
                          ),
                          SizedBox(height: AppSpacing.lg),
                          AppText(
                            context.l10n.what_you_will_earn,
                            style: (context) =>
                                AppTextStyles.gelasioMedium(context),
                          ),
                          SizedBox(height: AppSpacing.md),
                          const ChallengesBenefit(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(
                  AppSpacing.lg,
                  0,
                  AppSpacing.lg,
                  AppSpacing.bottomActionPadding,
                ),
                child: AppButton(
                  label: context.l10n.join_challenge,
                  onPressed: () async {
                    await onJoinConfirmed!();
                    if (context.mounted) Navigator.of(context).pop();
                  },
                  variant: AppButtonVariant.primary,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return _legacySheet(context, isRTL, isDarkMode);
  }

  Widget _legacySheet(BuildContext context, bool isRTL, bool isDark) {
    return Material(
      color: isDark ? AppColors.homeBackground : Colors.white,
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(vertical: AppSpacing.lg),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                      left: isRTL ? AppSpacing.base : AppSpacing.lg,
                      right: isRTL ? AppSpacing.lg : AppSpacing.base,
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: AppText(
                            context.l10n.join_challenge,
                            style: AppTextStyles.bottomSheetTitle,
                          ),
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: IconButton(
                            icon: const Icon(
                              Icons.close,
                              color: AppColors.arrowIcon,
                            ),
                            onPressed: () => Navigator.of(context).pop(),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: AppSpacing.lg),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ChallengesDetailCard(
                          imageIcon: isDark
                              ? "assets/images/svg/challenges/ic_dark_core_strength.svg"
                              : "assets/images/svg/challenges/ic_strength.svg",
                          title: context.l10n.core_strength_challenge,
                          subtitle: context.l10n.core_strength_subtitle(15),
                          days: 15,
                          point: 500,
                          people: 87,
                        ),
                        SizedBox(height: AppSpacing.lg),
                        AppText(
                          context.l10n.challenge_details,
                          style: (context) =>
                              AppTextStyles.gelasioMedium(context),
                        ),
                        SizedBox(height: AppSpacing.md),
                        Container(
                          padding: EdgeInsets.all(AppSpacing.lmd),
                          decoration: BoxDecoration(
                            color: isDark
                                ? AppColors.homeBackground
                                : AppColors.whiteColor,
                            borderRadius: BorderRadius.circular(AppRadius.md),
                            border: Border.all(
                              color: isDark
                                  ? AppColors.greyText
                                  : AppColors.buttonBorder,
                              width: 1,
                            ),
                          ),
                          child: AppText(
                            context.l10n.challenge_description(20, "February"),
                            style: (context) => AppTextStyles.bodyLightText(
                              context,
                            ).copyWith(height: 1.4),
                            maxLines: 3,
                          ),
                        ),
                        SizedBox(height: AppSpacing.lg),
                        AppText(
                          context.l10n.what_you_will_earn,
                          style: (context) =>
                              AppTextStyles.gelasioMedium(context),
                        ),
                        SizedBox(height: AppSpacing.md),
                        ChallengesBenefit(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: double.infinity,
              padding: EdgeInsets.fromLTRB(
                AppSpacing.lg,
                0,
                AppSpacing.lg,
                AppSpacing.bottomActionPadding,
              ),
              child: AppButton(
                label: context.l10n.join_challenge,
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BadgeCollectionView(),
                    ),
                  );
                },
                variant: AppButtonVariant.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
