import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pilates_app/features/auth/cubit/auth_cubit.dart';
import 'package:pilates_app/features/auth/cubit/auth_state.dart';
import 'package:pilates_app/features/auth/widgets/email_otp_verification_layout.dart';

import '../../../core/localization/localization_extension.dart';
import '../../../core/mixins/resend_code_cooldown_mixin.dart';
import 'create_new_password_view.dart';

class ForgotOtpView extends StatefulWidget {
  const ForgotOtpView({super.key, required this.email});

  final String email;

  @override
  State<ForgotOtpView> createState() => _ForgotOtpViewState();
}

class _ForgotOtpViewState extends State<ForgotOtpView>
    with ResendCodeCooldownMixin {
  String _code = '';

  @override
  void initState() {
    super.initState();
    startResendCodeCooldown(notify: false);
  }

  Future<void> _verify(BuildContext context) async {
    final l10n = context.l10n;
    if (_code.length != 6) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.otpHint)));
      return;
    }
    await context.read<AuthCubit>().verifyForgotEmailCode(
      email: widget.email,
      code: _code,
    );
  }

  Future<void> _resend(BuildContext context) async {
    if (isResendCodeOnCooldown) return;
    try {
      await context.read<AuthCubit>().resendForgotPasswordEmail(widget.email);
    } finally {
      if (mounted) startResendCodeCooldown();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
      listenWhen: (previous, current) {
        final finished =
            previous.forgotPasswordUiStatus == ForgotPasswordUiStatus.loading &&
            current.forgotPasswordUiStatus == ForgotPasswordUiStatus.idle;
        if (!finished) return false;
        if (current.forgotPasswordFieldErrors.isNotEmpty) return true;
        if (current.forgotPasswordErrorMessage.isNotEmpty) return true;
        if (current.forgotEmailCodeVerified &&
            !previous.forgotEmailCodeVerified) {
          return true;
        }
        if (!current.forgotEmailCodeVerified &&
            current.forgotPasswordEmail.isNotEmpty &&
            current.forgotPasswordErrorMessage.isEmpty &&
            current.forgotPasswordFieldErrors.isEmpty) {
          return true;
        }
        return false;
      },
      listener: (context, state) {
        if (state.forgotPasswordFieldErrors.isNotEmpty) return;
        if (state.forgotEmailCodeVerified) {
          Navigator.of(context).push(
            MaterialPageRoute<void>(
              builder: (_) => CreateNewPasswordView(email: widget.email),
            ),
          );
          return;
        }
        if (state.forgotPasswordErrorMessage.isNotEmpty) {
          final text = state.forgotPasswordErrorMessage.trim().isEmpty
              ? context.l10n.loginErrorGeneric
              : state.forgotPasswordErrorMessage;
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(text)));
          return;
        }
        if (state.forgotPasswordEmail.isNotEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(context.l10n.forgotPasswordCodeSent)),
          );
        }
      },
      builder: (context, state) {
        final loading =
            state.forgotPasswordUiStatus == ForgotPasswordUiStatus.loading;
        final codeErr = state.forgotPasswordFieldErrors['code'];
        final resendDisabled = loading || isResendCodeOnCooldown;

        return EmailOtpVerificationLayout(
          appBarTitle: context.l10n.forgotPasswordTitle,
          headerTitle: context.l10n.otpVerificationTitle,
          headerSubtitle: context.l10n.otpVerificationSubtitle,
          verifyLoading: loading,
          blockInteraction: loading,
          codeError: codeErr,
          resendDisabled: resendDisabled,
          verifyButtonLabel: context.l10n.verify,
          otpFieldKey: const ValueKey('forgot_otp_field'),
          resendActionKey: const ValueKey('forgot_resend_code'),
          verifyButtonKey: const ValueKey('forgot_verify_code'),
          isResendOnCooldown: isResendCodeOnCooldown,
          resendCooldownRemaining: resendCodeCooldownRemaining,
          onBack: () => Navigator.of(context).pop(),
          onOtpChanged: (otp) => setState(() => _code = otp),
          onOtpCompleted: (otp) {
            setState(() => _code = otp);
          },
          onResend: () => _resend(context),
          onVerifyPressed: () => _verify(context),
        );
      },
    );
  }
}
