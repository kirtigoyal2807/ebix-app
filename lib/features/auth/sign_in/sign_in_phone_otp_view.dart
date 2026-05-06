import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pilates_app/config/theme/app_colors.dart';
import 'package:pilates_app/config/theme/app_spacing.dart';
import 'package:pilates_app/config/theme/app_text_styles.dart';
import 'package:pilates_app/core/localization/localization_extension.dart';
import 'package:pilates_app/features/auth/cubit/auth_cubit.dart';
import 'package:pilates_app/features/auth/cubit/auth_state.dart';
import 'package:pilates_app/features/auth/sign_up/widgets/otp_field.dart';
import 'package:pilates_app/features/auth/sign_up/widgets/sign_up_header.dart';
import 'package:pilates_app/widgets/app_app_bar.dart';
import 'package:pilates_app/widgets/app_button.dart';
import 'package:pilates_app/widgets/app_scaffold.dart';

class SignInPhoneOtpView extends StatefulWidget {
  const SignInPhoneOtpView({super.key});

  @override
  State<SignInPhoneOtpView> createState() => _SignInPhoneOtpViewState();
}

class _SignInPhoneOtpViewState extends State<SignInPhoneOtpView> {
  String _code = '';

  Future<void> _resend(BuildContext context) async {
    await context.read<AuthCubit>().resendSignInPhoneOtp();
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

          return AppScaffold(
            appBar: AppAppBar(
              onBack: () => context.read<AuthCubit>().backFromSignIn(),
              title: context.l10n.verifyPhone,
              isMoreMenu: false,
            ),
            body: Stack(
              children: [
                Padding(
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
                                title: context.l10n.verifyPhone,
                                subtitle: '${context.l10n.enterCode} $phone',
                                step: 0,
                                totalSteps: 0,
                              ),
                              const SizedBox(height: AppSpacing.xxl),
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
                                const SizedBox(height: AppSpacing.sm),
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
                              const SizedBox(height: AppSpacing.lg),
                              Center(
                                child: GestureDetector(
                                  onTap: blockInteraction || loading
                                      ? null
                                      : () => _resend(context),
                                  child: RichText(
                                    text: TextSpan(
                                      children: [
                                        TextSpan(
                                          text:
                                              '${context.l10n.didntReceiveCode} ',
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
                                          style: AppTextStyles.boldBody(
                                            context,
                                          ),
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
