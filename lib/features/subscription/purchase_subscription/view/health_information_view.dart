import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pilates_app/config/theme/app_colors.dart';
import 'package:pilates_app/config/theme/app_spacing.dart';
import 'package:pilates_app/config/theme/app_text_styles.dart';
import 'package:pilates_app/core/localization/arb/app_localizations.dart';
import 'package:pilates_app/core/localization/localization_extension.dart';
import 'package:pilates_app/features/subscription/purchase_subscription/cubit/subscription_cubit.dart';
import 'package:pilates_app/features/subscription/purchase_subscription/view/widgets/subscription_header.dart';
import 'package:pilates_app/features/subscription/purchase_subscription/view/widgets/subscription_progress.dart';
import 'package:pilates_app/widgets/app_button.dart';
import 'package:pilates_app/widgets/app_scaffold.dart';
import 'package:pilates_app/widgets/app_text.dart';
import 'package:pilates_app/widgets/app_text_field.dart';
import 'package:pilates_app/widgets/phone_number_field.dart';

class HealthInformationView extends StatelessWidget {
  const HealthInformationView({super.key});

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
                  // Progress
                  SubscriptionStepHeader(
                    currentStep: 0,
                    totalSteps: 6,
                    isDark: isDark,
                  ),
                  // Title
                  AppText(
                    l10n.personalInformation,
                    style: (style) => AppTextStyles.heading1(context),
                  ),
                  const SizedBox(height: AppSpacing.lg),

                  // Fields
                  AppTextField(
                    label: l10n.firstName,
                    // Using "Name" from screenshot, but l10n has First Name. Adjust if needed.
                    hint: 'Name',
                    // onChanged: (val) => cubit.updateName(val),
                  ),
                  const SizedBox(height: AppSpacing.md),

                  AppTextField(
                    label: l10n.age,
                    hint: 'Age',
                    keyboardType: TextInputType.number,
                    // onChanged: (val) => cubit.updateAge(val),
                  ),
                  const SizedBox(height: AppSpacing.md),

                  AppTextField(
                    label: l10n.heightCm,
                    hint: 'Height',
                    keyboardType: TextInputType.number,
                    // onChanged: (val) => cubit.updateHeight(val),
                  ),
                  const SizedBox(height: AppSpacing.md),

                  AppTextField(
                    label: l10n.weightKg,
                    hint: 'Weight',
                    keyboardType: TextInputType.number,
                    // onChanged: (val) => cubit.updateWeight(val),
                  ),
                  const SizedBox(height: AppSpacing.md),

                  PhoneNumberField(
                    label: l10n.phoneNumber,
                    countryCode: '+966',
                    flagAsset: '', // Default from screenshot
                  ),
                  const SizedBox(height: AppSpacing.md),

                  AppTextField(
                    label: l10n.emailTab, // "Email"
                    hint: 'Email',
                    keyboardType: TextInputType.emailAddress,
                    // onChanged: (val) => cubit.updateEmail(val),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                ],
              ),
            ),
          ),

          AppButton(
            label: l10n.continueTxt,
            onPressed: () => cubit.nextStep(),
            buttonColor: AppColors.primaryBrown,
            expanded: true,
          ),
        ],
      ),
    );
  }
}
