import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pilates_app/config/theme/app_colors.dart';
import 'package:pilates_app/config/theme/app_spacing.dart';
import 'package:pilates_app/config/theme/app_text_styles.dart';
import 'package:pilates_app/widgets/app_app_bar.dart';
import 'package:pilates_app/widgets/app_button.dart';
import 'package:pilates_app/widgets/app_scaffold.dart';

import '../../../core/localization/localization_extension.dart';
import '../cubit/auth_cubit.dart';
import 'widgets/sign_up_header.dart';
import 'widgets/sign_up_progress.dart';
import 'widgets/otp_field.dart';

class SignUpOtpView extends StatelessWidget {
  const SignUpOtpView({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return AppScaffold(
      appBar: AppAppBar(
        onBack: () => context.read<AuthCubit>().previousSignUpStep(),
        title: context.l10n.verification,
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: IntrinsicHeight(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.lg,
                    vertical: AppSpacing.md,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Progress
                      const SignUpProgress(currentStep: 2, totalSteps: 5),
                
                      const SizedBox(height: AppSpacing.sm),
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: '${context.l10n.step} 3',
                              style: AppTextStyles.caption(context).copyWith(
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
                
                      const SizedBox(height: AppSpacing.xxl),
                
                      // Header
                      SignUpHeader(
                        title: context.l10n.verifyPhone,
                        subtitle: context.l10n.enterCode,
                        step: 2,
                        totalSteps: 5,
                      ),
                
                      const SizedBox(height: AppSpacing.lg),
                
                      // OTP field
                      OtpField(
                        length: 4,
                        onCompleted: (otp) {
                          // Handle OTP completion
                        },
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
                
                      const Spacer(),
                
                      // Verify button
                      AppButton(
                        label: context.l10n.verify,
                        onPressed: () => context.read<AuthCubit>().nextSignUpStep(),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
