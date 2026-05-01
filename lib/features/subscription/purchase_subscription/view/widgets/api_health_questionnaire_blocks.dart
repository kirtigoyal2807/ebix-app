import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pilates_app/config/theme/app_colors.dart';
import 'package:pilates_app/config/theme/app_spacing.dart';
import 'package:pilates_app/config/theme/app_text_styles.dart';
import 'package:pilates_app/core/localization/arb/app_localizations.dart';
import 'package:pilates_app/features/checkout/data/models/product_health_question.dart';
import 'package:pilates_app/features/subscription/purchase_subscription/cubit/subscription_cubit.dart';
import 'package:pilates_app/widgets/app_text.dart';
import 'package:pilates_app/widgets/app_text_field.dart';

/// Question ids for the default "12 Session Health Form" product schema.
abstract final class HealthQuestionnaireIds {
  static const injuriesSurgeries = 1;
  static const pregnancy = 2;
  static const goals = 3;
  static const medicalConditions = 4;
  static const activityPilates = 5;
}

List<ProductHealthQuestion> pickQuestionsByIds(
  List<ProductHealthQuestion> all,
  List<int> ids,
) {
  final byId = <int, ProductHealthQuestion>{};
  for (final q in all) {
    final n = q.numericQuestionId;
    if (n != null) {
      byId[n] = q;
    }
  }
  return [for (final id in ids) if (byId[id] != null) byId[id]!];
}

/// All questions for the Medical History step from
/// `GET …/questionnaires/product/{id}` except ids owned by other steps.
List<ProductHealthQuestion> medicalQuestionsFromApi(
  List<ProductHealthQuestion> all,
) {
  const reservedForOtherSteps = <int>{
    HealthQuestionnaireIds.pregnancy,
    HealthQuestionnaireIds.goals,
    HealthQuestionnaireIds.activityPilates,
  };
  final filtered = all.where((q) {
    final id = q.numericQuestionId;
    if (id == null) return false;
    if (q.isPersonalInformationEnvelopeField) return false;
    return !reservedForOtherSteps.contains(id);
  }).toList();
  int sortKey(ProductHealthQuestion q) =>
      q.order ?? q.numericQuestionId ?? 0;
  filtered.sort((a, b) => sortKey(a).compareTo(sortKey(b)));
  return filtered;
}

bool _answerContainsOption(Object? raw, String option) {
  if (raw == null) return false;
  if (raw is List) {
    return raw.map((e) => e.toString()).contains(option);
  }
  if (raw is Map) {
    final sel = raw['selected'];
    if (sel is List) {
      return sel.map((e) => e.toString()).contains(option);
    }
  }
  return false;
}

String? _otherAnswerText(Object? raw) {
  if (raw is Map && raw['other'] is String) {
    return raw['other'] as String;
  }
  return null;
}

/// Renders [medicalQuestionsFromApi] with boolean / checkbox / radio / text
/// driven entirely by the product questionnaire payload.
class ApiDynamicMedicalQuestionsBlock extends StatelessWidget {
  const ApiDynamicMedicalQuestionsBlock({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return BlocBuilder<SubscriptionCubit, SubscriptionState>(
      buildWhen: (p, c) =>
          p.healthQuestionnaireQuestions != c.healthQuestionnaireQuestions ||
          p.healthQuestionnaireAnswers != c.healthQuestionnaireAnswers ||
          p.healthQuestionnaireAnswerNotes != c.healthQuestionnaireAnswerNotes,
      builder: (context, state) {
        final qs = medicalQuestionsFromApi(state.healthQuestionnaireQuestions);
        if (qs.isEmpty) {
          return const SizedBox.shrink();
        }
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (final q in qs) ...[
              _MedicalQuestionBody(
                question: q,
                isDark: isDark,
                answer: q.numericQuestionId != null
                    ? state.healthQuestionnaireAnswers[q.numericQuestionId!]
                    : null,
              ),
              const SizedBox(height: AppSpacing.lg),
            ],
          ],
        );
      },
    );
  }
}

class _MedicalQuestionBody extends StatelessWidget {
  const _MedicalQuestionBody({
    required this.question,
    required this.isDark,
    required this.answer,
  });

  final ProductHealthQuestion question;
  final bool isDark;
  final Object? answer;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<SubscriptionCubit>();
    final id = question.numericQuestionId;
    if (id == null) {
      return const SizedBox.shrink();
    }
    final raw = answer;

