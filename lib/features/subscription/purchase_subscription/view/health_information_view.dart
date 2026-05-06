import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pilates_app/config/theme/app_colors.dart';
import 'package:pilates_app/config/theme/app_spacing.dart';
import 'package:pilates_app/config/theme/app_text_styles.dart';
import 'package:pilates_app/core/localization/arb/app_localizations.dart';
import 'package:pilates_app/core/validation/contact_validators.dart';
import 'package:pilates_app/core/validation/personal_information_validators.dart';
import 'package:pilates_app/features/auth/cubit/auth_cubit.dart';
import 'package:pilates_app/features/auth/data/models/auth_user.dart';
import 'package:pilates_app/features/checkout/data/checkout_repository.dart';
import 'package:pilates_app/features/checkout/data/models/product_health_question.dart';
import 'package:pilates_app/features/subscription/purchase_subscription/cubit/subscription_cubit.dart';
import 'package:pilates_app/features/subscription/purchase_subscription/view/widgets/api_personal_information_fields.dart';
import 'package:pilates_app/features/subscription/purchase_subscription/view/widgets/subscription_header.dart';
import 'package:pilates_app/widgets/app_button.dart';
import 'package:pilates_app/widgets/app_text.dart';
import 'package:pilates_app/widgets/app_text_field.dart';
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

  static String _displayNameFromUser(AuthUser? user) {
    if (user == null) return '';
    final parts = <String>[
      user.firstName?.trim() ?? '',
      user.lastName?.trim() ?? '',
    ].where((e) => e.isNotEmpty).toList();
    if (parts.isNotEmpty) return parts.join(' ');
    return user.name?.trim() ?? '';
  }

  static String _mergedName(SubscriptionState sub, AuthUser? user) {
    if (sub.name.trim().isNotEmpty) return sub.name;
    return _displayNameFromUser(user);
  }

  static String _mergedAge(SubscriptionState sub, AuthUser? user) {
    if (sub.age.trim().isNotEmpty) return sub.age;
    final y = user?.ageYears;
    return y == null ? '' : y.toString();
  }

  static String _mergedEmail(SubscriptionState sub, AuthUser? user) {
    if (sub.email.trim().isNotEmpty) return sub.email;
    return user?.email?.trim() ?? '';
  }

  static String _mergedPhoneNational(SubscriptionState sub, AuthUser? user) {
    if (sub.phoneNumber.trim().isNotEmpty) return sub.phoneNumber;
    return PersonalInformationValidators.profilePhoneToNationalDigits(
      user?.phone,
    );
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
    final sub = context.read<SubscriptionCubit>().state;
    final user = context.read<AuthCubit>().state.user;

    _nameController = TextEditingController(text: _mergedName(sub, user));
    _ageController = TextEditingController(text: _mergedAge(sub, user));
    _heightController = TextEditingController(text: sub.height);
    _weightController = TextEditingController(text: sub.weight);
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

  Future<void> _ensureQuestionnaire() async {
    final cubit = context.read<SubscriptionCubit>();
    if (!cubit.state.selectedProductRequiresHealthIntake) {
      return;
    }
    if (cubit.state.healthQuestionnaireQuestions.isNotEmpty) {
      return;
    }
    final repo = context.read<CheckoutRepository>();
    if (mounted) setState(() => _questionnaireLoading = true);
    await cubit.fetchHealthQuestionnaireForCurrentProduct(repo);
    if (!mounted) return;
    setState(() => _questionnaireLoading = false);
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
    final l10n = AppLocalizations.of(context)!;
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
          : (!PersonalInformationValidators.isValidName(s.name)
                ? l10n.enterValidName
                : null);
      _ageError = age.isEmpty
          ? l10n.pleaseCompletePersonalInformation
          : (!PersonalInformationValidators.isValidAge(s.age)
                ? l10n.enterValidAge
                : null);
      _heightError = height.isEmpty
          ? l10n.pleaseCompletePersonalInformation
          : (!PersonalInformationValidators.isValidHeightCm(s.height)
                ? l10n.enterValidHeightCm
                : null);
      _weightError = weight.isEmpty
          ? l10n.pleaseCompletePersonalInformation
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
    final messenger = ScaffoldMessenger.of(context);
    final l10n = AppLocalizations.of(context)!;
    final cubit = context.read<SubscriptionCubit>();

    if (!_validatePersonalInformationFields(context, cubit)) {
      return;
    }

    final s = cubit.state;
    final extras = extraPersonalInformationQuestionsFromApi(
      s.healthQuestionnaireQuestions,
    );
    if (s.selectedProductRequiresHealthIntake && extras.isNotEmpty) {
      if (!cubit.validateApiPersonalInformationQuestions(extras)) {
        messenger.showSnackBar(
          SnackBar(content: Text(l10n.pleaseCompletePersonalInformation)),
        );
        return;
      }
    }

    cubit.nextStep();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return BlocBuilder<SubscriptionCubit, SubscriptionState>(
      buildWhen: (p, c) =>
          p.currentStep != c.currentStep ||
          p.healthQuestionnaireQuestions != c.healthQuestionnaireQuestions ||
          p.selectedProductRequiresHealthIntake !=
              c.selectedProductRequiresHealthIntake,
      builder: (context, state) {
        final cubit = context.read<SubscriptionCubit>();
        final extraQs = extraPersonalInformationQuestionsFromApi(
          state.healthQuestionnaireQuestions,
        );
        final waitingForQuestionnaire =
            state.selectedProductRequiresHealthIntake &&
                state.healthQuestionnaireQuestions.isEmpty &&
                _questionnaireLoading;

        return Padding(
          padding: const EdgeInsets.symmetric(
            vertical: AppSpacing.lg,
            horizontal: AppSpacing.lg,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SubscriptionStepHeader(
                currentStep: 0,
                totalSteps: 6,
                isDark: isDark,
              ),
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
                        AppText(
                          l10n.personalInformation,
                          style: (style) => AppTextStyles.heading1(context),
                        ),
                        const SizedBox(height: AppSpacing.lg),
                        if (waitingForQuestionnaire)
                          const Padding(
                            padding: EdgeInsets.only(bottom: AppSpacing.md),
                            child: Center(
                              child: SizedBox(
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator(strokeWidth: 2),
                              ),
                            ),
                          ),
                        AppTextField(
                          label: l10n.name,
                          hint: l10n.name,
                          controller: _nameController,
                          errorText: _nameError,
                          onChanged: (_) {
                            cubit.updateName(_nameController.text);
                            setState(() => _nameError = null);
                          },
                        ),
                        const SizedBox(height: AppSpacing.md),
                        AppTextField(
                          label: l10n.age,
                          hint: l10n.age,
                          keyboardType: TextInputType.number,
                          controller: _ageController,
                          errorText: _ageError,
                          onChanged: (_) {
                            cubit.updateAge(_ageController.text);
                            setState(() => _ageError = null);
                          },
                        ),
                        const SizedBox(height: AppSpacing.md),
                        AppTextField(
                          label: l10n.heightCm,
                          hint: l10n.heightCm,
                          keyboardType: TextInputType.number,
                          controller: _heightController,
                          errorText: _heightError,
                          onChanged: (_) {
                            cubit.updateHeight(_heightController.text);
                            setState(() => _heightError = null);
                          },
                        ),
                        const SizedBox(height: AppSpacing.md),
                        AppTextField(
                          label: l10n.weightKg,
                          hint: l10n.weightKg,
                          keyboardType: TextInputType.number,
                          controller: _weightController,
                          errorText: _weightError,
                          onChanged: (_) {
                            cubit.updateWeight(_weightController.text);
                            setState(() => _weightError = null);
                          },
                        ),
                        const SizedBox(height: AppSpacing.md),
                        PhoneNumberField(
                          label: l10n.phoneNumber,
                          countryCode: _phoneCountry?.dialCode ?? '+966',
                          flagAsset: '',
                          controller: _phoneController,
                          maxPhoneDigits: 10,
                          initialCountryIso: _phoneCountry?.code ?? 'SA',
                          errorText: _phoneError,
                          onCountryChanged: (country) {
                            setState(() {
                              _phoneCountry = country;
                              _phoneError = null;
                            });
                          },
                          onChanged: (v) {
                            cubit.updatePhoneNumber(v);
                            setState(() => _phoneError = null);
                          },
                        ),
                        const SizedBox(height: AppSpacing.md),
                        AppTextField(
                          label: l10n.emailTab,
                          hint: l10n.emailTab,
                          keyboardType: TextInputType.emailAddress,
                          controller: _emailController,
                          errorText: _emailError,
                          onChanged: (_) {
                            cubit.updateEmail(_emailController.text);
                            setState(() => _emailError = null);
                          },
                        ),
                        if (extraQs.isNotEmpty) ...[
                          const SizedBox(height: AppSpacing.lg),
                          ApiPersonalInformationFieldsBlock(questions: extraQs),
                        ],
                        const SizedBox(height: AppSpacing.lg),
                      ],
                    ),
                  ),
                ),
              ),
              AppButton(
                label: l10n.continueTxt,
                onPressed: waitingForQuestionnaire
                    ? null
                    : () => _onContinuePersonalInformation(context),
                buttonColor: isDark ? AppColors.primary : AppColors.primaryBrown,
                expanded: true,
              ),
            ],
          ),
        );
      },
    );
  }
}
