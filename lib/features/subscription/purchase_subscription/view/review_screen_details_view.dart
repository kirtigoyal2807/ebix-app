import 'package:pilates_app/widgets/app_loading_indicator.dart';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';

import '../../../../config/theme/app_colors.dart';
import '../../../../config/theme/app_radius.dart';
import '../../../../config/theme/app_spacing.dart';
import '../../../../config/theme/app_text_styles.dart';
import '../../../../core/localization/arb/app_localizations.dart';
import '../../../../widgets/app_button.dart';
import '../../../../widgets/app_shadow.dart';
import '../../../../widgets/app_text.dart';
import '../../../../widgets/app_text_field.dart';
import '../../../../widgets/currency_amount_text.dart';
import '../../../../widgets/dotted_underline.dart';
import '../../../checkout/data/checkout_repository.dart';
import '../../../checkout/data/models/checkout_start_result.dart';
import '../../../checkout/data/models/membership_receipt_summary.dart';
import '../cubit/subscription_cubit.dart';

/// Cart review + voucher. Pass [checkoutSessionId] when this widget is not under
/// [SubscriptionCubit] with a bound session (e.g. gift [PlanDetailsView]).
class ReviewScreenDetailsView extends StatefulWidget {
  const ReviewScreenDetailsView({
    super.key,
    this.checkoutSessionId,
    this.scrollKeyboardInset,
  });

  final String? checkoutSessionId;

  /// When non-null, used as extra bottom inset for the scroll view (keyboard).
  /// Lets parents adjust keyboard handling without relying only on [MediaQuery].
  final double? scrollKeyboardInset;

  @override
  State<ReviewScreenDetailsView> createState() =>
      _ReviewScreenDetailsViewState();
}

class _ReviewScreenDetailsViewState extends State<ReviewScreenDetailsView> {
  final TextEditingController _couponCode = TextEditingController();
  bool _applyingCoupon = false;
  String? _voucherSectionError;

  CheckoutStartResult? _checkout;
  bool _checkoutLoading = false;
  String? _checkoutLoadError;

