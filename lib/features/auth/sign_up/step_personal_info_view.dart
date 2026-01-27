import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pilates_app/config/theme/app_colors.dart';
import 'package:pilates_app/config/theme/app_spacing.dart';
import 'package:pilates_app/config/theme/app_text_styles.dart';
import 'package:pilates_app/widgets/app_app_bar.dart';
import 'package:pilates_app/widgets/app_button.dart';
import 'package:pilates_app/widgets/app_scaffold.dart';
import 'package:pilates_app/widgets/app_text_field.dart';

import '../../../core/localization/localization_extension.dart';
import '../cubit/auth_cubit.dart';
import 'widgets/sign_up_header.dart';
import 'widgets/sign_up_progress.dart';

class SignUpPersonalInfoView extends StatelessWidget {
  const SignUpPersonalInfoView({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBar: AppAppBar(
        onBack: () => context.read<AuthCubit>().previousSignUpStep(),
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
              // Progress bar
              const SignUpProgress(currentStep: 0, totalSteps: 5),
              const SizedBox(height: AppSpacing.sm),
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: '${context.l10n.step} 1',
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
                title: context.l10n.letsGo,
                subtitle: context.l10n.tellYourName, // temp copy reuse
                step: 0,
                totalSteps: 5,
              ),
        
              const SizedBox(height: AppSpacing.lg),
        
              // Form fields
              AppTextField(
                label: context.l10n.firstName,
                hint: 'Ayesha',
                keyboardType: TextInputType.name,
                // errorText: 'This email address is already registered.',
              ),
        
              const SizedBox(height: AppSpacing.md),
        
              AppTextField(
                label: context.l10n.lastName,
                hint: 'Tajib',
                keyboardType: TextInputType.name,
                // errorText: 'This email address is already registered.',
              ),
        
              const SizedBox(height: AppSpacing.md),
        
              AppTextField(
                label: context.l10n.email,
                hint: 'Ayesha@gmail.com',
                keyboardType: TextInputType.emailAddress,
                // errorText: 'This email address is already registered.',
              ),
        
              const Spacer(),
        
              // Continue button
              AppButton(
                label: context.l10n.continueTxt,
                onPressed: () => context.read<AuthCubit>().nextSignUpStep(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