    if (question.isCheckboxQuestion && question.resolvedOptionRows.isNotEmpty) {
      return ApiCheckboxQuestionBlock(
        question: question,
        rawAnswer: raw,
        isDark: isDark,
      );
    }
    if (question.isRadioQuestion && question.resolvedOptionRows.isNotEmpty) {
      return _MedicalRadioQuestion(
        question: question,
        rawAnswer: raw,
        isDark: isDark,
      );
    }
    if (question.isFreeTextQuestion) {
      return _MedicalTextQuestion(
        question: question,
        rawAnswer: raw,
      );
    }
    if (question.isBooleanQuestion ||
        (question.isCheckboxQuestion && question.resolvedOptionRows.isEmpty)) {
      return _BooleanYesNoRow(
        question: question,
        value: _asBool(raw),
        onChanged: (v) => cubit.setHealthQuestionnaireAnswer(id, v),
        isDark: isDark,
      );
    }
    return _BooleanYesNoRow(
      question: question,
      value: _asBool(raw),
      onChanged: (v) => cubit.setHealthQuestionnaireAnswer(id, v),
      isDark: isDark,
    );
  }
}

/// Checkbox (+ optional "Other" text) driven by [ProductHealthQuestion.options].
class ApiCheckboxQuestionBlock extends StatelessWidget {
  const ApiCheckboxQuestionBlock({
    super.key,
    required this.question,
    required this.rawAnswer,
    required this.isDark,
  });

  final ProductHealthQuestion question;
  final Object? rawAnswer;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<SubscriptionCubit>();
    final id = question.numericQuestionId!;
    final l10n = AppLocalizations.of(context)!;
    final rows = question.resolvedOptionRows;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText(
          '${question.displayLabel}${question.isRequired == true ? ' *' : ''}',
          style: (ctx) => AppTextStyles.bodyTextSmall(ctx).copyWith(
            fontWeight: FontWeight.w600,
            color: isDark ? AppColors.lightText : AppColors.darkText,
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        for (final row in rows)
          _MedicalOptionRow(
            label: row.label,
            isSelected: _answerContainsOption(rawAnswer, row.value),
            isDark: isDark,
            onTap: () {
              final on = !_answerContainsOption(rawAnswer, row.value);
              cubit.toggleHealthQuestionnaireOption(id, row.value, selected: on);
            },
          ),
        if (question.allowOther == true) ...[
          const SizedBox(height: AppSpacing.sm),
          AppTextField(
            label: '',
            hint: l10n.other,
            initialValue: _otherAnswerText(rawAnswer) ?? '',
            onChanged: (t) => cubit.setHealthQuestionnaireOtherText(id, t),
          ),
        ],
      ],
    );
  }
}

class _MedicalRadioQuestion extends StatelessWidget {
  const _MedicalRadioQuestion({
    required this.question,
    required this.rawAnswer,
    required this.isDark,
  });

  final ProductHealthQuestion question;
  final Object? rawAnswer;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<SubscriptionCubit>();
    final id = question.numericQuestionId!;
    final group = rawAnswer is String ? rawAnswer as String : null;
    final rows = question.resolvedOptionRows;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText(
          '${question.displayLabel}${question.isRequired == true ? ' *' : ''}',
          style: (ctx) => AppTextStyles.bodyTextSmall(ctx).copyWith(
            fontWeight: FontWeight.w600,
            color: isDark ? AppColors.lightText : AppColors.darkText,
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        for (final row in rows)
          _MedicalOptionRow(
            label: row.label,
            isSelected: group == row.value,
            isDark: isDark,
            onTap: () => cubit.setHealthQuestionnaireAnswer(id, row.value),
          ),
      ],
    );
  }
}

class _MedicalTextQuestion extends StatelessWidget {
  const _MedicalTextQuestion({
    required this.question,
    required this.rawAnswer,
  });

  final ProductHealthQuestion question;
  final Object? rawAnswer;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<SubscriptionCubit>();
    final id = question.numericQuestionId!;
    final text = rawAnswer?.toString() ?? '';
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText(
          '${question.displayLabel}${question.isRequired == true ? ' *' : ''}',
          style: (ctx) => AppTextStyles.bodyTextSmall(ctx).copyWith(
            fontWeight: FontWeight.w600,
            color: isDark ? AppColors.lightText : AppColors.darkText,
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        AppTextField(
          label: '',
          hint: question.displayLabel,
          initialValue: text,
          maxLines: question.type?.toLowerCase().trim() == 'textarea' ? 6 : 1,
          onChanged: (val) => cubit.setHealthQuestionnaireAnswer(id, val),
        ),
      ],
    );
  }
}

