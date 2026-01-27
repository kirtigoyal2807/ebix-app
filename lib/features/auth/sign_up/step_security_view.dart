import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pilates_app/config/theme/app_colors.dart';
import 'package:pilates_app/config/theme/app_spacing.dart';
import 'package:pilates_app/config/theme/app_text_styles.dart';
import 'package:pilates_app/widgets/app_app_bar.dart';
import 'package:pilates_app/widgets/app_button.dart';
import 'package:pilates_app/widgets/app_scaffold.dart';
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
      body: Container(
        color: Colors.white,
        child: Padding(
         padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.md,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Progress
              const SignUpProgress(
                currentStep: 1,
                totalSteps: 5,
              ),
              const SizedBox(height: AppSpacing.sm),
               RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: '${context.l10n.step} 2',
                      style: AppTextStyles.caption(context).copyWith(
                        color: AppColors.languageIcon,
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
                title: context.l10n.secureYourAccount,
                subtitle: context.l10n.createPassword,
                step: 1,
                totalSteps: 5,
              ),
        
              const SizedBox(height: AppSpacing.lg),
        
              // Password
              AppTextField(
                label: context.l10n.password,
                hint: '**********',
                keyboardType: TextInputType.name,
                errorText: 'Weak password',
              ),
        
              const SizedBox(height: AppSpacing.md),
        
              // Confirm Password
              PhoneNumberField(
                label: context.l10n.phoneNumber,
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
      ),
    );
  }
}
