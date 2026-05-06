import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pilates_app/config/theme/app_spacing.dart';
import 'package:pilates_app/features/checkout/data/models/product_health_question.dart';
import 'package:pilates_app/features/subscription/purchase_subscription/cubit/subscription_cubit.dart';
import 'package:pilates_app/widgets/app_text_field.dart';
import 'package:pilates_app/widgets/phone_number_field.dart';

/// Renders API personal questions as text (or phone) inputs.
///
/// When [questions] is null, uses [personalInformationQuestionsFromApi]; otherwise
/// renders exactly that list (e.g. [extraPersonalInformationQuestionsFromApi]).
class ApiPersonalInformationFieldsBlock extends StatelessWidget {
  const ApiPersonalInformationFieldsBlock({
    super.key,
    this.questions,
  });

  final List<ProductHealthQuestion>? questions;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SubscriptionCubit, SubscriptionState>(
      buildWhen: (p, c) =>
          p.healthQuestionnaireQuestions != c.healthQuestionnaireQuestions ||
          p.name != c.name ||
          p.age != c.age ||
          p.height != c.height ||
          p.weight != c.weight ||
          p.phoneNumber != c.phoneNumber ||
          p.email != c.email ||
          p.personalInformationDynamicFields !=
              c.personalInformationDynamicFields,
      builder: (context, state) {
        final qs = questions ??
            personalInformationQuestionsFromApi(
              state.healthQuestionnaireQuestions,
            );
        if (qs.isEmpty) {
          return const SizedBox.shrink();
        }
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (final q in qs) ...[
              _ApiPersonalFieldRow(
                key: ValueKey(
                  '${q.id ?? ''}_${q.key ?? ''}_${q.dynamicPersonalStorageKey}',
                ),
                question: q,
              ),
              const SizedBox(height: AppSpacing.md),
            ],
          ],
        );
      },
    );
  }
}

class _ApiPersonalFieldRow extends StatefulWidget {
  const _ApiPersonalFieldRow({super.key, required this.question});

  final ProductHealthQuestion question;

  @override
  State<_ApiPersonalFieldRow> createState() => _ApiPersonalFieldRowState();
}

class _ApiPersonalFieldRowState extends State<_ApiPersonalFieldRow> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    final cubit = context.read<SubscriptionCubit>();
    _controller = TextEditingController(
      text: cubit.apiPersonalFieldValue(widget.question),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  TextInputType _keyboardType(ProductHealthQuestion q) {
    if (q.isNumericInputQuestion) {
      return TextInputType.number;
    }
    if (q.isEmailInputQuestion) {
      return TextInputType.emailAddress;
    }
    if (q.isPhoneInputQuestion) {
      return TextInputType.phone;
    }
    return TextInputType.text;
  }

  @override
  Widget build(BuildContext context) {
    final q = widget.question;
    final cubit = context.read<SubscriptionCubit>();
    final label = q.displayLabel.isNotEmpty ? q.displayLabel : (q.key ?? '');

    if (q.personalInformationStateSlot == 'phoneNumber' ||
        q.isPhoneInputQuestion) {
      return PhoneNumberField(
        label: label,
        countryCode: '+966',
        flagAsset: '',
        controller: _controller,
        maxPhoneDigits: 10,
        onCountryChanged: (_) {},
        onChanged: (v) => cubit.applyApiPersonalInformationAnswer(q, v),
      );
    }

    return AppTextField(
      label: label,
      hint: label,
      keyboardType: _keyboardType(q),
      controller: _controller,
      onChanged: (v) => cubit.applyApiPersonalInformationAnswer(q, v),
    );
  }
}
