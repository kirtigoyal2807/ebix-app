import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:pilates_app/config/theme/app_colors.dart';
import 'package:pilates_app/config/theme/app_spacing.dart';
import 'package:pilates_app/config/theme/app_text_styles.dart';
import 'package:pilates_app/features/auth/cubit/auth_cubit.dart';
import 'package:pilates_app/features/auth/cubit/auth_state.dart';
import 'package:pilates_app/features/auth/data/models/register_gender.dart';
import 'package:pilates_app/widgets/app_app_bar.dart';
import 'package:pilates_app/widgets/app_button.dart';
import 'package:pilates_app/widgets/app_dropdown.dart';
import 'package:pilates_app/widgets/app_scaffold.dart';
import 'package:pilates_app/widgets/app_text_field.dart';
import 'package:pilates_app/widgets/phone_number_field.dart';

import '../../../core/localization/localization_extension.dart';
import '../../../core/utils/input_validators.dart';
import 'widgets/sign_up_header.dart';
import 'widgets/sign_up_progress.dart';

class SignUpPersonalInfoView extends StatefulWidget {
  const SignUpPersonalInfoView({super.key});

  @override
  State<SignUpPersonalInfoView> createState() => _SignUpPersonalInfoViewState();
}

class _SignUpPersonalInfoViewState extends State<SignUpPersonalInfoView> {
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _phoneController = TextEditingController();

  CountryCode? _phoneCountry;
  String? _genderValue;
  String? _clientFirstNameError;
  String? _clientLastNameError;
  String? _clientEmailError;
  String? _clientPasswordError;
  String? _clientPhoneError;

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  String _composePhoneE164() {
    final digits = _phoneController.text.replaceAll(RegExp(r'\D'), '');
    if (digits.isEmpty) return '';
    final dial = _phoneCountry?.dialCode ?? '+966';
    return '$dial$digits';
  }

  RegisterGender? _mapGender(String? value) {
    switch (value) {
      case 'male':
        return RegisterGender.male;
      case 'female':
        return RegisterGender.female;
      case 'other':
        return RegisterGender.other;
      default:
        return null;
    }
  }

