import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pilates_app/config/theme/app_colors.dart';
import 'package:pilates_app/config/theme/app_spacing.dart';
import 'package:pilates_app/config/theme/app_text_styles.dart';
import 'package:pilates_app/widgets/app_app_bar.dart';
import 'package:pilates_app/widgets/app_button.dart';
import 'package:pilates_app/widgets/app_scaffold.dart';
import 'package:pilates_app/widgets/app_text_field.dart';
import 'package:pilates_app/widgets/app_dropdown.dart';
import 'package:pilates_app/widgets/phone_number_field.dart';

import '../../../core/localization/localization_extension.dart';
import '../cubit/auth_cubit.dart';
import 'widgets/sign_up_header.dart';
import 'widgets/sign_up_progress.dart';

class SignUpPersonalInfoView extends StatefulWidget {
  const SignUpPersonalInfoView({super.key});

  @override
  State<SignUpPersonalInfoView> createState() => _SignUpPersonalInfoViewState();
}

class _SignUpPersonalInfoViewState extends State<SignUpPersonalInfoView> {
  String? selectedGender;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return AppScaffold(
      appBar: AppAppBar(
        onBack: () => context.read<AuthCubit>().previousSignUpStep(),
        title: context.l10n.signUp,
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
                    // Progress bar
                    const SignUpProgress(currentStep: 0, totalSteps: 4),
                    const SizedBox(height: AppSpacing.sm),
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: '${context.l10n.step} 1',
                            style: AppTextStyles.caption(context).copyWith(
                              color: isDark
                                  ? AppColors.languageTextDark
                                  : AppColors.languageIcon,
                            ),
                          ),
                          TextSpan(
                            text: ' ${context.l10n.offf} 4',
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
                      totalSteps: 4,
                    ),

                    const SizedBox(height: AppSpacing.lg),

                    // Form fields
                    AppTextField(
                      label: context.l10n.firstName,
                      hint: 'Ayesha',
                      keyboardType: TextInputType.name,
                    ),

                    const SizedBox(height: AppSpacing.md),

                    AppTextField(
                      label: context.l10n.lastName,
                      hint: 'Tajib',
                      keyboardType: TextInputType.name,
                    ),

                    const SizedBox(height: AppSpacing.md),

                    AppTextField(
                      label: context.l10n.email,
                      hint: 'Ayesha@gmail.com',
                      keyboardType: TextInputType.emailAddress,
                    ),

                    const SizedBox(height: AppSpacing.md),

                    AppDropDown<String>(
                      label: context.l10n.gender,
                      hint: context.l10n.selectGender,
                      value: selectedGender,
                      items: [
                        DropdownMenuItem(
                          value: 'Male',
                          child: Text(
                            context.l10n.male,
                            style: AppTextStyles.textField(context),
                          ),
                        ),
                        DropdownMenuItem(
                          value: 'Female',
                          child: Text(
                            context.l10n.female,
                            style: AppTextStyles.textField(context),
                          ),
                        ),
                      ],
                      onChanged: (value) {
                        setState(() {
                          selectedGender = value;
                        });
                      },
                    ),

                    const SizedBox(height: AppSpacing.md),

                    AppTextField(
                      label: context.l10n.password,
                      hint: '**********',
                      keyboardType: TextInputType.name,
                      // errorText: 'Weak password',
                    ),

                    const SizedBox(height: AppSpacing.md),

                    // Phone Number
                    PhoneNumberField(
                      label: context.l10n.phoneNumber,
                      countryCode: '+1',
                      flagAsset: 'assets/flags/us.svg',
                    ),
                    const SizedBox(height: AppSpacing.lg),
                  ],
                ),
              ),
            ),

            // Continue button
            AppButton(
              label: context.l10n.continueTxt,
              onPressed: () => context.read<AuthCubit>().nextSignUpStep(),
            ),
          ],
        ),
      ),
    );
  }
}
