import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pilates_app/config/theme/app_colors.dart';
import 'package:pilates_app/config/theme/app_spacing.dart';
import 'package:pilates_app/config/theme/app_text_styles.dart';
import 'package:pilates_app/widgets/app_app_bar.dart';
import 'package:pilates_app/widgets/app_button.dart';
import 'package:pilates_app/widgets/app_scaffold.dart';
import 'package:pilates_app/widgets/app_text.dart';

import '../../../core/localization/localization_extension.dart';
import '../../../core/mixins/resend_code_cooldown_mixin.dart';
import '../cubit/auth_cubit.dart';
import '../cubit/auth_state.dart';
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

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      startResendCodeCooldown();
    });
  }

  Future<void> _submit(BuildContext context) async {
    final cubit = context.read<AuthCubit>();
    final phone = cubit.state.signUpPendingPhone.trim();
    if (phone.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.l10n.phoneVerificationMissingPhone)),
      );
      return;
    }
    if (_otp.trim().length != 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.l10n.phoneVerificationEnterSixDigits)),
      );
      return;
    }
    await cubit.verifySignUpPhoneOtp(code: _otp.trim());
  }

  Future<void> _resend(BuildContext context) async {
    if (isResendCodeOnCooldown) return;
    startResendCodeCooldown();
    await context.read<AuthCubit>().resendSignUpPhoneOtp();
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
          ).showSnackBar(SnackBar(content: Text(context.l10n.registerOtpSent)));
        }
      },
      child: BlocConsumer<AuthCubit, AuthState>(
        listenWhen: (previous, current) {
          return previous.signUpPhoneOtpUiStatus ==
                  SignUpPhoneOtpUiStatus.loading &&
              current.signUpPhoneOtpUiStatus == SignUpPhoneOtpUiStatus.idle &&
              current.signUpPhoneOtpErrorMessage.isNotEmpty &&
              current.signUpPhoneOtpFieldErrors.isEmpty;
        },
        listener: (context, state) {
          final text = state.signUpPhoneOtpErrorMessage.trim().isEmpty
              ? context.l10n.loginErrorGeneric
              : state.signUpPhoneOtpErrorMessage;
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(text)));
        },
        builder: (context, state) {
          final loading =
              state.signUpPhoneOtpUiStatus == SignUpPhoneOtpUiStatus.loading;
          final blockInteraction =
              state.phoneOtpSendUiStatus == PhoneOtpSendUiStatus.loading;
          final phone = state.signUpPendingPhone.trim();
          final subtitle = phone.isEmpty
              ? context.l10n.enterCode
              : '${context.l10n.enterCode} $phone';
          final fe = state.signUpPhoneOtpFieldErrors;
          final codeErr = fe['code'];
          final phoneErr = fe['phone'];
          final theme = Theme.of(context);
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
                    vertical: AppSpacing.md,
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
                                onChanged: (otp) => setState(() => _otp = otp),
                                onCompleted: (otp) {
                                  setState(() => _otp = otp);
                                  context
                                      .read<AuthCubit>()
                                      .verifySignUpPhoneOtp(code: otp);
                                },
                              ),

                              if (codeErr != null || phoneErr != null) ...[
                                SizedBox(height: AppSpacing.sm),
                                AppText(
                                  codeErr ?? phoneErr ?? '',
                                  style: (c) =>
                                      AppTextStyles.caption(c).copyWith(
                                        color: isDark
                                            ? AppColors.redDark
                                            : AppColors.redLight,
                                      ),
                                ),
                              ],

                              SizedBox(height: AppSpacing.lg),

                              Center(
                                child: GestureDetector(
                                  onTap: resendDisabled
                                      ? null
                                      : () => _resend(context),
                                  child: RichText(
                                    text: TextSpan(
                                      children: [
                                        TextSpan(
                                          text:
                                              "${context.l10n.didntReceiveCode} ",
                                          style: AppTextStyles.caption(context)
                                              .copyWith(
                                                color: resendDisabled
                                                    ? theme.disabledColor
                                                    : (isDark
                                                          ? AppColors
                                                                .darkGreyText
                                                          : AppColors.greyText),
                                                fontWeight: FontWeight.w400,
                                                height: 1.4,
                                              ),
                                        ),
                                        TextSpan(
                                          text: context.l10n.resendCode,
                                          style: resendDisabled
                                              ? AppTextStyles.boldBody(
                                                  context,
                                                ).copyWith(
                                                  color: theme.disabledColor,
                                                )
                                              : AppTextStyles.boldBody(context),
                                        ),
                                      ],
                                    ),
                                  ),
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
                      child: Center(child: CircularProgressIndicator()),
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
