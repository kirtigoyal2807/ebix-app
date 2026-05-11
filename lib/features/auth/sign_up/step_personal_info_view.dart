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
import '../../../core/utils/date_of_birth_constraints.dart';
import '../../../core/utils/input_validators.dart';
import '../../../core/validation/phone_number_country_validation.dart';
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
  final _confirmPasswordController = TextEditingController();
  final _phoneController = TextEditingController();

  final _firstNameFocus = FocusNode();
  final _lastNameFocus = FocusNode();
  final _emailFocus = FocusNode();
  final _dobFocus = FocusNode();
  final _passwordFocus = FocusNode();
  final _confirmPasswordFocus = FocusNode();
  final _phoneFocus = FocusNode();

  CountryCode? _phoneCountry;
  String? _genderValue;
  String? _clientFirstNameError;
  String? _clientLastNameError;
  String? _clientEmailError;
  String? _clientConfirmError;
  String? _clientGenderError;
  String? _clientDobError;
  String? _clientPhoneError;

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _phoneController.dispose();
    _firstNameFocus.dispose();
    _lastNameFocus.dispose();
    _emailFocus.dispose();
    _dobFocus.dispose();
    _passwordFocus.dispose();
    _confirmPasswordFocus.dispose();
    _phoneFocus.dispose();
    super.dispose();
  }

  String _composePhoneE164() {
    final digits = PhoneNumberCountryValidation.normalizedNationalDigitsForE164(
      iso3166Alpha2: _phoneCountry?.code ?? 'SA',
      rawNationalField: _phoneController.text,
    );
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
    final authState = context.read<AuthCubit>().state;
    final dobSelection = authState.dateOfBirth.trim();
    final first = _firstNameController.text.trim();
    final last = _lastNameController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text;
    final confirm = _confirmPasswordController.text;
    final phoneSubmitError = PhoneNumberCountryValidation.submitErrorMessage(
      l10n: l10n,
      rawNationalField: _phoneController.text,
      countryIso3166Alpha2: _phoneCountry?.code,
    );

    setState(() {
      _clientFirstNameError = first.isEmpty ? l10n.pleaseEnterFirstName : null;
      _clientLastNameError = last.isEmpty ? l10n.pleaseEnterLastName : null;
      _clientEmailError = email.isEmpty
          ? l10n.pleaseEnterEmail
          : (InputValidators.isValidEmail(email)
                ? null
                : l10n.pleaseEnterValidEmail);
      _clientGenderError = _genderValue == null
          ? l10n.pleaseSelectGender
          : null;
      _clientDobError = dobSelection.isEmpty
          ? l10n.pleaseSelectDateOfBirth
          : null;
      _clientConfirmError = null;
      if (password.length < 8) {
        _clientConfirmError = l10n.passwordTooShort;
      } else if (password != confirm) {
        _clientConfirmError = l10n.passwordMismatch;
      }
      _clientPhoneError = phoneSubmitError;
    });

    if (first.isEmpty ||
        last.isEmpty ||
        email.isEmpty ||
        !InputValidators.isValidEmail(email) ||
        _genderValue == null ||
        dobSelection.isEmpty ||
        password.length < 8 ||
        password != confirm ||
        phoneSubmitError != null) {
      return;
    }

    final phone = _composePhoneE164();

    DateTime? dob;
    try {
      if (dobSelection.isNotEmpty) {
        dob = DateFormat('dd/MM/yyyy').parse(dobSelection);
      }
    } catch (_) {
      dob = null;
    }

    if (dob != null &&
        !DateOfBirthConstraints.satisfiesMinimumAge(dob, DateTime.now())) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(context.l10n.dobMinimumAgeError)));
      return;
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
        bool hasVisibleFieldError(String? text) =>
            text != null && text.trim().isNotEmpty;
        final confirmDisplayedError =
            _clientConfirmError ??
            fe['password_confirmation'] ??
            fe['confirm_password'];
        final showPasswordMinimumLengthHint =
            !hasVisibleFieldError(fe['password']) &&
            !hasVisibleFieldError(confirmDisplayedError);

        return AppScaffold(
          appBar: AppAppBar(
            onBack: () => context.read<AuthCubit>().previousSignUpStep(),
            title: context.l10n.signUp,
            isMoreMenu: false,
          ),
          body: Padding(
            padding: EdgeInsets.only(
              left: AppSpacing.lg,
              right: AppSpacing.lg,
              top: AppSpacing.md,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SignUpProgress(currentStep: 0, totalSteps: 5),

                SizedBox(height: AppSpacing.sm),
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
                SizedBox(height: AppSpacing.sm),
                Expanded(
                  child: Stack(
                    children: [
                      SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: AppSpacing.lg),
                            SignUpHeader(
                              title: context.l10n.letsGo,
                              subtitle: context.l10n.tellYourName,
                              step: 0,
                              totalSteps: 4,
                            ),
                            SizedBox(height: AppSpacing.lg),
                            AppTextField(
                              key: const ValueKey('signup_firstName'),
                              controller: _firstNameController,
                              focusNode: _firstNameFocus,
                              label: context.l10n.firstName,
                              hint: context.l10n.signupFirstNameHint,
                              keyboardType: TextInputType.name,
                              textInputAction: TextInputAction.next,
                              onFieldSubmitted: (_) => FocusScope.of(
                                context,
                              ).requestFocus(_lastNameFocus),
                              errorText:
                                  _clientFirstNameError ??
                                  fe['firstname'] ??
                                  fe['first_name'],
                              onChanged: (_) => setState(() {
                                _clientFirstNameError = null;
                              }),
                            ),
                            SizedBox(height: AppSpacing.md),
                            AppTextField(
                              key: const ValueKey('signup_lastName'),
                              controller: _lastNameController,
                              focusNode: _lastNameFocus,
                              label: context.l10n.lastName,
                              hint: context.l10n.signupLastNameHint,
                              keyboardType: TextInputType.name,
                              textInputAction: TextInputAction.next,
                              onFieldSubmitted: (_) => FocusScope.of(
                                context,
                              ).requestFocus(_emailFocus),
                              errorText:
                                  _clientLastNameError ??
                                  fe['lastname'] ??
                                  fe['last_name'],
                              onChanged: (_) => setState(() {
                                _clientLastNameError = null;
                              }),
                            ),
                            SizedBox(height: AppSpacing.md),
                            AppTextField(
                              key: const ValueKey('signup_email'),
                              controller: _emailController,
                              focusNode: _emailFocus,
                              label: context.l10n.emailAddress,
                              hint: 'Ayesha@gmail.com',
                              keyboardType: TextInputType.emailAddress,
                              textInputAction: TextInputAction.next,
                              onFieldSubmitted: (_) => FocusScope.of(
                                context,
                              ).requestFocus(_dobFocus),
                              errorText: _clientEmailError ?? fe['email'],
                              onChanged: (_) => setState(() {
                                _clientEmailError = null;
                              }),
                            ),
                            SizedBox(height: AppSpacing.md),
                            AppDropDown<String>(
                              label: context.l10n.gender,
                              hint: context.l10n.selectGender,
                              value: _genderValue,
                              errorText: _clientGenderError ?? fe['gender'],
                              items: [
                                //removed male and other options as per the client ISSUE-006
                                // DropdownMenuItem(
                                //   value: 'male',
                                //   child: Text(
                                //     context.l10n.male,
                                //     style: AppTextStyles.textField(context),
                                //   ),
                                // ),
                                DropdownMenuItem(
                                  value: 'female',
                                  child: Text(
                                    context.l10n.female,
                                    style: AppTextStyles.textField(context),
                                  ),
                                ),
                                // DropdownMenuItem(
                                //   value: 'other',
                                //   child: Text(
                                //     context.l10n.other,
                                //     style: AppTextStyles.textField(context),
                                //   ),
                                // ),
                              ],
                              onChanged: loading
                                  ? null
                                  : (value) {
                                      setState(() {
                                        _genderValue = value;
                                        _clientGenderError = null;
                                      });
                                    },
                            ),
                            SizedBox(height: AppSpacing.md),
                            BlocBuilder<AuthCubit, AuthState>(
                              builder: (context, state) {
                                return AppTextField(
                                  focusNode: _dobFocus,
                                  style: AppTextStyles.textField(context)
                                      .copyWith(
                                        color: state.dateOfBirth.isEmpty
                                            ? AppColors.lightGrey
                                            : null,
                                      ),
                                  onTap: () async {
                                    final today = DateTime.now();
                                    final lastDob =
                                        DateOfBirthConstraints.latestSelectableBirthDate(
                                          today,
                                        );
                                    final firstDate = DateTime(1900);
                                    DateTime parsedInitial = lastDob;
                                    try {
                                      if (state.dateOfBirth.isNotEmpty) {
                                        parsedInitial = DateFormat(
                                          'dd/MM/yyyy',
                                        ).parse(state.dateOfBirth);
                                      }
                                    } catch (_) {
                                      parsedInitial = lastDob;
                                    }
                                    final initial =
                                        DateOfBirthConstraints.clampToSelectableRange(
                                          parsedInitial,
                                          firstDate,
                                          lastDob,
                                        );
                                    final DateTime? picked =
                                        await showDatePicker(
                                          context: context,
                                          initialDate: initial,
                                          firstDate: firstDate,
                                          lastDate: lastDob,
                                        );

                                    if (picked != null) {
                                      if (!context.mounted) return;
                                      context.read<AuthCubit>().changeDOB(
                                        picked,
                                      );
                                      setState(() {
                                        _clientDobError = null;
                                      });
                                    }
                                  },
                                  readOnly: true,
                                  initialValue: state.dateOfBirth.isEmpty
                                      ? context.l10n.selectDOB
                                      : state.dateOfBirth,
                                  label: context.l10n.date_of_birth,

                                  hint: context.l10n.selectDOB,
                                  keyboardType: TextInputType.emailAddress,
                                  textInputAction: TextInputAction.next,
                                  errorText:
                                      _clientDobError ??
                                      fe['dob'] ??
                                      fe['date_of_birth'],
                                  onFieldSubmitted: (_) => FocusScope.of(
                                    context,
                                  ).requestFocus(_passwordFocus),
                                );
                              },
                            ),
                            SizedBox(height: AppSpacing.md),
                            AppTextField(
                              key: const ValueKey('signup_password'),
                              controller: _passwordController,
                              focusNode: _passwordFocus,
                              label: context.l10n.password,
                              hint: '**********',
                              obscure: true,
                              keyboardType: TextInputType.visiblePassword,
                              maxLines: 1,
                              textInputAction: TextInputAction.next,
                              onFieldSubmitted: (_) => FocusScope.of(
                                context,
                              ).requestFocus(_confirmPasswordFocus),
                              errorText: fe['password'],
                              onChanged: (_) => setState(() {
                                _clientConfirmError = null;
                              }),
                            ),
                            SizedBox(height: AppSpacing.md),
                            AppTextField(
                              key: const ValueKey('signup_confirm_password'),
                              controller: _confirmPasswordController,
                              focusNode: _confirmPasswordFocus,
                              label: context.l10n.confirmPassword,
                              hint: '**********',
                              obscure: true,
                              keyboardType: TextInputType.visiblePassword,
                              maxLines: 1,
                              textInputAction: TextInputAction.next,
                              onFieldSubmitted: (_) => FocusScope.of(
                                context,
                              ).requestFocus(_phoneFocus),
                              errorText:
                                  _clientConfirmError ??
                                  fe['password_confirmation'] ??
                                  fe['confirm_password'],
                              onChanged: (_) => setState(() {
                                _clientConfirmError = null;
                              }),
                            ),
                            if (showPasswordMinimumLengthHint) ...[
                              SizedBox(height: 6),
                              Text(
                                context.l10n.passwordMinimumLengthHint,
                                style:
                                    AppTextStyles.body(
                                      context,
                                      fontWeight: FontWeight.w400,
                                    ).copyWith(
                                      height: 1.55,
                                      color: AppColors.lightGrey,
                                    ),
                              ),
                            ],
                            SizedBox(height: AppSpacing.md),
                            PhoneNumberField(
                              key: const ValueKey('signup_phone'),
                              label: context.l10n.phoneNumber,
                              controller: _phoneController,
                              focusNode: _phoneFocus,
                              textInputAction: TextInputAction.done,
                              onFieldSubmitted: (_) =>
                                  FocusManager.instance.primaryFocus?.unfocus(),
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
                            SizedBox(
                              height:
                                  MediaQuery.sizeOf(context).height * 0.04 + 48,
                            ),
                          ],
                        ),
                      ),

                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: Container(
                          height: AppSpacing.md + 52,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin:
                                  Alignment.bottomCenter, // start from bottom
                              end: Alignment.topCenter, // fade to top
                              colors: isDark
                                  ? [
                                      AppColors.darkShadow,
                                      AppColors.darkShadow.withValues(alpha: 0),
                                    ]
                                  : [
                                      Colors.white,
                                      Colors.white.withValues(alpha: 0),
                                    ],
                            ),
                          ),
                        ),
                      ),

                      // Sticky action button
                      Positioned(
                        left: 0,
                        right: 0,
                        bottom: AppSpacing.md,
                        child: AppButton(
                          key: const ValueKey('signup_continue'),
                          label: context.l10n.continueTxt,
                          isLoading: loading,
                          onPressed: loading ? null : () => _submit(context),
                        ),
                      ),
                    ],
                  ),
                ),
                // AppButton(
                //   key: const ValueKey('signup_continue'),
                //   label: context.l10n.continueTxt,
                //   isLoading: loading,
                //   onPressed: loading ? null : () => _submit(context),
                // ),
              ],
            ),
          ),
        );
      },
    );
  }
}
