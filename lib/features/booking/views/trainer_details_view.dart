import 'package:flutter/material.dart';
import 'package:pilates_app/config/theme/app_spacing.dart';
import 'package:pilates_app/config/theme/app_text_styles.dart';
import 'package:pilates_app/widgets/app_app_bar.dart';
import 'package:pilates_app/widgets/app_text.dart';

import '../../../config/theme/app_colors.dart';
import '../../../config/theme/app_radius.dart';
import '../../../core/localization/localization_extension.dart';
import '../../../widgets/app_button.dart';
import '../widgets/booking_class_card.dart';
import '../widgets/class_reviews_section.dart';
import '../widgets/tag_chip.dart';

class TrainerDetailsView extends StatelessWidget {
  const TrainerDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: AppAppBar(
        title: context.l10n.trainerDetails,
        isMoreMenu: false,
        onBack: () => Navigator.of(context).pop(),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: AppSpacing.sm),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: [
              Center(
                child: Image.asset(
                  "assets/images/demo images/Trainer Avatar.png",
                  height: 90,
                  width: 90,
                ),
              ),

              SizedBox(height: AppSpacing.base),
              Center(
                child: AppText(
                  "Aisha Sherin",
                  style: (context) =>
                      AppTextStyles.heading1(context).copyWith(height: 1.55),
                ),
              ),
              Center(
                child: AppText(
                  context.l10n.powerPilatesSpecialist,
                  style: (context) =>
                      AppTextStyles.bodyText(context).copyWith(height: 1.55),
                ),
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.star, color: AppColors.goldStarColor, size: 14),
                  SizedBox(width: 2),
                  Icon(Icons.star, color: AppColors.goldStarColor, size: 14),
                  SizedBox(width: 2),
                  Icon(Icons.star, color: AppColors.goldStarColor, size: 14),
                  SizedBox(width: 2),
                  Icon(Icons.star, color: AppColors.goldStarColor, size: 14),
                  SizedBox(width: AppSpacing.sm),
                  AppText(
                    "4",
                    style: (context) => AppTextStyles.textFieldHeading(
                      context,
                      fontWeight: FontWeight.w600,
                    ).copyWith(height: 1, fontSize: 14),
                  ),
                  SizedBox(width: 2),
                  AppText(
                    "(127 ${context.l10n.reviews})",
                    style: (context) =>
                        AppTextStyles.helpAndSupportItemSubLabel(
                          context,
                        ).copyWith(height: 1, fontSize: 14),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Center(
                child: Wrap(
                  direction: Axis.horizontal,
                  spacing: AppSpacing.sm,
                  children: [
                    TagChip(
                      label: context.l10n.yearsExperience(8),
                      fontSize: 14,
                    ),
                    TagChip(label: context.l10n.matCertified, fontSize: 14),
                    TagChip(label: context.l10n.reformer, fontSize: 14),
                  ],
                ),
              ),
              SizedBox(height: AppSpacing.md),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg),

                child: Row(
                  children: [
                    _totalCard(
                      value: "350+",
                      label: context.l10n.classesTaught,
                      isDark: isDark,
                    ),
                    SizedBox(width: AppSpacing.md),
                    _totalCard(
                      value: "23",
                      label: context.l10n.thisWeek,
                      isDark: isDark,
                    ),
                    SizedBox(width: AppSpacing.md),
                    _totalCard(
                      value: "92%",
                      label: context.l10n.returnRate,
                      isDark: isDark,
                    ),
                  ],
                ),
              ),
              SizedBox(height: AppSpacing.lg),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg),

                child: AppText(
                  "${context.l10n.about} Aisha",
                  style: (context) => AppTextStyles.gelasioRegular(context),
                  textAlign: TextAlign.start,
                ),
              ),
              SizedBox(height: AppSpacing.xs),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg),

                child: AppText(
                  context.l10n.trainerAboutDescription,
                  style: (context) =>
                      AppTextStyles.bodyText(context).copyWith(height: 1.55),
                  maxLines: 12,
                ),
              ),
              SizedBox(height: AppSpacing.lg),
              _certificateTrainingCard(isDark: isDark, context: context),
              SizedBox(height: AppSpacing.lg),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg),

                child: AppText(
                  context.l10n.teachingStyle,
                  style: (context) => AppTextStyles.gelasioRegular(
                    context,
                  ).copyWith(height: 1.55),
                ),
              ),
              SizedBox(height: AppSpacing.sm),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg),

                child: Wrap(
                  direction: Axis.horizontal,
                  spacing: AppSpacing.sm,
                  runSpacing: AppSpacing.sm,
                  children: [
                    _teachingStyleCard(
                      label: context.l10n.dynamicTxt,
                      isDark: isDark,
                    ),

                    _teachingStyleCard(
                      label: context.l10n.motivating,
                      isDark: isDark,
                    ),

                    _teachingStyleCard(
                      label: context.l10n.detailOriented,
                      isDark: isDark,
                    ),

                    _teachingStyleCard(
                      label: context.l10n.challenging,
                      isDark: isDark,
                    ),

                    _teachingStyleCard(
                      label: context.l10n.supporting,
                      isDark: isDark,
                    ),
                  ],
                ),
              ),
              SizedBox(height: AppSpacing.xl),
              ClassReviewsSection(),
              SizedBox(height: AppSpacing.xl),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: AppText(
                        context.l10n.upcomingClasses,
                        style: (context) =>
                            AppTextStyles.heading1(context).copyWith(
                              color: isDark
                                  ? AppColors.lightText
                                  : AppColors.darkText,
                              fontSize: 18,
                              fontWeight: FontWeight.w400,
                            ),
                      ),
                    ),
                    // AppText(
                    //   context.l10n.seeAll,
                    //   style: (context) =>
                    //       AppTextStyles.captionText(
                    //         context,
                    //         fontWeight: FontWeight.w500,
                    //       ).copyWith(
                    //         color: isDark
                    //             ? AppColors.languageTextDark
                    //             : AppColors.languageIcon,
                    //         fontSize: 14,
                    //       ),
                    // ),
                  ],
                ),
              ),
              SizedBox(height: AppSpacing.base),
              BookingClassCard(
                title: 'Power Pilates',
                trainerName: 'Sarah Mitchell',
                studio: context.l10n.branchDowntown,
                time: '${context.l10n.today}, 6:00 PM',
                spotsLeft: 3,
                isInPlan: true,
              ),
              const SizedBox(height: AppSpacing.md),
              BookingClassCard(
                title: 'Power Pilates',
                trainerName: 'Sarah Mitchell',
                studio: context.l10n.branchDowntown,
                time: '${context.l10n.today}, 6:00 PM',
                spotsLeft: 0,
                isInPlan: false,
                upgradeRequired: true,
              ),
              const SizedBox(height: AppSpacing.lg),
              // Container(
              //   margin: EdgeInsets.symmetric(horizontal: AppSpacing.lg),
              //   decoration: BoxDecoration(
              //     color: isDark ? AppColors.homeBackground : Colors.white,
              //     borderRadius: BorderRadius.circular(AppRadius.xl),
              //     boxShadow: [
              //       BoxShadow(
              //         color: AppColors.shadowColor.withValues(alpha: 0.06),
              //         offset: const Offset(0, 1),
              //         blurRadius: 2,
              //         spreadRadius: 0,
              //       ),
              //     ],
              //   ),
              //   child: AppButton(
              //     label: context.l10n.viewAllAishaClasses,
              //     onPressed: () {},
              //     variant: AppButtonVariant.secondary,
              //   ),
              // ),
              // const SizedBox(height: AppSpacing.sm),
              // Padding(
              //   padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg),
              //   child: AppButton(
              //     label: context.l10n.browseAllClasses,
              //     onPressed: () {},
              //     variant: AppButtonVariant.primary,
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _totalCard({
    required String label,
    required String value,
    required bool isDark,
  }) {
    return Expanded(
      child: Container(
        height: 102,
        decoration: BoxDecoration(
          color: isDark ? AppColors.homeBackground : Colors.white,
          borderRadius: BorderRadius.circular(AppRadius.md),
          border: Border.all(
            color: isDark ? AppColors.greyText : AppColors.buttonBorder,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,

          children: [
            AppText(
              value,
              style: (context) => AppTextStyles.bottomSheetTitle(
                context,
                fontWeight: FontWeight.w600,
              ).copyWith(height: 1.55),
            ),
            SizedBox(height: AppSpacing.xs),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
              child: AppText(
                label,
                style: (context) => AppTextStyles.caption(
                  context,
                ).copyWith(height: 1.30, fontSize: 12),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _certificateTrainingCard({
    required bool isDark,
    required BuildContext context,
  }) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: AppSpacing.md),

      padding: EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: isDark ? AppColors.primaryDarkButton : AppColors.seekBarLight,
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          AppText(
            context.l10n.certificationsTraining,
            style: (context) => AppTextStyles.gelasioRegular(
              context,
              fontWeight: FontWeight.w400,
            ).copyWith(height: 1.55),
          ),
          SizedBox(height: AppSpacing.xs),
          _buildRow(label: context.l10n.pmaCertifiedInstructor, isDark: isDark),
          _buildRow(label: context.l10n.matPilatesLevel3, isDark: isDark),
          _buildRow(
            label: context.l10n.sportsRehabilitationTraining,
            isDark: isDark,
          ),
          _buildRow(
            label: context.l10n.anatomyBiomechanicsCertificate,
            isDark: isDark,
          ),
        ],
      ),
    );
  }

  Widget _buildRow({required String label, required bool isDark}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText(
          "• ",
          style: (context) =>
              AppTextStyles.bodyText(context).copyWith(height: 1.55),
        ),

        Expanded(
          child: AppText(
            label,
            style: (context) =>
                AppTextStyles.bodyText(context).copyWith(height: 1.55),
          ),
        ),
      ],
    );
  }

  Widget _teachingStyleCard({required String label, required bool isDark}) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 2, horizontal: 10),
      decoration: BoxDecoration(
        color: isDark ? AppColors.primaryDarkButton : AppColors.greyContainerBg,
        borderRadius: BorderRadius.circular(AppRadius.base),
      ),
      child: AppText(
        label,
        style: (context) => AppTextStyles.textFieldHeading(context),
      ),
    );
  }
}
