import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pilates_app/config/theme/app_spacing.dart';
import 'package:pilates_app/config/theme/app_text_styles.dart';
import 'package:pilates_app/widgets/app_app_bar.dart';
import 'package:pilates_app/widgets/app_button.dart';
import 'package:pilates_app/widgets/app_scaffold.dart';
import 'package:pilates_app/widgets/app_text.dart';
import 'package:pilates_app/widgets/app_text_field.dart';
import 'package:pilates_app/widgets/phone_number_field.dart';

import '../../../core/localization/localization_extension.dart';
import '../cubit/auth_cubit.dart';
import 'widgets/sign_up_header.dart';
import 'widgets/sign_up_progress.dart';

class SignUpSecurityView extends StatelessWidget {
  const SignUpSecurityView({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBar: AppAppBar(
        onBack: () =>
            context.read<AuthCubit>().previousSignUpStep(),
        title: context.l10n.signUp,
      ),
      body: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Progress
            const SignUpProgress(
              currentStep: 1,
              totalSteps: 5,
            ),
            const SizedBox(height: AppSpacing.sm),
            AppText(
              'Step ${0 + 2} of ${5}',
              style: AppTextStyles.caption,
            ),
            const SizedBox(height: AppSpacing.lg),

            // Header
            SignUpHeader(
              title: context.l10n.secureYourAccount,
              subtitle: context.l10n.createPassword,
              step: 1,
              totalSteps: 5,
            ),

            const SizedBox(height: AppSpacing.lg),

            // Password
            AppTextField(
              label: 'Password',
              hint: '',
              keyboardType: TextInputType.name,
              // errorText: 'weak Password.',
            ),

            const SizedBox(height: AppSpacing.md),

            // Confirm Password
            PhoneNumberField(
              label: 'Phone Number',
              countryCode: '+1',
              flagAsset: 'assets/flags/us.svg',
            ),

            const Spacer(),

            // Continue
            AppButton(
              label: context.l10n.continueTxt,
              onPressed: () =>
                  context.read<AuthCubit>().nextSignUpStep(),
            ),
          ],
        ),
      ),
    );
  }
}
