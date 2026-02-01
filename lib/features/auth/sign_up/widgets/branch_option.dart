import 'package:flutter/material.dart';
import 'package:pilates_app/config/theme/app_colors.dart';
import 'package:pilates_app/config/theme/app_radius.dart';
import 'package:pilates_app/config/theme/app_spacing.dart';
import 'package:pilates_app/config/theme/app_text_styles.dart';
import 'package:pilates_app/widgets/app_text.dart';

class BranchOption extends StatelessWidget {
  final String title;
  final String city;
  final String distance;
  final String type; // Premium / Standard
  final bool selected;
  final VoidCallback onTap;

  const BranchOption({
    super.key,
    required this.title,
    required this.city,
    required this.distance,
    required this.type,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final theme = Theme.of(context);
    final borderColor = selected
        ? isDark ? AppColors.darkGreyBorder: AppColors.languageIconDark
        : theme.dividerColor;

    return Material(
      // color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.md),
        child: Container(
          padding: const EdgeInsets.all(AppSpacing.lg),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppRadius.md),
            border: Border.all(
              color: borderColor,
              width: selected ? 1 : 1,
            ),
            // color:Colors.white,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// TOP ROW: TITLE + CHIP
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: AppText(
                      title,
                      style: AppTextStyles.textFieldHeading,
                    ),
                  ),
                  _BranchTypeChip(type: type),
                ],
              ),

              const SizedBox(height: AppSpacing.xs),

              /// CITY
              AppText(
                city,
                style: AppTextStyles.bodyTextSmall,
              ),

              const SizedBox(height: AppSpacing.md),

              /// DISTANCE
              Row(
                children: [
                  Icon(
                    Icons.location_on_outlined,
                    size: 16,
                    color: theme.hintColor,
                  ),
                  const SizedBox(width: 4),
                  AppText(
                    distance,
                    style: AppTextStyles.bodyTextSmall,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BranchTypeChip extends StatelessWidget {
  final String type;

  const _BranchTypeChip({required this.type});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 4,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: theme.dividerColor,
        ),
        color: isDark? (type == 'Premium' ? AppColors.languageIcon: AppColors.blueTagValue) : AppColors.branchTagLight,
      ),
      child: Text(
        type,
          // style: AppTextStyles.headingSmall,
        style: AppTextStyles.headingSmall(context).copyWith(
          color: isDark ? (type == 'Premium' ? AppColors.lightText: AppColors.blueTagText) : (type == 'Premium' ? AppColors.darkText: AppColors.blueTagText),
        ),
      ),
    );
  }
}
