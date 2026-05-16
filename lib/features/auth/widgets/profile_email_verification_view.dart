import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pilates_app/core/localization/localization_extension.dart';
import 'package:pilates_app/core/mixins/resend_code_cooldown_mixin.dart';
import 'package:pilates_app/features/account/cubit/personal_info_cubit.dart';
import 'package:pilates_app/features/account/cubit/personal_info_state.dart';
import 'package:pilates_app/features/auth/cubit/auth_cubit.dart';
import 'package:pilates_app/features/auth/cubit/auth_state.dart';
import 'package:pilates_app/features/auth/widgets/email_otp_verification_layout.dart';

/// Email OTP step after the customer updates their profile email (JWT session).
///
/// Uses the same layout as the forgot-password OTP step but verifies via
/// `POST /auth/profile/verify-email` instead of the forgot-password email API.
class ProfileEmailVerificationView extends StatefulWidget {
  const ProfileEmailVerificationView({super.key, required this.email});

  final String email;

  @override
  State<ProfileEmailVerificationView> createState() =>
      _ProfileEmailVerificationViewState();
}

class _ProfileEmailVerificationViewState extends State<ProfileEmailVerificationView>
    with ResendCodeCooldownMixin {
  String _code = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) startResendCodeCooldown(notify: false);
    });
  }

  Future<void> _resend(BuildContext context) async {
    if (isResendCodeOnCooldown) return;
    try {
      final attempted =
          await context.read<PersonalInfoCubit>().resendVerificationCode();
      if (mounted && attempted) startResendCodeCooldown();
    } catch (_) {
      if (mounted) startResendCodeCooldown();
    }
  }

  Future<void> _verify(BuildContext context) async {
    final l10n = context.l10n;
    if (_code.length != 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.otpHint)),
      );
      return;
    }
    await context.read<AuthCubit>().verifyProfileEmailCode(
          email: widget.email,
          code: _code,
        );
  }

  String? _firstFieldError(Map<String, String> fe) {
    final c = fe['code'];
    if (c != null && c.isNotEmpty) return c;
    for (final v in fe.values) {
      if (v.isNotEmpty) return v;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listenWhen: (previous, current) {
        return previous.profileEmailOtpUiStatus == ProfileEmailOtpUiStatus.loading &&
            current.profileEmailOtpUiStatus == ProfileEmailOtpUiStatus.idle;
      },
      listener: (context, state) {
        final msg = state.profileEmailOtpErrorMessage.trim();
        final fe = state.profileEmailOtpFieldErrors;
        if (msg.isNotEmpty || fe.isNotEmpty) {
          final text = msg.isNotEmpty
              ? msg
              : (_firstFieldError(fe) ?? context.l10n.loginErrorGeneric);
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
          return;
        }
        Navigator.of(context).pop(true);
      },
      child: BlocListener<PersonalInfoCubit, PersonalInfoState>(
        listenWhen: (previous, current) {
          return previous.resendStatus == PersonalInfoResendStatus.loading &&
              current.resendStatus == PersonalInfoResendStatus.idle;
        },
        listener: (context, state) {
          final err = state.resendErrorMessage.trim();
          if (err.isNotEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(err)),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(context.l10n.forgotPasswordCodeSent)),
            );
          }
        },
        child: BlocBuilder<AuthCubit, AuthState>(
          builder: (context, authState) {
            final personalState = context.watch<PersonalInfoCubit>().state;
            final verifyLoading =
                authState.profileEmailOtpUiStatus == ProfileEmailOtpUiStatus.loading;
            final sendLoading =
                personalState.resendStatus == PersonalInfoResendStatus.loading;
            final blockInteraction = sendLoading;
            final codeErr = authState.profileEmailOtpFieldErrors['code'];
            final resendDisabled =
                blockInteraction || verifyLoading || isResendCodeOnCooldown;

            return EmailOtpVerificationLayout(
              appBarTitle: context.l10n.verification,
              headerTitle: context.l10n.profileEmailVerificationTitle,
              headerSubtitle: context.l10n.profileEmailVerificationSubtitle(
                widget.email,
              ),
              verifyLoading: verifyLoading,
              blockInteraction: blockInteraction,
              codeError: codeErr,
              resendDisabled: resendDisabled,
              verifyButtonLabel: context.l10n.verify,
              appBarIsMoreMenu: false,
              isResendOnCooldown: isResendCodeOnCooldown,
              resendCooldownRemaining: resendCodeCooldownRemaining,
              otpFieldKey: const ValueKey('profile_email_otp_field'),
              resendActionKey: const ValueKey('profile_email_resend_code'),
              verifyButtonKey: const ValueKey('profile_email_verify_code'),
              onBack: () => Navigator.of(context).pop(),
              onOtpChanged: (otp) => setState(() => _code = otp),
              onOtpCompleted: (otp) {
                setState(() => _code = otp);
                _verify(context);
              },
              onResend: () => _resend(context),
              onVerifyPressed: () => _verify(context),
            );
          },
        ),
      ),
    );
  }
}
