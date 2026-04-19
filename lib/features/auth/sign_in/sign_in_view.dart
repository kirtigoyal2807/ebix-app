import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pilates_app/config/theme/app_colors.dart';
import 'package:pilates_app/config/theme/app_spacing.dart';
import 'package:pilates_app/config/theme/app_text_styles.dart';
import 'package:pilates_app/features/auth/cubit/auth_cubit.dart';
import 'package:pilates_app/features/auth/cubit/auth_state.dart';
import 'package:pilates_app/features/auth/sign_up/widgets/sign_up_header.dart';
import 'package:pilates_app/widgets/app_app_bar.dart';
import 'package:pilates_app/widgets/app_button.dart';
import 'package:pilates_app/widgets/app_scaffold.dart';
import 'package:pilates_app/widgets/app_text.dart';
import 'package:pilates_app/widgets/app_text_field.dart';
import 'package:pilates_app/widgets/phone_number_field.dart';

import '../../../core/localization/localization_extension.dart';
import '../forgot_password/forgot_password_view.dart';

class SignInView extends StatefulWidget {
  const SignInView({super.key});

  @override
  State<SignInView> createState() => _SignInViewState();
}

class _SignInViewState extends State<SignInView> {
  int _selectedTab = 0;

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _phoneController = TextEditingController();

  CountryCode? _phoneCountry;
  String? _clientEmailError;
  String? _clientPasswordError;
  String? _clientPhoneError;

  @override
  void dispose() {
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

  void _submitEmail(BuildContext context) {
    final l10n = context.l10n;
    final email = _emailController.text.trim();
    final password = _passwordController.text;
    setState(() {
      _clientEmailError =
          email.isEmpty ? l10n.pleaseEnterEmail : null;
      _clientPasswordError =
          password.isEmpty ? l10n.pleaseEnterPassword : null;
    });
    if (email.isEmpty || password.isEmpty) return;

    context.read<AuthCubit>().loginWithEmail(
          email: email,
          password: password,
        );
  }

  void _submitPhone(BuildContext context) {
    final phone = _composePhoneE164();
    final l10n = context.l10n;
    setState(() {
      _clientPhoneError =
          phone.length < 8 ? l10n.pleaseEnterPhone : null;
    });
    if (phone.length < 8) return;

    context.read<AuthCubit>().requestPhoneLoginOtp(phone: phone);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return BlocConsumer<AuthCubit, AuthState>(
      listenWhen: (previous, current) {
        if (current.showPhoneOtpSuccess && !previous.showPhoneOtpSuccess) {
          return true;
        }
        return previous.loginUiStatus == LoginUiStatus.loading &&
            current.loginUiStatus == LoginUiStatus.idle &&
            current.loginErrorMessage.isNotEmpty &&
            current.loginFieldErrors.isEmpty;
      },
      listener: (context, state) {
        final messenger = ScaffoldMessenger.of(context);
        if (state.showPhoneOtpSuccess) {
          messenger.showSnackBar(
            SnackBar(content: Text(context.l10n.loginOtpSent)),
          );
          context.read<AuthCubit>().clearPhoneOtpSuccessBanner();
          return;
        }
        if (state.loginErrorMessage.isNotEmpty &&
            state.loginFieldErrors.isEmpty) {
          final text = state.loginErrorMessage.trim().isEmpty
              ? context.l10n.loginErrorGeneric
              : state.loginErrorMessage;
          messenger.showSnackBar(SnackBar(content: Text(text)));
        }
      },
      builder: (context, state) {
        final fe = state.loginFieldErrors;
        final loading = state.loginUiStatus == LoginUiStatus.loading;

        return AppScaffold(
          appBar: AppAppBar(
            onBack: () => context.read<AuthCubit>().backFromSignIn(),
            title: context.l10n.signIn,
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 0,
              vertical: AppSpacing.md,
            ),
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 2),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.lg,
                          ),
                          child: SignUpHeader(
                            title:
                                '${context.l10n.welcome} Tasha',
                            subtitle: context.l10n.enterYourLoginDetails,
                            step: 1,
                            totalSteps: 5,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.lg),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.lg,
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: GestureDetector(
                                  onTap: loading
                                      ? null
                                      : () => setState(() => _selectedTab = 0),
                                  child: Column(
                                    children: [
                                      AppText(
                                        context.l10n.emailTab,
                                        style: (context) => GoogleFonts.inter(
                                          fontSize: 16,
                                          fontWeight: _selectedTab == 0
                                              ? FontWeight.w600
                                              : FontWeight.w400,
                                          color: _selectedTab == 0
                                              ? (isDark
                                                  ? AppColors.languageTextDark
                                                  : AppColors.languageIcon)
                                              : AppColors.lightGrey,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Container(
                                        height: 2,
                                        color: _selectedTab == 0
                                            ? (isDark
                                                ? AppColors.languageTextDark
                                                : AppColors.primary)
                                            : Colors.transparent,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Expanded(
                                child: GestureDetector(
                                  key: const ValueKey('sign_in_tab_phone'),
                                  onTap: loading
                                      ? null
                                      : () => setState(() => _selectedTab = 1),
                                  child: Column(
                                    children: [
                                      AppText(
                                        context.l10n.phoneTab,
                                        style: (context) =>
                                            GoogleFonts.inter(
                                          fontSize: 16,
                                          fontWeight: _selectedTab == 1
                                              ? FontWeight.w600
                                              : FontWeight.w400,
                                          color: _selectedTab == 1
                                              ? (isDark
                                                  ? AppColors.languageTextDark
                                                  : AppColors.languageIcon)
                                              : AppColors.lightGrey,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Container(
                                        height: 2,
                                        color: _selectedTab == 1
                                            ? (isDark
                                                ? AppColors.languageTextDark
                                                : AppColors.primary)
                                            : Colors.transparent,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Divider(
                          height: 1,
                          thickness: 1,
                          color: isDark
                              ? AppColors.greyText
                              : AppColors.buttonBorder,
                        ),
                        const SizedBox(height: AppSpacing.xl),
                        if (_selectedTab == 0) ...[
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppSpacing.lg,
                            ),
                            child: AppTextField(
                              controller: _emailController,
                              label: context.l10n.email,
                              hint: context.l10n.usernameHint,
                              keyboardType: TextInputType.emailAddress,
                              errorText: _clientEmailError ?? fe['email'],
                              onChanged: (_) => setState(() {
                                _clientEmailError = null;
                              }),
                            ),
                          ),
                          const SizedBox(height: AppSpacing.md),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppSpacing.lg,
                            ),
                            child: AppTextField(
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
                          ),
                          const SizedBox(height: AppSpacing.sm),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppSpacing.lg,
                            ),
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: TextButton(
                                onPressed: loading
                                    ? null
                                    : () {
                                        Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder: (_) =>
                                                const ForgotPasswordView(),
                                          ),
                                        );
                                      },
                                child: AppText(
                                  context.l10n.forgotPassword,
                                  style: AppTextStyles.body,
                                ),
                              ),
                            ),
                          ),
                        ] else ...[
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppSpacing.lg,
                            ),
                            child: PhoneNumberField(
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
                          ),
                        ],
                        const SizedBox(height: AppSpacing.lg),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                  child: AppButton(
                    key: const ValueKey('sign_in_submit'),
                    label: _selectedTab == 0
                        ? context.l10n.signIn
                        : context.l10n.sendOtp,
                    isLoading: loading,
                    onPressed: loading
                        ? null
                        : () {
                            if (_selectedTab == 0) {
                              _submitEmail(context);
                            } else {
                              _submitPhone(context);
                            }
                          },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
