import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pilates_app/config/theme/app_spacing.dart';
import 'package:pilates_app/widgets/app_app_bar.dart';
import 'package:pilates_app/widgets/app_button.dart';
import 'package:pilates_app/widgets/app_scaffold.dart';
import 'package:pilates_app/widgets/app_text_field.dart';

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

            const SizedBox(height: AppSpacing.lg),

            // Header
            SignUpHeader(
              title: context.l10n.createPassword,
              subtitle: context.l10n.passwordHint,
              step: 1,
              totalSteps: 5,
            ),

            const SizedBox(height: AppSpacing.xl),

            // Password
            AppTextField(
              hint: context.l10n.password,
              obscure: true,
            ),

            const SizedBox(height: AppSpacing.md),

            // Confirm Password
            AppTextField(
              hint: context.l10n.confirmPassword,
              obscure: true,
            ),

            const Spacer(),

            // Continue
            AppButton(
              label: context.l10n.next,
              onPressed: () =>
                  context.read<AuthCubit>().nextSignUpStep(),
            ),
          ],
        ),
      ),
    );
  }
}
