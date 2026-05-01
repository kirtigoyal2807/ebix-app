import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pilates_app/config/theme/app_colors.dart';
import 'package:pilates_app/config/theme/app_spacing.dart';
import 'package:pilates_app/config/theme/app_text_styles.dart';
import 'package:pilates_app/core/localization/arb/app_localizations.dart';
import 'package:pilates_app/core/localization/localization_extension.dart';
import 'package:pilates_app/features/subscription/purchase_subscription/cubit/subscription_cubit.dart';
import 'package:pilates_app/features/subscription/purchase_subscription/view/widgets/api_health_questionnaire_blocks.dart';
import 'package:pilates_app/features/subscription/purchase_subscription/view/widgets/subscription_header.dart';
import 'package:pilates_app/features/subscription/purchase_subscription/view/widgets/subscription_progress.dart';
import 'package:pilates_app/widgets/app_button.dart';
import 'package:pilates_app/widgets/app_text.dart';

class PregnancyView extends StatelessWidget {
  const PregnancyView({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final cubit = context.read<SubscriptionCubit>();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: AppSpacing.lg,
        horizontal: AppSpacing.lg,
      ),
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: BlocBuilder<SubscriptionCubit, SubscriptionState>(
                buildWhen: (p, c) =>
                    p.healthQuestionnaireQuestions !=
                        c.healthQuestionnaireQuestions ||
                    p.selectedProductRequiresHealthIntake !=
                        c.selectedProductRequiresHealthIntake,
                builder: (context, state) {
                  final intake = state.selectedProductRequiresHealthIntake;
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SubscriptionStepHeader(
                        currentStep: 3,
                        totalSteps: 6,
                        isDark: isDark,
                      ),
                      AppText(
                        l10n.pregnancy,
                        style: (style) => AppTextStyles.heading1(context),
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      if (intake) ...[
                        const ApiBooleanQuestionsBlock(
                          questionIds: [HealthQuestionnaireIds.pregnancy],
                        ),
                      ] else ...[
                        _buildSectionHeader(context, l10n.areYouPregnant),
                        const SizedBox(height: AppSpacing.md),
                        BlocBuilder<SubscriptionCubit, SubscriptionState>(
                          buildWhen: (p, c) => p.isPregnant != c.isPregnant,
                          builder: (context, state) {
                            return Column(
                              children: [
                                _buildRadioOption(
                                  context,
                                  l10n.yes,
                                  true,
                                  state.isPregnant,
                                  cubit.updateIsPregnant,
                                ),
                                _buildRadioOption(
                                  context,
                                  l10n.no,
                                  false,
                                  state.isPregnant,
                                  cubit.updateIsPregnant,
                                ),
                              ],
                            );
                          },
                        ),
                      ],
                    ],
                  );
                },
              ),
            ),
          ),
          AppButton(
            label: l10n.continueTxt,
            onPressed: () {
              final intake = cubit.state.selectedProductRequiresHealthIntake;
              if (intake) {
                final qs = pickQuestionsByIds(
                  cubit.state.healthQuestionnaireQuestions,
                  const [HealthQuestionnaireIds.pregnancy],
                );
                if (qs.isNotEmpty && !cubit.validateQuestionnaireGroup(qs)) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(l10n.giftRecipientValidationError)),
                  );
                  return;
                }
              } else {
                if (cubit.state.isPregnant == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(l10n.giftRecipientValidationError)),
                  );
                  return;
                }
              }
              cubit.nextStep();
            },
            buttonColor: isDark ? AppColors.primary : AppColors.primaryBrown,
            expanded: true,
          ),
        ],
      ),
    );
  }

  Widget _buildRadioOption(
    BuildContext context,
    String label,
    bool value,
    bool? groupValue,
    Function(bool) onChanged,
  ) {
    final isSelected = value == groupValue;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: GestureDetector(
        onTap: () => onChanged(value),
        child: Row(
          children: [
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6),
                border: Border.all(
                  color: isSelected
                      ? AppColors.primaryBrown
                      : (isDark
                            ? AppColors.greyText
                            : AppColors.lightGreyBorder),
                  width: 1,
                ),
                color: isSelected
                    ? AppColors.primaryBrown
                    : isDark
                    ? AppColors.homeBackground
                    : Colors.white,
              ),
              child: isSelected
                  ? const Icon(Icons.check, size: 14, color: Colors.white)
                  : null,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: AppText(
                label,
                style: (style) => AppTextStyles.bodyTextSmall(context).copyWith(
                  color: isDark ? AppColors.lightGrey : AppColors.lightGrey,
                  fontWeight: FontWeight.w500,
                  height: 1.5,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return AppText(
      title,
      style: (style) => AppTextStyles.bodyText(context).copyWith(
        fontWeight: FontWeight.w500,
        fontSize: 16,
        color: isDark ? AppColors.lightText : AppColors.darkText,
      ),
      maxLines: 4,
    );
  }
}