class _MedicalOptionRow extends StatelessWidget {
  const _MedicalOptionRow({
    required this.label,
    required this.isSelected,
    required this.isDark,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final bool isDark;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: GestureDetector(
        onTap: onTap,
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
                ),
                color: isSelected
                    ? AppColors.primaryBrown
                    : (isDark ? AppColors.homeBackground : Colors.white),
              ),
              child: isSelected
                  ? const Icon(Icons.check, size: 14, color: Colors.white)
                  : null,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: AppText(
                label,
                style: (ctx) => AppTextStyles.bodyTextSmall(ctx).copyWith(
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
}

/// Yes/No API questions for the given [questionIds] (e.g. medical step: 1, 4).
class ApiBooleanQuestionsBlock extends StatelessWidget {
  const ApiBooleanQuestionsBlock({super.key, required this.questionIds});

  final List<int> questionIds;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return BlocBuilder<SubscriptionCubit, SubscriptionState>(
      buildWhen: (p, c) =>
          p.healthQuestionnaireQuestions != c.healthQuestionnaireQuestions ||
          p.healthQuestionnaireAnswers != c.healthQuestionnaireAnswers ||
          p.healthQuestionnaireAnswerNotes != c.healthQuestionnaireAnswerNotes,
      builder: (context, state) {
        final picked =
            pickQuestionsByIds(state.healthQuestionnaireQuestions, questionIds);
        if (picked.isEmpty) {
          return const SizedBox.shrink();
        }
        final cubit = context.read<SubscriptionCubit>();
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (final q in picked) ...[
              _BooleanYesNoRow(
                question: q,
                value: _asBool(
                  q.numericQuestionId != null
                      ? state.healthQuestionnaireAnswers[q.numericQuestionId!]
                      : null,
                ),
                onChanged: (v) {
                  final id = q.numericQuestionId;
                  if (id != null) {
                    cubit.setHealthQuestionnaireAnswer(id, v);
                  }
                },
                isDark: isDark,
              ),
              const SizedBox(height: AppSpacing.lg),
            ],
          ],
        );
      },
    );
  }
}

bool? _asBool(Object? v) {
  if (v is bool) return v;
  return null;
}

class _BooleanAnswerExplainField extends StatefulWidget {
  const _BooleanAnswerExplainField({required this.questionId});

  final int questionId;

  @override
  State<_BooleanAnswerExplainField> createState() =>
      _BooleanAnswerExplainFieldState();
}

class _BooleanAnswerExplainFieldState extends State<_BooleanAnswerExplainField> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    final initial = context
            .read<SubscriptionCubit>()
            .state
            .healthQuestionnaireAnswerNotes[widget.questionId] ??
        '';
    _controller = TextEditingController(text: initial);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final cubit = context.read<SubscriptionCubit>();
    return AppTextField(
      label: '',
      hint: l10n.healthAnswerExplainHint,
      controller: _controller,
      maxLines: 4,
      onChanged: (t) => cubit.setHealthQuestionnaireAnswerNote(widget.questionId, t),
    );
  }
}

class _BooleanYesNoRow extends StatelessWidget {
  const _BooleanYesNoRow({
    required this.question,
    required this.value,
    required this.onChanged,
    required this.isDark,
  });

  final ProductHealthQuestion question;
  final bool? value;
  final ValueChanged<bool?> onChanged;
  final bool isDark;

  void _onYesTap() {
    final required = question.isRequired == true;
    if (!required && value == true) {
      onChanged(null);
    } else {
      onChanged(true);
    }
  }

