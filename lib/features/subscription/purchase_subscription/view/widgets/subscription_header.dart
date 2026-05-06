import 'package:flutter/material.dart';
import 'package:pilates_app/config/theme/app_colors.dart';
import 'package:pilates_app/config/theme/app_spacing.dart';
import 'package:pilates_app/config/theme/app_text_styles.dart';
import 'package:pilates_app/core/localization/localization_extension.dart';

import 'subscription_progress.dart';

class SubscriptionStepHeader extends StatelessWidget {
  final int currentStep;
  final int totalSteps;
  final bool isDark;

  const SubscriptionStepHeader({
    super.key,
    required this.currentStep,
    required this.totalSteps,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SubscriptionProgress(currentStep: currentStep, totalSteps: totalSteps),

        const SizedBox(height: AppSpacing.sm),

        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: '${context.l10n.step} ${currentStep + 1}',
                style: AppTextStyles.caption(context).copyWith(
                  color: isDark
                      ? AppColors.languageTextDark
                      : AppColors.languageIcon,
                ),
              ),
              TextSpan(
                text: ' ${context.l10n.offf} $totalSteps',
                style: AppTextStyles.caption(context),
              ),
            ],
          ),
        ),

        const SizedBox(height: AppSpacing.xxl),
      ],
    );
  }
}
