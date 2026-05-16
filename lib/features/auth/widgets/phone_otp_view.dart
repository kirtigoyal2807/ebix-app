import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pilates_app/config/theme/app_colors.dart';
import 'package:pilates_app/config/theme/app_spacing.dart';
import 'package:pilates_app/config/theme/app_text_styles.dart';
import 'package:pilates_app/core/localization/localization_extension.dart';
import 'package:pilates_app/core/mixins/resend_code_cooldown_mixin.dart';
import 'package:pilates_app/features/account/cubit/personal_info_cubit.dart';
import 'package:pilates_app/features/account/cubit/personal_info_state.dart';
import 'package:pilates_app/features/auth/cubit/auth_cubit.dart';
import 'package:pilates_app/features/auth/cubit/auth_state.dart';
import 'package:pilates_app/features/auth/sign_up/widgets/otp_field.dart';
import 'package:pilates_app/features/auth/sign_up/widgets/sign_up_header.dart';
import 'package:pilates_app/features/auth/widgets/otp_resend_action.dart';
import 'package:pilates_app/widgets/app_app_bar.dart';
import 'package:pilates_app/widgets/app_button.dart';
import 'package:pilates_app/widgets/app_scaffold.dart';

/// Generic reusable phone OTP verification view.
/// Can be used for signup, signin, forgot password, or profile phone verification.
class PhoneOtpView extends StatefulWidget {
  const PhoneOtpView({
    super.key,
    required this.phone,
    required this.title,
    required this.subtitlePrefix,
    this.onBack,
    this.onVerified,
    this.showStepHeader = false,
    this.step = 0,
    this.totalSteps = 0,
  });

  /// Phone number to verify (displayed to user).
  final String phone;

  /// App bar title.
  final String title;

  /// Prefix text before phone number (e.g., "Enter the 6-digit code sent to").
  final String subtitlePrefix;

  /// Optional back button callback. If null, uses Navigator.pop.
  final VoidCallback? onBack;

  /// Called when OTP is verified successfully. If null, just pops with true.
  final ValueChanged<String>? onVerified;

  /// Whether to show step header (for signup flow).
  final bool showStepHeader;

  /// Current step number (for step header).
  final int step;

  /// Total steps (for step header).
  final int totalSteps;

  @override
  State<PhoneOtpView> createState() => _PhoneOtpViewState();
}

class _PhoneOtpViewState extends State<PhoneOtpView>
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
    if (_code.length != 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.l10n.phoneVerificationEnterSixDigits)),
      );
      return;
    }

    // Use verifyProfilePhoneOtp which works for any flow with the provided phone
    await context.read<AuthCubit>().verifyProfilePhoneOtp(
      phone: widget.phone,
      code: _code,
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return BlocListener<AuthCubit, AuthState>(
      listenWhen: (previous, current) {
        return previous.signUpPhoneOtpUiStatus ==
                SignUpPhoneOtpUiStatus.loading &&
            current.signUpPhoneOtpUiStatus == SignUpPhoneOtpUiStatus.idle;
      },
      listener: (context, state) {
        if (state.signUpPhoneOtpErrorMessage.isNotEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.signUpPhoneOtpErrorMessage)),
          );
        } else if (state.user != null) {
          // OTP verified successfully
          if (widget.onVerified != null) {
            widget.onVerified!(_code);
          } else {
            Navigator.of(context).pop(true);
          }
        }
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
              SnackBar(content: Text(context.l10n.registerOtpSent)),
            );
          }
        },
        child: AppScaffold(
          appBar: AppAppBar(
            onBack: widget.onBack ?? () => Navigator.of(context).pop(),
            title: context.l10n.verification,
            isMoreMenu: false,
          ),
          body: BlocBuilder<AuthCubit, AuthState>(
            builder: (context, authState) {
              final personalState = context.watch<PersonalInfoCubit>().state;
              final loading = authState.signUpPhoneOtpUiStatus ==
                  SignUpPhoneOtpUiStatus.loading;
              final blockInteraction =
                  personalState.resendStatus == PersonalInfoResendStatus.loading;
              final codeErr = authState.signUpPhoneOtpFieldErrors['code'];
              final phoneErr = authState.signUpPhoneOtpFieldErrors['phone'];
              final resendDisabled =
                  blockInteraction || loading || isResendCodeOnCooldown;

              return Stack(
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
                                if (widget.showStepHeader) ...[
                                  SizedBox(height: AppSpacing.lg),
                                  SignUpHeader(
                                    title: context.l10n.verifyPhone,
                                    subtitle:
                                        '${widget.subtitlePrefix} ${widget.phone}',
                                    step: widget.step,
                                    totalSteps: widget.totalSteps,
                                  ),
                                ] else ...[
                                  SizedBox(height: AppSpacing.lg),
                                  SignUpHeader(
                                    title: widget.title,
                                    subtitle:
                                        '${widget.subtitlePrefix} ${widget.phone}',
                                    step: 0,
                                    totalSteps: 0,
                                  ),
                                ],
                                SizedBox(height: AppSpacing.xxl),
                                Center(
                                  child: OtpField(
                                    length: 6,
                                    onChanged: (otp) =>
                                        setState(() => _code = otp),
                                    onCompleted: (otp) {
                                      setState(() => _code = otp);
                                      _verify(context);
                                    },
                                  ),
                                ),
                                if (codeErr != null || phoneErr != null) ...[
                                  SizedBox(height: AppSpacing.sm),
                                  Text(
                                    codeErr ?? phoneErr ?? '',
                                    style: AppTextStyles.caption(context)
                                        .copyWith(
                                      color: isDark
                                          ? AppColors.redDark
                                          : AppColors.redLight,
                                    ),
                                  ),
                                ],
                                SizedBox(height: AppSpacing.lg),
                                Center(
                                  child: OtpResendAction(
                                    isOnCooldown: isResendCodeOnCooldown,
                                    cooldownRemaining:
                                        resendCodeCooldownRemaining,
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
              );
            },
          ),
        ),
      ),
    );
  }
}
