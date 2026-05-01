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
import '../../../../widgets/dotted_underline.dart';
import '../../../checkout/data/checkout_repository.dart';
import '../../../checkout/data/models/checkout_start_result.dart';
import '../../../checkout/data/models/membership_receipt_summary.dart';
import '../cubit/subscription_cubit.dart';

/// Cart review + voucher. Pass [checkoutSessionId] when this widget is not under
/// [SubscriptionCubit] with a bound session (e.g. gift [PlanDetailsView]).
class ReviewScreenDetailsView extends StatefulWidget {
  const ReviewScreenDetailsView({super.key, this.checkoutSessionId});

  final String? checkoutSessionId;

  @override
  State<ReviewScreenDetailsView> createState() =>
      _ReviewScreenDetailsViewState();
}

class _ReviewScreenDetailsViewState extends State<ReviewScreenDetailsView> {
  final TextEditingController _couponCode = TextEditingController();
  bool _applyingCoupon = false;

  CheckoutStartResult? _checkout;
  bool _checkoutLoading = false;
  String? _checkoutLoadError;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance
        .addPostFrameCallback((_) => _refreshCheckoutDetails());
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
      final fromCubit =
          context.read<SubscriptionCubit>().state.checkoutSessionId.trim();
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
    final l10n = AppLocalizations.of(context)!;
    final messenger = ScaffoldMessenger.of(context);
    final id = _effectiveCheckoutId();
    if (id == null || id.isEmpty) {
      messenger.showSnackBar(
        SnackBar(content: Text(l10n.giftCheckoutSessionRequired)),
      );
      return;
    }
    final code = _couponCode.text.trim();
    if (code.isEmpty) {
      messenger.showSnackBar(
        SnackBar(content: Text(l10n.enterVoucherCode)),
      );
      return;
    }

