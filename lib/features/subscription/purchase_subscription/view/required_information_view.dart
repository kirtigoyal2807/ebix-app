import 'dart:async';

import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pilates_app/config/theme/app_colors.dart';
import 'package:pilates_app/config/theme/app_spacing.dart';
import 'package:pilates_app/config/theme/app_text_styles.dart';
import 'package:pilates_app/core/localization/arb/app_localizations.dart';
import 'package:pilates_app/core/validation/contact_validators.dart';
import 'package:pilates_app/core/validation/personal_information_validators.dart';
import 'package:pilates_app/features/checkout/data/checkout_repository.dart';
import 'package:pilates_app/features/subscription/purchase_subscription/data/subscription_emergency_contact_body.dart';
import 'package:pilates_app/features/subscription/purchase_subscription/cubit/subscription_cubit.dart';
import 'package:pilates_app/features/subscription/purchase_subscription/view/subscription_hosted_payment_flow.dart';
import 'package:pilates_app/widgets/app_button.dart';
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
    final idNum = s.idNumber.trim();

    final nameOk = name.isNotEmpty && ContactValidators.isValidPersonName(name);
    final phoneOk = PersonalInformationValidators.isTenDigitMobile(
      s.emergencyContactPhone,
    );
    final relOk =
        s.emergencyContactRelationship != null &&
        s.emergencyContactRelationship!.trim().isNotEmpty;
    final typeOk = s.idType != null && s.idType!.trim().isNotEmpty;
    final idLen = idNum.length;
    final idOk = idLen >= 1 && idLen <= 100;

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
      _idTypeError = typeOk ? null : l10n.pleaseCompletePersonalInformation;
      _idNumberError = idNum.isEmpty
          ? l10n.pleaseCompletePersonalInformation
          : (!idOk ? l10n.pleaseCompletePersonalInformation : null);
    });

    if (!nameOk || !phoneOk || !relOk || !typeOk || !idOk) {
      return;
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
    final l10n = AppLocalizations.of(context)!;
    final cubit = context.read<SubscriptionCubit>();
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final keyboardBottom = MediaQuery.viewInsetsOf(context).bottom;

    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
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
                        Container(
                          padding: const EdgeInsets.all(AppSpacing.md),
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
                              const SizedBox(width: AppSpacing.sm),
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

                        const SizedBox(height: AppSpacing.xl),

                        AppText(
                          l10n.emergencyContact,
                          style: (style) => AppTextStyles.heading1(context),
                        ),
                        const SizedBox(height: 4),
                        AppText(
                          l10n.emergencyContactSubtitle,
                          style: (context) => AppTextStyles.bodyText(context),
                        ),
                        const SizedBox(height: AppSpacing.lg),

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
                        const SizedBox(height: AppSpacing.md),

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
                        const SizedBox(height: AppSpacing.md),

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

                        const SizedBox(height: AppSpacing.xl),

                        AppText(
                          l10n.identityVerification,
                          style: (style) => AppTextStyles.heading1(context),
                        ),
                        const SizedBox(height: 4),
                        AppText(
                          l10n.requiredForLegalComplianceShort,
                          style: (context) => AppTextStyles.bodyText(context),
                        ),
                        const SizedBox(height: AppSpacing.lg),

                        BlocBuilder<SubscriptionCubit, SubscriptionState>(
                          buildWhen: (p, c) => p.idType != c.idType,
                          builder: (context, state) {
                            return AppDropDown<String>(
                              label: l10n.idType,
                              hint: l10n.selectIdType,
                              value: state.idType,
                              errorText: _idTypeError,
                              items:
                                  [
                                    'National ID',
                                    'Passport',
                                    'Driver License',
                                  ].map((e) {
                                    String label = e;
                                    switch (e) {
                                      case 'National ID':
                                        label = l10n.idTypeNationalId;
                                        break;
                                      case 'Passport':
                                        label = l10n.idTypePassport;
                                        break;
                                      case 'Driver License':
                                        label = l10n.idTypeDriverLicense;
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
                                  cubit.updateIdType(val);
                                  setState(() => _idTypeError = null);
                                }
                              },
                            );
                          },
                        ),
                        const SizedBox(height: AppSpacing.md),

                        AppTextField(
                          label: l10n.idNumber,
                          hint: l10n.idNumber,
                          controller: _idNumberController,
                          maxLength: 100,
                          errorText: _idNumberError,
                          onChanged: (_) {
                            cubit.updateIdNumber(_idNumberController.text);
                            setState(() => _idNumberError = null);
                          },
                        ),
                        const SizedBox(height: AppSpacing.xxl),
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
                child: AppButton(
                  label: l10n.submit,
                  onPressed: _isSubmitting
                      ? null
                      : () => unawaited(_validateAndSubmit(l10n)),
                  buttonColor: isDark
                      ? AppColors.primary
                      : AppColors.primaryBrown,
                  expanded: true,
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
                child: Center(
                  child: CircularProgressIndicator(
                    color: isDark ? AppColors.primary : AppColors.primaryBrown,
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
