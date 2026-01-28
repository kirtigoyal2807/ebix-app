import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pilates_app/config/theme/app_spacing.dart';
import 'package:pilates_app/features/auth/sign_up/widgets/sign_up_header.dart';
import 'package:pilates_app/widgets/app_app_bar.dart';
import 'package:pilates_app/widgets/app_button.dart';
import 'package:pilates_app/widgets/app_scaffold.dart';
import 'package:pilates_app/widgets/app_text_field.dart';

import '../../../core/localization/localization_extension.dart';
import '../cubit/auth_cubit.dart';

class SignInView extends StatelessWidget {
  const SignInView({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBar: AppAppBar(
        onBack: () => context.read<AuthCubit>().previousSignUpStep(),
        title: context.l10n.signIn,
      ),
      body: Container(
        // color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.md,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 2),
        
              // Header
              SignUpHeader(
                title: '${context.l10n.welcome} Tasha',
                subtitle: context.l10n.enterYourLoginDetails,
                step: 1,
                totalSteps: 5,
              ),
        
              const SizedBox(height: AppSpacing.lg),
        
              // Email or Phone
              AppTextField(
                label: context.l10n.emailOrPhone,
                hint: 'XXXXXXXXXX',
                keyboardType: TextInputType.name,
                // errorText: 'Weak password',
              ),
        
              const SizedBox(height: AppSpacing.md),
        
                // Password
              AppTextField(
                label: context.l10n.password,
                hint: '**********',
                keyboardType: TextInputType.name,
                // errorText: 'Weak password',
              ),
        
        
              const Spacer(),
        
              // Continue
              AppButton(
                label: context.l10n.signIn,
                onPressed: () => context.read<AuthCubit>().nextSignUpStep(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
