import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pilates_app/config/theme/app_spacing.dart';
import 'package:pilates_app/features/auth/cubit/auth_cubit.dart';
import 'package:pilates_app/features/auth/cubit/auth_state.dart';
import 'package:pilates_app/features/auth/data/models/auth_user.dart';
import 'package:pilates_app/features/checkout/data/models/product_health_question.dart';
import 'package:pilates_app/features/subscription/purchase_subscription/cubit/subscription_cubit.dart';
import 'package:pilates_app/features/subscription/purchase_subscription/personal_information_profile_lock.dart';
import 'package:pilates_app/widgets/app_text_field.dart';
import 'package:pilates_app/widgets/phone_number_field.dart';

/// Renders API personal questions as text (or phone) inputs.
///
/// When [questions] is null, uses [personalInformationQuestionsFromApi]; otherwise
/// renders exactly that list (e.g. [extraPersonalInformationQuestionsFromApi]).
///
/// [syncedPhoneCountry] / [onSyncedPhoneCountryChanged] mirror the main
/// [PhoneNumberField] on Personal Information so pickers stay aligned.
class ApiPersonalInformationFieldsBlock extends StatelessWidget {
  const ApiPersonalInformationFieldsBlock({
    super.key,
    this.questions,
    this.syncedPhoneCountry,
    this.onSyncedPhoneCountryChanged,
  });

  final List<ProductHealthQuestion>? questions;

  final CountryCode? syncedPhoneCountry;

  final ValueChanged<CountryCode>? onSyncedPhoneCountryChanged;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      buildWhen: (prev, curr) =>
          prev.user?.id != curr.user?.id ||
          prev.user?.firstName != curr.user?.firstName ||
          prev.user?.lastName != curr.user?.lastName ||
          prev.user?.name != curr.user?.name ||
          prev.user?.dateOfBirth != curr.user?.dateOfBirth ||
          prev.user?.email != curr.user?.email ||
          prev.user?.phone != curr.user?.phone,
      builder: (context, _) {
        return BlocBuilder<SubscriptionCubit, SubscriptionState>(
          buildWhen: (p, c) =>
              p.healthQuestionnaireQuestions !=
                  c.healthQuestionnaireQuestions ||
              p.name != c.name ||
              p.age != c.age ||
              p.height != c.height ||
              p.weight != c.weight ||
              p.phoneNumber != c.phoneNumber ||
              p.email != c.email ||
              p.personalInformationDynamicFields !=
                  c.personalInformationDynamicFields,
          builder: (context, state) {
            final qs =
                questions ??
                personalInformationQuestionsFromApi(
                  state.healthQuestionnaireQuestions,
                );
            if (qs.isEmpty) {
              return const SizedBox.shrink();
            }
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (var i = 0; i < qs.length; i++) ...[
                  _ApiPersonalFieldRow(
                    key: ValueKey(
                      '${qs[i].id ?? ''}_${qs[i].key ?? ''}_${qs[i].dynamicPersonalStorageKey}',
                    ),
                    question: qs[i],
                    syncedPhoneCountry: syncedPhoneCountry,
                    onSyncedPhoneCountryChanged: onSyncedPhoneCountryChanged,
                  ),
                  if (i < qs.length - 1) SizedBox(height: AppSpacing.md),
                ],
              ],
            );
          },
        );
      },
    );
  }
}

class _ApiPersonalFieldRow extends StatefulWidget {
  const _ApiPersonalFieldRow({
    super.key,
    required this.question,
    this.syncedPhoneCountry,
    this.onSyncedPhoneCountryChanged,
  });

  final ProductHealthQuestion question;
  final CountryCode? syncedPhoneCountry;
  final ValueChanged<CountryCode>? onSyncedPhoneCountryChanged;

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

  bool _slotLocked(String? slot, AuthUser? user) => switch (slot) {
        'name' => PersonalInformationProfileLock.shouldLockName(user),
        'age' => PersonalInformationProfileLock.shouldLockAge(user),
        'phoneNumber' =>
          PersonalInformationProfileLock.shouldLockPhone(user),
        'email' => PersonalInformationProfileLock.shouldLockEmail(user),
        _ => false,
      };

