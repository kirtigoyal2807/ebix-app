import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pilates_app/config/theme/app_colors.dart';
import 'package:pilates_app/config/theme/app_spacing.dart';
import 'package:pilates_app/config/theme/app_text_styles.dart';
import 'package:pilates_app/core/localization/arb/app_localizations.dart';
import 'package:pilates_app/features/checkout/data/checkout_repository.dart';
import 'package:pilates_app/features/subscription/purchase_subscription/cubit/subscription_cubit.dart';
import 'package:pilates_app/features/subscription/purchase_subscription/view/widgets/api_health_questionnaire_blocks.dart';
import 'package:pilates_app/features/subscription/purchase_subscription/view/widgets/subscription_header.dart';
import 'package:pilates_app/features/subscription/purchase_subscription/view/widgets/subscription_health_wizard_step.dart';
import 'package:pilates_app/widgets/app_button.dart';
import 'package:pilates_app/widgets/app_text.dart';
import 'package:pilates_app/widgets/inline_validation_banner.dart';
import 'package:pilates_app/widgets/app_loading_indicator.dart';

class PhysicalActivityView extends StatefulWidget {
  const PhysicalActivityView({super.key});

  @override
  State<PhysicalActivityView> createState() => _PhysicalActivityViewState();
}

class _PhysicalActivityViewState extends State<PhysicalActivityView> {
  String? _validationMessage;
  bool _questionnaireLoading = false;
  bool _questionnaireLoadFailed = false;

  bool _questionnaireHydrationScheduled = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_questionnaireHydrationScheduled) return;
    _questionnaireHydrationScheduled = true;
    final cubit = context.read<SubscriptionCubit>();
    final needFetch =
        cubit.state.selectedProductRequiresHealthIntake &&
        cubit.state.healthQuestionnaireQuestions.isEmpty;
    if (needFetch) {
      setState(() => _questionnaireLoading = true);
    }
    WidgetsBinding.instance.addPostFrameCallback((_) => _ensureQuestionnaire());
  }

  Future<void> _ensureQuestionnaire() async {
    if (!mounted) return;
    final cubit = context.read<SubscriptionCubit>();
    if (!cubit.state.selectedProductRequiresHealthIntake) {
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
    final ok = await cubit.fetchHealthQuestionnaireForCurrentProduct(repo);
    if (!mounted) return;
    setState(() {
      _questionnaireLoading = false;
      _questionnaireLoadFailed = !ok;
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final cubit = context.read<SubscriptionCubit>();
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return BlocListener<SubscriptionCubit, SubscriptionState>(
      listenWhen: (p, c) =>
          p.exerciseRegularly != c.exerciseRegularly ||
          p.activityFrequency != c.activityFrequency ||
          p.healthQuestionnaireAnswers != c.healthQuestionnaireAnswers,
      listener: (_, _) {
        if (mounted) setState(() => _validationMessage = null);
      },
      child: Padding(
        padding: EdgeInsets.symmetric(
          vertical: AppSpacing.xi,
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
                  final apiActivityQs = pickQuestionsByIds(
                    state.healthQuestionnaireQuestions,
                    const [HealthQuestionnaireIds.activityPilates],
                  );
                  final showStaticLegacy =
                      !intake && !state.isGiftRedeemIntakeFlow;
                  final useApiActivity =
                      intake &&
                      !_questionnaireLoading &&
                      !_questionnaireLoadFailed &&
                      apiActivityQs.isNotEmpty;

                  return SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SubscriptionStepHeader(
                          wizardStep:
                              SubscriptionHealthWizardStep.physicalActivity,
                          isDark: isDark,
                          showProgressCaption:
                              !intake || !_questionnaireLoading,
                        ),
                        SizedBox(height: AppSpacing.xl),
                        AppText(
                          l10n.physicalActivityLevel,
                          style: (style) => AppTextStyles.heading1(context),
                        ),
                        SizedBox(height: AppSpacing.lg),
                        if (intake && _questionnaireLoading) ...[
                          Padding(
                            padding: EdgeInsets.symmetric(
                              vertical: AppSpacing.md,
                            ),
                            child: Center(
                              child: AppInlineBusy(size: 28),
                            ),
                          ),
                        ],
                        if (intake &&
                            !_questionnaireLoading &&
                            _questionnaireLoadFailed) ...[
                          Padding(
                            padding: EdgeInsets.only(bottom: AppSpacing.md),
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
                                  onPressed: _ensureQuestionnaire,
                                  child: Text(l10n.retry),
                                ),
                              ],
                            ),
                          ),
                        ],
                        if (useApiActivity) ...[
                          const ApiActivityLevelQuestionBlock(),
                          SizedBox(height: AppSpacing.lg),
                        ],
                        if (showStaticLegacy) ...[
                          _buildSectionHeader(
                            context,
                            l10n.doYouExerciseRegularly,
                          ),
                          SizedBox(height: AppSpacing.md),
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
            if (_validationMessage != null)
              InlineValidationBanner(message: _validationMessage!),
            AppButton(
              label: l10n.continueTxt,
              onPressed:
                  !cubit.state.selectedProductRequiresHealthIntake ||
                      (!_questionnaireLoading && !_questionnaireLoadFailed)
                  ? () {
                      final intake =
                          cubit.state.selectedProductRequiresHealthIntake;
                      final actQs = pickQuestionsByIds(
                        cubit.state.healthQuestionnaireQuestions,
                        const [HealthQuestionnaireIds.activityPilates],
                      );
                      if (intake) {
                        if (actQs.isNotEmpty) {
                          if (!cubit.validateQuestionnaireGroup(
                            actQs,
                            requireEveryQuestionInGroup: true,
                          )) {
                            setState(
                              () => _validationMessage =
                                  l10n.physicalActivityStepIncomplete,
                            );
                            return;
                          }

                          final raw =
                              cubit
                                  .state
                                  .healthQuestionnaireAnswers[HealthQuestionnaireIds
                                  .activityPilates];
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
                        }
                      } else {
                        final er = cubit.state.exerciseRegularly;
                        if (er == null || er.trim().isEmpty) {
                          setState(
                            () => _validationMessage =
                                l10n.physicalActivityStepIncomplete,
                          );
                          return;
                        }
                        final low = er.trim().toLowerCase();
                        if (low == 'yes' || low == 'sometimes') {
                          if (cubit.state.activityFrequency == null) {
                            setState(
                              () => _validationMessage =
                                  l10n.physicalActivityStepIncomplete,
                            );
                            return;
                          }
                        }
                      }
                      setState(() => _validationMessage = null);
                      cubit.nextStep();
                    }
                  : null,
              buttonColor: isDark ? AppColors.primary : AppColors.primaryBrown,
              expanded: true,
            ),
          ],
        ),
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
                borderRadius: BorderRadius.circular(
                  6,
                ), // Rounded square like checkboxes
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
                  color: isSelected
                      ? AppColors.primaryBrown
                      : (isDark
                            ? AppColors.greyText
                            : AppColors.lightGreyBorder),
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
              style: (style) => AppTextStyles.bodyTextSmall(context).copyWith(
                color: isDark ? AppColors.greyText : AppColors.greyText,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return AppText(
      title,
      style: (style) => AppTextStyles.textFieldHeading(
        context,
        fontWeight: FontWeight.w400,
      ).copyWith(fontSize: 16, height: 1.4),
      maxLines: 4,
    );
  }
}
