import 'package:flutter/material.dart';
import 'package:pilates_app/config/theme/app_colors.dart';
import 'package:pilates_app/config/theme/app_spacing.dart';
import 'package:pilates_app/config/theme/app_text_styles.dart';
import 'package:pilates_app/widgets/app_text.dart';

import '../../../core/localization/localization_extension.dart';

class HelpSupportBottomSheet extends StatelessWidget {
  const HelpSupportBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final isRTL = Directionality.of(context) == TextDirection.rtl;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Material(
      color: isDark ? AppColors.homeBackground : Colors.white,
      borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
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
                  // Header
                  Padding(
                    padding: EdgeInsets.only(
                      left: isRTL ? AppSpacing.base : AppSpacing.lg,
                      right: isRTL ? AppSpacing.lg : AppSpacing.base,
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: AppText(
                            context.l10n.helpAndSupport,
                            style: AppTextStyles.bottomSheetTitle,
                          ),
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: IconButton(
                            icon: const Icon(Icons.close),
                            onPressed: () => Navigator.of(context).pop(),
                            color: AppColors.arrowIcon,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: AppSpacing.xl),

                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.lg,
                    ),
                    child: Column(
                      children: [
                        _HelpOption(
                          icon: Icons.chat_bubble_outline,
                          title: context.l10n.liveChat,
                          subtitle: context.l10n.liveChatDesc,
                          onTap: () {
                            Navigator.pop(context);
                          },
                        ),
                        const SizedBox(height: AppSpacing.md),

                        _HelpOption(
                          icon: Icons.alternate_email,
                          title: context.l10n.emailSupport,
                          subtitle: context.l10n.emailSupportDesc,
                          onTap: () {
                            Navigator.pop(context);
                          },
                        ),

                        const SizedBox(height: AppSpacing.md),

                        _HelpOption(
                          icon: Icons.phone_outlined,
                          title: context.l10n.phoneSupport,
                          subtitle: context.l10n.phoneSupportDesc,
                          onTap: () {
                            Navigator.pop(context);
                          },
                        ),

                        const SizedBox(height: AppSpacing.lg),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Bottom safe area with white background
            Container(
              width: double.infinity,
              color: Colors.white,
              height: MediaQuery.of(context).viewInsets.bottom,
            ),
          ],
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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return InkWell(
      onTap: onTap,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 2),
            child: Icon(
              icon,
              color: isDark
                  ? AppColors.languageIconDark
                  : theme.colorScheme.primary, // Brownish color from theme
            ),
          ),
          const SizedBox(width: AppSpacing.lg),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText(title, style: AppTextStyles.helpAndSupportItemLabel),
                const SizedBox(height: AppSpacing.xs),
                AppText(
                  subtitle,
                  style: AppTextStyles.helpAndSupportItemSubLabel,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
