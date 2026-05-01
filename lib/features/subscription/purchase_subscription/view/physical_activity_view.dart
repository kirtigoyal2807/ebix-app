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

class PhysicalActivityView extends StatelessWidget {
  const PhysicalActivityView({super.key});

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
            child: BlocBuilder<SubscriptionCubit, SubscriptionState>(
              buildWhen: (p, c) =>
                  p.healthQuestionnaireQuestions !=
                      c.healthQuestionnaireQuestions ||
                  p.selectedProductRequiresHealthIntake !=
                      c.selectedProductRequiresHealthIntake,
              builder: (context, state) {
                final intake = state.selectedProductRequiresHealthIntake;

                return SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SubscriptionStepHeader(
                        currentStep: 2,
                        totalSteps: 6,
                        isDark: isDark,
                      ),
                      AppText(
                        l10n.physicalActivityLevel,
                        style: (style) => AppTextStyles.heading1(context),
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      if (intake) ...[
                        const ApiActivityLevelQuestionBlock(),
                        const SizedBox(height: AppSpacing.lg),
                      ] else ...[
                        _buildSectionHeader(context, l10n.doYouExerciseRegularly),
                        const SizedBox(height: AppSpacing.md),
                        BlocBuilder<SubscriptionCubit, SubscriptionState>(
                          buildWhen: (p, c) =>
                              p.exerciseRegularly != c.exerciseRegularly,
                          builder: (context, state) {
                            final c = context.read<SubscriptionCubit>();
                            return Column(
                              children: [
                                _buildRadioOption(
                                  context,
                                  l10n.yes,
                                  'yes',
                                  state.exerciseRegularly,
                                  c.updateExerciseRegularly,
                                ),
                                _buildRadioOption(
                                  context,
                                  l10n.sometimes,
                                  'sometimes',
                                  state.exerciseRegularly,
                                  c.updateExerciseRegularly,
                                ),
                                _buildRadioOption(
                                  context,
                                  l10n.no,
                                  'no',
                                  state.exerciseRegularly,
                                  c.updateExerciseRegularly,
                                ),
                              ],
                            );
                          },
                        ),
                        const SizedBox(height: 32),
                        BlocBuilder<SubscriptionCubit, SubscriptionState>(
                          buildWhen: (p, c) =>
                              p.exerciseRegularly != c.exerciseRegularly ||
                              p.activityFrequency != c.activityFrequency,
                          builder: (context, state) {
                            if (state.exerciseRegularly != 'yes' &&
                                state.exerciseRegularly != 'sometimes') {
                              return const SizedBox.shrink();
                            }
                            final c = context.read<SubscriptionCubit>();
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                AppText(
                                  l10n.ifYesHowManyTimes,
                                  style: (ctx) =>
                                      AppTextStyles.textFieldHeading(
                                        ctx,
                                        fontWeight: FontWeight.w400,
                                      ).copyWith(fontSize: 16, height: 1.4),
                                ),
                                const SizedBox(height: 16),
                                _buildFrequencyOption(
                                  context,
                                  l10n.daysAWeek(2),
                                  PhysicalActivityFrequency.twoDays,
                                  state.activityFrequency,
                                  c.updateActivityFrequency,
                                ),
                                _buildFrequencyOption(
                                  context,
                                  l10n.daysAWeek(3),
                                  PhysicalActivityFrequency.threeDays,
                                  state.activityFrequency,
                                  c.updateActivityFrequency,
                                ),
                                _buildFrequencyOption(
                                  context,
                                  l10n.daysAWeek(4),
                                  PhysicalActivityFrequency.fourDays,
                                  state.activityFrequency,
                                  c.updateActivityFrequency,
                                ),
                                _buildFrequencyOption(
                                  context,
                                  l10n.daysAWeek(5),
                                  PhysicalActivityFrequency.fiveDays,
                                  state.activityFrequency,
                                  c.updateActivityFrequency,
                                ),
                              ],
                            );
                          },
                        ),
                      ],
                    ],
                  ),
                );
              },
            ),
          ),
          AppButton(
            label: l10n.continueTxt,
            onPressed: () {
              final actQs = pickQuestionsByIds(
                cubit.state.healthQuestionnaireQuestions,
                const [HealthQuestionnaireIds.activityPilates],
              );
              if (actQs.isNotEmpty &&
                  !cubit.validateQuestionnaireGroup(
                    actQs,
                    requireEveryQuestionInGroup: true,
                  )) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(l10n.physicalActivityStepIncomplete),
                  ),
                );
                return;
              }
              final raw = cubit.state.healthQuestionnaireAnswers[
                  HealthQuestionnaireIds.activityPilates];
              if (raw is String && raw.trim().isNotEmpty) {
                cubit.updateExerciseRegularly(raw.trim());
              } else if (raw is bool) {
                cubit.updateExerciseRegularly(raw ? 'yes' : 'no');
              } else if (raw is List) {
                cubit.updateExerciseRegularly(
                  raw.map((e) => e.toString()).join(', '),
                );
              } else if (raw is Map) {
                final sel = raw['selected'];
                final other = raw['other'];
                final parts = <String>[];
                if (sel is List) {
                  parts.addAll(sel.map((e) => e.toString()));
                }
                if (other is String && other.trim().isNotEmpty) {
                  parts.add(other.trim());
                }
                if (parts.isNotEmpty) {
                  cubit.updateExerciseRegularly(parts.join(', '));
                }
              }
              if (!cubit.state.selectedProductRequiresHealthIntake &&
                  actQs.isEmpty) {
                final er = cubit.state.exerciseRegularly;
                if (er == null || er.trim().isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(l10n.physicalActivityStepIncomplete),
                    ),
                  );
                  return;
                }
                final low = er.trim().toLowerCase();
                if (low == 'yes' || low == 'sometimes') {
                  if (cubit.state.activityFrequency == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(l10n.physicalActivityStepIncomplete),
                      ),
                    );
                    return;
                  }
                }
              }
              cubit.nextStep();
            },
            buttonColor:isDark ?AppColors.primary: AppColors.primaryBrown,
            expanded: true,
          ),
        ],
      ),
    );
  }

  Widget _buildRadioOption(
    BuildContext context,
    String label,
    String value,
    String? groupValue,
    Function(String) onChanged,
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
                borderRadius: BorderRadius.circular(6), // Rounded square like checkboxes
                border: Border.all(
                  color: isSelected ? AppColors.primaryBrown : (isDark ? AppColors.greyText : AppColors.lightGreyBorder),
                  width: 1,
                ),
                color: isSelected ? AppColors.primaryBrown : isDark? AppColors.homeBackground:Colors.white,
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
                  fontWeight: FontWeight.w500
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFrequencyOption(
    BuildContext context,
    String label,
    PhysicalActivityFrequency value,
    PhysicalActivityFrequency? groupValue,
    Function(PhysicalActivityFrequency) onChanged,
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
                  color: isSelected ? AppColors.primaryBrown : (isDark ? AppColors.greyText : AppColors.lightGreyBorder),
                  width: 1,
                ),
                color: isSelected ? AppColors.primaryBrown : Colors.transparent,
              ),
               child: isSelected
                  ? const Icon(Icons.check, size: 16, color: Colors.white)
                  : null,
            ),
            const SizedBox(width: 12),
            AppText(
              label,
              style:(style)=> AppTextStyles.bodyTextSmall(context).copyWith(
                color: isDark ? AppColors.greyText : AppColors.greyText,
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
      style: (style) => AppTextStyles.textFieldHeading(context,fontWeight: FontWeight.w400,).copyWith(fontSize: 16,height: 1.4),
      maxLines: 4,
    );
  }

}
