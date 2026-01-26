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
      child: Material(
        color: Colors.white, // ✅ WHITE BACKGROUND
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(20),
        ),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  AppText(
                    context.l10n.helpAndSupport,
                    style: AppTextStyles.headline,
                  ),
                  IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Icon(
                        Icons.close,
                        color: Theme.of(context).hintColor,
                      ))
                ],
              ),
        
              const SizedBox(height: AppSpacing.lg),
        
              _HelpOption(
                icon: Icons.chat_bubble_outline,
                title: context.l10n.liveChat,
                subtitle: context.l10n.liveChatDesc,
                onTap: () {
                  // TODO: Hook live chat
                  Navigator.pop(context);
                },
              ),
        
              const SizedBox(height: AppSpacing.md),
        
              _HelpOption(
                icon: Icons.alternate_email,
                title: context.l10n.emailSupport,
                subtitle: context.l10n.emailSupportDesc,
                onTap: () {
                  // TODO: Hook email support
                  Navigator.pop(context);
                },
              ),
        
              const SizedBox(height: AppSpacing.md),
        
              _HelpOption(
                icon: Icons.phone_outlined,
                title: context.l10n.phoneSupport,
                subtitle: context.l10n.phoneSupportDesc,
                onTap: () {
                  // TODO: Hook call support
                  Navigator.pop(context);
                },
              ),
        
              const SizedBox(height: AppSpacing.lg),
            ],
          ),
        ),
      ),
    );
  }
}

class _HelpOption extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _HelpOption({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: onTap,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 2),
            child: Icon(
              icon,
              color: theme.colorScheme.primary, // Brownish color from theme
            ),
          ),
          const SizedBox(width: AppSpacing.lg),
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
                  subtitle,
                  style: AppTextStyles.body,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
