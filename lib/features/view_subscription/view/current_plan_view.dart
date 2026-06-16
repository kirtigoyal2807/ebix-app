import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:pilates_app/config/theme/app_colors.dart';
import 'package:pilates_app/config/theme/app_radius.dart';
import 'package:pilates_app/config/theme/app_spacing.dart';
import 'package:pilates_app/config/theme/app_text_styles.dart';
import 'package:pilates_app/core/network/api_result.dart';
import 'package:pilates_app/core/localization/arb/app_localizations.dart';
import 'package:pilates_app/features/checkout/data/checkout_repository.dart';
import 'package:pilates_app/features/invoice_history/data/models/customer_subscription_resource.dart';
import 'package:pilates_app/features/subscription/purchase_subscription/view/subscription_view.dart';
import 'package:pilates_app/features/view_subscription/cubit/subscriptions_cubit.dart';
import 'package:pilates_app/features/view_subscription/cubit/subscriptions_state.dart';
import 'package:pilates_app/features/view_subscription/view/pause_subscription_view.dart';
import 'package:pilates_app/widgets/app_text.dart';
import 'package:pilates_app/widgets/currency_amount_text.dart';
import 'package:pilates_app/widgets/app_loading_indicator.dart';

import '../../../core/localization/localization_extension.dart';
import '../../../widgets/app_button.dart';
import '../../../widgets/app_shadow.dart';
import '../../../widgets/dotted_underline.dart';

/// Current plan tab — primary subscription from §9.3 list.
class CurrentPlanView extends StatefulWidget {
  const CurrentPlanView({super.key});

  @override
  State<CurrentPlanView> createState() => _CurrentPlanViewState();
}

class _CurrentPlanViewState extends State<CurrentPlanView> {
  final Map<int, List<String>> _productFeatureCache = <int, List<String>>{};
  final Set<int> _loadingProductIds = <int>{};

  String _planTitle(CustomerSubscriptionResource p, BuildContext context) {
    final n = p.product?.name?.trim();
    if (n != null && n.isNotEmpty) return n;
    final t = p.entitlementType.trim();
    if (t.isNotEmpty) return t.replaceAll('_', ' ');
    return context.l10n.subscriptionTitle;
  }

  String _sessionsLine(CustomerSubscriptionResource p) {
    final se = p.sessions;
    if (se == null) return '—';
    final total = se.total;
    final used = se.used;
    if (total != null) return '$used / $total';
    final rem = se.remaining;
    if (rem != null) return '$used used · $rem left';
    return '$used used';
  }

  String _validUntil(BuildContext context, CustomerSubscriptionResource p) {
    final end = p.expiresAt;
    if (end == null) return '—';
    final locale = Localizations.localeOf(context).toLanguageTag();
    return DateFormat.yMMMd(locale).format(end.toLocal());
  }

  Future<void> _ensurePlanFeaturesLoaded(CustomerSubscriptionResource p) async {
    final productId = p.product?.id;
    if (productId == null || productId <= 0) return;
    if (_productFeatureCache.containsKey(productId)) return;
    if (_loadingProductIds.contains(productId)) return;

    _loadingProductIds.add(productId);
    final repo = context.read<CheckoutRepository>();
    final l10n = AppLocalizations.of(context);
    final result = await repo.getProduct(productId);
    if (!mounted) return;

    final features = switch (result) {
      ApiSuccess(:final data) => List<String>.from(
        (data.toPlanMap(l10n)['features'] as List?) ?? const <String>[],
      ),
      ApiFailure() => <String>[],
    };

    setState(() {
      _loadingProductIds.remove(productId);
      _productFeatureCache[productId] = features;
    });
  }

  List<String> _fallbackPlanDetails(CustomerSubscriptionResource p) {
    final out = <String>[];
    final totalSessions = p.sessions?.total;
    if (totalSessions != null && totalSessions > 0) {
      out.add(totalSessions == 1 ? '1 session' : '$totalSessions sessions');
    }

    final starts = p.startsAt;
    final expires = p.expiresAt;
    if (starts != null && expires != null) {
      final days = expires.difference(starts).inDays;
      if (days > 0) {
        out.add('Valid $days days');
      }
    }
    return out;
  }

