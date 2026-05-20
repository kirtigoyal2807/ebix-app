import 'package:flutter/material.dart';
import 'package:pilates_app/config/theme/app_colors.dart';
import 'package:pilates_app/config/theme/app_spacing.dart';
import 'package:pilates_app/config/theme/app_text_styles.dart';
import 'package:pilates_app/features/auth/sign_up/widgets/otp_field.dart';
import 'package:pilates_app/features/auth/sign_up/widgets/sign_up_header.dart';
import 'package:pilates_app/features/auth/widgets/otp_resend_action.dart';
import 'package:pilates_app/widgets/app_app_bar.dart';
import 'package:pilates_app/widgets/app_button.dart';
import 'package:pilates_app/widgets/app_scaffold.dart';
import 'package:pilates_app/widgets/app_loading_indicator.dart';

/// Shared email OTP UI (forgot-password flow and profile email verification).
class EmailOtpVerificationLayout extends StatelessWidget {
  const EmailOtpVerificationLayout({
    super.key,
    required this.appBarTitle,
    required this.headerTitle,
    required this.headerSubtitle,
    required this.verifyLoading,
    required this.blockInteraction,
    required this.codeError,
    required this.resendDisabled,
    required this.verifyButtonLabel,
    required this.onBack,
    required this.onOtpCompleted,
    required this.onOtpChanged,
    required this.onResend,
    required this.onVerifyPressed,
    this.otpFieldKey = const ValueKey('email_otp_field'),
    this.resendActionKey = const ValueKey('email_otp_resend'),
    this.verifyButtonKey = const ValueKey('email_otp_verify'),
    this.appBarIsMoreMenu = true,
    required this.isResendOnCooldown,
    required this.resendCooldownRemaining,
  });

  final String appBarTitle;
  final String headerTitle;
  final String headerSubtitle;
  final bool verifyLoading;
  final bool blockInteraction;
  final String? codeError;
  final bool resendDisabled;
  final String verifyButtonLabel;
  final VoidCallback onBack;
  final ValueChanged<String> onOtpCompleted;
  final ValueChanged<String> onOtpChanged;
  final VoidCallback onResend;
  final VoidCallback onVerifyPressed;
  final Key otpFieldKey;
  final Key resendActionKey;
  final Key verifyButtonKey;
  final bool appBarIsMoreMenu;
  final bool isResendOnCooldown;
  final Duration resendCooldownRemaining;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return AppScaffold(
      appBar: AppAppBar(
        onBack: onBack,
        title: appBarTitle,
        isMoreMenu: appBarIsMoreMenu,
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
                          title: headerTitle,
                          subtitle: headerSubtitle,
                          step: 0,
                          totalSteps: 0,
                        ),
                        SizedBox(height: AppSpacing.xxl),
                        Center(
                          child: OtpField(
                            key: otpFieldKey,
                            length: 6,
                            onChanged: onOtpChanged,
                            onCompleted: onOtpCompleted,
                          ),
                        ),
                        if (codeError != null) ...[
                          SizedBox(height: AppSpacing.sm),
                          Center(
                            child: Text(
                              codeError!,
                              style: AppTextStyles.caption(context).copyWith(
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
                            key: resendActionKey,
                            isOnCooldown: isResendOnCooldown,
                            cooldownRemaining: resendCooldownRemaining,
                            resendGestureDisabled: resendDisabled,
                            onResend: onResend,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                AppButton(
                  key: verifyButtonKey,
                  label: verifyButtonLabel,
                  isLoading: verifyLoading,
                  onPressed: (blockInteraction || verifyLoading)
                      ? null
                      : onVerifyPressed,
                ),
              ],
            ),
          ),
          if (blockInteraction && !verifyLoading)
            const Positioned.fill(
              child: ColoredBox(
                color: Color(0x33000000),
                child: const AppLoadingIndicator(),
              ),
            ),
        ],
      ),
    );
  }
}
