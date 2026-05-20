import 'dart:async';

import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pilates_app/config/theme/app_colors.dart';
import 'package:pilates_app/config/theme/app_spacing.dart';
import 'package:pilates_app/config/theme/app_text_styles.dart';
import 'package:pilates_app/core/localization/arb/app_localizations.dart';
import 'package:pilates_app/core/validation/contact_validators.dart';
import 'package:pilates_app/core/validation/id_document_validators.dart';
import 'package:pilates_app/core/validation/personal_information_validators.dart';
import 'package:pilates_app/features/checkout/data/checkout_repository.dart';
import 'package:pilates_app/features/subscription/purchase_subscription/data/subscription_emergency_contact_body.dart';
import 'package:pilates_app/features/subscription/purchase_subscription/cubit/subscription_cubit.dart';
import 'package:pilates_app/features/subscription/purchase_subscription/view/subscription_hosted_payment_flow.dart';
import 'package:pilates_app/widgets/app_button.dart';
import 'package:pilates_app/widgets/app_loading_indicator.dart';
import 'package:pilates_app/widgets/app_dropdown.dart';
import 'package:pilates_app/widgets/app_text.dart';
import 'package:pilates_app/widgets/app_text_field.dart';
import 'package:pilates_app/widgets/phone_number_field.dart';

class RequiredInformationView extends StatefulWidget {
  const RequiredInformationView({super.key});

  @override
  State<RequiredInformationView> createState() =>
      _RequiredInformationViewState();
}

class _RequiredInformationViewState extends State<RequiredInformationView> {
  late final TextEditingController _emergencyNameController;
  late final TextEditingController _emergencyPhoneController;
  late final TextEditingController _idNumberController;

  CountryCode? _emergencyPhoneCountry;

  String? _nameError;
  String? _phoneError;
  String? _relationshipError;
  String? _idTypeError;
  String? _idNumberError;

  bool _isSubmitting = false;

  void _unfocusKeyboard() {
    FocusManager.instance.primaryFocus?.unfocus();
  }

