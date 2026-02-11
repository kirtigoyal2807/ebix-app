import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pilates_app/config/theme/app_colors.dart';
import 'package:pilates_app/config/theme/app_spacing.dart';
import 'package:pilates_app/config/theme/app_text_styles.dart';
import 'package:pilates_app/core/localization/arb/app_localizations.dart';
import 'package:pilates_app/core/localization/localization_extension.dart';
import 'package:pilates_app/features/subscription/purchase_subscription/cubit/subscription_cubit.dart';
import 'package:pilates_app/features/subscription/purchase_subscription/view/widgets/subscription_header.dart';
import 'package:pilates_app/features/subscription/purchase_subscription/view/widgets/subscription_progress.dart';
import 'package:pilates_app/widgets/app_button.dart';
import 'package:pilates_app/widgets/app_text.dart';

class MedicalHistoryView extends StatelessWidget {
  const MedicalHistoryView({super.key});

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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Progress
                  SubscriptionStepHeader(
                    currentStep: 1,
                    totalSteps: 6,
                    isDark: isDark,
                  ),

                  // Title
                  AppText(
                    l10n.medicalHistory,
                    style: (style) => AppTextStyles.heading1(context),
                  ),
                  const SizedBox(height: AppSpacing.lg),

                  // Section 1: Chronic Conditions
                  _buildSectionHeader(context, l10n.chronicConditions),
                  const SizedBox(height: AppSpacing.md),
                  BlocBuilder<SubscriptionCubit, SubscriptionState>(
                    buildWhen: (p, c) =>
                        p.chronicConditions != c.chronicConditions,
                    builder: (context, state) {
                      return Column(
                        children: [
                          _buildCheckbox(
                            context,
                            l10n.highBloodPressure,
                            'high_blood_pressure',
                            state.chronicConditions,
                            cubit.updateChronicCondition,
                          ),
                          _buildCheckbox(
                            context,
                            l10n.diabetes,
                            'diabetes',
                            state.chronicConditions,
                            cubit.updateChronicCondition,
                          ),
                          _buildCheckbox(
                            context,
                            l10n.heartDisease,
                            'heart_disease',
                            state.chronicConditions,
                            cubit.updateChronicCondition,
                          ),
                          _buildCheckbox(
                            context,
                            l10n.heartCondition,
                            'heart_condition',
                            state.chronicConditions,
                            cubit.updateChronicCondition,
                          ),
                          _buildCheckbox(
                            context,
                            l10n.noneOfTheAbove,
                            'none',
                            state.chronicConditions,
                            cubit.updateChronicCondition,
                          ),
                        ],
                      );
                    },
                  ),
                  const SizedBox(height: AppSpacing.lg),

                  // Section 2: Surgeries/Injuries
                  _buildSectionHeader(context, l10n.surgeriesInjuries),
                  const SizedBox(height: AppSpacing.md),
                  BlocBuilder<SubscriptionCubit, SubscriptionState>(
                    buildWhen: (p, c) =>
                        p.surgeriesInjuries != c.surgeriesInjuries,
                    builder: (context, state) {
                      return Column(
                        children: [
                          _buildCheckbox(
                            context,
                            l10n.highBloodPressure,
                            'high_blood_pressure',
                            state.surgeriesInjuries,
                            cubit.updateSurgeryInjury,
                          ),
                          // Reusing keys as per screenshot, likely different but using same for now as placeholders or reuse
                          _buildCheckbox(
                            context,
                            l10n.diabetes,
                            'diabetes',
                            state.surgeriesInjuries,
                            cubit.updateSurgeryInjury,
                          ),
                          _buildCheckbox(
                            context,
                            l10n.heartDisease,
                            'heart_disease',
                            state.surgeriesInjuries,
                            cubit.updateSurgeryInjury,
                          ),
                          _buildCheckbox(
                            context,
                            l10n.heartCondition,
                            'heart_condition',
                            state.surgeriesInjuries,
                            cubit.updateSurgeryInjury,
                          ),
                          _buildCheckbox(
                            context,
                            l10n.noneOfTheAbove,
                            'none',
                            state.surgeriesInjuries,
                            cubit.updateSurgeryInjury,
                          ),
                        ],
                      );
                    },
                  ),
                  const SizedBox(height: AppSpacing.lg),

