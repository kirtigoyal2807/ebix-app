import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pilates_app/config/theme/app_colors.dart';
import 'package:pilates_app/config/theme/app_spacing.dart';
import 'package:pilates_app/config/theme/app_text_styles.dart';
import 'package:pilates_app/core/localization/arb/app_localizations.dart';
import 'package:pilates_app/core/localization/localization_extension.dart';
import 'package:pilates_app/features/subscription/purchase_subscription/cubit/subscription_cubit.dart';
import 'package:pilates_app/features/checkout/data/checkout_repository.dart';
import 'package:pilates_app/features/checkout/data/models/product_health_questionnaire.dart';
import 'package:pilates_app/features/subscription/purchase_subscription/view/widgets/api_health_questionnaire_blocks.dart';
import 'package:pilates_app/features/subscription/purchase_subscription/view/widgets/subscription_header.dart';
import 'package:pilates_app/features/subscription/purchase_subscription/view/widgets/subscription_progress.dart';
import 'package:pilates_app/widgets/app_button.dart';
import 'package:pilates_app/widgets/app_text.dart';

class MedicalHistoryView extends StatefulWidget {
  const MedicalHistoryView({super.key});

  @override
  State<MedicalHistoryView> createState() => _MedicalHistoryViewState();
}

class _MedicalHistoryViewState extends State<MedicalHistoryView> {
  bool _questionnaireLoading = true;
  bool _questionnaireLoadFailed = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadQuestionnaire());
  }

  Future<void> _loadQuestionnaire() async {
    if (!mounted) return;
    final cubit = context.read<SubscriptionCubit>();
    if (!cubit.state.selectedProductRequiresHealthIntake) {
      setState(() {
        _questionnaireLoading = false;
        _questionnaireLoadFailed = false;
      });
      return;
    }
    final productId = cubit.resolvedHealthQuestionnaireProductId;
    if (productId <= 0) {
      setState(() {
        _questionnaireLoading = false;
        _questionnaireLoadFailed = false;
      });
      return;
    }

    if (cubit.state.healthQuestionnaireQuestions.isNotEmpty) {
      setState(() {
        _questionnaireLoading = false;
        _questionnaireLoadFailed = false;
      });
      return;
    }

    setState(() {
      _questionnaireLoading = true;
      _questionnaireLoadFailed = false;
    });

    final repo = context.read<CheckoutRepository>();
    final result = await repo.getQuestionsByProduct(productId: productId);

    if (!mounted) return;

    result.when(
      success: (data, _) {
        cubit.applyHealthQuestionnaire(data, fetchedForProductId: productId);
        setState(() {
          _questionnaireLoading = false;
          _questionnaireLoadFailed = false;
        });
      },
      failure: (_) {
        cubit.applyHealthQuestionnaire(const ProductHealthQuestionnaire());
        setState(() {
          _questionnaireLoading = false;
          _questionnaireLoadFailed = true;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
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
                final cubit = context.read<SubscriptionCubit>();
                final medicalQs =
                    medicalQuestionsFromApi(state.healthQuestionnaireQuestions);
                final hasApiMedical = medicalQs.isNotEmpty;
                final intake = state.selectedProductRequiresHealthIntake;
                /// Legacy checkboxes only when this product does not use API health intake.
                final showStaticLegacy =
                    !intake && !_questionnaireLoading;

                return SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SubscriptionStepHeader(
                        currentStep: 1,
                        totalSteps: 6,
                        isDark: isDark,
                      ),
                      AppText(
                        l10n.medicalHistory,
                        style: (style) => AppTextStyles.heading1(context),
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      if (_questionnaireLoading)
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: AppSpacing.md),
                          child: Center(
                            child: SizedBox(
                              width: 28,
                              height: 28,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            ),
                          ),
                        ),
                      if (!_questionnaireLoading &&
                          _questionnaireLoadFailed &&
                          !hasApiMedical &&
                          cubit.state.selectedProductRequiresHealthIntake)
                        Padding(
                          padding: const EdgeInsets.only(bottom: AppSpacing.md),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                child: AppText(
                                  l10n.loginErrorGeneric,
                                  style: (ctx) =>
                                      AppTextStyles.captionText(ctx),
                                ),
                              ),
                              TextButton(
                                onPressed: _loadQuestionnaire,
                                child: Text(l10n.retry),
                              ),
                            ],
                          ),
                        ),
                      if (!_questionnaireLoading && hasApiMedical)
                        const ApiDynamicMedicalQuestionsBlock(),
                      if (!_questionnaireLoading && hasApiMedical)
                        const SizedBox(height: AppSpacing.lg),
                      if (showStaticLegacy) ...[
                        _buildSectionHeader(context, l10n.chronicConditions),
                        const SizedBox(height: AppSpacing.md),
                        BlocBuilder<SubscriptionCubit, SubscriptionState>(
                          buildWhen: (p, c) =>
                              p.chronicConditions != c.chronicConditions,
                          builder: (context, state) {
                            final c = context.read<SubscriptionCubit>();
                            return Column(
                              children: [
                                _buildCheckbox(
                                  context,
                                  l10n.highBloodPressure,
                                  'high_blood_pressure',
                                  state.chronicConditions,
                                  c.updateChronicCondition,
                                ),
                                _buildCheckbox(
                                  context,
                                  l10n.diabetes,
                                  'diabetes',
                                  state.chronicConditions,
                                  c.updateChronicCondition,
                                ),
                                _buildCheckbox(
                                  context,
                                  l10n.heartDisease,
                                  'heart_disease',
                                  state.chronicConditions,
                                  c.updateChronicCondition,
                                ),
                                _buildCheckbox(
                                  context,
                                  l10n.heartCondition,
                                  'heart_condition',
                                  state.chronicConditions,
                                  c.updateChronicCondition,
                                ),
                                _buildCheckbox(
                                  context,
                                  l10n.noneOfTheAbove,
                                  'none',
                                  state.chronicConditions,
                                  c.updateChronicCondition,
                                ),
                              ],
                            );
                          },
                        ),
                        const SizedBox(height: AppSpacing.lg),
                        _buildSectionHeader(context, l10n.surgeriesInjuries),
                        const SizedBox(height: AppSpacing.md),
                        BlocBuilder<SubscriptionCubit, SubscriptionState>(
                          buildWhen: (p, c) =>
                              p.surgeriesInjuries != c.surgeriesInjuries,
                          builder: (context, state) {
                            final c = context.read<SubscriptionCubit>();
                            return Column(
                              children: [
                                _buildCheckbox(
                                  context,
                                  l10n.highBloodPressure,
                                  'high_blood_pressure',
                                  state.surgeriesInjuries,
                                  c.updateSurgeryInjury,
                                ),
                                _buildCheckbox(
                                  context,
                                  l10n.diabetes,
                                  'diabetes',
                                  state.surgeriesInjuries,
                                  c.updateSurgeryInjury,
                                ),
                                _buildCheckbox(
                                  context,
                                  l10n.heartDisease,
                                  'heart_disease',
                                  state.surgeriesInjuries,
                                  c.updateSurgeryInjury,
                                ),
                                _buildCheckbox(
                                  context,
                                  l10n.heartCondition,
                                  'heart_condition',
                                  state.surgeriesInjuries,
                                  c.updateSurgeryInjury,
                                ),
                                _buildCheckbox(
                                  context,
                                  l10n.noneOfTheAbove,
                                  'none',
                                  state.surgeriesInjuries,
                                  c.updateSurgeryInjury,
                                ),
                              ],
                            );
                          },
                        ),
                        const SizedBox(height: AppSpacing.lg),
                        _buildSectionHeader(context, l10n.painBonesMuscles),
                        const SizedBox(height: AppSpacing.md),
                        BlocBuilder<SubscriptionCubit, SubscriptionState>(
                          buildWhen: (p, c) =>
                              p.painBonesMuscles != c.painBonesMuscles,
                          builder: (context, state) {
                            final c = context.read<SubscriptionCubit>();
                            return Column(
                              children: [
                                _buildCheckbox(
                                  context,
                                  l10n.highBloodPressure,
                                  'high_blood_pressure',
                                  state.painBonesMuscles,
                                  c.updatePainBoneMuscle,
                                ),
                                _buildCheckbox(
                                  context,
                                  l10n.diabetes,
                                  'diabetes',
                                  state.painBonesMuscles,
                                  c.updatePainBoneMuscle,
                                ),
                              ],
                            );
                          },
                        ),
                        const SizedBox(height: AppSpacing.lg),
                        _buildSectionHeader(context, l10n.respiratoryProblems),
                        const SizedBox(height: AppSpacing.md),
                        BlocBuilder<SubscriptionCubit, SubscriptionState>(
                          buildWhen: (p, c) =>
                              p.respiratoryProblems != c.respiratoryProblems,
                          builder: (context, state) {
                            final c = context.read<SubscriptionCubit>();
                            return Column(
                              children: [
                                _buildCheckbox(
                                  context,
                                  l10n.hearProblems,
                                  'hear_problems',
                                  state.respiratoryProblems,
                                  c.updateRespiratoryProblem,
                                ),
                                _buildCheckbox(
                                  context,
                                  l10n.lungProblems,
                                  'lung_problems',
                                  state.respiratoryProblems,
                                  c.updateRespiratoryProblem,
                                ),
                                _buildCheckbox(
                                  context,
                                  l10n.respiratoryProblem,
                                  'respiratory_problems',
                                  state.respiratoryProblems,
                                  c.updateRespiratoryProblem,
                                ),
                                _buildCheckbox(
                                  context,
                                  l10n.noneOfTheAbove,
                                  'none',
                                  state.respiratoryProblems,
                                  c.updateRespiratoryProblem,
                                ),
                              ],
                            );
                          },
                        ),
                        const SizedBox(height: AppSpacing.lg),
                        _buildSectionHeader(context, l10n.medications),
                        const SizedBox(height: AppSpacing.md),
                        BlocBuilder<SubscriptionCubit, SubscriptionState>(
                          buildWhen: (p, c) => p.medications != c.medications,
                          builder: (context, state) {
                            final c = context.read<SubscriptionCubit>();
                            return Column(
                              children: [
                                _buildCheckbox(
                                  context,
                                  l10n.highBloodPressure,
                                  'high_blood_pressure',
                                  state.medications,
                                  c.updateMedication,
                                ),
                                _buildCheckbox(
                                  context,
                                  l10n.diabetes,
                                  'diabetes',
                                  state.medications,
                                  c.updateMedication,
                                ),
                                _buildCheckbox(
                                  context,
                                  l10n.heartDisease,
                                  'heart_disease',
                                  state.medications,
                                  c.updateMedication,
                                ),
                                _buildCheckbox(
                                  context,
                                  l10n.heartCondition,
                                  'heart_condition',
                                  state.medications,
                                  c.updateMedication,
                                ),
                                _buildCheckbox(
                                  context,
                                  l10n.noneOfTheAbove,
                                  'none',
                                  state.medications,
                                  c.updateMedication,
                                ),
                              ],
                            );
                          },
                        ),
                        const SizedBox(height: AppSpacing.md),
                      ],
                    ],
                  ),
                );
              },
            ),
          ),
          BlocBuilder<SubscriptionCubit, SubscriptionState>(
            buildWhen: (p, c) =>
                p.healthQuestionnaireQuestions !=
                    c.healthQuestionnaireQuestions ||
                p.selectedProductRequiresHealthIntake !=
                    c.selectedProductRequiresHealthIntake,
            builder: (context, state) {
              final intake = state.selectedProductRequiresHealthIntake;
              final hasApiMedical = medicalQuestionsFromApi(
                state.healthQuestionnaireQuestions,
              ).isNotEmpty;
              final disableContinue = intake &&
                  !_questionnaireLoading &&
                  _questionnaireLoadFailed &&
                  !hasApiMedical;
              return AppButton(
                label: l10n.continueTxt,
                onPressed: disableContinue
                    ? null
                    : () {
                        final cubit = context.read<SubscriptionCubit>();
                        final medicalQs = medicalQuestionsFromApi(
                          cubit.state.healthQuestionnaireQuestions,
                        );
                        if (medicalQs.isNotEmpty &&
                            !cubit.validateQuestionnaireGroup(medicalQs)) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(l10n.giftRecipientValidationError),
                            ),
                          );
                          return;
                        }
                        cubit.nextStep();
                      },
                buttonColor:
                    isDark ? AppColors.primary : AppColors.primaryBrown,
                expanded: true,
              );
            },
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
        fontWeight: FontWeight.w400,
        fontSize: 16,
        color: isDark ? AppColors.lightText : AppColors.darkText,
        height: 1.4,
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
                color: isChecked
                    ? AppColors.primaryBrown
                    : isDark
                    ? AppColors.homeBackground
                    : Colors.white,
              ),
              child: isChecked
                  ? const Icon(Icons.check, size: 14, color: Colors.white)
                  : null,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: AppText(
                label,
                style: (style) => AppTextStyles.bodyTextSmall(context,   fontWeight: FontWeight.w500,).copyWith(
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