  @override
  void initState() {
    super.initState();
    final s = context.read<SubscriptionCubit>().state;
    _emergencyNameController = TextEditingController(
      text: s.emergencyContactName,
    );
    _emergencyPhoneController = TextEditingController(
      text: s.emergencyContactPhone.trim().isEmpty
          ? ''
          : PersonalInformationValidators.profilePhoneToNationalDigits(
              s.emergencyContactPhone,
            ),
    );
    _idNumberController = TextEditingController(text: s.idNumber);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final cubit = context.read<SubscriptionCubit>();
      cubit.updateEmergencyContactName(_emergencyNameController.text);
      cubit.updateEmergencyContactPhone(_emergencyPhoneController.text);
      cubit.updateIdNumber(_idNumberController.text);
    });
  }

  @override
  void dispose() {
    _emergencyNameController.dispose();
    _emergencyPhoneController.dispose();
    _idNumberController.dispose();
    super.dispose();
  }

  Future<void> _validateAndSubmit(AppLocalizations l10n) async {
    _unfocusKeyboard();
    final cubit = context.read<SubscriptionCubit>();
    cubit.updateEmergencyContactName(_emergencyNameController.text);
    cubit.updateEmergencyContactPhone(_emergencyPhoneController.text);
    cubit.updateIdNumber(_idNumberController.text);

    final s = cubit.state;
    final name = s.emergencyContactName.trim();
    final idRaw = _idNumberController.text;

    final nameOk = name.isNotEmpty && ContactValidators.isValidPersonName(name);
    final phoneOk = PersonalInformationValidators.isTenDigitMobile(
      s.emergencyContactPhone,
    );
    final relOk =
        s.emergencyContactRelationship != null &&
        s.emergencyContactRelationship!.trim().isNotEmpty;
    final typeOk = IdDocumentValidators.isAllowedUiIdType(s.idType);
    final idOk = IdDocumentValidators.isValidForUiIdType(s.idType, idRaw);

    setState(() {
      _nameError = name.isEmpty
          ? l10n.pleaseCompletePersonalInformation
          : (!ContactValidators.isValidPersonName(name)
                ? l10n.enterValidName
                : null);
      _phoneError = s.emergencyContactPhone.trim().isEmpty
          ? l10n.pleaseEnterPhone
          : (!phoneOk ? l10n.phoneTenDigitsRequired : null);
      _relationshipError = relOk
          ? null
          : l10n.pleaseCompletePersonalInformation;
      _idTypeError = typeOk
          ? null
          : ((s.idType?.trim().isEmpty ?? true)
                ? l10n.pleaseCompletePersonalInformation
                : l10n.pleaseSelectValidIdType);
      _idNumberError = _idNumberFieldError(
        s.idType,
        idRaw,
        l10n,
        treatEmptyAsNoError: false,
      );
    });

    if (!nameOk || !phoneOk || !relOk || !typeOk || !idOk) {
      return;
    }

    final normalizedId = IdDocumentValidators.isAllowedUiIdType(s.idType)
        ? _idValueForRules(s.idType, _idNumberController.text)
        : _idNumberController.text.trim();
    cubit.updateIdNumber(normalizedId);
    if (_idNumberController.text != normalizedId) {
      _idNumberController.text = normalizedId;
    }

    final messenger = ScaffoldMessenger.of(context);
    final checkoutId = cubit.state.checkoutSessionId.trim();
    final deferred = cubit.deferredPostPaymentReceiptIntent;

    setState(() => _isSubmitting = true);
    try {
      if (checkoutId.isEmpty) {
        messenger.showSnackBar(
          SnackBar(content: Text(l10n.giftCheckoutSessionRequired)),
        );
        return;
      }

      final repo = context.read<CheckoutRepository>();
      final formattedEmergencyPhone = _formatEmergencyPhoneForApi(
        _emergencyPhoneCountry,
        cubit.state.emergencyContactPhone,
      );

      final emergencyResult = await repo.submitEmergencyContact(
        checkoutId: checkoutId,
        body: subscriptionEmergencyContactBody(
          state: cubit.state,
          formattedEmergencyPhone: formattedEmergencyPhone,
        ),
      );

      if (!emergencyResult.isSuccess) {
        if (!context.mounted) return;
        final ex = emergencyResult.exceptionOrNull;
        messenger.showSnackBar(
          SnackBar(
            content: Text(
              (ex?.message != null && ex!.message!.trim().isNotEmpty)
                  ? ex.message!
                  : l10n.loginErrorGeneric,
            ),
          ),
        );
        return;
      }

      if (deferred != null) {
        try {
          await pushSubscriptionReceiptScreen(
            context,
            repo,
            checkoutId,
            deferred,
            gatewayCallback: cubit.deferredPostPaymentGatewayCallback,
          );
          if (context.mounted) {
            cubit.clearDeferredPostPaymentReceiptContext();
          }
        } catch (_) {
          // Keep deferred context so the user can retry Submit.
        }
        return;
      }

      await runSubscriptionHostedPaymentFlow(context);
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
  }

  bool _hasMinimumFieldsForSubmitAttempt(SubscriptionState s, String idRaw) {
    final name = s.emergencyContactName.trim();
    if (name.isEmpty || !ContactValidators.isValidPersonName(name)) {
      return false;
    }
    if (!PersonalInformationValidators.isTenDigitMobile(s.emergencyContactPhone)) {
      return false;
    }
    if (s.emergencyContactRelationship?.trim().isEmpty ?? true) {
      return false;
    }
    if (!IdDocumentValidators.isAllowedUiIdType(s.idType)) {
      return false;
    }
    if (idRaw.trim().isEmpty) {
      return false;
    }
    return true;
  }

  /// Value passed to [IdDocumentValidators] and API normalization where applicable.
  String _idValueForRules(String? uiIdType, String raw) {
    switch (uiIdType?.trim()) {
      case 'National ID':
      case 'Iqama':
        return raw.replaceAll(RegExp(r'\D'), '');
      default:
        return raw.trim();
    }
  }

  String? _idNumberFieldError(
    String? uiIdType,
    String raw,
    AppLocalizations l10n, {
    bool treatEmptyAsNoError = false,
  }) {
    if (!IdDocumentValidators.isAllowedUiIdType(uiIdType)) {
      return null;
    }
    final forRules = _idValueForRules(uiIdType, raw);
    if (forRules.isEmpty) {
      return treatEmptyAsNoError ? null : l10n.pleaseCompletePersonalInformation;
    }
    if (!IdDocumentValidators.isValidForUiIdType(uiIdType, raw)) {
      switch (uiIdType?.trim()) {
        case 'National ID':
          return l10n.idNumberNationalIdInvalid;
        case 'Iqama':
          return l10n.idNumberIqamaInvalid;
        default:
          return l10n.pleaseCompletePersonalInformation;
      }
    }
    return null;
  }

  int _idNumberMaxLength(String? uiIdType) {
    return IdDocumentValidators.isAllowedUiIdType(uiIdType) ? 10 : 100;
  }

  TextInputType _idKeyboardType(String? uiIdType) {
    return IdDocumentValidators.isAllowedUiIdType(uiIdType)
        ? TextInputType.number
        : TextInputType.text;
  }

  /// Builds E.164-style emergency phone for the API (`dialCode` + national digits), max 30 chars.
  String _formatEmergencyPhoneForApi(
    CountryCode? country,
    String nationalDigits,
  ) {
    final dial = country?.dialCode ?? '+966';
    final digits = nationalDigits.replaceAll(RegExp(r'\D'), '');
    final combined = '$dial$digits';
    if (combined.length <= 30) return combined;
    return combined.substring(0, 30);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final cubit = context.read<SubscriptionCubit>();
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final keyboardBottom = MediaQuery.viewInsetsOf(context).bottom;

    return Stack(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(
            vertical: AppSpacing.lg,
            horizontal: AppSpacing.lg,
          ),
          child: Column(
            children: [
              Expanded(
                child: GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: _unfocusKeyboard,
                  child: SingleChildScrollView(
                    keyboardDismissBehavior:
                        ScrollViewKeyboardDismissBehavior.onDrag,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        BlocBuilder<SubscriptionCubit, SubscriptionState>(
                          buildWhen: (previous, current) =>
                              previous.deferPaymentReceiptPending !=
                                  current.deferPaymentReceiptPending ||
                              previous.currentStep != current.currentStep,
                          builder: (context, blocState) {
                            if (!blocState.deferPaymentReceiptPending) {
                              return const SizedBox.shrink();
                            }
                            return Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Container(
                                  width: double.infinity,
                                  padding: EdgeInsets.all(AppSpacing.md),
                                  decoration: BoxDecoration(
                                    color: AppColors.successColor.withValues(
                                      alpha: 0.12,
                                    ),
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: AppColors.successColor.withValues(
                                        alpha: 0.35,
                                      ),
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      const Icon(
                                        Icons.check_circle_outline,
                                        color: AppColors.successColor,
                                        size: 20,
                                      ),
                                      SizedBox(width: AppSpacing.sm),
                                      Expanded(
                                        child: AppText(
                                          'Payment successful',
                                          style: (c) =>
                                              AppTextStyles.bodyText(c)
                                                  .copyWith(
                                                    color:
                                                        AppColors.successColor,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: AppSpacing.lg),
                              ],
                            );
                          },
                        ),
                        Container(
                          padding: EdgeInsets.all(AppSpacing.md),
                          decoration: BoxDecoration(
                            color: isDark
                                ? AppColors.warningColor.withValues(alpha: 0.11)
                                : AppColors.upgradeLightBackgroundColor,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(
                                Icons.info_outline_rounded,
                                color: isDark
                                    ? AppColors.warningColor
                                    : AppColors.lightRedColor,
                                size: 22,
                              ),
                              SizedBox(width: AppSpacing.sm),
                              Expanded(
                                child: RichText(
                                  text: TextSpan(
                                    children: [
                                      TextSpan(
                                        text:
                                            '${l10n.requiredForLegalComplianceShort}: ',
                                        style: AppTextStyles.bodyText(context)
                                            .copyWith(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w600,
                                              color: isDark
                                                  ? AppColors.darkGreyText
                                                  : AppColors.greyText,
                                            ),
                                      ),
                                      TextSpan(
                                        text: l10n.requiredForLegalCompliance,
                                        style: AppTextStyles.bodyText(context)
                                            .copyWith(
                                              fontSize: 12,
                                              color: isDark
                                                  ? AppColors.darkGreyText
                                                  : AppColors.greyText,
                                            ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        SizedBox(height: AppSpacing.xl),

                        AppText(
                          l10n.emergencyContact,
                          style: (style) => AppTextStyles.heading1(context),
                        ),
                        SizedBox(height: 4),
                        AppText(
                          l10n.emergencyContactSubtitle,
                          style: (context) => AppTextStyles.bodyText(context),
                        ),
                        SizedBox(height: AppSpacing.lg),

                        AppTextField(
                          label: l10n.contactName,
                          hint: l10n.fullName,
                          controller: _emergencyNameController,
                          errorText: _nameError,
                          keyboardType: TextInputType.name,
                          onChanged: (_) {
                            cubit.updateEmergencyContactName(
                              _emergencyNameController.text,
                            );
                            setState(() => _nameError = null);
                          },
                        ),
                        SizedBox(height: AppSpacing.md),

                        BlocBuilder<SubscriptionCubit, SubscriptionState>(
                          buildWhen: (p, c) =>
                              p.emergencyContactRelationship !=
                              c.emergencyContactRelationship,
                          builder: (context, state) {
                            return AppDropDown<String>(
                              label: l10n.relationship,
                              hint: l10n.selectRelationship,
                              value: state.emergencyContactRelationship,
                              errorText: _relationshipError,
                              items:
                                  [
                                    'Parent',
                                    'Spouse',
                                    'Sibling',
                                    'Friend',
                                    'Other',
                                  ].map((e) {
                                    String label = e;
                                    switch (e) {
                                      case 'Parent':
                                        label = l10n.relationshipParent;
                                        break;
                                      case 'Spouse':
                                        label = l10n.relationshipSpouse;
                                        break;
                                      case 'Sibling':
                                        label = l10n.relationshipSibling;
                                        break;
                                      case 'Friend':
                                        label = l10n.relationshipFriend;
                                        break;
                                      case 'Other':
                                        label = l10n.relationshipOther;
                                        break;
                                    }
                                    return DropdownMenuItem(
                                      value: e,
                                      child: Text(
                                        label,
                                        style: AppTextStyles.textField(context),
                                      ),
                                    );
                                  }).toList(),
                              onChanged: (val) {
                                if (val != null) {
                                  cubit.updateEmergencyContactRelationship(val);
                                  setState(() => _relationshipError = null);
                                }
                              },
                            );
                          },
                        ),
                        SizedBox(height: AppSpacing.md),

                        PhoneNumberField(
                          label: l10n.phoneNumber,
                          countryCode:
                              _emergencyPhoneCountry?.dialCode ?? '+966',
                          flagAsset: '',
                          controller: _emergencyPhoneController,
                          maxPhoneDigits: 10,
                          initialCountryIso:
                              _emergencyPhoneCountry?.code ?? 'SA',
                          errorText: _phoneError,
                          onCountryChanged: (country) {
                            setState(() {
                              _emergencyPhoneCountry = country;
                              _phoneError = null;
                            });
                          },
                          onChanged: (v) {
                            cubit.updateEmergencyContactPhone(v);
                            setState(() => _phoneError = null);
                          },
                        ),

                        SizedBox(height: AppSpacing.xl),

                        AppText(
                          l10n.identityVerification,
                          style: (style) => AppTextStyles.heading1(context),
                        ),
                        SizedBox(height: 4),
                        AppText(
                          l10n.requiredForLegalComplianceShort,
                          style: (context) => AppTextStyles.bodyText(context),
                        ),
                        SizedBox(height: AppSpacing.lg),

                        BlocBuilder<SubscriptionCubit, SubscriptionState>(
                          buildWhen: (p, c) => p.idType != c.idType,
                          builder: (context, state) {
                            final selectedIdType =
                                IdDocumentValidators.isAllowedUiIdType(
                                  state.idType,
                                )
                                ? state.idType
                                : null;
                            return AppDropDown<String>(
                              label: l10n.idType,
                              hint: l10n.selectIdType,
                              value: selectedIdType,
                              errorText: _idTypeError,
                              items: IdDocumentValidators.allowedUiIdTypes.map((e) {
                                    final label = switch (e) {
                                      'National ID' => l10n.idTypeNationalId,
                                      'Iqama' => l10n.idTypeIqama,
                                      _ => e,
                                    };
                                    return DropdownMenuItem(
                                      value: e,
                                      child: Text(
                                        label,
                                        style: AppTextStyles.textField(context),
                                      ),
                                    );
                                  }).toList(),
                              onChanged: (val) {
                                if (val == null) return;
                                final previous = state.idType?.trim();
                                final next = val.trim();
                                final changed = previous != next;
                                cubit.updateIdType(next);
                                if (changed) {
                                  _idNumberController.clear();
                                  cubit.updateIdNumber('');
                                }
                                setState(() {
                                  _idTypeError = null;
                                  if (changed) _idNumberError = null;
                                });
                              },
                            );
                          },
                        ),
                        SizedBox(height: AppSpacing.md),

                        BlocBuilder<SubscriptionCubit, SubscriptionState>(
                          buildWhen: (p, c) =>
                              p.idType != c.idType,
                          builder: (context, state) {
                            return AppTextField(
                              label: l10n.idNumber,
                              hint: l10n.idNumber,
                              controller: _idNumberController,
                              maxLength: _idNumberMaxLength(state.idType),
                              keyboardType: _idKeyboardType(state.idType),
                              showCharacterCounter: false,
                              errorText: _idNumberError,
                              onChanged: (_) {
                                cubit.updateIdNumber(_idNumberController.text);
                                setState(() {
                                  _idNumberError = _idNumberFieldError(
                                    cubit.state.idType,
                                    _idNumberController.text,
                                    l10n,
                                    treatEmptyAsNoError: true,
                                  );
                                });
                              },
                            );
                          },
                        ),
                        SizedBox(height: AppSpacing.xxl),
                      ],
                    ),
                  ),
                ),
              ),

              Padding(
                padding: EdgeInsets.only(
                  top: AppSpacing.sm,
                  bottom: keyboardBottom,
                ),
                child: BlocBuilder<SubscriptionCubit, SubscriptionState>(
                  buildWhen: (p, c) =>
                      p.emergencyContactRelationship !=
                          c.emergencyContactRelationship ||
                      p.idType != c.idType ||
                      p.idNumber != c.idNumber ||
                      p.emergencyContactName != c.emergencyContactName ||
                      p.emergencyContactPhone != c.emergencyContactPhone,
                  builder: (context, state) {
                    final canSubmit = !_isSubmitting &&
                        _hasMinimumFieldsForSubmitAttempt(
                          state,
                          _idNumberController.text,
                        );
                    return AppButton(
                      label: l10n.submit,
                      onPressed: canSubmit
                          ? () => unawaited(_validateAndSubmit(l10n))
                          : null,
                      buttonColor: isDark
                          ? AppColors.primary
                          : AppColors.primaryBrown,
                      expanded: true,
                    );
                  },
                ),
              ),
            ],
          ),
        ),
        if (_isSubmitting)
          Positioned.fill(
            child: AbsorbPointer(
              child: ColoredBox(
                color: Colors.black.withValues(alpha: 0.25),
                child: const AppLoadingIndicator(),
              ),
            ),
          ),
      ],
    );
  }
}
