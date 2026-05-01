import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pilates_app/config/theme/app_colors.dart';
import 'package:pilates_app/config/theme/app_spacing.dart';
import 'package:pilates_app/config/theme/app_text_styles.dart';
import 'package:pilates_app/core/localization/arb/app_localizations.dart';
import 'package:pilates_app/features/subscription/purchase_subscription/cubit/subscription_cubit.dart';
import 'package:pilates_app/features/subscription/purchase_subscription/view/widgets/subscription_calendar_date_field.dart';
import 'package:pilates_app/features/subscription/purchase_subscription/view/widgets/subscription_header.dart';
import 'package:pilates_app/features/subscription/purchase_subscription/view/widgets/subscription_progress.dart';
import 'package:pilates_app/widgets/app_button.dart';
import 'package:pilates_app/widgets/app_text.dart';
import 'package:pilates_app/widgets/app_text_field.dart';

class DeclarationView extends StatefulWidget {
  const DeclarationView({super.key});

  @override
  State<DeclarationView> createState() => _DeclarationViewState();
}

class _DeclarationViewState extends State<DeclarationView> {
  late final TextEditingController _nameController;
  late final TextEditingController _signatureController;
  late final TextEditingController _dateController;

  @override
  void initState() {
    super.initState();
    final s = context.read<SubscriptionCubit>().state;
    _nameController = TextEditingController(text: s.declarationName);
    _signatureController = TextEditingController(text: s.declarationSignature);
    _dateController = TextEditingController(text: s.declarationDate);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _signatureController.dispose();
    _dateController.dispose();
    super.dispose();
  }

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
                  SubscriptionStepHeader(
                    currentStep: 5,
                    totalSteps: 6,
                    isDark: isDark,
                  ),
                  AppText(
                    l10n.declaration,
                    style: (style) => AppTextStyles.gelasioMedium(
                      context,
                    ).copyWith(fontSize: 24, height: 1.2),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  _buildSectionHeader(context, l10n.declarationText),
                  const SizedBox(height: AppSpacing.md),
                  AppTextField(
                    label: l10n.name,
                    hint: l10n.name,
                    controller: _nameController,
                    onChanged: cubit.updateDeclarationName,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  AppTextField(
                    label: l10n.signature,
                    hint: l10n.signature,
                    controller: _signatureController,
                    onChanged: cubit.updateDeclarationSignature,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  SubscriptionCalendarDateField(
                    label: l10n.date,
                    hint: l10n.date,
                    controller: _dateController,
                    onDateSelected: cubit.updateDeclarationDate,
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
            buttonColor: isDark ? AppColors.primary : AppColors.primaryBrown,
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
        fontSize: 16,
        color: isDark ? AppColors.lightText : AppColors.darkText,
      ),
      maxLines: 4,
    );
  }
}
