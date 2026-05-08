import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pilates_app/config/theme/app_colors.dart';
import 'package:pilates_app/config/theme/app_spacing.dart';
import 'package:pilates_app/config/theme/app_text_styles.dart';
import 'package:pilates_app/features/auth/cubit/auth_cubit.dart';
import 'package:pilates_app/features/auth/cubit/auth_state.dart';
import 'package:pilates_app/features/auth/sign_up/widgets/otp_field.dart';
import 'package:pilates_app/features/auth/sign_up/widgets/sign_up_header.dart';
import 'package:pilates_app/widgets/app_app_bar.dart';
import 'package:pilates_app/widgets/app_button.dart';
import 'package:pilates_app/widgets/app_scaffold.dart';

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
    startResendCodeCooldown();
    await context.read<AuthCubit>().resendForgotPasswordEmail(widget.email);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

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
                          title: context.l10n.otpVerificationTitle,
                          subtitle: context.l10n.otpVerificationSubtitle,
                          step: 0,
                          totalSteps: 0,
                        ),
                        const SizedBox(height: AppSpacing.xxl),
                        Center(
                          child: OtpField(
                            key: const ValueKey('forgot_otp_field'),
                            length: 6,
                            onCompleted: (otp) {
                              setState(() => _code = otp);
                            },
                          ),
                        ),
                        if (codeErr != null) ...[
                          const SizedBox(height: AppSpacing.sm),
                          Center(
                            child: Text(
                              codeErr,
                              style: AppTextStyles.caption(context).copyWith(
                                color: isDark
                                    ? AppColors.redDark
                                    : AppColors.redLight,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                        const SizedBox(height: AppSpacing.lg),
                        Center(
                          child: GestureDetector(
                            key: const ValueKey('forgot_resend_code'),
                            onTap: loading || isResendCodeOnCooldown
                                ? null
                                : () => _resend(context),
                            child: RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: '${context.l10n.didntReceiveCode} ',
                                    style: AppTextStyles.caption(context)
                                        .copyWith(
                                          color: isDark
                                              ? AppColors.darkGreyText
                                              : AppColors.greyText,
                                          fontWeight: FontWeight.w400,
                                          height: 1.4,
                                        ),
                                  ),
                                  TextSpan(
                                    text: context.l10n.resendCode,
                                    style: AppTextStyles.boldBody(context),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                AppButton(
                  key: const ValueKey('forgot_verify_code'),
                  label: context.l10n.verify,
                  isLoading: loading,
                  onPressed: loading ? null : () => _verify(context),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
