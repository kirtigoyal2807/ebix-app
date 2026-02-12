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
import 'package:pilates_app/widgets/app_text.dart';
import 'package:pilates_app/widgets/app_text_field.dart';

class DeclarationView extends StatelessWidget {
  const DeclarationView({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final cubit = context.read<SubscriptionCubit>();
    final isDark = Theme.of(context).brightness == Brightness.dark;

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
                    currentStep: 5,
                    totalSteps: 6,
                    isDark: isDark,
                  ),

                  // Title
                  AppText(
                    l10n.declaration,
                    style: (style) => AppTextStyles.gelasioMedium(
                      context,
                    ).copyWith(fontSize: 24, height: 1.2),
                  ),
                  const SizedBox(height: AppSpacing.lg),

                  // Declaration Text
                  _buildSectionHeader(context, l10n.declarationText),
                  const SizedBox(height: AppSpacing.md),

                  // Name Field
                  AppTextField(
                    label: l10n.name, // "Name" from screenshot
                    hint: l10n.name, // Placeholder
                    // onChanged: (val) => cubit.updateDeclarationName(val),
                  ),
                  const SizedBox(height: AppSpacing.md),

                  // Signature Field
                  AppTextField(
                    label: l10n.signature,
                    hint: l10n.signature,
                    // onChanged: (val) => cubit.updateDeclarationSignature(val),
                  ),
                  const SizedBox(height: AppSpacing.md),

                  // Date Field
                  AppTextField(
                    label: l10n.date,
                    hint: l10n.date,
                    // onChanged: (val) => cubit.updateDeclarationDate(val),
                    // Ideally would act as date picker
                  ),
                  const SizedBox(height: AppSpacing.lg),
                ],
              ),
            ),
          ),
          AppButton(
            label: l10n.continueTxt,
            onPressed: () {
              cubit.nextStep();
            },
            buttonColor: AppColors.primaryBrown,
            expanded: true,
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return AppText(
      title,
      style: (style) => AppTextStyles.bodyText(context).copyWith(
        fontWeight: FontWeight.w500,
        fontSize: 16,
        color: isDark ? AppColors.lightText : AppColors.darkText,
      ),
      maxLines: 4,
    );
  }
}
