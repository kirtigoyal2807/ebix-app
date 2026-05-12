import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pilates_app/config/theme/app_colors.dart';
import 'package:pilates_app/config/theme/app_spacing.dart';
import 'package:pilates_app/config/theme/app_text_styles.dart';
import 'package:pilates_app/core/localization/arb/app_localizations.dart';
import 'package:pilates_app/core/localization/localization_extension.dart';
import 'package:pilates_app/features/checkout/data/checkout_repository.dart';
import 'package:pilates_app/features/subscription/purchase_subscription/cubit/subscription_cubit.dart';
import 'package:pilates_app/features/subscription/purchase_subscription/view/widgets/api_health_questionnaire_blocks.dart';
import 'package:pilates_app/features/subscription/purchase_subscription/view/widgets/subscription_header.dart';
import 'package:pilates_app/features/subscription/purchase_subscription/view/widgets/subscription_health_wizard_step.dart';
import 'package:pilates_app/widgets/app_button.dart';
import 'package:pilates_app/widgets/app_text.dart';
import 'package:pilates_app/widgets/app_text_field.dart';
import 'package:pilates_app/widgets/inline_validation_banner.dart';

class GoalsView extends StatefulWidget {
  const GoalsView({super.key});

  @override
  State<GoalsView> createState() => _GoalsViewState();
}

class _GoalsViewState extends State<GoalsView> {
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
          p.goals != c.goals ||
          p.healthQuestionnaireAnswers != c.healthQuestionnaireAnswers,
      listener: (_, _) {
        if (mounted) setState(() => _validationMessage = null);
      },
      child: Padding(
        padding: EdgeInsets.symmetric(
          vertical: AppSpacing.lg,
          horizontal: AppSpacing.lg,
        ),
        child: Column(
          children: [
            Expanded(
              child: GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
                child: SingleChildScrollView(
                  keyboardDismissBehavior:
                      ScrollViewKeyboardDismissBehavior.onDrag,
                  child: BlocBuilder<SubscriptionCubit, SubscriptionState>(
                    buildWhen: (p, c) =>
                        p.healthQuestionnaireQuestions !=
                            c.healthQuestionnaireQuestions ||
                        p.selectedProductRequiresHealthIntake !=
                            c.selectedProductRequiresHealthIntake,
                    builder: (context, state) {
                      final intake = state.selectedProductRequiresHealthIntake;
                      final apiGoalsQs = pickQuestionsByIds(
                        state.healthQuestionnaireQuestions,
                        const [HealthQuestionnaireIds.goals],
                      );
                      final useApiGoals =
                          intake &&
                          !_questionnaireLoading &&
                          !_questionnaireLoadFailed &&
                          apiGoalsQs.isNotEmpty;
                      final showStaticLegacy = !intake;

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SubscriptionStepHeader(
                            wizardStep: SubscriptionHealthWizardStep.goals,
                            isDark: isDark,
                            showProgressCaption:
                                !intake || !_questionnaireLoading,
                          ),
                          SizedBox(height: AppSpacing.xl),
                          AppText(
                            l10n.goals,
                            style: (style) => AppTextStyles.gelasioMedium(
                              context,
                            ).copyWith(fontSize: 24, height: 1.2),
                          ),
                          SizedBox(height: AppSpacing.lg),
                          if (intake && _questionnaireLoading) ...[
                            Padding(
                              padding: EdgeInsets.symmetric(
                                vertical: AppSpacing.md,
                              ),
                              child: Center(
                                child: SizedBox(
                                  width: 28,
                                  height: 28,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                ),
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
                          if (useApiGoals) const ApiGoalsQuestionBlock(),
                          if (showStaticLegacy)
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildSectionHeader(
                                  context,
                                  l10n.whatIsYourGoal,
                                ),
                                Stack(
                                  children: [
                                    AppTextField(
                                      hint: l10n.enterYourGoals,
                                      label: '',
                                      maxLength: 200,
                                      onChanged: (val) {
                                        cubit.updateGoals(val);
                                        setState(
                                          () => _validationMessage = null,
                                        );
                                      },
                                      maxLines: 8,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                        ],
                      );
                    },
                  ),
                ),
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
                      final goalQs = pickQuestionsByIds(
                        cubit.state.healthQuestionnaireQuestions,
                        const [HealthQuestionnaireIds.goals],
                      );
                      if (intake) {
                        if (goalQs.isNotEmpty &&
                            !cubit.validateQuestionnaireGroup(goalQs)) {
                          setState(
                            () => _validationMessage =
                                context.l10n.giftRecipientValidationError,
                          );
                          return;
                        }
                      } else {
                        if (cubit.state.goals.trim().isEmpty) {
                          setState(
                            () => _validationMessage =
                                context.l10n.giftRecipientValidationError,
                          );
                          return;
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
