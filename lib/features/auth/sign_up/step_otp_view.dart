import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pilates_app/config/theme/app_spacing.dart';
import 'package:pilates_app/config/theme/app_text_styles.dart';
import 'package:pilates_app/widgets/app_app_bar.dart';
import 'package:pilates_app/widgets/app_button.dart';
import 'package:pilates_app/widgets/app_scaffold.dart';
import 'package:pilates_app/widgets/app_text.dart';

import '../../../core/localization/localization_extension.dart';
import '../cubit/auth_cubit.dart';
import 'widgets/sign_up_header.dart';
import 'widgets/sign_up_progress.dart';
import 'widgets/otp_field.dart';

class SignUpOtpView extends StatelessWidget {
  const SignUpOtpView({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBar: AppAppBar(
        onBack: () =>
            context.read<AuthCubit>().previousSignUpStep(),
      ),
      body: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Progress
            const SignUpProgress(
              currentStep: 2,
              totalSteps: 5,
            ),

            const SizedBox(height: AppSpacing.md),
            AppText(
              'Step ${0 + 3} of ${5}',
              style: AppTextStyles.caption,
            ),
            const SizedBox(height: AppSpacing.lg),

            // Header
            SignUpHeader(
              title: context.l10n.verifyOtp,
              subtitle: context.l10n.otpHint,
              step: 2,
              totalSteps: 5,
            ),

            const SizedBox(height: AppSpacing.xl),

            // OTP field
            const OtpField(),

            const SizedBox(height: AppSpacing.md),

            // Resend
            Center(
              child: TextButton(
                onPressed: () {
                  // UI only for now
                },
                child: AppText(
                  context.l10n.resendCode,
                  style: AppTextStyles.body,
                ),
              ),
            ),

            const Spacer(),

            // Verify button
            AppButton(
              label: context.l10n.verify,
              onPressed: () =>
                  context.read<AuthCubit>().nextSignUpStep(),
            ),
          ],
        ),
      ),
    );
  }
}
