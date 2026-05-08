import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pilates_app/config/theme/app_colors.dart';
import 'package:pilates_app/config/theme/app_spacing.dart';
import 'package:pilates_app/config/theme/app_text_styles.dart';
import 'package:pilates_app/widgets/app_text.dart';

import '../../../core/localization/localization_extension.dart';
import '../../../core/utils/support_launcher.dart';

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
                          svgImage: "assets/images/svg/explore/ic_chat.svg",
                          icon: Icons.chat_bubble_outline,
                          title: context.l10n.liveChat,
                          subtitle: context.l10n.liveChatDesc,
                          onTap: () => _openSupport(
                            context,
                            () => SupportLauncher.openWhatsApp(),
                          ),
                        ),
                        const SizedBox(height: AppSpacing.md),

                        _HelpOption(
                          svgImage: "assets/images/svg/explore/Ic_email.svg",
                          icon: Icons.alternate_email,
                          title: context.l10n.emailSupport,
                          subtitle: context.l10n.emailSupportDesc,
                          onTap: () => _openSupport(
                            context,
                            () => SupportLauncher.openEmail(),
                          ),
                        ),

                        const SizedBox(height: AppSpacing.md),

                        _HelpOption(
                          svgImage: "assets/images/svg/explore/ic_phone.svg",
                          icon: Icons.phone_outlined,
                          title: context.l10n.phoneSupport,
                          subtitle: context.l10n.phoneSupportDesc,
                          onTap: () => _openSupport(
                            context,
                            () => SupportLauncher.openPhone(),
                          ),
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

Future<void> _openSupport(
  BuildContext context,
  Future<bool> Function() launch,
) async {
  final messenger = ScaffoldMessenger.maybeOf(context);
  final message = context.l10n.loginErrorGeneric;
  Navigator.of(context).pop();
  final ok = await launch();
  if (ok) return;
  messenger?.showSnackBar(
    SnackBar(content: AppText(message, style: AppTextStyles.body)),
  );
}

class _HelpOption extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final String? svgImage;

  const _HelpOption({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.svgImage,
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
            child: svgImage != null
                ? SvgPicture.asset(
                    svgImage ?? "",
                    color: isDark
                        ? AppColors.languageIconDark
                        : AppColors.languageIcon,
                  )
                : Icon(
                    icon,
                    color: isDark
                        ? AppColors.languageIconDark
                        : AppColors.languageIcon, // Brownish color from theme
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
