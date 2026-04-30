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
          p.healthQuestionnaireAnswers != c.healthQuestionnaireAnswers,
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
        const SizedBox(height: AppSpacing.sm),
        Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: () => onChanged(true),
                style: OutlinedButton.styleFrom(
                  backgroundColor: value == true
                      ? (isDark ? AppColors.primary : AppColors.primaryBrown)
                      : Colors.transparent,
                  foregroundColor: value == true
                      ? Colors.white
                      : (isDark ? AppColors.lightText : AppColors.darkText),
                  side: BorderSide(
                    color:
                        isDark ? AppColors.greyText : AppColors.lightGreyBorder,
                  ),
                ),
                child: Text(l10n.yes),
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: OutlinedButton(
                onPressed: () => onChanged(false),
                style: OutlinedButton.styleFrom(
                  backgroundColor: value == false
                      ? (isDark ? AppColors.primary : AppColors.primaryBrown)
                      : Colors.transparent,
                  foregroundColor: value == false
                      ? Colors.white
                      : (isDark ? AppColors.lightText : AppColors.darkText),
                  side: BorderSide(
                    color:
                        isDark ? AppColors.greyText : AppColors.lightGreyBorder,
                  ),
                ),
                child: Text(l10n.no),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

/// Maps to API question [HealthQuestionnaireIds.activityPilates] — Yes / Sometimes / No.
class ApiActivityLevelQuestionBlock extends StatelessWidget {
  const ApiActivityLevelQuestionBlock({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;
    return BlocBuilder<SubscriptionCubit, SubscriptionState>(
      buildWhen: (p, c) =>
          p.healthQuestionnaireQuestions != c.healthQuestionnaireQuestions ||
          p.healthQuestionnaireAnswers != c.healthQuestionnaireAnswers,
      builder: (context, state) {
        final picked = pickQuestionsByIds(
          state.healthQuestionnaireQuestions,
          const [HealthQuestionnaireIds.activityPilates],
        );
        if (picked.isEmpty) {
          return const SizedBox.shrink();
        }
        final q = picked.first;
        final id = q.numericQuestionId!;
        final raw = state.healthQuestionnaireAnswers[id];
        final group = raw is String ? raw : null;
        final cubit = context.read<SubscriptionCubit>();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppText(
              '${q.displayLabel}${q.isRequired == true ? ' *' : ''}',
              style: (ctx) => AppTextStyles.bodyTextSmall(ctx).copyWith(
                fontWeight: FontWeight.w600,
                color: isDark ? AppColors.lightText : AppColors.darkText,
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            _TriChip(
              label: l10n.yes,
              value: 'yes',
              group: group,
              isDark: isDark,
              onSelect: () => cubit.setHealthQuestionnaireAnswer(id, 'yes'),
            ),
            _TriChip(
              label: l10n.sometimes,
              value: 'sometimes',
              group: group,
              isDark: isDark,
              onSelect: () =>
                  cubit.setHealthQuestionnaireAnswer(id, 'sometimes'),
            ),
            _TriChip(
              label: l10n.no,
              value: 'no',
              group: group,
              isDark: isDark,
              onSelect: () => cubit.setHealthQuestionnaireAnswer(id, 'no'),
            ),
          ],
        );
      },
    );
  }
}

class _TriChip extends StatelessWidget {
  const _TriChip({
    required this.label,
    required this.value,
    required this.group,
    required this.isDark,
    required this.onSelect,
  });

  final String label;
  final String value;
  final String? group;
  final bool isDark;
  final VoidCallback onSelect;

  @override
  Widget build(BuildContext context) {
    final isSelected = value == group;
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: GestureDetector(
        onTap: onSelect,
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

/// Free-text goals question (API id 3) aligned with the Goals step UI.
class ApiGoalsQuestionBlock extends StatefulWidget {
  const ApiGoalsQuestionBlock({super.key});

  @override
  State<ApiGoalsQuestionBlock> createState() => _ApiGoalsQuestionBlockState();
}

class _ApiGoalsQuestionBlockState extends State<ApiGoalsQuestionBlock> {
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

    return BlocBuilder<SubscriptionCubit, SubscriptionState>(
      buildWhen: (p, c) =>
          p.healthQuestionnaireQuestions != c.healthQuestionnaireQuestions,
      builder: (context, state) {
        final picked = pickQuestionsByIds(
          state.healthQuestionnaireQuestions,
          const [HealthQuestionnaireIds.goals],
        );
        if (picked.isEmpty) {
          return const SizedBox.shrink();
        }
        final q = picked.first;

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
      },
    );
  }
}
