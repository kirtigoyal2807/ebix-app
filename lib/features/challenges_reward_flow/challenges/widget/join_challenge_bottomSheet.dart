import 'package:flutter/material.dart';
import 'package:pilates_app/config/theme/app_radius.dart';
import 'package:pilates_app/config/theme/app_spacing.dart';
import 'package:pilates_app/config/theme/app_text_styles.dart';
import 'package:pilates_app/config/theme/app_colors.dart';
import 'package:pilates_app/core/localization/localization_extension.dart';

import '../../../../widgets/app_button.dart';
import '../../../../widgets/app_text.dart';
import '../../badge_collection/badge_collection_view.dart';
import 'challenges_benefit.dart';
import 'challenges_detail_card.dart';

class JoinChallengeBottomSheet extends StatelessWidget {
  const JoinChallengeBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final isRTL = Directionality.of(context) == TextDirection.rtl;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Material(
      color: isDark ? AppColors.homeBackground : Colors.white,
      borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: AppSpacing.lg),
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
                  const SizedBox(height: AppSpacing.lg),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.lg,
                    ),
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
                            color:
                                isDark ? AppColors.homeBackground : AppColors.whiteColor,
                            borderRadius: BorderRadius.circular(AppRadius.md),
                            border: Border.all(
                              color: isDark
                                  ? AppColors.greyText
                                  : AppColors.buttonBorder,
                              width: 1,
                            ),
                          ),
                          child: AppText(
                            context.l10n.challenge_description(
                              20,
                              "February",
                            ),
                            style: (context) =>
                                AppTextStyles.bodyLightText(context).copyWith(
                              height: 1.4,
                            ),
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
                        ChallengesBenefit()
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
                AppSpacing.md + 2,
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