  void _submit(BuildContext context) {
    final l10n = context.l10n;
    final first = _firstNameController.text.trim();
    final last = _lastNameController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text;
    final phone = _composePhoneE164();

    setState(() {
      _clientFirstNameError = first.isEmpty ? l10n.pleaseEnterFirstName : null;
      _clientLastNameError = last.isEmpty ? l10n.pleaseEnterLastName : null;
      _clientEmailError = email.isEmpty
          ? l10n.pleaseEnterEmail
          : (InputValidators.isValidEmail(email)
                ? null
                : l10n.pleaseEnterValidEmail);
      _clientPasswordError = password.length < 8 ? l10n.passwordTooShort : null;
      _clientPhoneError = phone.length < 8 ? l10n.pleaseEnterPhone : null;
    });

    if (first.isEmpty ||
        last.isEmpty ||
        email.isEmpty ||
        !InputValidators.isValidEmail(email) ||
        password.length < 8 ||
        phone.length < 8) {
      return;
    }

    final authState = context.read<AuthCubit>().state;
    DateTime? dob;
    try {
      dob = DateFormat('dd/MM/yyyy').parse(authState.dateOfBirth.trim());
    } catch (_) {
      dob = null;
    }

    context.read<AuthCubit>().register(
      firstName: first,
      lastName: last,
      email: email,
      phone: phone,
      password: password,
      gender: _mapGender(_genderValue),
      dob: dob,
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return BlocConsumer<AuthCubit, AuthState>(
      listenWhen: (previous, current) {
        return previous.registerUiStatus == RegisterUiStatus.loading &&
            current.registerUiStatus == RegisterUiStatus.idle &&
            current.registerErrorMessage.isNotEmpty &&
            current.registerFieldErrors.isEmpty;
      },
      listener: (context, state) {
        final text = state.registerErrorMessage.trim().isEmpty
            ? context.l10n.loginErrorGeneric
            : state.registerErrorMessage;
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(text)));
      },
      builder: (context, state) {
        final fe = state.registerFieldErrors;
        final loading = state.registerUiStatus == RegisterUiStatus.loading;

        return AppScaffold(
          appBar: AppAppBar(
            onBack: () => context.read<AuthCubit>().previousSignUpStep(),
            title: context.l10n.signUp,
            isMoreMenu: false,
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.lg,
              vertical: AppSpacing.md,
            ),
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SignUpProgress(currentStep: 0, totalSteps: 5),
                        const SizedBox(height: AppSpacing.sm),
                        RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: '${context.l10n.step} 1',
                                style: AppTextStyles.caption(context).copyWith(
                                  color: isDark
                                      ? AppColors.languageTextDark
                                      : AppColors.languageIcon,
                                ),
                              ),
                              TextSpan(
                                text: ' ${context.l10n.offf} 5',
                                style: AppTextStyles.caption(context),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: AppSpacing.xl),
                        SignUpHeader(
                          title: context.l10n.letsGo,
                          subtitle: context.l10n.tellYourName,
                          step: 0,
                          totalSteps: 4,
                        ),
                        const SizedBox(height: AppSpacing.lg),
                        AppTextField(
                          key: const ValueKey('signup_firstName'),
                          controller: _firstNameController,
                          label: context.l10n.firstName,
                          hint: 'Ayesha',
                          keyboardType: TextInputType.name,
                          errorText:
                              _clientFirstNameError ??
                              fe['firstname'] ??
                              fe['first_name'],
                          onChanged: (_) => setState(() {
                            _clientFirstNameError = null;
                          }),
                        ),
                        const SizedBox(height: AppSpacing.md),
                        AppTextField(
                          key: const ValueKey('signup_lastName'),
                          controller: _lastNameController,
                          label: context.l10n.lastName,
                          hint: 'Tajib',
                          keyboardType: TextInputType.name,
                          errorText:
                              _clientLastNameError ??
                              fe['lastname'] ??
                              fe['last_name'],
                          onChanged: (_) => setState(() {
                            _clientLastNameError = null;
                          }),
                        ),
                        const SizedBox(height: AppSpacing.md),
                        AppTextField(
                          key: const ValueKey('signup_email'),
                          controller: _emailController,
                          label: context.l10n.emailAddress,
                          hint: 'Ayesha@gmail.com',
                          keyboardType: TextInputType.emailAddress,
                          errorText: _clientEmailError ?? fe['email'],
                          onChanged: (_) => setState(() {
                            _clientEmailError = null;
                          }),
                        ),
                        const SizedBox(height: AppSpacing.md),
                        AppDropDown<String>(
                          label: context.l10n.gender,
                          hint: context.l10n.selectGender,
                          value: _genderValue,
                          errorText: fe['gender'],
                          items: [
                            DropdownMenuItem(
                              value: 'male',
                              child: Text(
                                context.l10n.male,
                                style: AppTextStyles.textField(context),
                              ),
                            ),
                            DropdownMenuItem(
                              value: 'female',
                              child: Text(
                                context.l10n.female,
                                style: AppTextStyles.textField(context),
                              ),
                            ),
                            DropdownMenuItem(
                              value: 'other',
                              child: Text(
                                context.l10n.other,
                                style: AppTextStyles.textField(context),
                              ),
                            ),
                          ],
                          onChanged: loading
                              ? null
                              : (value) {
                                  setState(() {
                                    _genderValue = value;
                                  });
                                },
                        ),
                        const SizedBox(height: AppSpacing.md),
                        BlocBuilder<AuthCubit, AuthState>(
                          builder: (context, state) {
                            return AppTextField(
                              style: AppTextStyles.textField(context).copyWith(
                                color: state.dateOfBirth.isEmpty
                                    ? AppColors.lightGrey
                                    : null,
                              ),
                              onTap: () async {
                                final DateTime? picked = await showDatePicker(
                                  context: context,
                                  initialDate: state.dateOfBirth.isEmpty
                                      ? DateTime.now()
                                      : DateFormat(
                                          "dd/MM/yyyy",
                                        ).parse(state.dateOfBirth),
                                  firstDate: DateTime(1900),
                                  lastDate: DateTime(2100),
                                );

                                if (picked != null) {
                                  if (!context.mounted) return;
                                  context.read<AuthCubit>().changeDOB(picked);
                                }
                              },
                              readOnly: true,
                              initialValue: state.dateOfBirth.isEmpty
                                  ? context.l10n.selectDOB
                                  : state.dateOfBirth,
                              label: context.l10n.date_of_birth,

                              hint: context.l10n.selectDOB,
                              keyboardType: TextInputType.emailAddress,
                            );
                          },
                        ),
                        const SizedBox(height: AppSpacing.md),
                        AppTextField(
                          key: const ValueKey('signup_password'),
                          controller: _passwordController,
                          label: context.l10n.password,
                          hint: '**********',
                          obscure: true,
                          keyboardType: TextInputType.visiblePassword,
                          maxLines: 1,
                          errorText: _clientPasswordError ?? fe['password'],
                          onChanged: (_) => setState(() {
                            _clientPasswordError = null;
                          }),
                        ),
                        const SizedBox(height: AppSpacing.md),
                        PhoneNumberField(
                          key: const ValueKey('signup_phone'),
                          label: context.l10n.phoneNumber,
                          controller: _phoneController,
                          countryCode: '+1',
                          flagAsset: 'assets/flags/us.svg',
                          errorText: _clientPhoneError ?? fe['phone'],
                          onCountryChanged: (country) {
                            setState(() {
                              _phoneCountry = country;
                              _clientPhoneError = null;
                            });
                          },
                        ),
                        const SizedBox(height: AppSpacing.lg),
                      ],
                    ),
                  ),
                ),
                AppButton(
                  key: const ValueKey('signup_continue'),
                  label: context.l10n.continueTxt,
                  isLoading: loading,
                  onPressed: loading ? null : () => _submit(context),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
