import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pilates_app/config/theme/app_colors.dart';
import 'package:pilates_app/config/theme/app_spacing.dart';
import 'package:pilates_app/config/theme/app_text_styles.dart';
import 'package:pilates_app/core/localization/arb/app_localizations.dart';
import 'package:pilates_app/core/validation/contact_validators.dart';
import 'package:pilates_app/core/validation/personal_information_validators.dart';
import 'package:pilates_app/features/auth/cubit/auth_cubit.dart';
import 'package:pilates_app/features/auth/cubit/auth_state.dart';
import 'package:pilates_app/features/auth/data/models/auth_user.dart';
import 'package:pilates_app/features/checkout/data/checkout_repository.dart';
import 'package:pilates_app/features/checkout/data/models/product_health_question.dart';
import 'package:pilates_app/features/subscription/purchase_subscription/cubit/subscription_cubit.dart';
import 'package:pilates_app/features/subscription/purchase_subscription/personal_information_profile_lock.dart';
import 'package:pilates_app/features/subscription/purchase_subscription/view/widgets/api_personal_information_fields.dart';
import 'package:pilates_app/features/subscription/purchase_subscription/view/widgets/subscription_header.dart';
import 'package:pilates_app/features/subscription/purchase_subscription/view/widgets/subscription_health_wizard_step.dart';
import 'package:pilates_app/widgets/app_button.dart';
import 'package:pilates_app/widgets/app_text.dart';
import 'package:pilates_app/widgets/app_text_field.dart';
import 'package:pilates_app/widgets/inline_validation_banner.dart';
import 'package:pilates_app/widgets/phone_number_field.dart';

class HealthInformationView extends StatefulWidget {
  const HealthInformationView({super.key});

  @override
  State<HealthInformationView> createState() => _HealthInformationViewState();
}

class _HealthInformationViewState extends State<HealthInformationView> {
  late final TextEditingController _nameController;
  late final TextEditingController _ageController;
  late final TextEditingController _heightController;
  late final TextEditingController _weightController;
  late final TextEditingController _phoneController;
  late final TextEditingController _emailController;

  CountryCode? _phoneCountry;

  String? _nameError;
  String? _ageError;
  String? _heightError;
  String? _weightError;
  String? _phoneError;
  String? _emailError;

  bool _questionnaireLoading = false;
  bool _attemptedPersonalQuestionnaireFetch = false;

  String? _apiExtrasValidationMessage;

  static String _mergedName(SubscriptionState sub, AuthUser? user) {
    if (sub.name.trim().isNotEmpty) return sub.name;
    return PersonalInformationProfileLock.displayNameFromUser(user);
  }

  static String _mergedAge(SubscriptionState sub, AuthUser? user) {
    final apiAge = PersonalInformationProfileLock.profileAgeString(user);
    if (apiAge.isNotEmpty) return apiAge;
    if (sub.age.trim().isNotEmpty) return sub.age;
    return '';
  }

  static String _mergedHeight(SubscriptionState sub, AuthUser? user) {
    final apiHeight = user?.heightCm?.trim() ?? '';
    if (apiHeight.isNotEmpty) return apiHeight;
    if (sub.height.trim().isNotEmpty) return sub.height;
    return '';
  }

  static String _mergedWeight(SubscriptionState sub, AuthUser? user) {
    final apiWeight = user?.weightKg?.trim() ?? '';
    if (apiWeight.isNotEmpty) return apiWeight;
    if (sub.weight.trim().isNotEmpty) return sub.weight;
    return '';
  }

  static String _mergedEmail(SubscriptionState sub, AuthUser? user) {
    final apiEmail = PersonalInformationProfileLock.profileEmail(user);
    if (apiEmail.isNotEmpty) return apiEmail;
    if (sub.email.trim().isNotEmpty) return sub.email;
    return '';
  }

  static String _mergedPhoneNational(SubscriptionState sub, AuthUser? user) {
    final apiPhone = PersonalInformationProfileLock.profilePhoneNational(user);
    if (apiPhone.trim().isNotEmpty) return apiPhone;
    if (sub.phoneNumber.trim().isNotEmpty) return sub.phoneNumber;
    return '';
  }

