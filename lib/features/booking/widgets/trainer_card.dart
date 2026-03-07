import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pilates_app/config/theme/app_colors.dart';
import 'package:pilates_app/config/theme/app_spacing.dart';
import 'package:pilates_app/config/theme/app_text_styles.dart';
import 'package:pilates_app/core/localization/localization_extension.dart';
import 'package:pilates_app/features/booking/widgets/tag_chip.dart';
import 'package:pilates_app/widgets/app_text.dart';

import '../../../config/theme/app_radius.dart';
import '../../../widgets/app_shadow.dart';
import '../views/trainer_details_view.dart';

class TrainerCard extends StatelessWidget {
  const TrainerCard({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => TrainerDetailsView()),
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
        padding: EdgeInsets.symmetric(
          horizontal: AppSpacing.lmd,
          vertical: AppSpacing.md,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppRadius.md),
          color: isDark ? AppColors.homeBackground : AppColors.whiteColor,
          border: Border.all(
            color: isDark ? AppColors.greyText : AppColors.buttonBorder,
            width: 0.5,
          ),
          boxShadow: isDark
              ? []
              : [
                  AppShadows.lightShadow,
                  AppShadows.mediumShadow,
                  AppShadows.mediumHeavyShadow,
                  BoxShadow(
                    color: AppColors.shadowColor.withValues(alpha: 0.01),
                    offset: const Offset(0, 64),
                    blurRadius: 25,
                    spreadRadius: 0,
                  ),
                  BoxShadow(
                    color: AppColors.shadowColor.withValues(alpha: 0.00),
                    offset: const Offset(0, 99),
                    blurRadius: 28,
                    spreadRadius: 0,
                  ),
                ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset(
              "assets/images/demo images/Trainer Avatar.png",
              height: 56,
              width: 56,
            ),
            SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      AppText(
                        "Aisha Sherin",
                        style: (context) => AppTextStyles.textFieldHeading(
                          context,
                        ).copyWith(height: 1),
                      ),
                      Spacer(),
                      Icon(
                        Icons.star,
                        color: AppColors.goldStarColor,
                        size: 14,
                      ),
                      SizedBox(width: AppSpacing.sm),
                      AppText(
                        "4.5",
                        style: (context) => AppTextStyles.textFieldHeading(
                          context,
                          fontWeight: FontWeight.w600,
                        ).copyWith(height: 1, fontSize: 12),
                      ),
                      SizedBox(width: 2),
                      AppText(
                        "(127)",
                        style: (context) =>
                            AppTextStyles.helpAndSupportItemSubLabel(
                              context,
                            ).copyWith(height: 1),
                      ),
                    ],
                  ),
                  SizedBox(height: AppSpacing.sm),
                  AppText(
                    context.l10n.powerPilatesSpecialist,
                    style: (context) => AppTextStyles.bodyLightText(
                      context,
                    ).copyWith(fontSize: 12),
                  ),
                  SizedBox(height: AppSpacing.base),
                  Wrap(
                    direction: Axis.horizontal,
                    spacing: AppSpacing.sm,
                    runSpacing: AppSpacing.sm,
                    children: [
                      TagChip(
                        label: context.l10n.yearsExperience(8),
                        fontSize: 12,
                      ),
                      TagChip(label: context.l10n.matCertified, fontSize: 12),
                      TagChip(label: context.l10n.reformer, fontSize: 12),
                    ],
                  ),
                  SizedBox(height: AppSpacing.sm),
                  AppText(
                    context.l10n.trainerDescription,
                    style: (context) => AppTextStyles.bodyTextSmall(
                      context,
                    ).copyWith(fontSize: 12, height: 1.4),
                  ),
                  SizedBox(height: AppSpacing.sm),
                  _buildIconRow(
                    icon: Icon(
                      Icons.location_on_outlined,
                      color: isDark
                          ? AppColors.languageIconDark
                          : AppColors.languageIcon,
                      size: 16,
                    ),
                    label: context.l10n.downtownStudio,
                    isDark: isDark,
                  ),
                  SizedBox(height: AppSpacing.sm),
                  _buildIconRow(
                    icon: SvgPicture.asset(
                      "assets/images/svg/ic_physical_therapy.svg",
                      height: 16,
                      width: 16,
                      color: isDark
                          ? AppColors.languageIconDark
                          : AppColors.languageIcon,
                    ),
                    label: context.l10n.classesThisWeek(32),
                    isDark: isDark,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIconRow({
    required Widget icon,
    required String label,
    required bool isDark,
  }) {
    return Row(
      children: [
        icon,
        SizedBox(width: AppSpacing.xs),
        AppText(
          label,
          style: (context) => AppTextStyles.bodyTextSmall(
            context,
          ).copyWith(fontSize: 12, height: 1.2),
        ),
      ],
    );
  }
}
