import 'package:flutter/material.dart';
import 'package:pilates_app/config/theme/app_colors.dart';
import 'package:pilates_app/config/theme/app_radius.dart';

class SubscriptionProgress extends StatelessWidget {
  final int currentStep;
  final int totalSteps;

  const SubscriptionProgress({
    super.key,
    required this.currentStep,
    required this.totalSteps,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final progress = (currentStep + 1) / totalSteps;

    return ClipRRect(
      borderRadius: BorderRadius.circular(AppRadius.sm),
      child: LinearProgressIndicator(
        value: progress,
        minHeight: 6,
        backgroundColor: isDark
            ? AppColors.primaryDarkButton
            : AppColors.seekBarLight,
        valueColor: AlwaysStoppedAnimation<Color>(
          isDark ? AppColors.languageIconDark : AppColors.languageTextDark,
        ),
      ),
    );
  }
}