  void _syncCubitFromControllers() {
    final cubit = context.read<SubscriptionCubit>();
    cubit.updateName(_nameController.text);
    cubit.updateAge(_ageController.text);
    cubit.updateHeight(_heightController.text);
    cubit.updateWeight(_weightController.text);
    cubit.updatePhoneNumber(_phoneController.text);
    cubit.updateEmail(_emailController.text);
  }

  void _unfocusKeyboard() {
    FocusManager.instance.primaryFocus?.unfocus();
  }

  @override
  void initState() {
    super.initState();
    final cubit = context.read<SubscriptionCubit>();
    final sub = cubit.state;
    final user = context.read<AuthCubit>().state.user;

    final needsPrefetch = sub.selectedProductRequiresHealthIntake &&
        sub.healthQuestionnaireQuestions.isEmpty;
    _questionnaireLoading = needsPrefetch;
    _attemptedPersonalQuestionnaireFetch = !needsPrefetch;

    _nameController = TextEditingController(text: _mergedName(sub, user));
    _ageController = TextEditingController(text: _mergedAge(sub, user));
    _heightController = TextEditingController(text: _mergedHeight(sub, user));
    _weightController = TextEditingController(text: _mergedWeight(sub, user));
    _phoneController = TextEditingController(
      text: _mergedPhoneNational(sub, user),
    );
    _emailController = TextEditingController(text: _mergedEmail(sub, user));

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _syncCubitFromControllers();
      _ensureQuestionnaire();
    });
  }

  void _applyApiLockedValuesIfNeeded(AuthUser? user) {
    final lockedName =
        PersonalInformationProfileLock.shouldLockName(user)
            ? PersonalInformationProfileLock.displayNameFromUser(user)
            : '';
    final apiAge = PersonalInformationProfileLock.profileAgeString(user);
    final apiPhone = PersonalInformationProfileLock.profilePhoneNational(user);
    final apiEmail = PersonalInformationProfileLock.profileEmail(user);
    var changed = false;

    if (lockedName.isNotEmpty && _nameController.text.trim() != lockedName) {
      _nameController.text = lockedName;
      changed = true;
    }

    if (PersonalInformationProfileLock.shouldLockAge(user) &&
        _ageController.text != apiAge) {
      _ageController.text = apiAge;
      changed = true;
    }
    // Height and weight remain user-editable when other profile fields are locked;
    // do not overwrite them here or input would reset on every rebuild.
    if (PersonalInformationProfileLock.shouldLockPhone(user) &&
        _phoneController.text != apiPhone) {
      _phoneController.text = apiPhone;
      changed = true;
    }
    if (PersonalInformationProfileLock.shouldLockEmail(user) &&
        _emailController.text != apiEmail) {
      _emailController.text = apiEmail;
      changed = true;
    }

    if (changed) {
      _syncCubitFromControllers();
    }
  }

  Future<void> _ensureQuestionnaire() async {
    final cubit = context.read<SubscriptionCubit>();
    final st = cubit.state;

    if (!st.selectedProductRequiresHealthIntake) {
      if (mounted) {
        setState(() {
          _questionnaireLoading = false;
          _attemptedPersonalQuestionnaireFetch = true;
        });
      }
      return;
    }
    if (st.healthQuestionnaireQuestions.isNotEmpty) {
      if (mounted) {
        setState(() {
          _questionnaireLoading = false;
          _attemptedPersonalQuestionnaireFetch = true;
        });
      }
      return;
    }

    final repo = context.read<CheckoutRepository>();
    if (mounted) setState(() => _questionnaireLoading = true);

    await cubit.fetchHealthQuestionnaireForCurrentProduct(repo);
    if (!mounted) return;
    setState(() {
      _questionnaireLoading = false;
      _attemptedPersonalQuestionnaireFetch = true;
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    _heightController.dispose();
    _weightController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  bool _validatePersonalInformationFields(
    BuildContext context,
    SubscriptionCubit cubit,
  ) {
    final l10n = AppLocalizations.of(context);
    _syncCubitFromControllers();
    final s = cubit.state;

    final name = s.name.trim();
    final age = s.age.trim();
    final height = s.height.trim();
    final weight = s.weight.trim();
    final phone = s.phoneNumber.trim();
    final email = s.email.trim();

    setState(() {
      _nameError = name.isEmpty
          ? l10n.pleaseCompletePersonalInformation
          : (!PersonalInformationValidators.isValidName(name)
                ? l10n.enterValidName
                : null);
      _ageError = age.isEmpty
          ? l10n.pleaseCompletePersonalInformation
          : (!PersonalInformationValidators.isValidAge(age)
                ? l10n.enterValidAge
                : null);
      _heightError = height.isEmpty
          ? l10n.pleaseFillHeight
          : (!PersonalInformationValidators.isValidHeightCm(s.height)
                ? l10n.enterValidHeightCm
                : null);
      _weightError = weight.isEmpty
          ? l10n.pleaseFillWeight
          : (!PersonalInformationValidators.isValidWeightKg(s.weight)
                ? l10n.enterValidWeightKg
                : null);
      _phoneError = phone.isEmpty
          ? l10n.pleaseEnterPhone
          : (!PersonalInformationValidators.isTenDigitMobile(s.phoneNumber)
                ? l10n.phoneTenDigitsRequired
                : null);
      _emailError = email.isEmpty
          ? l10n.pleaseCompletePersonalInformation
          : (!ContactValidators.isValidEmail(s.email)
                ? l10n.pleaseEnterValidEmail
                : null);
    });

    return _nameError == null &&
        _ageError == null &&
        _heightError == null &&
        _weightError == null &&
        _phoneError == null &&
        _emailError == null;
  }

  void _onContinuePersonalInformation(BuildContext context) {
    _unfocusKeyboard();
    final cubit = context.read<SubscriptionCubit>();
    setState(() => _apiExtrasValidationMessage = null);

    final sEarly = cubit.state;
    final questionnairePendingHydration =
        sEarly.selectedProductRequiresHealthIntake &&
        sEarly.healthQuestionnaireQuestions.isEmpty;
    if (questionnairePendingHydration &&
        (_questionnaireLoading || !_attemptedPersonalQuestionnaireFetch)) {
      return;
    }

    if (!_validatePersonalInformationFields(context, cubit)) {
      return;
    }

    final s = cubit.state;
    final extras = extraPersonalInformationQuestionsFromApi(
      s.healthQuestionnaireQuestions,
    );
    if (s.selectedProductRequiresHealthIntake && extras.isNotEmpty) {
      if (!cubit.validateApiPersonalInformationQuestions(extras)) {
        setState(
          () => _apiExtrasValidationMessage =
              AppLocalizations.of(context).pleaseCompletePersonalInformation,
        );
        return;
      }
    }

    cubit.nextStep();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final authUser = context.select<AuthCubit, AuthUser?>(
      (cubit) => cubit.state.user,
    );

    return BlocListener<SubscriptionCubit, SubscriptionState>(
      listenWhen: (p, c) =>
          p.personalInformationDynamicFields !=
          c.personalInformationDynamicFields,
      listener: (_, __) {
        if (!mounted || _apiExtrasValidationMessage == null) return;
        setState(() => _apiExtrasValidationMessage = null);
      },
      child: BlocListener<AuthCubit, AuthState>(
        listenWhen: (p, c) => p.user != c.user,
        listener: (_, __) {
          if (mounted) setState(() {});
        },
        child: BlocBuilder<SubscriptionCubit, SubscriptionState>(
          buildWhen: (p, c) =>
              p.currentStep != c.currentStep ||
              p.healthQuestionnaireQuestions !=
                  c.healthQuestionnaireQuestions ||
              p.selectedProductRequiresHealthIntake !=
                  c.selectedProductRequiresHealthIntake ||
              p.name != c.name ||
              p.age != c.age ||
              p.height != c.height ||
              p.weight != c.weight ||
              p.phoneNumber != c.phoneNumber ||
              p.email != c.email ||
              p.personalInformationDynamicFields !=
                  c.personalInformationDynamicFields,
          builder: (context, state) {
            final cubit = context.read<SubscriptionCubit>();
            final nameLocked =
                PersonalInformationProfileLock.shouldLockName(authUser);
            final ageLocked =
                PersonalInformationProfileLock.shouldLockAge(authUser);
            final phoneLocked =
                PersonalInformationProfileLock.shouldLockPhone(authUser);
            final emailLocked =
                PersonalInformationProfileLock.shouldLockEmail(authUser);
            _applyApiLockedValuesIfNeeded(authUser);
        final extraQs = extraPersonalInformationQuestionsFromApi(
          state.healthQuestionnaireQuestions,
        );
        final questionnairePendingHydration =
            state.selectedProductRequiresHealthIntake &&
                state.healthQuestionnaireQuestions.isEmpty;

        final waitingForQuestionnaire = questionnairePendingHydration &&
            (_questionnaireLoading || !_attemptedPersonalQuestionnaireFetch);

        return Padding(
          padding: EdgeInsets.symmetric(
            vertical: AppSpacing.lg,
            horizontal: AppSpacing.lg,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SubscriptionStepHeader(
                wizardStep:
                    SubscriptionHealthWizardStep.personalInformation,
                isDark: isDark,
                showProgressCaption: !waitingForQuestionnaire,
              ),

              Expanded(
                child: GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: _unfocusKeyboard,
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final bottomInset = MediaQuery.paddingOf(context).bottom;
                      return SingleChildScrollView(
                        keyboardDismissBehavior:
                            ScrollViewKeyboardDismissBehavior.onDrag,
                        padding: EdgeInsets.only(
                          bottom: AppSpacing.xl + bottomInset,
                        ),
                        child: ConstrainedBox(
                          constraints: BoxConstraints(
                            minWidth: constraints.maxWidth,
                            minHeight: constraints.maxHeight,
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment:
                                CrossAxisAlignment.stretch,
                            children: [
                              SizedBox(height: AppSpacing.xl),
                              AppText(
                                l10n.personalInformation,
                                style: (style) =>
                                    AppTextStyles.heading1(context),
                              ),
                              SizedBox(height: AppSpacing.lg),
                              if (waitingForQuestionnaire)
                                Padding(
                                  padding: EdgeInsets.only(
                                    bottom: AppSpacing.md,
                                  ),
                                  child: Center(
                                    child: SizedBox(
                                      width: 24,
                                      height: 24,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                      ),
                                    ),
                                  ),
                                ),
                              AppTextField(
                                label: l10n.name,
                                hint: l10n.name,
                                keyboardType: TextInputType.text,
                                controller: _nameController,
                                readOnly: nameLocked,
                                enabled: !nameLocked,
                                showCharacterCounter: false,
                                textCapitalization:
                                    TextCapitalization.words,
                                autocorrect: false,
                                enableSuggestions: false,
                                textInputAction: TextInputAction.next,
                                errorText: _nameError,
                                onChanged: (_) {
                                  cubit.updateName(_nameController.text);
                                  setState(() {
                                    _nameError = null;
                                    _apiExtrasValidationMessage = null;
                                  });
                                },
                              ),
                              SizedBox(height: AppSpacing.md),
                              AppTextField(
                                label: l10n.age,
                                hint: l10n.age,
                                keyboardType:
                                    const TextInputType.numberWithOptions(
                                  decimal: true,
                                ),
                                controller: _ageController,
                                inputFormatters: [
                                  FilteringTextInputFormatter.allow(
                                    RegExp(r'[0-9]'),
                                  ),
                                  LengthLimitingTextInputFormatter(3),
                                ],
                                showCharacterCounter: false,
                                readOnly: ageLocked,
                                enabled: !ageLocked,
                                autocorrect: false,
                                enableSuggestions: false,
                                textInputAction: TextInputAction.next,
                                errorText: _ageError,
                                onChanged: (_) {
                                  cubit.updateAge(_ageController.text);
                                  setState(() {
                                    _ageError = null;
                                    _apiExtrasValidationMessage = null;
                                  });
                                },
                              ),
                              SizedBox(height: AppSpacing.md),
                              AppTextField(
                                label: l10n.heightCm,
                                hint: l10n.heightCm,
                                keyboardType:
                                    const TextInputType.numberWithOptions(
                                  decimal: true,
                                ),
                                controller: _heightController,
                                inputFormatters: [
                                  FilteringTextInputFormatter.allow(
                                    RegExp(r'[0-9.,]'),
                                  ),
                                ],
                                showCharacterCounter: false,
                                autocorrect: false,
                                enableSuggestions: false,
                                textInputAction: TextInputAction.next,
                                errorText: _heightError,
                                onChanged: (_) {
                                  cubit.updateHeight(_heightController.text);
                                  setState(() {
                                    _heightError = null;
                                    _apiExtrasValidationMessage = null;
                                  });
                                },
                              ),
                              SizedBox(height: AppSpacing.md),
                              AppTextField(
                                label: l10n.weightKg,
                                hint: l10n.weightKg,
                                keyboardType:
                                    const TextInputType.numberWithOptions(
                                  decimal: true,
                                ),
                                controller: _weightController,
                                inputFormatters: [
                                  FilteringTextInputFormatter.allow(
                                    RegExp(r'[0-9.,]'),
                                  ),
                                ],
                                showCharacterCounter: false,
                                autocorrect: false,
                                enableSuggestions: false,
                                textInputAction: TextInputAction.next,
                                errorText: _weightError,
                                onChanged: (_) {
                                  cubit.updateWeight(_weightController.text);
                                  setState(() {
                                    _weightError = null;
                                    _apiExtrasValidationMessage = null;
                                  });
                                },
                              ),
                              SizedBox(height: AppSpacing.md),
                              PhoneNumberField(
                                label: l10n.phoneNumber,
                                countryCode:
                                    _phoneCountry?.dialCode ?? '+966',
                                flagAsset: '',
                                controller: _phoneController,
                                maxPhoneDigits: 10,
                                initialCountryIso:
                                    _phoneCountry?.code ?? 'SA',
                                enabled: !phoneLocked,
                                errorText: _phoneError,
                                textInputAction: TextInputAction.next,
                                onCountryChanged: (country) {
                                  setState(() {
                                    _phoneCountry = country;
                                    _phoneError = null;
                                    _apiExtrasValidationMessage = null;
                                  });
                                },
                                onChanged: (v) {
                                  cubit.updatePhoneNumber(v);
                                  setState(() {
                                    _phoneError = null;
                                    _apiExtrasValidationMessage = null;
                                  });
                                },
                              ),
                              SizedBox(height: AppSpacing.md),
                              AppTextField(
                                label: l10n.emailTab,
                                hint: l10n.emailTab,
                                keyboardType: TextInputType.emailAddress,
                                controller: _emailController,
                                readOnly: emailLocked,
                                enabled: !emailLocked,
                                showCharacterCounter: false,
                                autocorrect: false,
                                enableSuggestions: false,
                                textInputAction: TextInputAction.done,
                                errorText: _emailError,
                                onChanged: (_) {
                                  cubit.updateEmail(_emailController.text);
                                  setState(() {
                                    _emailError = null;
                                    _apiExtrasValidationMessage = null;
                                  });
                                },
                              ),
                              if (extraQs.isNotEmpty) ...[
                                SizedBox(height: AppSpacing.md),
                                ApiPersonalInformationFieldsBlock(
                                  questions: extraQs,
                                  syncedPhoneCountry: _phoneCountry,
                                  onSyncedPhoneCountryChanged: (country) {
                                    setState(() {
                                      _phoneCountry = country;
                                      _apiExtrasValidationMessage = null;
                                    });
                                  },
                                ),
                              ],
                              SizedBox(height: AppSpacing.lg),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              if (_apiExtrasValidationMessage != null) ...[
                SizedBox(height: AppSpacing.sm),
                InlineValidationBanner(
                  message: _apiExtrasValidationMessage!,
                ),
              ],
              AppButton(
                label: l10n.continueTxt,
                onPressed: waitingForQuestionnaire
                    ? null
                    : () => _onContinuePersonalInformation(context),
                buttonColor: isDark
                    ? AppColors.primary
                    : AppColors.primaryBrown,
                expanded: true,
              ),
            ],
          ),
        );
      },
      ),
    ),
    );
  }
}
