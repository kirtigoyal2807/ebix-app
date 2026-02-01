import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pilates_app/config/theme/app_colors.dart';
import 'package:pilates_app/config/theme/app_spacing.dart';
import 'package:pilates_app/config/theme/app_text_styles.dart';
import 'package:pilates_app/features/auth/sign_up/widgets/sign_up_header.dart';
import 'package:pilates_app/widgets/app_app_bar.dart';
import 'package:pilates_app/widgets/app_button.dart';
import 'package:pilates_app/widgets/app_scaffold.dart';
import 'package:pilates_app/widgets/app_text.dart';
import 'package:pilates_app/widgets/app_text_field.dart';
import 'package:pilates_app/widgets/phone_number_field.dart';

import '../../../core/localization/localization_extension.dart';
import '../cubit/auth_cubit.dart';

import '../forgot_password/forgot_password_view.dart';

class SignInView extends StatefulWidget {
  const SignInView({super.key});

  @override
  State<SignInView> createState() => _SignInViewState();
}

class _SignInViewState extends State<SignInView> {
  int _selectedTab = 0; // 0 for Email, 1 for Phone Number

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return AppScaffold(
      appBar: AppAppBar(
        onBack: () => context.read<AuthCubit>().previousSignUpStep(),
        title: context.l10n.signIn,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 0,
          vertical: AppSpacing.md,
        ),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 2),

                    // Header
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                      child: SignUpHeader(
                        title: '${context.l10n.welcome} Tasha',
                        subtitle: context.l10n.enterYourLoginDetails,
                        step: 1,
                        totalSteps: 5,
                      ),
                    ),

                    const SizedBox(height: AppSpacing.lg),

                    // Tab Selector
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                      child: Row(
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: () => setState(() => _selectedTab = 0),
                              child: Column(
                                children: [
                                  AppText(
                                    context.l10n.emailTab,
                                    style:  AppTextStyles.bodyText,
                                  ),
                                  const SizedBox(height: 8),
                                  Container(
                                    height: 2,
                                    color: _selectedTab == 0
                                        ? (isDark ? AppColors.languageTextDark : AppColors.primary)
                                        : Colors.transparent,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Expanded(
                            child: GestureDetector(
                              onTap: () => setState(() => _selectedTab = 1),
                              child: Column(
                                children: [
                                  AppText(
                                    context.l10n.phoneTab,
                                    style: AppTextStyles.bodyText,
                                  ),
                                  const SizedBox(height: 8),
                                  Container(
                                    height: 2,
                                    color: _selectedTab == 1
                                        ? (isDark ? AppColors.languageTextDark : AppColors.primary)
                                        : Colors.transparent,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                     Divider(height: 1, thickness: 1,color: (isDark ? AppColors.greyText : AppColors.buttonBorder),),

                    const SizedBox(height: AppSpacing.xl),


                    if (_selectedTab == 0) ...[
                      // Email Form
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                        child: AppTextField(
                          label: context.l10n.emailOrPhone,
                          hint: 'XXXXXXXXXX',
                          keyboardType: TextInputType.emailAddress,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.md),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                        child: AppTextField(
                          label: context.l10n.password,
                          hint: '**********',
                          obscure: true,
                          keyboardType: TextInputType.visiblePassword,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => const ForgotPasswordView(),
                                ),
                              );
                            },
                            child: AppText(
                              context.l10n.forgotPassword,
                              style: AppTextStyles.body,
                            ),
                          ),
                        ),
                      ),
                    ] else ...[
                      // Phone Number Form
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                        child: PhoneNumberField(
                          label: context.l10n.phoneNumber,
                          countryCode: '+1',
                          flagAsset: 'assets/flags/us.svg',
                        ),
                      ),
                    ],
                    const SizedBox(height: AppSpacing.lg),
                  ],
                ),
              ),
            ),

            // Sticky Button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
              child: AppButton(
                label: _selectedTab == 0 ? context.l10n.signIn : context.l10n.sendOtp,
                onPressed: () {
                  if (_selectedTab == 0) {
                     context.read<AuthCubit>().nextSignUpStep();
                  } else {
                     // Send OTP logic
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
