import 'package:flutter/material.dart';
import 'package:pilates_app/config/theme/app_colors.dart';
import 'package:pilates_app/config/theme/app_radius.dart';
import 'package:pilates_app/config/theme/app_spacing.dart';
import 'package:pilates_app/config/theme/app_text_styles.dart';
import 'package:pilates_app/core/localization/localization_extension.dart';
import 'package:pilates_app/widgets/app_text.dart';

import '../views/trainer_details_view.dart';

class ClassInfoGrid extends StatelessWidget {
  const ClassInfoGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => TrainerDetailsView()),
                  );
                },
                child: _InfoCard(

                  label: context.l10n.instructor,
                  value: context.l10n.trainerAishaSherin,
                  showAvatar: true,
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: _InfoCard(
                label: context.l10n.duration,
                value: context.l10n.minutesCount(40),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        Row(
          children: [
            Expanded(
              child: _InfoCard(
                label: context.l10n.dateTime,
                value: '${context.l10n.today}, 6:00 PM',
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: _InfoCard(
                label: context.l10n.availability,
                value: context.l10n.spotsLeft(3),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _InfoCard extends StatelessWidget {
  final String label;
  final String value;
  final bool showAvatar;

  const _InfoCard({
    required this.label,
    required this.value,
    this.showAvatar = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: isDark ? AppColors.homeBackground : AppColors.whiteColor,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(
          color: isDark ? AppColors.greyText : AppColors.buttonBorder,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AppText(
            label,
            style: (context) => AppTextStyles.captionText(context).copyWith(
              color: AppColors.lightGrey,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Row(
            children: [
              if (showAvatar) ...[
                Image.asset("assets/images/png/ic_trainer.png",height: 24,
                  width: 24,
                  fit: BoxFit.fill,),
                const SizedBox(width: 8),
              ]else ...[
                SizedBox(height: 24,)
              ],
              Expanded(
                child: AppText(
                  value,
                  style: (context) => AppTextStyles.boldBody(context).copyWith(
                    fontSize: 14,
                    color: showAvatar ?isDark ? AppColors.languageTextDark : AppColors.languageIcon  : (isDark ? AppColors.lightText : AppColors.darkText),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
