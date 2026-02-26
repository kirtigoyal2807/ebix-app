import 'package:flutter/material.dart';
import 'package:pilates_app/config/theme/app_spacing.dart';
import 'package:pilates_app/widgets/app_app_bar.dart';
import 'package:pilates_app/widgets/app_button.dart';
import 'package:pilates_app/widgets/app_scaffold.dart';
import 'package:pilates_app/widgets/app_text_field.dart';

import '../../../core/localization/localization_extension.dart';
import '../sign_up/widgets/sign_up_header.dart';

class CreateNewPasswordView extends StatelessWidget {
  const CreateNewPasswordView({super.key});

  @override
  Widget build(BuildContext context) {
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
                      title: context.l10n.createNewPasswordTitle,
                      subtitle: context.l10n.createNewPasswordSubtitle,
                      step: 0,
                      totalSteps: 0,
                    ),

                    const SizedBox(height: AppSpacing.xxl),

                    // Password Field
                    AppTextField(
                      label: context.l10n.password,
                      hint: "********",
                      obscure: true,
                      maxLines: 1,
                    ),

                    const SizedBox(height: AppSpacing.lg),

                    // Confirm Password Field
                    AppTextField(
                      label: context.l10n.confirmPassword,
                      hint: "********",
                      obscure: true,
                      maxLines: 1,
                    ),
                  ],
                ),
              ),
            ),

            // Sticky Button
            AppButton(
              label: context.l10n.submit,
              onPressed: () {
                // Handle password reset submission
                // For now, it could pop back to login or show success
              },
            ),
          ],
        ),
      ),
    );
  }
}
