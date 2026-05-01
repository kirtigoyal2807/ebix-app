import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pilates_app/config/theme/app_colors.dart';
import 'package:pilates_app/config/theme/app_spacing.dart';
import 'package:pilates_app/config/theme/app_text_styles.dart';
import 'package:pilates_app/core/localization/arb/app_localizations.dart';
import 'package:pilates_app/core/validation/contact_validators.dart';
import 'package:pilates_app/core/validation/personal_information_validators.dart';
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

  bool _questionnaireLoading = false;

  @override
  void initState() {
    super.initState();
    final s = context.read<SubscriptionCubit>().state;
    _nameController = TextEditingController(text: s.name);
    _ageController = TextEditingController(text: s.age);
    _heightController = TextEditingController(text: s.height);
    _weightController = TextEditingController(text: s.weight);
    _phoneController = TextEditingController(text: s.phoneNumber);
    _emailController = TextEditingController(text: s.email);

    WidgetsBinding.instance.addPostFrameCallback((_) => _ensureQuestionnaire());
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

  void _onContinuePersonalInformation(BuildContext context) {
    final messenger = ScaffoldMessenger.of(context);
    final l10n = AppLocalizations.of(context)!;
    final cubit = context.read<SubscriptionCubit>();
    // Flush controllers into cubit so validation matches what the user sees
    // (avoids stale state if `onChanged` did not run for the latest edit).
    cubit.updateName(_nameController.text);
    cubit.updateAge(_ageController.text);
    cubit.updateHeight(_heightController.text);
    cubit.updateWeight(_weightController.text);
    cubit.updatePhoneNumber(_phoneController.text);
    cubit.updateEmail(_emailController.text);
    final s = cubit.state;

    if (s.name.trim().isEmpty ||
        s.age.trim().isEmpty ||
        s.height.trim().isEmpty ||
        s.weight.trim().isEmpty ||
        s.phoneNumber.trim().isEmpty ||
        s.email.trim().isEmpty) {
      messenger.showSnackBar(
        SnackBar(content: Text(l10n.pleaseCompletePersonalInformation)),
      );
      return;
    }
    if (!PersonalInformationValidators.isValidName(s.name)) {
      messenger.showSnackBar(
        SnackBar(content: Text(l10n.enterValidName)),
      );
      return;
    }
    if (!PersonalInformationValidators.isValidAge(s.age)) {
      messenger.showSnackBar(
        SnackBar(content: Text(l10n.enterValidAge)),
      );
      return;
    }
    if (!PersonalInformationValidators.isValidHeightCm(s.height)) {
      messenger.showSnackBar(
        SnackBar(content: Text(l10n.enterValidHeightCm)),
      );
      return;
    }
    if (!PersonalInformationValidators.isValidWeightKg(s.weight)) {
      messenger.showSnackBar(
        SnackBar(content: Text(l10n.enterValidWeightKg)),
      );
      return;
    }
    if (!PersonalInformationValidators.isTenDigitMobile(s.phoneNumber)) {
      messenger.showSnackBar(
        SnackBar(content: Text(l10n.phoneTenDigitsRequired)),
      );
      return;
    }
    if (!ContactValidators.isValidEmail(s.email)) {
      messenger.showSnackBar(
        SnackBar(content: Text(l10n.pleaseEnterValidEmail)),
      );
      return;
    }

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
          p.healthQuestionnaireQuestions != c.healthQuestionnaireQuestions ||
          p.selectedProductRequiresHealthIntake !=
              c.selectedProductRequiresHealthIntake,
      builder: (context, state) {
        final cubit = context.read<SubscriptionCubit>();
        final extraQs = extraPersonalInformationQuestionsFromApi(
          state.healthQuestionnaireQuestions,
        );
        final waitingForQuestionnaire = state.selectedProductRequiresHealthIntake &&
            state.healthQuestionnaireQuestions.isEmpty &&
            _questionnaireLoading;

        return Padding(
          padding: const EdgeInsets.symmetric(
            vertical: AppSpacing.lg,
            horizontal: AppSpacing.lg,
          ),
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SubscriptionStepHeader(
                        currentStep: 0,
                        totalSteps: 6,
                        isDark: isDark,
                      ),
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
                        onChanged: cubit.updateName,
                      ),
                      const SizedBox(height: AppSpacing.md),
                      AppTextField(
                        label: l10n.age,
                        hint: l10n.age,
                        keyboardType: TextInputType.number,
                        controller: _ageController,
                        onChanged: cubit.updateAge,
                      ),
                      const SizedBox(height: AppSpacing.md),
                      AppTextField(
                        label: l10n.heightCm,
                        hint: l10n.heightCm,
                        keyboardType: TextInputType.number,
                        controller: _heightController,
                        onChanged: cubit.updateHeight,
                      ),
                      const SizedBox(height: AppSpacing.md),
                      AppTextField(
                        label: l10n.weightKg,
                        hint: l10n.weightKg,
                        keyboardType: TextInputType.number,
                        controller: _weightController,
                        onChanged: cubit.updateWeight,
                      ),
                      const SizedBox(height: AppSpacing.md),
                      PhoneNumberField(
                        label: l10n.phoneNumber,
                        countryCode: '+966',
                        flagAsset: '',
                        controller: _phoneController,
                        maxPhoneDigits: 10,
                        onChanged: cubit.updatePhoneNumber,
                      ),
                      const SizedBox(height: AppSpacing.md),
                      AppTextField(
                        label: l10n.emailTab,
                        hint: l10n.emailTab,
                        keyboardType: TextInputType.emailAddress,
                        controller: _emailController,
                        onChanged: cubit.updateEmail,
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
