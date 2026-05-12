import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pilates_app/config/theme/app_colors.dart';
import 'package:pilates_app/config/theme/app_spacing.dart';
import 'package:pilates_app/config/theme/app_text_styles.dart';
import 'package:pilates_app/core/localization/arb/app_localizations.dart';
import 'package:pilates_app/core/validation/contact_validators.dart';
import 'package:pilates_app/core/validation/subscription_declaration_validators.dart';
import 'package:pilates_app/features/subscription/purchase_subscription/cubit/subscription_cubit.dart';
import 'package:pilates_app/features/subscription/purchase_subscription/view/widgets/subscription_calendar_date_field.dart';
import 'package:pilates_app/features/subscription/purchase_subscription/view/widgets/subscription_header.dart';
import 'package:pilates_app/features/subscription/purchase_subscription/view/widgets/subscription_health_wizard_step.dart';
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

  String? _nameError;
  String? _signatureError;
  String? _dateError;

  void _unfocusKeyboard() {
    FocusManager.instance.primaryFocus?.unfocus();
  }

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

  void _onContinue(AppLocalizations l10n) {
    _unfocusKeyboard();
    final cubit = context.read<SubscriptionCubit>();
    cubit.updateDeclarationName(_nameController.text);
    cubit.updateDeclarationSignature(_signatureController.text);
    cubit.updateDeclarationDate(_dateController.text);

    final name = _nameController.text.trim();
    final sig = _signatureController.text.trim();
    final date = _dateController.text.trim();

    setState(() {
      _nameError = name.isEmpty
          ? l10n.declarationNameRequired
          : (!ContactValidators.isValidPersonName(name)
                ? l10n.enterValidName
                : null);
      _signatureError = sig.isEmpty
          ? l10n.declarationSignatureRequired
          : (!SubscriptionDeclarationValidators.isValidSignature(sig)
                ? l10n.declarationSignatureInvalid
                : null);
      _dateError = date.isEmpty
          ? l10n.declarationDateRequired
          : (!SubscriptionDeclarationValidators.isValidDeclarationDate(date)
                ? l10n.declarationDateInvalid
                : null);
    });

    if (name.isEmpty ||
        !ContactValidators.isValidPersonName(name) ||
        sig.isEmpty ||
        !SubscriptionDeclarationValidators.isValidSignature(sig) ||
        date.isEmpty ||
        !SubscriptionDeclarationValidators.isValidDeclarationDate(date)) {
      return;
    }
    cubit.nextStep();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final cubit = context.read<SubscriptionCubit>();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: AppSpacing.lg,
        horizontal: AppSpacing.lg,
      ),
      child: Column(
        children: [
          Expanded(
            child: GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: _unfocusKeyboard,
              child: SingleChildScrollView(
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SubscriptionStepHeader(
                      wizardStep:
                          SubscriptionHealthWizardStep.declaration,
                      isDark: isDark,
                    ),
                    SizedBox(height: AppSpacing.xl),
                    AppText(
                      l10n.declaration,
                      style: (style) => AppTextStyles.gelasioMedium(
                        context,
                      ).copyWith(fontSize: 24, height: 1.2),
                    ),
                    SizedBox(height: AppSpacing.lg),
                    _buildSectionHeader(context, l10n.declarationText),
                    SizedBox(height: AppSpacing.md),
                    AppTextField(
                      label: l10n.name,
                      hint: l10n.name,
                      controller: _nameController,
                      errorText: _nameError,
                      keyboardType: TextInputType.name,
                      onChanged: (_) {
                        cubit.updateDeclarationName(_nameController.text);
                        setState(() => _nameError = null);
                      },
                    ),
                    SizedBox(height: AppSpacing.md),
                    AppTextField(
                      label: l10n.signature,
                      hint: l10n.signature,
                      controller: _signatureController,
                      errorText: _signatureError,
                      onChanged: (_) {
                        cubit.updateDeclarationSignature(
                          _signatureController.text,
                        );
                        setState(() => _signatureError = null);
                      },
                    ),
                    SizedBox(height: AppSpacing.md),
                    SubscriptionCalendarDateField(
                      label: l10n.date,
                      hint: l10n.date,
                      controller: _dateController,
                      onDateSelected: (d) {
                        cubit.updateDeclarationDate(d);
                        setState(() => _dateError = null);
                      },
                    ),
                    if (_dateError != null) ...[
                      SizedBox(height: 6),
                      Text(
                        _dateError!,
                        style: AppTextStyles.bodyText(context).copyWith(
                          fontSize: 12,
                          color: Theme.of(context).brightness == Brightness.dark
                              ? AppColors.redDark
                              : AppColors.redLight,
                        ),
                      ),
                    ],
                    SizedBox(height: AppSpacing.lg),
                  ],
                ),
              ),
            ),
          ),
          AppButton(
            label: l10n.continueTxt,
            onPressed: () => _onContinue(l10n),
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
