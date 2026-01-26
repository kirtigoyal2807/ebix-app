import 'package:flutter/material.dart';
import 'package:pilates_app/config/theme/app_radius.dart';
import 'package:pilates_app/config/theme/app_spacing.dart';
import 'package:pilates_app/config/theme/app_text_styles.dart';
import 'package:pilates_app/widgets/app_text.dart';

import '../../../core/localization/localization_extension.dart';

class HelpSupportBottomSheet extends StatelessWidget {
  const HelpSupportBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Handle
            Center(
              child: Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(
                  bottom: AppSpacing.lg,
                ),
                decoration: BoxDecoration(
                  color: Theme.of(context).dividerColor,
                  borderRadius: BorderRadius.circular(AppRadius.sm),
                ),
              ),
            ),

            // Title
            AppText(
              context.l10n.helpAndSupport,
              style: AppTextStyles.headline,
            ),

            const SizedBox(height: AppSpacing.lg),

            _HelpOption(
              icon: Icons.chat_bubble_outline,
              title: context.l10n.liveChat,
              onTap: () {
                // TODO: Hook live chat
                Navigator.pop(context);
              },
            ),

            const SizedBox(height: AppSpacing.md),

            _HelpOption(
              icon: Icons.email_outlined,
              title: context.l10n.emailSupport,
              onTap: () {
                // TODO: Hook email support
                Navigator.pop(context);
              },
            ),

            const SizedBox(height: AppSpacing.md),

            _HelpOption(
              icon: Icons.call_outlined,
              title: context.l10n.callSupport,
              onTap: () {
                // TODO: Hook call support
                Navigator.pop(context);
              },
            ),

            const SizedBox(height: AppSpacing.lg),
          ],
        ),
      ),
    );
  }
}


class _HelpOption extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const _HelpOption({
    required this.icon,
    required this.title,
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
            color: theme.dividerColor,
          ),
          color: theme.colorScheme.surface,
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: theme.colorScheme.primary,
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: AppText(
                title,
                style: AppTextStyles.body,
              ),
            ),
            Icon(
              Icons.chevron_right,
              color: theme.hintColor,
            ),
          ],
        ),
      ),
    );
  }
}
