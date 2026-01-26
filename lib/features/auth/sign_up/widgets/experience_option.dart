import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pilates_app/config/theme/app_radius.dart';
import 'package:pilates_app/config/theme/app_spacing.dart';
import 'package:pilates_app/config/theme/app_text_styles.dart';
import 'package:pilates_app/widgets/app_text.dart';

class ExperienceOption extends StatelessWidget {
  final String title;
  final String description;
  final String iconPath; // SVG path
  final bool selected;
  final VoidCallback onTap;

  const ExperienceOption({
    super.key,
    required this.title,
    required this.description,
    required this.iconPath,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.md),
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.md + 2,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppRadius.md),
            border: Border.all(
              color: selected
                  ? theme.colorScheme.primary
                  : theme.dividerColor.withOpacity(0.6),
              width: selected ? 1.5 : 1,
            ),
            color: selected
                ? theme.colorScheme.primary.withOpacity(0.06)
                : theme.colorScheme.surface,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              /// SVG ICON
              SvgPicture.asset(
                iconPath,
                width: 34,
                height: 34,
                colorFilter: ColorFilter.mode(
                  selected
                      ? theme.colorScheme.primary
                      : theme.hintColor,
                  BlendMode.srcIn,
                ),
                alignment: Alignment.center,
              ),

              const SizedBox(width: AppSpacing.md),

              /// TEXT
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppText(
                      title,
                      style: AppTextStyles.bottomSheet,
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    AppText(
                      description,
                      style: AppTextStyles.body,

                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