    final repo = context.read<CheckoutRepository>();
    setState(() => _applyingCoupon = true);
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
          );
        } catch (_) {}
        messenger.showSnackBar(
          SnackBar(content: Text(l10n.voucherAppliedSuccess)),
        );
        unawaited(_refreshCheckoutDetails());
      },
      failure: (e) {
        messenger.showSnackBar(
          SnackBar(
            content: Text(
              (e.message != null && e.message!.trim().isNotEmpty)
                  ? e.message!
                  : l10n.loginErrorGeneric,
            ),
          ),
        );
      },
    );
  }

  String _startDateValue(
    AppLocalizations l10n,
    String locale,
    CheckoutStartResult? s,
  ) {
    final iso = s?.createdAt;
    String datePart;
    if (iso != null && iso.trim().isNotEmpty) {
      datePart =
          MembershipReceiptSummary.formatPaidDate(iso, locale) ?? iso.trim();
    } else {
      try {
        datePart = DateFormat.yMMMd(locale).format(DateTime.now());
      } catch (_) {
        datePart = '';
      }
    }
    if (datePart.isEmpty) {
      return l10n.today;
    }
    return '${l10n.today} ($datePart)';
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
    final totalMinor = pricing?.totalAmount ?? pricing?.subtotal;
    final priceText = MembershipReceiptSummary.formatMoney(
      totalMinor,
      currency,
      locale,
    );
    final suffix = product?.billingPriceSuffix ?? '';
    final planName = product?.name?.trim();
    final planTitle =
        (planName != null && planName.isNotEmpty) ? planName : l10n.premiumPlan;

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
              color: AppColors.successColor,
              borderRadius: BorderRadius.circular(AppRadius.base),
            ),
            child: AppText(
              l10n.active,
              style: (context) =>
                  AppTextStyles.bodyText(context, fontWeight: FontWeight.w500)
                      .copyWith(
                color: Colors.white,
                fontSize: 12,
                height: 1.8,
              ),
            ),
          ),
          SizedBox(height: AppSpacing.base),
          if (_checkoutLoading)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: AppSpacing.lg),
              child: Center(
                child: SizedBox(
                  width: 28,
                  height: 28,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              ),
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
                  AppTextStyles.bodyText(context, fontWeight: FontWeight.w500)
                      .copyWith(
                color: isDark ? AppColors.lightText : AppColors.darkText,
                fontSize: 24,
              ),
            ),
            SizedBox(height: AppSpacing.md),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                AppText(
                  priceText,
                  style: (context) =>
                      AppTextStyles.bodyText(context, fontWeight: FontWeight.w500)
                          .copyWith(
                    color: isDark
                        ? AppColors.languageTextDark
                        : AppColors.languageIcon,
                    fontSize: 18,
                    height: 1.1,
                  ),
                ),
                SvgPicture.asset(
                  'assets/images/svg/ic_Saudi_Riyal_Symbol.svg',
                  height: 18,
                  width: 18,
                  color: isDark
                      ? AppColors.languageTextDark
                      : AppColors.languageIcon,
                ),
                if (suffix.isNotEmpty)
                  Expanded(
                    child: AppText(
                      suffix,
                      style: (context) => AppTextStyles.bodyText(context,
                              fontWeight: FontWeight.w500)
                          .copyWith(
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
            SizedBox(height: AppSpacing.xl),
            _buildClassDetailRow(
              label: '${l10n.startDate}:',
              value: _startDateValue(l10n, locale, session),
              isDark: isDark,
            ),
            const SizedBox(height: AppSpacing.sm),
            if (sessionCount != null && sessionCount > 0) ...[
              _buildClassDetailRow(
                label: '${l10n.classesPerMonth}:',
                value: '$sessionCount',
                isDark: isDark,
              ),
              const SizedBox(height: AppSpacing.sm),
            ],
            if (validityDays > 0 &&
                (sessionCount == null || sessionCount <= 0)) ...[
              _buildClassDetailRow(
                label: '${l10n.redeem_valid_for}:',
                value: '$validityDays',
                isDark: isDark,
              ),
              const SizedBox(height: AppSpacing.sm),
            ],
            _buildClassDetailRow(
              label: '${l10n.validAt}:',
              value: validAt,
              isDark: isDark,
            ),
            const SizedBox(height: AppSpacing.sm),
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
    final l10n = AppLocalizations.of(context)!;

    final scrollBody = Expanded(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppText(
                l10n.reviewYourSelection,
                style: (style) => AppTextStyles.heading1(context),
              ),
              const SizedBox(height: 4),
              AppText(
                l10n.confirmPlanDetails,
                style: (context) => AppTextStyles.bodyText(context),
              ),
              const SizedBox(height: AppSpacing.md),
              _buildPlanSummaryCard(
                context: context,
                isDark: isDark,
                l10n: l10n,
              ),
              const SizedBox(height: AppSpacing.lg),
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
                    ),
                    SizedBox(height: AppSpacing.base),
                    AppButton(
                      label: l10n.apply,
                      isLoading: _applyingCoupon,
                      onPressed: _applyingCoupon ? null : _onApplyCoupon,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              AppText(
                '${l10n.acceptedPaymentMethods}:',
                style: (context) =>
                    AppTextStyles.bodyTextSmall(context).copyWith(height: 1.2),
              ),
              const SizedBox(height: AppSpacing.md),
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
              const SizedBox(height: 90),
            ],
          ),
        ),
      ),
    );

    if (!_listenSubscriptionCubitCheckout) {
      return scrollBody;
    }
    return BlocListener<SubscriptionCubit, SubscriptionState>(
      listenWhen: (p, c) => p.checkoutSessionId != c.checkoutSessionId,
      listener: (context, state) {
        unawaited(_refreshCheckoutDetails());
      },
      child: scrollBody,
    );
  }

  Widget _buildClassDetailRow({
    required String label,
    required String value,
    required bool isDark,
    bool isMultiLine = false,
    bool isBorder = true,
  }) {
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
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: AppText(
                  value,
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
