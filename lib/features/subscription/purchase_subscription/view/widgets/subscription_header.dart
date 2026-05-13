import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pilates_app/config/theme/app_colors.dart';
import 'package:pilates_app/config/theme/app_spacing.dart';
import 'package:pilates_app/config/theme/app_text_styles.dart';
import 'package:pilates_app/core/localization/localization_extension.dart';
import 'package:pilates_app/features/subscription/purchase_subscription/cubit/subscription_cubit.dart';
import 'package:pilates_app/features/subscription/purchase_subscription/health_questionnaire_query.dart';

import 'subscription_health_wizard_step.dart';
import 'subscription_progress.dart';

class SubscriptionStepHeader extends StatelessWidget {
  final SubscriptionHealthWizardStep wizardStep;
  final bool isDark;

  /// When false, hides the localized “Step … of …” line (previous behavior also used only
  /// the progress indicator in some sparse / loading shells).
  final bool showProgressCaption;

  const SubscriptionStepHeader({
    super.key,
    required this.wizardStep,
    required this.isDark,
    this.showProgressCaption = true,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SubscriptionCubit, SubscriptionState>(
      buildWhen: (previous, current) =>
          previous.healthQuestionnaireQuestions !=
              current.healthQuestionnaireQuestions ||
          previous.selectedProductRequiresHealthIntake !=
              current.selectedProductRequiresHealthIntake,
      builder: (context, state) {
        final captionStyle = AppTextStyles.caption(context);
        final chrome = subscriptionHealthWizardStepperChrome(
          selectedProductRequiresHealthIntake:
              state.selectedProductRequiresHealthIntake,
          questionnaireQuestions: state.healthQuestionnaireQuestions,
          shellStepNumber: wizardStep.questionnaireStepNumber,
        );
        final i = chrome.progressZeroBased;
        final total = chrome.totalSteps;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SubscriptionProgress(
              currentStep: i,
              totalSteps: total,
            ),
            if (showProgressCaption) ...[
              SizedBox(height: AppSpacing.sm),
              RichText(
                text: TextSpan(
                  style: captionStyle,
                  children: [
                    TextSpan(
                      text: '${context.l10n.step} ${i + 1}',
                      style: captionStyle.copyWith(
                        color: isDark
                            ? AppColors.languageTextDark
                            : AppColors.languageIcon,
                      ),
                    ),
                    TextSpan(
                      text: ' ${context.l10n.offf} $total',
                      style: captionStyle.copyWith(
                        color: isDark
                            ? AppColors.languageTextDark
                            : AppColors.darkText,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: AppSpacing.sm),
            ],
          ],
        );
      },
    );
  }
}
