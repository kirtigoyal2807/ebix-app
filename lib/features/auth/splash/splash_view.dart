import 'package:flutter/material.dart';
import 'package:pilates_app/config/theme/app_colors.dart';
import 'package:pilates_app/config/theme/app_spacing.dart';
import 'package:pilates_app/config/theme/app_text_styles.dart';
import 'package:pilates_app/core/localization/localization_extension.dart';
import 'package:pilates_app/widgets/app_text.dart';

class SplashView extends StatelessWidget {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = isDark
        ? AppColors.splashBackgroundDark
        : AppColors.splashBackgroundLight;

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Logo with border
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.lg,
                        vertical: AppSpacing.md,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: isDark
                              ? AppColors.splashBorderDark
                              : AppColors.splashBorderLight,
                          width: 1.0,
                        ),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          AppText(
                            context.l10n.splashAppName,
                            style: AppTextStyles.splashLogoTitle,
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: AppSpacing.xs),
                          AppText(
                            context.l10n.splashStudio,
                            style: AppTextStyles.splashStudio,
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    // Tagline
                    AppText(
                      context.l10n.splashTagline,
                      style: AppTextStyles.splashTagline,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
            // Version at bottom
            Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.lg),
              child: AppText(
                context.l10n.splashVersion,
                style: AppTextStyles.splashVersion,
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