  @override
  void initState() {
    super.initState();
    _couponCode.addListener(_onCouponCodeEdited);
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => _refreshCheckoutDetails(),
    );
  }

  void _onCouponCodeEdited() {
    if (_voucherSectionError != null && mounted) {
      setState(() => _voucherSectionError = null);
    }
  }

  @override
  void didUpdateWidget(covariant ReviewScreenDetailsView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.checkoutSessionId != widget.checkoutSessionId) {
      _refreshCheckoutDetails();
    }
  }

  @override
  void dispose() {
    _couponCode.removeListener(_onCouponCodeEdited);
    _couponCode.dispose();
    super.dispose();
  }

  bool get _listenSubscriptionCubitCheckout {
    final w = widget.checkoutSessionId?.trim();
    return w == null || w.isEmpty;
  }

  String? _effectiveCheckoutId() {
    final w = widget.checkoutSessionId?.trim();
    if (w != null && w.isNotEmpty) return w;
    try {
      final fromCubit = context
          .read<SubscriptionCubit>()
          .state
          .checkoutSessionId
          .trim();
      if (fromCubit.isNotEmpty) return fromCubit;
    } catch (_) {
      return null;
    }
    return null;
  }

  Future<void> _refreshCheckoutDetails() async {
    final id = _effectiveCheckoutId();
    if (id == null || id.isEmpty) {
      if (mounted) {
        setState(() {
          _checkout = null;
          _checkoutLoadError = null;
          _checkoutLoading = false;
        });
      }
      return;
    }
    if (!mounted) return;
    setState(() {
      _checkoutLoading = true;
      _checkoutLoadError = null;
    });
    final repo = context.read<CheckoutRepository>();
    final result = await repo.getCheckoutDetails(id);
    if (!mounted) return;
    result.when(
      success: (data, _) {
        setState(() {
          _checkout = data;
          _checkoutLoading = false;
          _checkoutLoadError = null;
        });
      },
      failure: (e) {
        setState(() {
          _checkout = null;
          _checkoutLoading = false;
          _checkoutLoadError =
              (e.message != null && e.message!.trim().isNotEmpty)
              ? e.message!.trim()
              : null;
        });
      },
    );
  }

  Future<void> _onApplyCoupon() async {
    final l10n = AppLocalizations.of(context);
    final id = _effectiveCheckoutId();
    if (id == null || id.isEmpty) {
      setState(() {
        _voucherSectionError = l10n.voucherCheckoutSessionMissing;
      });
      return;
    }
    final code = _couponCode.text.trim();
    if (code.isEmpty) {
      setState(() {
        _voucherSectionError = l10n.voucherEnterCodeMessage;
      });
      return;
    }

    final repo = context.read<CheckoutRepository>();
    setState(() {
      _applyingCoupon = true;
      _voucherSectionError = null;
    });
    final result = await repo.applyCoupon(checkoutId: id, code: code);
    if (!mounted) return;
    setState(() => _applyingCoupon = false);

    result.when(
      success: (session, _) {
        try {
          final cubit = context.read<SubscriptionCubit>();
          final pid =
              session.resolvedProductId ?? cubit.state.checkoutProductId;
          cubit.bindCheckoutSession(
            sessionId: session.id,
            productId: pid,
            requiresHealthIntake: session.resolvedRequiresHealthIntake,
            preserveWizardProgress: true,
          );
        } catch (_) {}
        unawaited(_refreshCheckoutDetails());
      },
      failure: (e) {
        setState(() {
          final msg = e.message?.trim();
          _voucherSectionError = (msg != null && msg.isNotEmpty)
              ? msg
              : l10n.voucherCodeInvalid;
        });
      },
    );
  }

  String _cartDateDisplay(
    AppLocalizations l10n,
    String locale,
    CheckoutStartResult? s,
  ) {
    final iso = s?.createdAt;
    if (iso != null && iso.trim().isNotEmpty) {
      final formatted = MembershipReceiptSummary.formatPaidDate(iso, locale);
      if (formatted != null && formatted.trim().isNotEmpty) {
        return formatted.trim();
      }
    }
    try {
      return DateFormat.yMMMd(locale).format(DateTime.now());
    } catch (_) {
      return l10n.today;
    }
  }

  /// Discount from API totals (major currency units).
  num _effectiveDiscountAmount(CheckoutPricing? pricing) {
    final explicit = pricing?.discountAmount;
    if (explicit != null && explicit > 0) return explicit;
    final sub = pricing?.subtotal;
    final total = pricing?.totalAmount;
    if (sub != null && total != null && sub > total) {
      return sub - total;
    }
    return 0;
  }

  Widget _buildVoucherFeedback({
    required AppLocalizations l10n,
    required String locale,
  }) {
    final session = _checkout;
    if (session == null || _voucherSectionError != null) {
      return const SizedBox.shrink();
    }

    final appliedCode = session.appliedOffer?.code?.trim();
    final entered = _couponCode.text.trim();
    final disc = _effectiveDiscountAmount(session.pricing);
    final hasAppliedOffer = appliedCode != null && appliedCode.isNotEmpty;

    // User is typing a different code than the one on the session — hide success.
    if (hasAppliedOffer &&
        entered.isNotEmpty &&
        entered.toUpperCase() != appliedCode.toUpperCase()) {
      return const SizedBox.shrink();
    }

    // Discount visible in pricing but API omitted appliedOffer.code — still show savings.
    if (!hasAppliedOffer && disc <= 0) {
      return const SizedBox.shrink();
    }

    final pricing = session.pricing;
    final cur = pricing?.currency?.trim();
    final currency = (cur != null && cur.isNotEmpty) ? cur : 'SAR';

    TextStyle successStyle(BuildContext context) =>
        AppTextStyles.bodyText(context).copyWith(
          color: AppColors.successColor,
          fontWeight: FontWeight.w600,
          height: 1.35,
        );

    if (disc > 0) {
      final st = successStyle(context);
      return Padding(
        padding: EdgeInsets.only(top: AppSpacing.sm),
        child: Text.rich(
          TextSpan(
            children: [
              TextSpan(text: l10n.voucherAppliedSavingsLead, style: st),
              ...currencyAmountInlineSpans(
                amount: disc,
                currencyCode: currency,
                textStyle: st,
              ),
              TextSpan(text: l10n.voucherAppliedSavingsEnd, style: st),
            ],
          ),
        ),
      );
    }

    return Padding(
      padding: EdgeInsets.only(top: AppSpacing.sm),
      child: AppText(l10n.voucherAppliedSuccess, style: successStyle),
    );
  }

  Widget _buildPlanSummaryCard({
    required BuildContext context,
    required bool isDark,
    required AppLocalizations l10n,
  }) {
    final locale = Localizations.localeOf(context).languageCode;
    final session = _checkout;
    final product = session?.product;
    final pricing = session?.pricing;
    final branch = session?.branch;
    final payment = session?.payment;

    final cur = pricing?.currency?.trim();
    final currency = (cur != null && cur.isNotEmpty) ? cur : 'SAR';
    final discountAmt = _effectiveDiscountAmount(pricing);
    final subtotalAmt = pricing?.subtotal;
    final totalAmt = pricing?.totalAmount ?? pricing?.subtotal;
    final impliedSubtotal = (subtotalAmt != null && subtotalAmt > 0)
        ? subtotalAmt
        : (totalAmt != null && totalAmt > 0 && discountAmt > 0)
        ? totalAmt + discountAmt
        : subtotalAmt;
    final showPriceBreakdown =
        discountAmt > 0 && impliedSubtotal != null && impliedSubtotal > 0;
    final headlineTotalAmt = (totalAmt != null && totalAmt > 0)
        ? totalAmt
        : impliedSubtotal;
    final suffix = product?.billingPriceSuffix ?? '';
    final planName = product?.name?.trim();
    final planTitle = (planName != null && planName.isNotEmpty)
        ? planName
        : l10n.premiumPlan;

    final nextBilling = MembershipReceiptSummary.formatNextBilling(
      payment?.nextBillingAt,
      locale,
    );

    final branchName = branch?.name?.trim();
    final validAt = (branchName != null && branchName.isNotEmpty)
        ? branchName
        : l10n.featureStudios;

    final sessionCount = product?.sessionCount;
    final validityDays = product?.validityDays ?? 0;

    return Container(
      padding: EdgeInsets.all(AppSpacing.lmd),
      decoration: BoxDecoration(
        color: isDark ? AppColors.homeBackground : Colors.white,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(
          color: isDark ? AppColors.greyText : AppColors.buttonBorder,
          width: 1,
        ),
        boxShadow: isDark
            ? []
            : [
                AppShadows.lightShadow,
                AppShadows.mediumShadow,
                AppShadows.mediumHeavyShadow,
                BoxShadow(
                  color: AppColors.shadowColor.withValues(alpha: 0.01),
                  offset: const Offset(0, 64),
                  blurRadius: 25,
                  spreadRadius: 0,
                ),
                BoxShadow(
                  color: AppColors.shadowColor.withValues(alpha: 0.00),
                  offset: const Offset(0, 99),
                  blurRadius: 28,
                  spreadRadius: 0,
                ),
              ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.symmetric(
              vertical: 1,
              horizontal: AppSpacing.sm,
            ),
            decoration: BoxDecoration(
              color: AppColors.warningColor,
              borderRadius: BorderRadius.circular(AppRadius.base),
            ),
            child: AppText(
              l10n.planReviewPendingPayment,
              style: (context) => AppTextStyles.bodyText(
                context,
                fontWeight: FontWeight.w500,
              ).copyWith(color: AppColors.darkText, fontSize: 12, height: 1.8),
            ),
          ),
          SizedBox(height: AppSpacing.base),
          if (_checkoutLoading)
            Padding(
              padding: EdgeInsets.symmetric(vertical: AppSpacing.lg),
              child: Center(child: AppInlineBusy(size: 28)),
            )
          else if (session == null && _checkoutLoadError != null) ...[
            AppText(
              _checkoutLoadError!,
              style: (context) => AppTextStyles.captionText(context),
            ),
            TextButton(
              onPressed: _refreshCheckoutDetails,
              child: Text(l10n.retry),
            ),
          ] else ...[
            AppText(
              planTitle,
              style: (context) =>
                  AppTextStyles.bodyText(
                    context,
                    fontWeight: FontWeight.w500,
                  ).copyWith(
                    color: isDark ? AppColors.lightText : AppColors.darkText,
                    fontSize: 24,
                  ),
            ),
            SizedBox(height: AppSpacing.md),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: CurrencyAmountText(
                    amount: headlineTotalAmt,
                    currencyCode: currency,
                    priceSuffix: suffix,
                    style: (context) =>
                        AppTextStyles.bodyText(
                          context,
                          fontWeight: FontWeight.w500,
                        ).copyWith(
                          color: isDark
                              ? AppColors.languageTextDark
                              : AppColors.languageIcon,
                          fontSize: 18,
                          height: 1.1,
                        ),
                  ),
                ),
              ],
            ),
            if (showPriceBreakdown) ...[
              SizedBox(height: AppSpacing.md),
              _buildClassDetailRow(
                label: '${l10n.checkoutSubtotal}:',
                valueWidget: CurrencyAmountText(
                  amount: impliedSubtotal,
                  currencyCode: currency,
                  style: (ctx) => AppTextStyles.bodyText(ctx),
                  textAlign: TextAlign.end,
                ),
                isDark: isDark,
              ),
              SizedBox(height: AppSpacing.sm),
              _buildClassDetailRow(
                label: '${l10n.checkoutVoucherDiscount}:',
                valueWidget: CurrencyAmountText(
                  amount: discountAmt,
                  currencyCode: currency,
                  leading: '- ',
                  style: (ctx) => AppTextStyles.bodyText(ctx),
                  textAlign: TextAlign.end,
                ),
                isDark: isDark,
              ),
            ],
            SizedBox(height: AppSpacing.xl),
            _buildClassDetailRow(
              label: '${l10n.cartDateLabel}:',
              value: _cartDateDisplay(l10n, locale, session),
              isDark: isDark,
            ),
            SizedBox(height: AppSpacing.sm),
            if (sessionCount != null && sessionCount > 0) ...[
              _buildClassDetailRow(
                label: '${l10n.classesPerMonth}:',
                value: '$sessionCount',
                isDark: isDark,
              ),
              SizedBox(height: AppSpacing.sm),
            ],
            if (validityDays > 0) ...[
              _buildClassDetailRow(
                label: '${l10n.redeem_valid_for}:',
                value: '$validityDays',
                isDark: isDark,
              ),
              SizedBox(height: AppSpacing.sm),
            ],
            _buildClassDetailRow(
              label: '${l10n.validAt}:',
              value: validAt,
              isDark: isDark,
            ),
            SizedBox(height: AppSpacing.sm),
            _buildClassDetailRow(
              label: '${l10n.nextBillingDateText}:',
              value: (nextBilling != null && nextBilling.trim().isNotEmpty)
                  ? nextBilling.trim()
                  : '—',
              isBorder: false,
              isDark: isDark,
            ),
          ],
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context);
    final locale = Localizations.localeOf(context).languageCode;
    final bottomInset =
        widget.scrollKeyboardInset ?? MediaQuery.viewInsetsOf(context).bottom;

    final scrollView = SingleChildScrollView(
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      child: Padding(
        padding: EdgeInsets.only(
          left: AppSpacing.lg,
          right: AppSpacing.lg,
          bottom: bottomInset + AppSpacing.xl,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: AppSpacing.md),
            AppText(
              l10n.reviewYourSelection,
              style: (style) => AppTextStyles.heading1(context),
            ),
            SizedBox(height: 4),
            AppText(
              l10n.confirmPlanDetails,
              style: (context) => AppTextStyles.bodyText(context),
            ),
            SizedBox(height: AppSpacing.md),
            _buildPlanSummaryCard(context: context, isDark: isDark, l10n: l10n),
            SizedBox(height: AppSpacing.lg),
            Container(
              padding: EdgeInsets.all(AppSpacing.lmd),
              decoration: BoxDecoration(
                color: isDark ? AppColors.homeBackground : Colors.white,
                borderRadius: BorderRadius.circular(AppRadius.md),
                border: Border.all(
                  color: isDark ? AppColors.greyText : AppColors.buttonBorder,
                  width: 1,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppText(
                    l10n.haveVoucherCode,
                    style: (context) => AppTextStyles.gelasioRegular(
                      context,
                      fontWeight: FontWeight.w500,
                    ).copyWith(height: 1.2),
                  ),
                  SizedBox(height: AppSpacing.md),
                  AppTextField(
                    hint: l10n.enterVoucherCode,
                    controller: _couponCode,
                    showClearButton: true,
                    scrollPadding: EdgeInsets.only(bottom: 220),
                    errorText: _voucherSectionError,
                    onChanged: (_) => setState(() {}),
                  ),
                  _buildVoucherFeedback(l10n: l10n, locale: locale),
                  SizedBox(height: AppSpacing.md),
                  AppButton(
                    label: l10n.apply,
                    isLoading: _applyingCoupon,
                    onPressed: _applyingCoupon ? null : _onApplyCoupon,
                  ),
                ],
              ),
            ),
            SizedBox(height: AppSpacing.lg),
            AppText(
              '${l10n.acceptedPaymentMethods}:',
              style: (context) =>
                  AppTextStyles.bodyTextSmall(context).copyWith(height: 1.2),
            ),
            SizedBox(height: AppSpacing.md),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SvgPicture.asset(
                  isDark
                      ? 'assets/images/svg/ic_dark_cs_mada.svg'
                      : 'assets/images/svg/ic_cs_mada.svg',
                ),
                SizedBox(width: AppSpacing.sm),
                SvgPicture.asset(
                  isDark
                      ? 'assets/images/svg/ic_dark_tabby.svg'
                      : 'assets/images/svg/ic_tabby.svg',
                ),
                SizedBox(width: AppSpacing.sm),
                SvgPicture.asset(
                  isDark
                      ? 'assets/images/svg/ic_dark_master.svg'
                      : 'assets/images/svg/ic_master.svg',
                ),
                SizedBox(width: AppSpacing.sm),
                SvgPicture.asset(
                  isDark
                      ? 'assets/images/svg/ic_dark_visa.svg'
                      : 'assets/images/svg/ic_visa.svg',
                ),
                SizedBox(width: AppSpacing.sm),
                SvgPicture.asset(
                  isDark
                      ? 'assets/images/svg/ic_dark_tamara.svg'
                      : 'assets/images/svg/ic_tamara.svg',
                ),
              ],
            ),
            SizedBox(height: AppSpacing.xl),
          ],
        ),
      ),
    );

    if (!_listenSubscriptionCubitCheckout) {
      return scrollView;
    }
    return BlocListener<SubscriptionCubit, SubscriptionState>(
      listenWhen: (p, c) => p.checkoutSessionId != c.checkoutSessionId,
      listener: (context, state) {
        unawaited(_refreshCheckoutDetails());
      },
      child: scrollView,
    );
  }

  Widget _buildClassDetailRow({
    required String label,
    String? value,
    Widget? valueWidget,
    required bool isDark,
    bool isMultiLine = false,
    bool isBorder = true,
  }) {
    assert(value != null || valueWidget != null);
    return SizedBox(
      width: double.infinity,
      child: CustomPaint(
        painter: isBorder
            ? DashedUnderlinePainter(
                color: isDark ? AppColors.greyText : AppColors.buttonBorder,
              )
            : null,
        child: Padding(
          padding: EdgeInsets.only(bottom: isBorder ? AppSpacing.sm : 0),
          child: Row(
            crossAxisAlignment: isMultiLine
                ? CrossAxisAlignment.start
                : CrossAxisAlignment.center,
            children: [
              Expanded(
                child: AppText(
                  label,
                  style: (context) => AppTextStyles.textFieldHeading(context),
                ),
              ),
              SizedBox(width: AppSpacing.md),
              Expanded(
                child:
                    valueWidget ??
                    AppText(
                      value!,
                      style: (context) => AppTextStyles.bodyText(context),
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
