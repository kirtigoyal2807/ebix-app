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
import 'package:pilates_app/widgets/app_button.dart';
import 'package:pilates_app/widgets/app_text.dart';
import 'package:pilates_app/widgets/app_text_field.dart';

class SafetyView extends StatefulWidget {
  const SafetyView({super.key});

  @override
  State<SafetyView> createState() => _SafetyViewState();
}

class _SafetyViewState extends State<SafetyView> {
  late final TextEditingController _nameController;
  late final TextEditingController _signatureController;
  late final TextEditingController _dateController;
  late final ScrollController _legalScrollController;

  /// User has reached the bottom of the safety legal text (or it did not scroll).
  bool _legalTextScrolledToEnd = false;

  String? _nameError;
  String? _signatureError;
  String? _dateError;

  @override
  void initState() {
    super.initState();
    final s = context.read<SubscriptionCubit>().state;
    _nameController = TextEditingController(text: s.declarationName);
    _signatureController = TextEditingController(text: s.declarationSignature);
    _dateController = TextEditingController(text: s.declarationDate);
    _legalScrollController = ScrollController();
    _legalScrollController.addListener(_onLegalScroll);
    WidgetsBinding.instance.addPostFrameCallback((_) => _maybeMarkShortLegalContentRead());
  }

  @override
  void dispose() {
    _legalScrollController.removeListener(_onLegalScroll);
    _legalScrollController.dispose();
    _nameController.dispose();
    _signatureController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  void _onLegalScroll() {
    if (!mounted) return;
    if (!_legalScrollController.hasClients) return;
    _syncLegalReadProgress();
  }

  void _syncLegalReadProgress() {
    if (!mounted) return;
    if (!_legalScrollController.hasClients) return;
    final p = _legalScrollController.position;
    final atEnd = p.maxScrollExtent <= 8 || p.extentAfter <= 8;
    if (atEnd && !_legalTextScrolledToEnd) {
      setState(() => _legalTextScrolledToEnd = true);
    }
  }

  void _maybeMarkShortLegalContentRead() {
    if (!mounted) return;
    if (!_legalScrollController.hasClients) return;
    _syncLegalReadProgress();
  }

  void _unfocusKeyboard() {
    FocusManager.instance.primaryFocus?.unfocus();
  }

  void _onContinueToNext(AppLocalizations l10n) {
    if (!_legalTextScrolledToEnd) {
      return;
    }
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
    final l10n = AppLocalizations.of(context)!;
    final cubit = context.read<SubscriptionCubit>();
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final size = MediaQuery.sizeOf(context);

    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: AppSpacing.lg,
        horizontal: AppSpacing.lg,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: _unfocusKeyboard,
              child: SingleChildScrollView(
                // Block skipping the legal read by scrolling past the inner box.
                physics: _legalTextScrolledToEnd
                    ? const AlwaysScrollableScrollPhysics()
                    : const NeverScrollableScrollPhysics(),
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                  AppText(
                    l10n.safetyConsent,
                    style: (style) => AppTextStyles.heading1(context),
                  ),
                  const SizedBox(height: 4),
                  AppText(
                    l10n.pleaseReviewTerms,
                    style: (context) => AppTextStyles.bodyText(context),
                  ),
                  const SizedBox(height: AppSpacing.lg),

                  SizedBox(
                    height: size.height * 0.4,
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: isDark
                            ? AppColors.homeBackground
                            : AppColors.whiteColor,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: isDark
                              ? AppColors.greyText
                              : AppColors.buttonBorder,
                        ),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: ScrollbarTheme(
                          data: ScrollbarThemeData(
                            thumbColor: WidgetStateProperty.all(
                              isDark ? AppColors.languageIconDark : AppColors.languageIcon,
                            ),
                            trackColor: WidgetStateProperty.all(
                              isDark ? AppColors.greyText : AppColors.buttonBorder,
                            ),
                            trackVisibility: WidgetStateProperty.all(true),
                            thickness: WidgetStateProperty.all(4),
                            radius: const Radius.circular(16),
                          ),
                          child: Scrollbar(
                            thumbVisibility: true,
                            controller: _legalScrollController,
                            thickness: 4,
                            radius: const Radius.circular(16),
                            child: NotificationListener<ScrollNotification>(
                              onNotification: (ScrollNotification n) {
                                if (n.metrics.axis != Axis.vertical) {
                                  return false;
                                }
                                _syncLegalReadProgress();
                                return false;
                              },
                              child: SingleChildScrollView(
                                controller: _legalScrollController,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: AppSpacing.md,
                                    horizontal: AppSpacing.md,
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      AppText(
                                        l10n.subscriptionAgreement,
                                        style: (style) =>
                                            AppTextStyles
                                                .helpAndSupportItemLabel(
                                              context,
                                            ).copyWith(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w500,
                                              height: 1.5,
                                            ),
                                        maxLines: 4,
                                      ),
                                      const SizedBox(height: AppSpacing.md),
                                      Text(
                                        l10n.safetyText,
                                        style: AppTextStyles
                                            .helpAndSupportItemLabel(
                                          context,
                                        ).copyWith(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w400,
                                          color: isDark
                                              ? AppColors.darkGreyText
                                              : AppColors.greyText,
                                          height: 1.5,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                  if (!_legalTextScrolledToEnd) ...[
                    const SizedBox(height: AppSpacing.sm),
                    AppText(
                      l10n.scrollLegalContentToContinue,
                      style: (c) => AppTextStyles.captionText(c).copyWith(
                        color: isDark
                            ? AppColors.languageTextDark
                            : AppColors.languageIcon,
                        fontWeight: FontWeight.w500,
                      ),
                      maxLines: 3,
                    ),
                  ],
                  const SizedBox(height: AppSpacing.lg),

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
                  const SizedBox(height: AppSpacing.md),

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
                  const SizedBox(height: AppSpacing.md),

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
                    const SizedBox(height: 6),
                    Text(
                      _dateError!,
                      style: AppTextStyles.bodyText(context).copyWith(
                        fontSize: 12,
                        color: isDark ? AppColors.redDark : AppColors.redLight,
                      ),
                    ),
                  ],
                  const SizedBox(height: AppSpacing.lg),
                ],
              ),
            ),
            ),
          ),

          AppButton(
            label: l10n.continueToPayment,
            onPressed: _legalTextScrolledToEnd
                ? () => _onContinueToNext(l10n)
                : null,
            buttonColor: isDark ? AppColors.primary : AppColors.primaryBrown,
            expanded: true,
          ),
        ],
      ),
    );
  }
}
