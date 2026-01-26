import 'package:flutter/material.dart';
import 'package:pilates_app/config/theme/app_radius.dart';
import 'package:pilates_app/config/theme/app_spacing.dart';
import 'package:pilates_app/config/theme/app_text_styles.dart';
import 'package:pilates_app/widgets/app_text.dart';

class ExperienceOption extends StatelessWidget {
  final String title;
  final String description;
  final bool selected;
  final VoidCallback onTap;

  const ExperienceOption({
    super.key,
    required this.title,
    required this.description,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadius.lg),
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.lg),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppRadius.lg),
          border: Border.all(
            color: selected
                ? theme.colorScheme.primary
                : theme.dividerColor,
            width: selected ? 1.5 : 1,
          ),
          color: selected
              ? theme.colorScheme.primary.withOpacity(0.05)
              : theme.colorScheme.surface,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppText(
              title,
              style: AppTextStyles.body,
            ),
            const SizedBox(height: AppSpacing.xs),
            AppText(
              description,
              style: AppTextStyles.caption,
            ),
          ],
        ),
      ),
    );
  }
}