  void _syncLockedProfileFields(
    ProductHealthQuestion q,
    SubscriptionCubit cubit,
    AuthUser? user,
  ) {
    final slot = q.personalInformationStateSlot;
    final want = switch (slot) {
      'name' when PersonalInformationProfileLock.shouldLockName(user) =>
        PersonalInformationProfileLock.displayNameFromUser(user),
      'age' when PersonalInformationProfileLock.shouldLockAge(user) =>
        PersonalInformationProfileLock.profileAgeString(user),
      'phoneNumber'
          when PersonalInformationProfileLock.shouldLockPhone(user) =>
        PersonalInformationProfileLock.profilePhoneNational(user),
      'email' when PersonalInformationProfileLock.shouldLockEmail(user) =>
        PersonalInformationProfileLock.profileEmail(user),
      _ => '',
    };
    if (want.trim().isEmpty) return;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      if (_controller.text == want) return;
      _controller.value = TextEditingValue(
        text: want,
        selection: TextSelection.collapsed(offset: want.length),
      );
      cubit.applyApiPersonalInformationAnswer(q, want);
    });
  }

  bool _isTextarea(ProductHealthQuestion q) {
    final t = q.type?.toLowerCase().trim() ?? '';
    return t == 'textarea' ||
        t == 'multi_line' ||
        t == 'multiline' ||
        t == 'text_area';
  }

  bool _isDecimalNumericType(String typeLower) {
    return typeLower == 'decimal' ||
        typeLower == 'numeric' ||
        typeLower == 'float' ||
        typeLower == 'double';
  }

  @override
  Widget build(BuildContext context) {
    final q = widget.question;
    final cubit = context.read<SubscriptionCubit>();
    final user = context.select<AuthCubit, AuthUser?>(
      (c) => c.state.user,
    );
    final label = q.displayLabel.isNotEmpty ? q.displayLabel : (q.key ?? '');
    final slot = q.personalInformationStateSlot;
    final isPhoneSlot = slot == 'phoneNumber' || q.isPhoneInputQuestion;
    final locked = _slotLocked(slot, user);
    final typeLower = q.type?.toLowerCase().trim() ?? '';

    _syncLockedProfileFields(q, cubit, user);

    if (isPhoneSlot) {
      final iso = (widget.syncedPhoneCountry?.code ?? 'SA').trim();
      return PhoneNumberField(
        key: widget.syncedPhoneCountry != null
            ? ValueKey<String>('api_phone_$iso')
            : null,
        label: label,
        countryCode: widget.syncedPhoneCountry?.dialCode ?? '+966',
        flagAsset: '',
        controller: _controller,
        maxPhoneDigits: 10,
        initialCountryIso: iso.isNotEmpty ? iso : 'SA',
        enabled: !locked,
        onCountryChanged: widget.onSyncedPhoneCountryChanged,
        onChanged: (v) => cubit.applyApiPersonalInformationAnswer(q, v),
      );
    }

    if (_isTextarea(q)) {
      return AppTextField(
        label: label,
        hint: label,
        keyboardType: TextInputType.multiline,
        controller: _controller,
        maxLines: 6,
        showCharacterCounter: false,
        readOnly: locked,
        enabled: !locked,
        scrollPadding: const EdgeInsets.only(bottom: 120),
        textInputAction: TextInputAction.newline,
        onChanged: (v) => cubit.applyApiPersonalInformationAnswer(q, v),
      );
    }

    final usesAgeDigits = slot == 'age';

    TextInputType keyboardType;
    List<TextInputFormatter>? formatters;
    int? maxLength;
    var textCapitalization = TextCapitalization.none;
    var autocorrect = true;
    var enableSuggestions = true;

    if (usesAgeDigits) {
      keyboardType =
          const TextInputType.numberWithOptions(decimal: true);
      formatters = [
        FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
        LengthLimitingTextInputFormatter(3),
      ];
      autocorrect = false;
      enableSuggestions = false;
    } else if (slot == 'email' || q.isEmailInputQuestion) {
      keyboardType = TextInputType.emailAddress;
      formatters = null;
    } else if (q.isNumericInputQuestion &&
        slot != 'phoneNumber') {
      if (_isDecimalNumericType(typeLower)) {
        keyboardType =
            const TextInputType.numberWithOptions(decimal: true);
        formatters =
            [FilteringTextInputFormatter.allow(RegExp(r'[0-9.,]'))];
      } else {
        keyboardType =
            const TextInputType.numberWithOptions(decimal: false);
        formatters =
            [FilteringTextInputFormatter.allow(RegExp(r'[0-9]'))];
      }
      autocorrect = false;
      enableSuggestions = false;
    } else if (slot == 'name') {
      keyboardType = TextInputType.text;
      formatters = null;
      textCapitalization = TextCapitalization.words;
      autocorrect = false;
      enableSuggestions = false;
    } else {
      keyboardType = TextInputType.text;
      formatters = null;
    }

    return AppTextField(
      label: label,
      hint: label,
      keyboardType: keyboardType,
      controller: _controller,
      inputFormatters: formatters,
      maxLength: maxLength,
      showCharacterCounter: false,
      readOnly: locked,
      enabled: !locked,
      textCapitalization: textCapitalization,
      autocorrect: autocorrect,
      enableSuggestions: enableSuggestions,
      textInputAction: TextInputAction.next,
      onChanged: (v) => cubit.applyApiPersonalInformationAnswer(q, v),
    );
  }
}
