import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pilates_app/config/theme/app_spacing.dart';
import 'package:pilates_app/features/auth/cubit/auth_cubit.dart';
import 'package:pilates_app/features/auth/cubit/auth_state.dart';
import 'package:pilates_app/widgets/app_app_bar.dart';
import 'package:pilates_app/widgets/app_button.dart';
import 'package:pilates_app/widgets/app_scaffold.dart';
import 'package:pilates_app/widgets/app_text_field.dart';

import '../../../core/localization/localization_extension.dart';
import '../sign_up/widgets/sign_up_header.dart';
import 'forgot_otp_view.dart';

class ForgotPasswordView extends StatefulWidget {
  const ForgotPasswordView({super.key});

  @override
  State<ForgotPasswordView> createState() => _ForgotPasswordViewState();
}

class _ForgotPasswordViewState extends State<ForgotPasswordView> {
  final _emailController = TextEditingController();
  String? _clientEmailError;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.read<AuthCubit>().prepareForgotPasswordFlow();
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _sendCode(BuildContext context) async {
    final l10n = context.l10n;
    final email = _emailController.text.trim();
    setState(() {
      _clientEmailError = email.isEmpty ? l10n.pleaseEnterEmail : null;
    });
    if (email.isEmpty) return;

    await context.read<AuthCubit>().requestForgotPassword(email);
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
      listenWhen: (previous, current) {
        return previous.forgotPasswordUiStatus == ForgotPasswordUiStatus.loading &&
            current.forgotPasswordUiStatus == ForgotPasswordUiStatus.idle;
      },
      listener: (context, state) {
        if (state.forgotPasswordFieldErrors.isNotEmpty) return;
        if (state.forgotPasswordEmail.isNotEmpty &&
            state.forgotPasswordErrorMessage.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(context.l10n.forgotPasswordCodeSent)),
          );
          final email = state.forgotPasswordEmail;
          Navigator.of(context).push(
            MaterialPageRoute<void>(
              builder: (_) => ForgotOtpView(email: email),
            ),
          );
          return;
        }
        if (state.forgotPasswordErrorMessage.isNotEmpty) {
          final text = state.forgotPasswordErrorMessage.trim().isEmpty
              ? context.l10n.loginErrorGeneric
              : state.forgotPasswordErrorMessage;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(text)),
          );
        }
      },
      builder: (context, state) {
        final fe = state.forgotPasswordFieldErrors;
        final loading = state.forgotPasswordUiStatus == ForgotPasswordUiStatus.loading;

        return AppScaffold(
          appBar: AppAppBar(
            onBack: () => Navigator.of(context).pop(),
            title: context.l10n.forgotPasswordTitle,
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
                        const SizedBox(height: AppSpacing.lg),
                        SignUpHeader(
                          title: context.l10n.enterEmailHeader,
                          subtitle: context.l10n.enterEmailSubtitle,
                          step: 0,
                          totalSteps: 0,
                        ),
                        const SizedBox(height: AppSpacing.xxl),
                        AppTextField(
                          key: const ValueKey('forgot_email'),
                          controller: _emailController,
                          label: context.l10n.enterEmailHeader,
                          hint: context.l10n.usernameHint,
                          keyboardType: TextInputType.emailAddress,
                          errorText: _clientEmailError ?? fe['email'],
                          onChanged: (_) => setState(() => _clientEmailError = null),
                        ),
                      ],
                    ),
                  ),
                ),
                AppButton(
                  key: const ValueKey('forgot_send_code'),
                  label: context.l10n.sendCode,
                  isLoading: loading,
                  onPressed: loading ? null : () => _sendCode(context),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
