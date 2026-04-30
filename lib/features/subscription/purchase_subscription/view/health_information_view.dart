import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pilates_app/config/theme/app_colors.dart';
import 'package:pilates_app/config/theme/app_spacing.dart';
import 'package:pilates_app/config/theme/app_text_styles.dart';
import 'package:pilates_app/core/localization/arb/app_localizations.dart';
import 'package:pilates_app/features/subscription/purchase_subscription/cubit/subscription_cubit.dart';
import 'package:pilates_app/features/subscription/purchase_subscription/view/widgets/subscription_header.dart';
import 'package:pilates_app/features/subscription/purchase_subscription/view/widgets/subscription_progress.dart';
import 'package:pilates_app/widgets/app_button.dart';
import 'package:pilates_app/widgets/app_text.dart';
import 'package:pilates_app/widgets/app_text_field.dart';
import 'package:pilates_app/widgets/phone_number_field.dart';

class HealthInformationView extends StatefulWidget {
  const HealthInformationView({super.key});

  @override
  State<HealthInformationView> createState() => _HealthInformationViewState();
}

class _HealthInformationViewState extends State<HealthInformationView> {
  late final TextEditingController _nameController;
  late final TextEditingController _ageController;
  late final TextEditingController _heightController;
  late final TextEditingController _weightController;
  late final TextEditingController _phoneController;
  late final TextEditingController _emailController;

  @override
  void initState() {
    super.initState();
    final s = context.read<SubscriptionCubit>().state;
    _nameController = TextEditingController(text: s.name);
    _ageController = TextEditingController(text: s.age);
    _heightController = TextEditingController(text: s.height);
    _weightController = TextEditingController(text: s.weight);
    _phoneController = TextEditingController(text: s.phoneNumber);
    _emailController = TextEditingController(text: s.email);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    _heightController.dispose();
    _weightController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cubit = context.read<SubscriptionCubit>();

    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: AppSpacing.lg,
        horizontal: AppSpacing.lg,
      ),
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SubscriptionStepHeader(
                    currentStep: 0,
                    totalSteps: 6,
                    isDark: isDark,
                  ),
                  AppText(
                    l10n.personalInformation,
                    style: (style) => AppTextStyles.heading1(context),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  AppTextField(
                    label: l10n.name,
                    hint: l10n.name,
                    controller: _nameController,
                    onChanged: cubit.updateName,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  AppTextField(
                    label: l10n.age,
                    hint: l10n.age,
                    keyboardType: TextInputType.number,
                    controller: _ageController,
                    onChanged: cubit.updateAge,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  AppTextField(
                    label: l10n.heightCm,
                    hint: l10n.heightCm,
                    keyboardType: TextInputType.number,
                    controller: _heightController,
                    onChanged: cubit.updateHeight,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  AppTextField(
                    label: l10n.weightKg,
                    hint: l10n.weightKg,
                    keyboardType: TextInputType.number,
                    controller: _weightController,
                    onChanged: cubit.updateWeight,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  PhoneNumberField(
                    label: l10n.phoneNumber,
                    countryCode: '+966',
                    flagAsset: '',
                    controller: _phoneController,
                    onChanged: cubit.updatePhoneNumber,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  AppTextField(
                    label: l10n.emailTab,
                    hint: l10n.emailTab,
                    keyboardType: TextInputType.emailAddress,
                    controller: _emailController,
                    onChanged: cubit.updateEmail,
                  ),
                  const SizedBox(height: AppSpacing.lg),
                ],
              ),
            ),
          ),
          AppButton(
            label: l10n.continueTxt,
            onPressed: () => cubit.nextStep(),
            buttonColor: isDark ? AppColors.primary : AppColors.primaryBrown,
            expanded: true,
          ),
        ],
      ),
    );
  }
}
