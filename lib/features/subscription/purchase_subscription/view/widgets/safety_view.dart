import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:pilates_app/config/theme/app_colors.dart';
import 'package:pilates_app/config/theme/app_spacing.dart';
import 'package:pilates_app/config/theme/app_text_styles.dart';
import 'package:pilates_app/core/localization/arb/app_localizations.dart';
import 'package:pilates_app/core/validation/contact_validators.dart';
import 'package:pilates_app/core/validation/subscription_declaration_validators.dart';
import 'package:pilates_app/features/auth/cubit/auth_cubit.dart';
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
  late final ScrollController _agreementScrollController;

  /// True after the agreement text (inner scroll) reaches its bottom.
  /// Matches [TermsAndConditionsView] scroll gating; user fields + Continue use this.
  bool _agreementReadToBottom = false;

  String? _nameError;
  String? _signatureError;
  String? _dateError;

  String _resolvedProfileName() {
    final subState = context.read<SubscriptionCubit>().state;
    final user = context.read<AuthCubit>().state.user;
    final fromUserParts = [
      user?.firstName?.trim() ?? '',
      user?.lastName?.trim() ?? '',
    ].where((name) => name.isNotEmpty).join(' ').trim();
    if (fromUserParts.isNotEmpty) return fromUserParts;
    final fromUserName = user?.name?.trim() ?? '';
    if (fromUserName.isNotEmpty) return fromUserName;
    final fromPersonalInfo = subState.name.trim();
    if (fromPersonalInfo.isNotEmpty) return fromPersonalInfo;
    return '';
  }

  @override
  void initState() {
    super.initState();
    final s = context.read<SubscriptionCubit>().state;
    final profileName = _resolvedProfileName();
    final safeName = profileName.isNotEmpty
        ? profileName
        : (s.declarationName.trim().isNotEmpty ? s.declarationName : '');
    final today = DateFormat('dd-MM-yyyy').format(DateTime.now());
    final safeDate = s.declarationDate.trim().isNotEmpty
        ? s.declarationDate
        : today;

    _nameController = TextEditingController(text: safeName);
    _signatureController = TextEditingController(text: s.declarationSignature);
    _dateController = TextEditingController(text: safeDate);
    _agreementScrollController = ScrollController();
    _agreementScrollController.addListener(_onAgreementScroll);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final cubit = context.read<SubscriptionCubit>();
      cubit.updateDeclarationName(_nameController.text);
      cubit.updateDeclarationDate(_dateController.text);
      _syncAgreementReadProgress();
    });
  }

  @override
  void dispose() {
    _agreementScrollController.removeListener(_onAgreementScroll);
    _agreementScrollController.dispose();
    _nameController.dispose();
    _signatureController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  void _onAgreementScroll() {
    if (!mounted) return;
    _syncAgreementReadProgress();
  }

  void _syncAgreementReadProgress() {
    if (!mounted) return;
    if (!_agreementScrollController.hasClients) return;
    final p = _agreementScrollController.position;
    final atEnd = p.maxScrollExtent <= 8 || p.extentAfter <= 8;
    if (atEnd && !_agreementReadToBottom) {
      setState(() => _agreementReadToBottom = true);
    }
  }

  void _unfocusKeyboard() {
    FocusManager.instance.primaryFocus?.unfocus();
  }

  void _onContinueToNext(AppLocalizations l10n) {
    if (!_agreementReadToBottom) {
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
    final l10n = AppLocalizations.of(context);
    final cubit = context.read<SubscriptionCubit>();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (_nameController.text.trim().isEmpty) {
      final fallbackName = _resolvedProfileName();
      if (fallbackName.isNotEmpty) {
        _nameController.text = fallbackName;
        cubit.updateDeclarationName(fallbackName);
      }
    }
    if (_dateController.text.trim().isEmpty) {
      final today = DateFormat('dd-MM-yyyy').format(DateTime.now());
      _dateController.text = today;
      cubit.updateDeclarationDate(today);
    }

    final fieldsEnabled = _agreementReadToBottom;

    return Padding(
      padding: EdgeInsets.only(
        bottom: AppSpacing.lg,
        left: AppSpacing.lg,
        right: AppSpacing.lg,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: AppSpacing.sm),
          AppText(
            l10n.safetyConsent,
            style: (style) => AppTextStyles.heading1(context),
          ),
          SizedBox(height: 4),
          AppText(
            l10n.pleaseReviewTerms,
            style: (context) => AppTextStyles.bodyText(context),
          ),
          SizedBox(height: AppSpacing.lg),
          Expanded(
            child: GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: _unfocusKeyboard,
              child: NotificationListener<ScrollNotification>(
                onNotification: (ScrollNotification n) {
                  if (n.metrics.axis == Axis.vertical) {
                    _syncAgreementReadProgress();
                  }
                  return false;
                },
                child: SingleChildScrollView(
                  controller: _agreementScrollController,
                  keyboardDismissBehavior:
                      ScrollViewKeyboardDismissBehavior.onDrag,
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(AppSpacing.md),
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
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AppText(
                          l10n.subscriptionAgreement,
                          style: (style) =>
                              AppTextStyles.helpAndSupportItemLabel(
                                context,
                              ).copyWith(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                height: 1.5,
                              ),
                          maxLines: 4,
                        ),
                        SizedBox(height: AppSpacing.md),
                        Text(
                          l10n.safetyText,
                          style: AppTextStyles.helpAndSupportItemLabel(context)
                              .copyWith(
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
          // Scroll when header + agreement + footer exceed the viewport (~112px+
          // overflows on shorter devices). Continue stays pinned like Terms flow.
          Flexible(
            flex: 0,
            fit: FlexFit.loose,
            child: ListView(
              shrinkWrap: true,
              primary: false,
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              physics: const ClampingScrollPhysics(),
              padding: EdgeInsets.only(bottom: AppSpacing.sm),
              children: [
                if (!fieldsEnabled) ...[
                  SizedBox(height: AppSpacing.sm),
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
                SizedBox(height: AppSpacing.md),
                GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: _unfocusKeyboard,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppTextField(
                        label: l10n.name,
                        hint: l10n.name,
                        controller: _nameController,
                        enabled: fieldsEnabled,
                        readOnly: true,
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
                        enabled: fieldsEnabled,
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
                        enabled: fieldsEnabled,
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
                            color: isDark
                                ? AppColors.redDark
                                : AppColors.redLight,
                          ),
                        ),
                      ],
                      SizedBox(height: AppSpacing.sm),
                    ],
                  ),
                ),
              ],
            ),
          ),
          AppButton(
            label: l10n.continueToPayment,
            onPressed: fieldsEnabled ? () => _onContinueToNext(l10n) : null,
            buttonColor: isDark ? AppColors.primary : AppColors.primaryBrown,
            expanded: true,
          ),
        ],
      ),
    );
  }
}
