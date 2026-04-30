import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:html/parser.dart' as html_parser;
import 'package:pilates_app/config/theme/app_colors.dart';
import 'package:pilates_app/config/theme/app_spacing.dart';
import 'package:pilates_app/config/theme/app_text_styles.dart';
import 'package:pilates_app/core/localization/arb/app_localizations.dart';
import 'package:pilates_app/features/checkout/data/checkout_repository.dart';
import 'package:pilates_app/features/subscription/purchase_subscription/cubit/subscription_cubit.dart';
import 'package:pilates_app/widgets/app_button.dart';
import 'package:pilates_app/widgets/app_text.dart';

/// Bottom sheet for plan summary. When [plan] `id` parses to a positive int,
/// loads `GET /products/{id}` and merges price, features, [requiresHealthIntake],
/// and a plain-text excerpt from HTML [description].
class PlanDetailsModal extends StatefulWidget {
  const PlanDetailsModal({
    super.key,
    required this.plan,
    this.appLabel,
    this.onSubscribe,
  });

  final Map<String, dynamic> plan;
  final String? appLabel;
  final VoidCallback? onSubscribe;

  @override
  State<PlanDetailsModal> createState() => _PlanDetailsModalState();
}

class _PlanDetailsModalState extends State<PlanDetailsModal> {
  late Map<String, dynamic> _displayPlan;
  bool _detailLoading = false;

  @override
  void initState() {
    super.initState();
    _displayPlan = Map<String, dynamic>.from(widget.plan);
    WidgetsBinding.instance.addPostFrameCallback((_) => _maybeLoadProductDetail());
  }

  Future<void> _maybeLoadProductDetail() async {
    final id = int.tryParse(widget.plan['id']?.toString() ?? '');
    if (id == null || id <= 0 || !mounted) {
      return;
    }
    setState(() => _detailLoading = true);
    final repo = context.read<CheckoutRepository>();
    int? branchId;
    try {
      branchId = context.read<SubscriptionCubit>().state.selectedBranchId;
    } catch (_) {
      branchId = null;
    }
    final result = await repo.getProduct(
      id,
      branchId: (branchId != null && branchId > 0) ? branchId : null,
    );
    if (!mounted) {
      return;
    }
    setState(() => _detailLoading = false);
    result.when(
      success: (product, _) {
        if (!mounted) {
          return;
        }
        final l10n = AppLocalizations.of(context)!;
        final merged = Map<String, dynamic>.from(widget.plan);
        merged.addAll(product.toPlanMap(l10n));
        merged['id'] = widget.plan['id'];
        final plain = _htmlToSingleLinePlainText(product.description);
        if (plain.isNotEmpty) {
          merged['descriptionPlain'] = plain;
        }
        setState(() => _displayPlan = merged);
        try {
          context.read<SubscriptionCubit>().selectPlan(
                merged['id'] as String,
                requiresHealthIntake: product.requiresHealthIntake,
              );
        } catch (_) {}
      },
      failure: (_) {},
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final billingSuffix = _planPriceSubtitle(_displayPlan);
    final descriptionPlain = _displayPlan['descriptionPlain'] as String?;
    final hasDescription =
        descriptionPlain != null && descriptionPlain.trim().isNotEmpty;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (_displayPlan['badge'] != null)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: _displayPlan['isPopular'] == true
                          ? AppColors.goldStarColor
                          : (isDark
                              ? const Color(0x3BFDC700)
                              : AppColors.goldStarColor),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: AppText(
                      _displayPlan['badge'],
                      style: (context) => AppTextStyles.body(context).copyWith(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: (isDark
                            ? AppColors.blackColor
                            : AppColors.darkText),
                      ),
                    ),
                  )
                else
                  const SizedBox(),
                SizedBox(
                  height: 28,
                  width: 32,
                  child: IconButton(
                    icon: Icon(
                      Icons.close,
                      size: 22,
                      color: isDark
                          ? AppColors.lightGrey
                          : AppColors.darkGreyText,
                    ),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
              ],
            ),
            AppText(
              _displayPlan['title'],
              style: (context) => AppTextStyles.headline(context).copyWith(
                fontWeight: FontWeight.w500,
                color: isDark ? AppColors.lightText : AppColors.darkText,
              ),
            ),
            if (_detailLoading) ...[
              const SizedBox(height: AppSpacing.sm),
              const Center(
                child: SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              ),
            ],
            const SizedBox(height: AppSpacing.sm),
            Row(
              children: [
                AppText(
                  '${_displayPlan['price']}',
                  style: (context) => AppTextStyles.boldBody(context).copyWith(
                    fontSize: 32,
                    fontWeight: FontWeight.w500,
                    color: isDark
                        ? AppColors.languageTextDark
                        : AppColors.languageIcon,
                  ),
                ),
                SvgPicture.asset(
                  'assets/images/svg/ic_Saudi_Riyal_Symbol.svg',
                  height: 24,
                  width: 24,
                  color: isDark
                      ? AppColors.languageTextDark
                      : AppColors.languageIcon,
                ),
                if (billingSuffix.isNotEmpty)
                  AppText(
                    billingSuffix,
                    style: (context) =>
                        AppTextStyles.boldBody(context).copyWith(
                      fontSize: 32,
                      fontWeight: FontWeight.w500,
                      color: isDark
                          ? AppColors.languageTextDark
                          : AppColors.languageIcon,
                    ),
                  ),
              ],
            ),
            if (hasDescription) ...[
              const SizedBox(height: AppSpacing.md),
              AppText(
                descriptionPlain.trim(),
                style: (context) => AppTextStyles.bodyTextSmall(context)
                    .copyWith(
                  color: isDark ? AppColors.lightText : AppColors.greyText,
                  height: 1.35,
                ),
              ),
            ],
            const SizedBox(height: AppSpacing.lg),
            if (_displayPlan['features'] != null)
              Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                decoration: BoxDecoration(
                  color: isDark
                      ? AppColors.lightBlackColor
                      : AppColors.seekBarLight,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children:
                      (_displayPlan['features'] as List<String>).map((feature) {
                    return Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.check,
                            size: 12,
                            color: isDark
                                ? AppColors.seekBarLight
                                : AppColors.languageIcon,
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: AppText(
                              feature,
                              style: (style) =>
                                  AppTextStyles.bodyTextSmall(context).copyWith(
                                color: isDark
                                    ? AppColors.lightText
                                    : AppColors.greyText,
                                fontSize: 12,
                                height: 1.2,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
            const SizedBox(height: 32),
            AppButton(
              label: widget.appLabel ?? 'Subscribe Now',
              onPressed: widget.onSubscribe,
              buttonColor:
                  isDark ? AppColors.primary : AppColors.primaryBrown,
              expanded: true,
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

String _htmlToSingleLinePlainText(String? raw) {
  if (raw == null || raw.trim().isEmpty) {
    return '';
  }
  final text = html_parser.parseFragment(raw).text ?? '';
  return text.replaceAll(RegExp(r'\s+'), ' ').trim();
}

/// Text after the SAR symbol in the plan sheet (e.g. ` / Month` for legacy rows).
String _planPriceSubtitle(Map<String, dynamic> plan) {
  if (plan.containsKey('priceSubtitle')) {
    return (plan['priceSubtitle'] as String?) ?? '';
  }
  return ' / Month';
}
