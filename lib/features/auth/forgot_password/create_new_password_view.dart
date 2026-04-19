import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pilates_app/config/theme/app_spacing.dart';
import 'package:pilates_app/core/localization/localization_extension.dart';
import 'package:pilates_app/features/auth/cubit/auth_cubit.dart';
import 'package:pilates_app/features/auth/cubit/auth_state.dart';
import 'package:pilates_app/features/auth/sign_up/widgets/sign_up_header.dart';
import 'package:pilates_app/widgets/app_app_bar.dart';
import 'package:pilates_app/widgets/app_button.dart';
import 'package:pilates_app/widgets/app_scaffold.dart';
import 'package:pilates_app/widgets/app_text_field.dart';

class CreateNewPasswordView extends StatefulWidget {
  const CreateNewPasswordView({super.key, required this.email});

  final String email;

  @override
  State<CreateNewPasswordView> createState() => _CreateNewPasswordViewState();
}

class _CreateNewPasswordViewState extends State<CreateNewPasswordView> {
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();
  String? _clientConfirmError;

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  Future<void> _submit(BuildContext context) async {
    final l10n = context.l10n;
    final password = _passwordController.text;
    final confirm = _confirmController.text;

    setState(() {
      _clientConfirmError = null;
      if (password.length < 8) {
        _clientConfirmError = l10n.passwordTooShort;
      } else if (password != confirm) {
        _clientConfirmError = l10n.passwordMismatch;
      }
    });

    if (password.length < 8 || password != confirm) return;

    final nav = Navigator.of(context);

    await context.read<AuthCubit>().resetForgotPassword(
          email: widget.email,
          password: password,
        );

    if (!context.mounted) return;

    final state = context.read<AuthCubit>().state;
    final messenger = ScaffoldMessenger.of(context);

    if (state.forgotPasswordFieldErrors.isNotEmpty) {
      return;
    }
    if (state.forgotPasswordErrorMessage.isNotEmpty) {
      final text = state.forgotPasswordErrorMessage.trim().isEmpty
          ? l10n.loginErrorGeneric
          : state.forgotPasswordErrorMessage;
      messenger.showSnackBar(SnackBar(content: Text(text)));
      return;
    }

    messenger.showSnackBar(
      SnackBar(content: Text(l10n.passwordResetSuccess)),
    );
    nav.popUntil((route) => route.isFirst);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        final fe = state.forgotPasswordFieldErrors;
        final loading =
            state.forgotPasswordUiStatus == ForgotPasswordUiStatus.loading;

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
                          title: context.l10n.createNewPasswordTitle,
                          subtitle: context.l10n.createNewPasswordSubtitle,
                          step: 0,
                          totalSteps: 0,
                        ),
                        const SizedBox(height: AppSpacing.xxl),
                        AppTextField(
                          key: const ValueKey('forgot_new_password'),
                          controller: _passwordController,
                          label: context.l10n.password,
                          hint: '********',
                          obscure: true,
                          maxLines: 1,
                          keyboardType: TextInputType.visiblePassword,
                          errorText: fe['password'],
                          onChanged: (_) => setState(() {}),
                        ),
                        const SizedBox(height: AppSpacing.lg),
                        AppTextField(
                          key: const ValueKey('forgot_confirm_password'),
                          controller: _confirmController,
                          label: context.l10n.confirmPassword,
                          hint: '********',
                          obscure: true,
                          maxLines: 1,
                          keyboardType: TextInputType.visiblePassword,
                          errorText: _clientConfirmError,
                          onChanged: (_) =>
                              setState(() => _clientConfirmError = null),
                        ),
                      ],
                    ),
                  ),
                ),
                AppButton(
                  key: const ValueKey('forgot_submit_password'),
                  label: context.l10n.submit,
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
