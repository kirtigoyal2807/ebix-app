import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pilates_app/config/theme/app_colors.dart';
import 'package:pilates_app/config/theme/app_spacing.dart';
import 'package:pilates_app/config/theme/app_text_styles.dart';
import 'package:pilates_app/widgets/app_app_bar.dart';
import 'package:pilates_app/widgets/app_button.dart';
import 'package:pilates_app/widgets/app_scaffold.dart';
import 'package:pilates_app/widgets/app_text.dart';
import 'package:pilates_app/widgets/app_text_field.dart';

import '../../../core/localization/localization_extension.dart';
import '../cubit/auth_cubit.dart';
import '../sign_up/widgets/sign_up_header.dart';
import 'forgot_otp_view.dart';

class ForgotPasswordView extends StatelessWidget {
  const ForgotPasswordView({super.key});

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
                      title: context.l10n.enterEmailHeader,
                      subtitle: context.l10n.enterEmailSubtitle,
                      step: 0,
                      totalSteps: 0, // Not showing progress for this flow
                    ),

                    const SizedBox(height: AppSpacing.xxl),

                    // Email Field
                    AppTextField(
                      label: context.l10n.enterEmailHeader,
                      hint: context.l10n.usernameHint,
                      keyboardType: TextInputType.emailAddress,
                    ),
                  ],
                ),
              ),
            ),

            // Sticky Button
            AppButton(
              label: context.l10n.sendCode,
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const ForgotOtpView()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
