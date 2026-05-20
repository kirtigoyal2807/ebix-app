import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pilates_app/config/theme/app_colors.dart';
import 'package:pilates_app/config/theme/app_spacing.dart';
import 'package:pilates_app/config/theme/app_text_styles.dart';
import 'package:pilates_app/widgets/app_app_bar.dart';
import 'package:pilates_app/widgets/app_button.dart';
import 'package:pilates_app/widgets/app_scaffold.dart';
import 'package:pilates_app/widgets/app_text.dart';
import 'package:pilates_app/widgets/app_loading_indicator.dart';

import '../../../core/localization/localization_extension.dart';
import '../../../core/mixins/resend_code_cooldown_mixin.dart';
import '../cubit/auth_cubit.dart';
import '../cubit/auth_state.dart';
import '../widgets/otp_resend_action.dart';
import 'widgets/sign_up_header.dart';
import 'widgets/sign_up_progress.dart';
import 'widgets/otp_field.dart';

class SignUpOtpView extends StatefulWidget {
  const SignUpOtpView({super.key});

  @override
  State<SignUpOtpView> createState() => _SignUpOtpViewState();
}

class _SignUpOtpViewState extends State<SignUpOtpView>
    with ResendCodeCooldownMixin {
  String _otp = '';
  String? _localValidationError;

  Color _otpErrorColor(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return isDark ? AppColors.redText : AppColors.redLight;
  }

  String? _otpErrorMessage(AuthState state) {
    if (_localValidationError != null && _localValidationError!.isNotEmpty) {
      return _localValidationError;
    }
    final fe = state.signUpPhoneOtpFieldErrors;
    final codeErr = fe['code'];
    if (codeErr != null && codeErr.isNotEmpty) return codeErr;
    final phoneErr = fe['phone'];
    if (phoneErr != null && phoneErr.isNotEmpty) return phoneErr;
    if (state.signUpPhoneOtpUiStatus != SignUpPhoneOtpUiStatus.loading &&
        state.signUpPhoneOtpErrorMessage.trim().isNotEmpty &&
        fe.isEmpty) {
      return state.signUpPhoneOtpErrorMessage.trim();
    }
    if (state.phoneOtpSendUiStatus != PhoneOtpSendUiStatus.loading &&
        state.phoneOtpSendErrorMessage.trim().isNotEmpty) {
      return state.phoneOtpSendErrorMessage.trim();
    }
    return null;
  }

  @override
  void initState() {
    super.initState();
    // OTP cooldown is started by the BlocListener below on the
    // `signUpStep` 0 -> 1 transition (i.e. when register succeeds and the
    // OTP is actually sent). Starting here would tick during step 0 because
    // [SignUpOtpView] is kept mounted by the parent IndexedStack.
    if (context.read<AuthCubit>().state.signUpStep == 1) {
      startResendCodeCooldown(notify: false);
    }
  }

  Future<void> _submit(BuildContext context) async {
    final cubit = context.read<AuthCubit>();
    final phone = cubit.state.signUpPendingPhone.trim();
    if (phone.isEmpty) {
      setState(
        () => _localValidationError = context.l10n.phoneVerificationMissingPhone,
      );
      return;
    }
    if (_otp.trim().length != 6) {
      setState(
        () =>
            _localValidationError = context.l10n.phoneVerificationEnterSixDigits,
      );
      return;
    }
    setState(() => _localValidationError = null);
    await cubit.verifySignUpPhoneOtp(code: _otp.trim());
  }

  void _onOtpChanged(String otp) {
    setState(() {
      _otp = otp;
      _localValidationError = null;
    });
  }

  Future<void> _resend(BuildContext context) async {
    if (isResendCodeOnCooldown) return;
    try {
      final attempted = await context.read<AuthCubit>().resendSignUpPhoneOtp();
      if (mounted && attempted) startResendCodeCooldown();
    } catch (_) {
      if (mounted) startResendCodeCooldown();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return MultiBlocListener(
      listeners: [
        // Start the 30s resend cooldown the moment the OTP screen becomes
        // active (signUpStep flips to 1 after `register` succeeds). Avoids
        // ticking while user is still on step 0 (personal info).
        BlocListener<AuthCubit, AuthState>(
          listenWhen: (previous, current) =>
              previous.signUpStep != 1 && current.signUpStep == 1,
          listener: (context, _) => startResendCodeCooldown(),
        ),
        BlocListener<AuthCubit, AuthState>(
          listenWhen: (previous, current) {
            return previous.phoneOtpSendUiStatus ==
                    PhoneOtpSendUiStatus.loading &&
                current.phoneOtpSendUiStatus == PhoneOtpSendUiStatus.idle;
          },
          listener: (context, state) {
            if (state.phoneOtpSendErrorMessage.isEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(context.l10n.registerOtpSent)),
              );
            }
          },
        ),
      ],
      child: BlocBuilder<AuthCubit, AuthState>(
        builder: (context, state) {
          final loading =
              state.signUpPhoneOtpUiStatus == SignUpPhoneOtpUiStatus.loading;
          final blockInteraction =
              state.phoneOtpSendUiStatus == PhoneOtpSendUiStatus.loading;
          final phone = state.signUpPendingPhone.trim();
          final subtitle = phone.isEmpty
              ? context.l10n.enterCode
              : '${context.l10n.enterCode} $phone';
          final otpError = _otpErrorMessage(state);
          final resendDisabled =
              blockInteraction || loading || isResendCodeOnCooldown;

          return AppScaffold(
            appBar: AppAppBar(
              onBack: () => context.read<AuthCubit>().previousSignUpStep(),
              title: context.l10n.verification,
              isMoreMenu: false,
            ),
            body: Stack(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: AppSpacing.lg,
                    vertical: AppSpacing.xi,
                  ),
                  child: Column(
                    children: [
                      Expanded(
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SignUpProgress(
                                currentStep: 1,
                                totalSteps: 5,
                              ),
                              SizedBox(height: AppSpacing.sm),
                              RichText(
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                      text: '${context.l10n.step} 2',
                                      style: AppTextStyles.caption(context)
                                          .copyWith(
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
                              SizedBox(height: AppSpacing.xl),

                              SignUpHeader(
                                title: context.l10n.verifyPhone,
                                subtitle: subtitle,
                                step: 1,
                                totalSteps: 4,
                              ),

                              SizedBox(height: AppSpacing.lg),

                              OtpField(
                                length: 6,
                                onChanged: _onOtpChanged,
                                onCompleted: (otp) {
                                  _onOtpChanged(otp);
                                  context
                                      .read<AuthCubit>()
                                      .verifySignUpPhoneOtp(code: otp);
                                },
                              ),

                              if (otpError != null && otpError.isNotEmpty)
                                _SignUpOtpInlineError(
                                  message: otpError,
                                  color: _otpErrorColor(context),
                                ),

                              SizedBox(height: AppSpacing.lg),

                              Center(
                                child: OtpResendAction(
                                  isOnCooldown: isResendCodeOnCooldown,
                                  cooldownRemaining: resendCodeCooldownRemaining,
                                  resendGestureDisabled: resendDisabled,
                                  onResend: () => _resend(context),
                                ),
                              ),
                              SizedBox(height: AppSpacing.lg),
                            ],
                          ),
                        ),
                      ),

                      AppButton(
                        key: const ValueKey('sign_up_phone_otp_verify'),
                        label: context.l10n.verify,
                        isLoading: loading,
                        onPressed: (loading || blockInteraction)
                            ? null
                            : () => _submit(context),
                      ),
                    ],
                  ),
                ),
                if (blockInteraction)
                  const Positioned.fill(
                    child: ColoredBox(
                      color: Color(0x33000000),
                      child: const AppLoadingIndicator(),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _SignUpOtpInlineError extends StatelessWidget {
  const _SignUpOtpInlineError({
    required this.message,
    required this.color,
  });

  final String message;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final maxWidth =
        MediaQuery.sizeOf(context).width - (AppSpacing.lg * 2);
    return Padding(
      padding: EdgeInsets.only(top: AppSpacing.base),
      child: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: maxWidth),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(Icons.info_outline, size: 18, color: color),
              SizedBox(width: AppSpacing.xs),
              Flexible(
                child: AppText(
                  message,
                  maxLines: 3,
                  textAlign: TextAlign.center,
                  style: (c) => AppTextStyles.bodyText(c).copyWith(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    height: 1.2,
                    color: color,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
