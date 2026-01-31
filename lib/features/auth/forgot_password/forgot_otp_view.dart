import 'package:flutter/material.dart';
import 'package:pilates_app/config/theme/app_colors.dart';
import 'package:pilates_app/config/theme/app_spacing.dart';
import 'package:pilates_app/config/theme/app_text_styles.dart';
import 'package:pilates_app/features/auth/sign_up/widgets/otp_field.dart';
import 'package:pilates_app/features/auth/sign_up/widgets/sign_up_header.dart';
import 'package:pilates_app/widgets/app_app_bar.dart';
import 'package:pilates_app/widgets/app_button.dart';
import 'package:pilates_app/widgets/app_scaffold.dart';
import 'package:pilates_app/widgets/app_text.dart';
import 'create_new_password_view.dart';

import '../../../core/localization/localization_extension.dart';

class ForgotOtpView extends StatelessWidget {
  const ForgotOtpView({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

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

                    // Header
                    SignUpHeader(
                      title: context.l10n.otpVerificationTitle,
                      subtitle: context.l10n.otpVerificationSubtitle,
                      step: 0,
                      totalSteps: 0,
                    ),

                    const SizedBox(height: AppSpacing.xxl),

                    // OTP field
                    Center(
                      child: OtpField(
                        length: 4,
                        onCompleted: (otp) {
                          // Handle OTP completion
                        },
                      ),
                    ),

                    const SizedBox(height: AppSpacing.lg),

                    Center(
                      child: RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: context.l10n.didntReceiveCode,
                              style: AppTextStyles.caption(context).copyWith(
                                color: isDark
                                    ? AppColors.darkGreyText
                                    : AppColors.greyText,
                                fontWeight: FontWeight.w400,
                                height: 1.4,
                              ),
                            ),
                            TextSpan(
                              text: context.l10n.resendCode,
                              style: AppTextStyles.caption(context).copyWith(
                                color: isDark
                                    ? AppColors.languageTextDark
                                    : AppColors.languageIcon,
                                fontWeight: FontWeight.w600,
                                height: 1.4,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Sticky Button
            AppButton(
              label: context.l10n.sendOtp,
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => const CreateNewPasswordView(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
