import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pilates_app/config/theme/app_colors.dart';
import 'package:pilates_app/config/theme/app_spacing.dart';
import 'package:pilates_app/config/theme/app_text_styles.dart';
import 'package:pilates_app/core/localization/localization_extension.dart';
import 'package:pilates_app/core/mixins/resend_code_cooldown_mixin.dart';
import 'package:pilates_app/features/auth/cubit/auth_cubit.dart';
import 'package:pilates_app/features/auth/cubit/auth_state.dart';
import 'package:pilates_app/features/auth/sign_up/widgets/otp_field.dart';
import 'package:pilates_app/features/auth/sign_up/widgets/sign_up_header.dart';
import 'package:pilates_app/features/auth/widgets/otp_resend_action.dart';
import 'package:pilates_app/widgets/app_app_bar.dart';
import 'package:pilates_app/widgets/app_button.dart';
import 'package:pilates_app/widgets/app_scaffold.dart';
import 'package:pilates_app/widgets/app_loading_indicator.dart';

class SignInPhoneOtpView extends StatefulWidget {
  const SignInPhoneOtpView({super.key});

  @override
  State<SignInPhoneOtpView> createState() => _SignInPhoneOtpViewState();
}

class _SignInPhoneOtpViewState extends State<SignInPhoneOtpView>
    with ResendCodeCooldownMixin {
  String _code = '';

  @override
  void initState() {
    super.initState();
    startResendCodeCooldown(notify: false);
  }

  Future<void> _resend(BuildContext context) async {
    if (isResendCodeOnCooldown) return;
    try {
      final attempted = await context.read<AuthCubit>().resendSignInPhoneOtp();
      if (mounted && attempted) startResendCodeCooldown();
    } catch (_) {
      if (mounted) startResendCodeCooldown();
    }
  }

  Future<void> _verify(BuildContext context) async {
    if (_code.length != 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.l10n.phoneVerificationEnterSixDigits)),
      );
      return;
    }
    await context.read<AuthCubit>().verifySignInPhoneOtp(code: _code);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return BlocListener<AuthCubit, AuthState>(
      listenWhen: (previous, current) {
        return previous.phoneOtpSendUiStatus == PhoneOtpSendUiStatus.loading &&
            current.phoneOtpSendUiStatus == PhoneOtpSendUiStatus.idle;
      },
      listener: (context, state) {
        if (state.phoneOtpSendErrorMessage.isNotEmpty) {
          final text = state.phoneOtpSendErrorMessage.trim().isEmpty
              ? context.l10n.loginErrorGeneric
              : state.phoneOtpSendErrorMessage;
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(text)));
        } else {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(context.l10n.loginOtpSent)));
        }
      },
      child: BlocConsumer<AuthCubit, AuthState>(
        listenWhen: (previous, current) {
          return previous.loginUiStatus == LoginUiStatus.loading &&
              current.loginUiStatus == LoginUiStatus.idle &&
              current.loginErrorMessage.isNotEmpty &&
              current.loginFieldErrors.isEmpty;
        },
        listener: (context, state) {
          final text = state.loginErrorMessage.trim().isEmpty
              ? context.l10n.loginErrorGeneric
              : state.loginErrorMessage;
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(text)));
        },
        builder: (context, state) {
          final loading = state.loginUiStatus == LoginUiStatus.loading;
          final blockInteraction =
              state.phoneOtpSendUiStatus == PhoneOtpSendUiStatus.loading;
          final codeErr = state.loginFieldErrors['code'];
          final phone = state.signInPendingPhone;
          final resendDisabled =
              blockInteraction || loading || isResendCodeOnCooldown;

          return AppScaffold(
            appBar: AppAppBar(
              onBack: () => context.read<AuthCubit>().backFromSignIn(),
              title: context.l10n.verifyPhone,
              isMoreMenu: false,
            ),
            body: Stack(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(
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
                              SizedBox(height: AppSpacing.lg),
                              SignUpHeader(
                                title: context.l10n.verifyPhone,
                                subtitle: '${context.l10n.enterCode} $phone',
                                step: 0,
                                totalSteps: 0,
                              ),
                              SizedBox(height: AppSpacing.xxl),
                              Center(
                                child: OtpField(
                                  key: const ValueKey(
                                    'sign_in_phone_otp_field',
                                  ),
                                  length: 6,
                                  onChanged: (otp) =>
                                      setState(() => _code = otp),
                                  onCompleted: (otp) {
                                    setState(() => _code = otp);
                                  },
                                ),
                              ),
                              if (codeErr != null) ...[
                                SizedBox(height: AppSpacing.sm),
                                Center(
                                  child: Text(
                                    codeErr,
                                    style: AppTextStyles.caption(context)
                                        .copyWith(
                                          color: isDark
                                              ? AppColors.redDark
                                              : AppColors.redLight,
                                        ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ],
                              SizedBox(height: AppSpacing.lg),
                              Center(
                                child: OtpResendAction(
                                  isOnCooldown: isResendCodeOnCooldown,
                                  cooldownRemaining: resendCodeCooldownRemaining,
                                  resendGestureDisabled: resendDisabled,
                                  onResend: () => _resend(context),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      AppButton(
                        key: const ValueKey('sign_in_phone_otp_verify'),
                        label: context.l10n.verify,
                        isLoading: loading,
                        onPressed: (loading || blockInteraction)
                            ? null
                            : () => _verify(context),
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