  List<String> _resolvedPlanDetails(CustomerSubscriptionResource p) {
    final productId = p.product?.id;
    if (productId != null && productId > 0) {
      final cached = _productFeatureCache[productId];
      if (cached != null && cached.isNotEmpty) {
        return cached;
      }
    }
    return _fallbackPlanDetails(p);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return BlocBuilder<SubscriptionsCubit, SubscriptionsState>(
      builder: (context, state) {
        if (state.status == SubscriptionsLoadStatus.loading &&
            state.subscriptions.isEmpty) {
          return const AppLoadingIndicator();
        }

        if (state.status == SubscriptionsLoadStatus.failure &&
            state.subscriptions.isEmpty) {
          return Center(
            child: Padding(
              padding: EdgeInsets.all(AppSpacing.lg),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AppText(
                    state.errorMessage ?? context.l10n.loginErrorGeneric,
                    textAlign: TextAlign.center,
                    style: (context) => AppTextStyles.body(context),
                  ),
                  SizedBox(height: AppSpacing.md),
                  TextButton(
                    onPressed: () => context.read<SubscriptionsCubit>().load(),
                    child: AppText(
                      context.l10n.retry,
                      style: (context) => AppTextStyles.body(
                        context,
                      ).copyWith(color: AppColors.languageIcon),
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        final primary = state.primarySubscription;
        if (primary == null) {
          return Center(
            child: Padding(
              padding: EdgeInsets.all(AppSpacing.lg),
              child: AppText(
                context.l10n.noSubscriptionsYet,
                textAlign: TextAlign.center,
                style: (context) => AppTextStyles.bodyLightText(context),
              ),
            ),
          );
        }

        if (primary.product?.id != null) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (!mounted) return;
            _ensurePlanFeaturesLoaded(primary);
          });
        }

        final stickyFooterHeight =
            AppSpacing.md +
            AppSpacing.buttonHeight +
            AppSpacing.sm +
            AppSpacing.buttonHeight;

        return RefreshIndicator(
          onRefresh: () => context.read<SubscriptionsCubit>().load(),
          child: Stack(
            fit: StackFit.expand,
            children: [
              SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Padding(
                  padding: EdgeInsets.all(AppSpacing.lg),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                  Container(
                    padding: EdgeInsets.symmetric(
                      vertical: AppSpacing.lmd,
                      horizontal: AppSpacing.md,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(AppRadius.md),
                      gradient: const LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        stops: [0.1514, 1.0],
                        colors: [
                          AppColors.subscriptionCardGradient1,
                          AppColors.subscriptionCardGradient2,
                        ],
                      ),
                      boxShadow: [
                        AppShadows.lightShadow,
                        AppShadows.mediumShadow,
                        AppShadows.mediumHeavyShadow,
                        BoxShadow(
                          color: AppColors.shadowColor.withValues(alpha: 0.01),
                          offset: const Offset(0, 64),
                          blurRadius: 25,
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
                            color: primary.isActive
                                ? AppColors.successColor
                                : AppColors.lightGrey,
                            borderRadius: BorderRadius.circular(AppRadius.base),
                          ),
                          child: AppText(
                            primary.isActive
                                ? context.l10n.active
                                : context.l10n.cancelled,
                            style: (context) => AppTextStyles.bodyText(
                              context,
                              fontWeight: FontWeight.w500,
                            ).copyWith(color: Colors.white, fontSize: 12),
                          ),
                        ),
                        SizedBox(height: AppSpacing.base),
                        AppText(
                          _planTitle(primary, context),
                          style: (context) =>
                              AppTextStyles.bodyText(
                                context,
                                fontWeight: FontWeight.w500,
                              ).copyWith(
                                color: isDark
                                    ? AppColors.lightText
                                    : Colors.white,
                                fontSize: 24,
                                height: 0,
                              ),
                        ),
                        CurrencyAmountText(
                          amount: primary.pricePaid <= 0
                              ? null
                              : primary.pricePaid,
                          currencyCode: 'SAR',
                          priceSuffix:
                              primary.entitlementType.trim().toLowerCase() ==
                                      'subscription'
                                  ? ' / Month'
                                  : '',
                          style: (context) =>
                              AppTextStyles.bodyText(context).copyWith(
                            color: AppColors.seekBarLight,
                            fontSize: 16,
                          ),
                        ),
                        SizedBox(height: AppSpacing.md),
                        SizedBox(
                          width: double.infinity,
                          child: CustomPaint(
                            painter: DashedUnderlinePainter(
                              color: AppColors.darkGreyBorder,
                              dashWidth: 3,
                              dashSpace: 3,
                            ),
                          ),
                        ),
                        SizedBox(height: AppSpacing.md),
                        _buildRow(
                          label: context.l10n.validUntil,
                          subtitle: _validUntil(context, primary),
                          isDark: isDark,
                        ),
                        SizedBox(height: AppSpacing.sm),
                        _buildRow(
                          label: context.l10n.classesUsed,
                          subtitle: _sessionsLine(primary),
                          isDark: isDark,
                        ),
                        SizedBox(height: AppSpacing.sm),
                        _buildRow(
                          label: context.l10n.pauseUsed,
                          subtitle: '${primary.freezes.length}',
                          isDark: isDark,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: AppSpacing.lg),
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: isDark
                            ? AppColors.greyText
                            : AppColors.buttonBorder,
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Theme(
                      data: Theme.of(
                        context,
                      ).copyWith(dividerColor: Colors.transparent),
                      child: ExpansionTile(
                        iconColor: isDark
                            ? AppColors.lightGrey
                            : AppColors.darkText,
                        tilePadding: EdgeInsets.symmetric(horizontal: 16),
                        childrenPadding: EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        title: AppText(
                          context.l10n.planDetails,
                          style: (context) =>
                              AppTextStyles.gelasioRegular(context),
                        ),
                        children: [
                          ..._resolvedPlanDetails(primary).map(
                            (line) =>
                                _buildCheckRow(label: line, isDark: isDark),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: AppSpacing.md),
                  if (primary.freezes.isNotEmpty)
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: isDark
                              ? AppColors.greyText
                              : AppColors.buttonBorder,
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Theme(
                        data: Theme.of(
                          context,
                        ).copyWith(dividerColor: Colors.transparent),
                        child: ExpansionTile(
                          tilePadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                          ),
                          iconColor: isDark
                              ? AppColors.lightGrey
                              : AppColors.darkText,
                          childrenPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          title: AppText(
                            context.l10n.pauseHistory,
                            style: (context) =>
                                AppTextStyles.gelasioRegular(context),
                          ),
                          children: [
                            ...primary.freezes.map((f) {
                              final range =
                                  '${f.startDate ?? '—'} – ${f.endDate ?? '—'}';
                              return Padding(
                                padding: EdgeInsets.only(bottom: AppSpacing.sm),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: AppText(
                                        range,
                                        style: (context) =>
                                            AppTextStyles.bodyText(
                                              context,
                                            ).copyWith(
                                              color: isDark
                                                  ? AppColors.darkGreyText
                                                  : AppColors.lightGrey,
                                              height: 1.2,
                                            ),
                                      ),
                                    ),
                                    AppText(
                                      context.l10n.days_only(f.daysFrozen),
                                      style: (context) =>
                                          AppTextStyles.bodyText(
                                            context,
                                            fontWeight: FontWeight.w500,
                                          ).copyWith(
                                            color: isDark
                                                ? AppColors.lightText
                                                : AppColors.darkText,
                                          ),
                                    ),
                                  ],
                                ),
                              );
                            }),
                            SizedBox(height: AppSpacing.md),
                            Divider(
                              color: isDark
                                  ? AppColors.greyText
                                  : AppColors.buttonBorder,
                              height: 1,
                            ),
                            SizedBox(height: AppSpacing.md),
                            _buildPauseRow(
                              label: context.l10n.remainingThisYear,
                              subtitle: context.l10n.pauseAttemptsRemaining,
                              content: context.l10n.attemptCount,
                              contentColor: isDark
                                  ? AppColors.successBorderDark
                                  : AppColors.successColor,
                              isDark: isDark,
                            ),
                          ],
                        ),
                      ),
                    ),
                  SizedBox(height: stickyFooterHeight + AppSpacing.lg),
                    ],
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  height: stickyFooterHeight,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: isDark
                          ? [
                              AppColors.darkShadow,
                              AppColors.darkShadow.withValues(alpha: 0),
                            ]
                          : [
                              Colors.white,
                              Colors.white.withValues(alpha: 0),
                            ],
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 0,
                right: 0,
                bottom: AppSpacing.md,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                      child: AppButton(
                        label: context.l10n.changePlan,
                        onPressed: () {
                          Navigator.of(context).push<void>(
                            MaterialPageRoute<void>(
                              builder: (context) => const SubscriptionView(),
                            ),
                          );
                        },
                        variant: AppButtonVariant.primary,
                      ),
                    ),
                    SizedBox(height: AppSpacing.sm),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                      child: Container(
                        decoration: BoxDecoration(
                          color: isDark
                              ? AppColors.homeBackground
                              : Colors.white,
                          borderRadius: BorderRadius.circular(AppRadius.xl),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.shadowColor.withValues(
                                alpha: 0.06,
                              ),
                              offset: const Offset(0, 1),
                              blurRadius: 2,
                              spreadRadius: 0,
                            ),
                          ],
                        ),
                        child: AppButton(
                          label: context.l10n.pauseSubscription,
                          onPressed: () {
                            Navigator.push<bool>(
                              context,
                              MaterialPageRoute<bool>(
                                builder: (context) => PauseSubscriptionView(
                                  subscriptionId: primary.id,
                                  planStartsAt:
                                      primary.startsAt ?? DateTime.now(),
                                  planExpiresAt: primary.expiresAt,
                                  maxFreezeDays:
                                      primary.maxFreezeDays ??
                                      primary.product?.maxFreezeDays ??
                                      30,
                                ),
                              ),
                            ).then((refreshed) {
                              if (refreshed != true || !context.mounted) {
                                return;
                              }
                              context.read<SubscriptionsCubit>().load();
                            });
                          },
                          variant: AppButtonVariant.secondary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildRow({
    required String label,
    required String subtitle,
    required bool isDark,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        AppText(
          label,
          style: (context) => AppTextStyles.bodyText(context).copyWith(
            fontSize: 12,
            color: isDark ? AppColors.lightText : AppColors.lightGreyText,
            height: 1.2,
          ),
        ),
        AppText(
          subtitle,
          style: (context) => AppTextStyles.bodyText(context).copyWith(
            fontSize: 12,
            color: isDark ? AppColors.lightText : Colors.white,
            height: 1.2,
          ),
        ),
      ],
    );
  }

  Widget _buildCheckRow({required String label, required bool isDark}) {
    return Padding(
      padding: EdgeInsets.only(bottom: AppSpacing.sm),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.done,
            color: isDark ? AppColors.languageIconDark : AppColors.languageIcon,
            size: 16,
          ),
          SizedBox(width: AppSpacing.xs),
          AppText(
            label,
            style: (context) => AppTextStyles.bodyText(context).copyWith(
              fontSize: 12,
              color: isDark ? AppColors.lightText : AppColors.darkText,
              height: 1.2,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPauseRow({
    required String label,
    required String subtitle,
    required String content,
    required Color contentColor,
    required bool isDark,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppText(
                label,
                style: (context) => AppTextStyles.bodyText(context).copyWith(
                  fontSize: 12,
                  color: AppColors.lightGrey,
                  height: 1.2,
                ),
              ),
              SizedBox(height: AppSpacing.sm),
              AppText(
                subtitle,
                style: (context) => AppTextStyles.bodyText(context).copyWith(
                  color: isDark ? AppColors.darkGreyText : AppColors.lightGrey,
                  height: 1.2,
                ),
              ),
            ],
          ),
        ),
        AppText(
          content,
          style: (context) => AppTextStyles.bodyText(
            context,
            fontWeight: FontWeight.w500,
          ).copyWith(color: contentColor),
        ),
      ],
    );
  }
}
