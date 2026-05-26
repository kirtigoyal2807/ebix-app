import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pilates_app/config/theme/app_colors.dart';
import 'package:pilates_app/config/theme/app_spacing.dart';
import 'package:pilates_app/config/theme/app_text_styles.dart';
import 'package:pilates_app/core/localization/arb/app_localizations.dart';
import 'package:pilates_app/features/checkout/data/models/product_health_question.dart';
import 'package:pilates_app/features/subscription/purchase_subscription/cubit/subscription_cubit.dart';
import 'package:pilates_app/features/subscription/purchase_subscription/health_questionnaire_query.dart';
import 'package:pilates_app/widgets/app_text.dart';
import 'package:pilates_app/widgets/app_text_field.dart';

export 'package:pilates_app/features/subscription/purchase_subscription/health_questionnaire_query.dart';

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
            for (var i = 0; i < qs.length; i++) ...[
              _MedicalQuestionGroup(
                key: ValueKey(
                  'medical-q-${qs[i].id ?? qs[i].key ?? qs[i].order ?? i}',
                ),
                question: qs[i],
                isDark: isDark,
                answer: qs[i].numericQuestionId != null
                    ? state.healthQuestionnaireAnswers[qs[i].numericQuestionId!]
                    : null,
              ),
              if (i < qs.length - 1) SizedBox(height: AppSpacing.lg),
            ],
          ],
        );
      },
    );
  }
}

/// One API question — label and input stay in a single tight group.
class _MedicalQuestionGroup extends StatelessWidget {
  const _MedicalQuestionGroup({
    super.key,
    required this.question,
    required this.isDark,
    required this.answer,
  });

  final ProductHealthQuestion question;
  final bool isDark;
  final Object? answer;

  @override
  Widget build(BuildContext context) {
    return _MedicalQuestionBody(
      question: question,
      isDark: isDark,
      answer: answer,
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
      return _MedicalTextQuestion(question: question, rawAnswer: raw);
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
    final l10n = AppLocalizations.of(context);
    final rows = question.resolvedOptionRows;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText(
          '${question.displayLabel}${question.isRequired == true ? ' *' : ''}',
          style: (ctx) => AppTextStyles.bodyTextSmall(ctx).copyWith(
            fontSize: 16,
            height: 1.4,
            color: isDark ? AppColors.lightText : AppColors.darkText,
          ),
        ),
        SizedBox(height: AppSpacing.lmd),
        for (final row in rows)
          _MedicalOptionRow(
            label: row.label,
            isSelected: _answerContainsOption(rawAnswer, row.value),
            isDark: isDark,
            onTap: () {
              final on = !_answerContainsOption(rawAnswer, row.value);
              cubit.toggleHealthQuestionnaireOption(
                id,
                row.value,
                selected: on,
              );
            },
          ),
        if (question.allowOther == true) ...[
          SizedBox(height: AppSpacing.sm),
          AppTextField(
            hint: l10n.other,
            initialValue: _otherAnswerText(rawAnswer) ?? '',
            onChanged: (t) => cubit.setHealthQuestionnaireOtherText(id, t),
            showCharacterCounter: false,
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
            fontSize: 16,
            height: 1.4,
            color: isDark ? AppColors.lightText : AppColors.darkText,
          ),
        ),
        SizedBox(height: AppSpacing.lmd),
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

bool _isMedicalTextarea(ProductHealthQuestion q) {
  final t = q.type?.toLowerCase().trim() ?? '';
  return t == 'textarea' ||
      t == 'multi_line' ||
      t == 'multiline' ||
      t == 'text_area';
}

class _MedicalTextQuestion extends StatefulWidget {
  const _MedicalTextQuestion({required this.question, required this.rawAnswer});

  final ProductHealthQuestion question;
  final Object? rawAnswer;

  @override
  State<_MedicalTextQuestion> createState() => _MedicalTextQuestionState();
}

class _MedicalTextQuestionState extends State<_MedicalTextQuestion> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(
      text: widget.rawAnswer?.toString() ?? '',
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<SubscriptionCubit>();
    final q = widget.question;
    final id = q.numericQuestionId!;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final label = '${q.displayLabel}${q.isRequired == true ? ' *' : ''}';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        AppText(
          label,
          style: (ctx) => AppTextStyles.bodyTextSmall(ctx).copyWith(
            fontSize: 16,
            height: 1.4,
            color: isDark ? AppColors.lightText : AppColors.darkText,
          ),
        ),
        SizedBox(height: AppSpacing.lmd),
        AppTextField(
          controller: _controller,
          hint: q.displayLabel,
          maxLines: _isMedicalTextarea(q) ? 6 : 1,
          showCharacterCounter: false,
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
                  color: AppColors.lightGrey,
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
        final picked = pickQuestionsByIds(
          state.healthQuestionnaireQuestions,
          questionIds,
        );
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
              SizedBox(height: AppSpacing.lg),
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
    onChanged(true);
  }

  void _onNoTap() {
    onChanged(false);
  }

  @override
  Widget build(BuildContext context) {
    final label = question.displayLabel;
    final requiredMark = question.isRequired == true ? ' *' : '';
    final l10n = AppLocalizations.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        AppText(
          '$label$requiredMark',
          style: (ctx) => AppTextStyles.bodyTextSmall(ctx).copyWith(
            fontSize: 16,
            height: 1.4,
            color: isDark ? AppColors.lightText : AppColors.darkText,
          ),
        ),
        SizedBox(height: AppSpacing.lmd),
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
        return _MedicalQuestionBody(question: q, isDark: isDark, answer: raw);
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
    final l10n = AppLocalizations.of(context);
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
        SizedBox(height: AppSpacing.md),
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