  void _onNoTap() {
    final required = question.isRequired == true;
    if (!required && value == false) {
      onChanged(null);
    } else {
      onChanged(false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final label = question.displayLabel;
    final requiredMark = question.isRequired == true ? ' *' : '';
    final l10n = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText(
          '$label$requiredMark',
          style: (ctx) => AppTextStyles.bodyTextSmall(ctx).copyWith(
            fontWeight: FontWeight.w600,
            color: isDark ? AppColors.lightText : AppColors.darkText,
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        _MedicalOptionRow(
          label: l10n.yes,
          isSelected: value == true,
          isDark: isDark,
          onTap: _onYesTap,
        ),
        _MedicalOptionRow(
          label: l10n.no,
          isSelected: value == false,
          isDark: isDark,
          onTap: _onNoTap,
        ),
        if (value == true &&
            question.numericQuestionId != null &&
            question.allowOther == true) ...[
          const SizedBox(height: AppSpacing.md),
          _BooleanAnswerExplainField(
            questionId: question.numericQuestionId!,
          ),
        ],
      ],
    );
  }
}

/// Physical activity step: question id [HealthQuestionnaireIds.activityPilates]
/// rendered from API `type` / `options` (boolean, radio, checkbox, text) — same
/// behaviour as [ApiDynamicMedicalQuestionsBlock] / [_MedicalQuestionBody].
class ApiActivityLevelQuestionBlock extends StatelessWidget {
  const ApiActivityLevelQuestionBlock({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return BlocBuilder<SubscriptionCubit, SubscriptionState>(
      buildWhen: (p, c) =>
          p.healthQuestionnaireQuestions != c.healthQuestionnaireQuestions ||
          p.healthQuestionnaireAnswers != c.healthQuestionnaireAnswers ||
          p.healthQuestionnaireAnswerNotes != c.healthQuestionnaireAnswerNotes,
      builder: (context, state) {
        final picked = pickQuestionsByIds(
          state.healthQuestionnaireQuestions,
          const [HealthQuestionnaireIds.activityPilates],
        );
        if (picked.isEmpty) {
          return const SizedBox.shrink();
        }
        final q = picked.first;
        final id = q.numericQuestionId;
        if (id == null) {
          return const SizedBox.shrink();
        }
        final raw = state.healthQuestionnaireAnswers[id];
        return _MedicalQuestionBody(
          question: q,
          isDark: isDark,
          answer: raw,
        );
      },
    );
  }
}

/// Goals step (questionnaire id 3): API may send [checkbox] + options + allowOther,
/// free text, or boolean — UI follows [ProductHealthQuestion.type].
class ApiGoalsQuestionBlock extends StatelessWidget {
  const ApiGoalsQuestionBlock({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return BlocBuilder<SubscriptionCubit, SubscriptionState>(
      buildWhen: (p, c) =>
          p.healthQuestionnaireQuestions != c.healthQuestionnaireQuestions ||
          p.healthQuestionnaireAnswers != c.healthQuestionnaireAnswers ||
          p.healthQuestionnaireAnswerNotes != c.healthQuestionnaireAnswerNotes,
      builder: (context, state) {
        final picked = pickQuestionsByIds(
          state.healthQuestionnaireQuestions,
          const [HealthQuestionnaireIds.goals],
        );
        if (picked.isEmpty) {
          return const SizedBox.shrink();
        }
        final q = picked.first;
        final id = q.numericQuestionId!;
        final raw = state.healthQuestionnaireAnswers[id];
        final cubit = context.read<SubscriptionCubit>();

        if (q.isCheckboxQuestion && q.resolvedOptionRows.isNotEmpty) {
          return ApiCheckboxQuestionBlock(
            question: q,
            rawAnswer: raw,
            isDark: isDark,
          );
        }
        if (q.isBooleanQuestion) {
          return _BooleanYesNoRow(
            question: q,
            value: _asBool(raw),
            onChanged: (v) => cubit.setHealthQuestionnaireAnswer(id, v),
            isDark: isDark,
          );
        }
        return _ApiGoalsFreeTextBlock(question: q);
      },
    );
  }
}

class _ApiGoalsFreeTextBlock extends StatefulWidget {
  const _ApiGoalsFreeTextBlock({required this.question});

  final ProductHealthQuestion question;

  @override
  State<_ApiGoalsFreeTextBlock> createState() => _ApiGoalsFreeTextBlockState();
}

class _ApiGoalsFreeTextBlockState extends State<_ApiGoalsFreeTextBlock> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    final initial = context.read<SubscriptionCubit>().state.goals;
    _controller = TextEditingController(text: initial);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;
    final cubit = context.read<SubscriptionCubit>();
    final q = widget.question;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText(
          '${q.displayLabel}${q.isRequired == true ? ' *' : ''}',
          style: (ctx) => AppTextStyles.bodyText(ctx).copyWith(
            fontWeight: FontWeight.w500,
            fontSize: 16,
            color: isDark ? AppColors.lightText : AppColors.darkText,
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        AppTextField(
          controller: _controller,
          hint: l10n.enterYourGoals,
          label: '',
          maxLength: 200,
          maxLines: 8,
          onChanged: (val) {
            cubit.updateGoals(val);
            cubit.setHealthQuestionnaireAnswer(
              HealthQuestionnaireIds.goals,
              val,
            );
          },
        ),
      ],
    );
  }
}
