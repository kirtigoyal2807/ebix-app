import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pilates_app/config/theme/app_colors.dart';
import 'package:pilates_app/config/theme/app_spacing.dart';
import 'package:pilates_app/config/theme/app_text_styles.dart';
import 'package:pilates_app/core/localization/arb/app_localizations.dart';
import 'package:pilates_app/features/subscription/purchase_subscription/cubit/subscription_cubit.dart';
import 'package:pilates_app/widgets/app_button.dart';
import 'package:pilates_app/widgets/app_text.dart';

class TermsAndConditionsView extends StatefulWidget {
  const TermsAndConditionsView({super.key});

  @override
  State<TermsAndConditionsView> createState() => _TermsAndConditionsViewState();
}

class _TermsAndConditionsViewState extends State<TermsAndConditionsView> {
  late final ScrollController _legalScrollController;

  /// User has reached the bottom of the terms legal text (or it did not scroll).
  bool _legalTextScrolledToEnd = false;

  /// Shown when the user tries to continue without accepting the terms checkbox.
  String? _termsAcceptanceError;

  @override
  void initState() {
    super.initState();
    _legalScrollController = ScrollController();
    _legalScrollController.addListener(_onLegalScroll);
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => _maybeMarkShortLegalContentRead(),
    );
  }

  @override
  void dispose() {
    _legalScrollController.removeListener(_onLegalScroll);
    _legalScrollController.dispose();
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
    // Short copy: nothing to scroll — treat as read.
    // Long copy: require near bottom of the *inner* legal scroller only
    // ([extentAfter] shrinks as the user scrolls down).
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

  void _onContinueToPayment(AppLocalizations l10n) {
    final cubit = context.read<SubscriptionCubit>();
    if (!cubit.state.isTermsAccepted) {
      setState(() {
        _termsAcceptanceError = l10n.pleaseAcceptTermsCheckbox;
      });
      return;
    }
    setState(() => _termsAcceptanceError = null);
    cubit.nextStep();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final cubit = context.read<SubscriptionCubit>();
    final state = context.watch<SubscriptionCubit>().state;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final size = MediaQuery.sizeOf(context);

    return Padding(
      padding: EdgeInsets.only(
        bottom: AppSpacing.lg,
        left: AppSpacing.lg,
        right: AppSpacing.lg,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: SingleChildScrollView(
              // Until the inner legal scroller reaches the bottom, do not allow
              // scrolling this outer view (avoids skipping the legal read gate).
              physics: _legalTextScrolledToEnd
                  ? const AlwaysScrollableScrollPhysics()
                  : const NeverScrollableScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: AppSpacing.md),
                  AppText(
                    l10n.termsAndConditions,
                    style: (style) => AppTextStyles.heading1(context),
                  ),
                  SizedBox(height: 4),
                  AppText(
                    l10n.pleaseReviewTerms,
                    style: (context) => AppTextStyles.bodyText(context),
                  ),
                  SizedBox(height: AppSpacing.lg),

                  SizedBox(
                    height: size.height * 0.5,
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
                              isDark
                                  ? AppColors.languageIconDark
                                  : AppColors.languageIcon,
                            ),
                            trackColor: WidgetStateProperty.all(
                              isDark
                                  ? AppColors.greyText
                                  : AppColors.buttonBorder,
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
                                  padding: EdgeInsets.symmetric(
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
                                        l10n.subscriptionTermsText,
                                        style:
                                            AppTextStyles.helpAndSupportItemLabel(
                                              context,
                                            ).copyWith(
                                              fontSize: 12,
                                              color: isDark
                                                  ? AppColors.darkGreyText
                                                  : AppColors.greyText,
                                              fontWeight: FontWeight.w400,
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

                  SizedBox(height: AppSpacing.lg),

                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 20,
                        width: 20,
                        child: Checkbox(
                          value: state.isTermsAccepted,
                          onChanged: _legalTextScrolledToEnd
                              ? (val) {
                                  cubit.toggleTermsAccepted(val ?? false);
                                  setState(() => _termsAcceptanceError = null);
                                }
                              : null,
                          activeColor: AppColors.primaryBrown,
                          checkColor: isDark
                              ? AppColors.lightText
                              : AppColors.whiteColor,
                          side: BorderSide(
                            color: isDark
                                ? AppColors.greyText
                                : AppColors.buttonBorder,
                            width: 1,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ),
                      SizedBox(width: 8),
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.only(top: 2),
                          child: AppText(
                            l10n.agreeToTermsAndConditions,
                            style: (style) =>
                                AppTextStyles.helpAndSupportItemLabel(
                                  context,
                                ).copyWith(fontWeight: FontWeight.w400),
                            maxLines: 4,
                          ),
                        ),
                      ),
                    ],
                  ),
                  if (_termsAcceptanceError != null) ...[
                    SizedBox(height: AppSpacing.sm),
                    Text(
                      _termsAcceptanceError!,
                      style: AppTextStyles.bodyText(context).copyWith(
                        fontSize: 12,
                        color: isDark ? AppColors.redDark : AppColors.redLight,
                      ),
                    ),
                  ],
                  SizedBox(height: AppSpacing.lg),
                ],
              ),
            ),
          ),

          AppButton(
            label: l10n.continueToPayment,
            onPressed: _legalTextScrolledToEnd
                ? () => _onContinueToPayment(l10n)
                : null,
            buttonColor: isDark ? AppColors.primary : AppColors.primaryBrown,
            expanded: true,
          ),
        ],
      ),
    );
  }
}