                  // Section 3: Pain/Bones/Muscles
                  _buildSectionHeader(context, l10n.painBonesMuscles),
                  const SizedBox(height: AppSpacing.md),
                  BlocBuilder<SubscriptionCubit, SubscriptionState>(
                    buildWhen: (p, c) =>
                        p.painBonesMuscles != c.painBonesMuscles,
                    builder: (context, state) {
                      return Column(
                        children: [
                          _buildCheckbox(
                            context,
                            l10n.highBloodPressure,
                            'high_blood_pressure',
                            state.painBonesMuscles,
                            cubit.updatePainBoneMuscle,
                          ),
                          _buildCheckbox(
                            context,
                            l10n.diabetes,
                            'diabetes',
                            state.painBonesMuscles,
                            cubit.updatePainBoneMuscle,
                          ),
                        ],
                      );
                    },
                  ),
                  const SizedBox(height: AppSpacing.lg),

                  // Section 4: Respiratory
                  _buildSectionHeader(context, l10n.respiratoryProblems),
                  const SizedBox(height: AppSpacing.md),
                  BlocBuilder<SubscriptionCubit, SubscriptionState>(
                    buildWhen: (p, c) =>
                        p.respiratoryProblems != c.respiratoryProblems,
                    builder: (context, state) {
                      return Column(
                        children: [
                          _buildCheckbox(
                            context,
                            l10n.hearProblems,
                            'hear_problems',
                            state.respiratoryProblems,
                            cubit.updateRespiratoryProblem,
                          ),
                          _buildCheckbox(
                            context,
                            l10n.lungProblems,
                            'lung_problems',
                            state.respiratoryProblems,
                            cubit.updateRespiratoryProblem,
                          ),
                          _buildCheckbox(
                            context,
                            l10n.respiratoryProblem,
                            'respiratory_problems',
                            state.respiratoryProblems,
                            cubit.updateRespiratoryProblem,
                          ),
                          _buildCheckbox(
                            context,
                            l10n.noneOfTheAbove,
                            'none',
                            state.respiratoryProblems,
                            cubit.updateRespiratoryProblem,
                          ),
                        ],
                      );
                    },
                  ),
                  const SizedBox(height: AppSpacing.lg),

                  // Section 5: Medications - Regular
                  _buildSectionHeader(context, l10n.medications),
                  const SizedBox(height: AppSpacing.md),
                  BlocBuilder<SubscriptionCubit, SubscriptionState>(
                    buildWhen: (p, c) => p.medications != c.medications,
                    builder: (context, state) {
                      return Column(
                        children: [
                          _buildCheckbox(
                            context,
                            l10n.highBloodPressure,
                            'high_blood_pressure',
                            state.medications,
                            cubit.updateMedication,
                          ),
                          _buildCheckbox(
                            context,
                            l10n.diabetes,
                            'diabetes',
                            state.medications,
                            cubit.updateMedication,
                          ),
                          _buildCheckbox(
                            context,
                            l10n.heartDisease,
                            'heart_disease',
                            state.medications,
                            cubit.updateMedication,
                          ),
                          _buildCheckbox(
                            context,
                            l10n.heartCondition,
                            'heart_condition',
                            state.medications,
                            cubit.updateMedication,
                          ),
                          _buildCheckbox(
                            context,
                            l10n.noneOfTheAbove,
                            'none',
                            state.medications,
                            cubit.updateMedication,
                          ),
                        ],
                      );
                    },
                  ),
                  const SizedBox(height: AppSpacing.md),
                ],
              ),
            ),
          ),
          AppButton(
            label: l10n.continueTxt,
            onPressed: () {
              // Logic for finishing or next step
              cubit.nextStep(); // For now
            },
            buttonColor: AppColors.primaryBrown,
            expanded: true,
          ),
        ],
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

  Widget _buildCheckbox(
    BuildContext context,
    String label,
    String key,
    Map<String, bool> map,
    Function(String, bool?) onChanged,
  ) {
    final isChecked = map[key] ?? false;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: GestureDetector(
        onTap: () => onChanged(key, !isChecked),
        child: Row(
          children: [
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6),
                border: Border.all(
                  color: isChecked
                      ? AppColors.primaryBrown
                      : (isDark
                            ? AppColors.greyText
                            : AppColors.lightGreyBorder),
                  width: 1,
                ),
                color: isChecked ? AppColors.primaryBrown : isDark? AppColors.homeBackground:Colors.white,
              ),
              child: isChecked
                  ? const Icon(Icons.check, size: 14, color: Colors.white)
                  : null,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: AppText(
                label,
                style: (style) => AppTextStyles.bodyTextSmall(context).copyWith(
                  color: isDark ? AppColors.lightGrey : AppColors.lightGrey,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
