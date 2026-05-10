import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:pilates_app/config/theme/app_colors.dart';
import 'package:pilates_app/config/theme/app_radius.dart';
import 'package:pilates_app/config/theme/app_spacing.dart';
import 'package:pilates_app/config/theme/app_text_styles.dart';
import 'package:pilates_app/features/invoice_history/data/models/customer_subscription_resource.dart';
import 'package:pilates_app/features/invoice_history/data/subscriptions_repository.dart';
import 'package:pilates_app/features/view_subscription/cubit/subscriptions_cubit.dart';
import 'package:pilates_app/features/view_subscription/cubit/subscriptions_state.dart';
import 'package:pilates_app/features/view_subscription/view/pause_subscription_view.dart';
import 'package:pilates_app/core/utils/currency_display.dart';
import 'package:pilates_app/widgets/app_text.dart';

import '../../../core/localization/localization_extension.dart';

/// Tab: full subscription history from §9.3 — stacked rows, freezes, pause entry points.
class ExistingPlanView extends StatelessWidget {
  const ExistingPlanView({super.key});

  List<CustomerSubscriptionResource> _sorted(
    List<CustomerSubscriptionResource> raw,
  ) {
    final list = List<CustomerSubscriptionResource>.from(raw);
    DateTime? anchor(CustomerSubscriptionResource x) =>
        x.startsAt ?? x.expiresAt ?? x.createdAt;

    list.sort((a, b) {
      final da = anchor(a);
      final db = anchor(b);
      if (da == null && db == null) return 0;
      if (da == null) return 1;
      if (db == null) return -1;
      return db.compareTo(da);
    });
    return list;
  }

  _PlanTimeline _timeline(CustomerSubscriptionResource s) {
    final now = DateTime.now();
    final start = s.startsAt?.toLocal();
    final end = s.expiresAt?.toLocal();
    if (start != null && start.isAfter(now)) return _PlanTimeline.upcoming;
    if (end != null && end.isBefore(now)) return _PlanTimeline.ended;
    if (s.isActive) return _PlanTimeline.active;
    return _PlanTimeline.inactive;
  }

  String _planTitle(CustomerSubscriptionResource s, BuildContext context) {
    final n = s.product?.name?.trim();
    if (n != null && n.isNotEmpty) return n;
    final t = s.entitlementType.trim();
    if (t.isNotEmpty) return t.replaceAll('_', ' ');
    return context.l10n.subscriptionTitle;
  }

  String _entitlementLine(CustomerSubscriptionResource s) {
    final t = s.entitlementType.trim();
    if (t.isEmpty) return '';
    return t.replaceAll('_', ' ');
  }

  String _priceLine(CustomerSubscriptionResource s) {
    if (s.pricePaid <= 0) return '—';
    return formatCurrencyAmount(amount: s.pricePaid, code: 'SAR');
  }

  String _sessionsLine(CustomerSubscriptionResource s) {
    final se = s.sessions;
    if (se == null) return '—';
    final total = se.total;
    final used = se.used;
    if (total != null) return '$used / $total';
    final rem = se.remaining;
    if (rem != null) return '$used used · $rem left';
    return '$used used';
  }

  String _periodLine(BuildContext context, CustomerSubscriptionResource s) {
    final locale = Localizations.localeOf(context).toLanguageTag();
    final fmt = DateFormat.yMMMd(locale);
    final start = s.startsAt;
    final end = s.expiresAt;
    if (start != null && end != null) {
      return context.l10n.planDuration(
        fmt.format(start.toLocal()),
        fmt.format(end.toLocal()),
      );
    }
    if (end != null) {
      return context.l10n.expiredOn(fmt.format(end.toLocal()));
    }
    if (start != null) {
      return context.l10n.sinceDate(fmt.format(start.toLocal()));
    }
    return '—';
  }

  String _formatFreezeBoundary(String? raw, BuildContext context) {
    if (raw == null || raw.trim().isEmpty) return '';
    final t = raw.trim();
    final d =
        DateTime.tryParse(t) ?? DateTime.tryParse(t.replaceFirst(' ', 'T'));
    if (d == null) return t;
    final locale = Localizations.localeOf(context).toLanguageTag();
    return DateFormat.yMMMd(locale).format(d.toLocal());
  }

  String _freezeSummary(BuildContext context, SubscriptionFreeze f) {
    final a = _formatFreezeBoundary(f.startDate, context);
    final b = _formatFreezeBoundary(f.endDate, context);
    if (a.isNotEmpty && b.isNotEmpty) return '$a — $b';
    if (a.isNotEmpty) return a;
    if (b.isNotEmpty) return b;
    return f.status.isNotEmpty ? f.status : '—';
  }

  bool _canCancelFreeze(SubscriptionFreeze f) {
    if (f.id.isEmpty) return false;
    final st = f.status.toLowerCase().trim();
    if (st.contains('cancel')) return false;
    if (st == 'completed' || st == 'ended') return false;
    return true;
  }

  bool _canPause(CustomerSubscriptionResource s) {
    if (!s.isActive) return false;
    final now = DateTime.now();
    final start = s.startsAt?.toLocal();
    if (start != null && start.isAfter(now)) return false;
    final end = s.expiresAt?.toLocal();
    if (end != null && end.isBefore(now)) return false;
    return true;
  }

  Future<void> _cancelFreeze(
    BuildContext context,
    CustomerSubscriptionResource sub,
    SubscriptionFreeze freeze,
  ) async {
    final messenger = ScaffoldMessenger.maybeOf(context);
    final repo = context.read<SubscriptionsRepository>();
    final cubit = context.read<SubscriptionsCubit>();
    final result = await repo.cancelFreeze(sub.id, freeze.id);
    if (!context.mounted) return;
    result.when(
      success: (_, __) {
        cubit.load();
      },
      failure: (e) {
        messenger?.showSnackBar(
          SnackBar(content: Text(e.message ?? context.l10n.loginErrorGeneric)),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final safe = MediaQuery.paddingOf(context);

    return BlocBuilder<SubscriptionsCubit, SubscriptionsState>(
      builder: (context, state) {
        if (state.status == SubscriptionsLoadStatus.loading &&
            state.subscriptions.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state.status == SubscriptionsLoadStatus.failure &&
            state.subscriptions.isEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
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

        if (state.subscriptions.isEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: AppText(
                context.l10n.noSubscriptionsYet,
                textAlign: TextAlign.center,
                style: (context) => AppTextStyles.bodyLightText(context),
              ),
            ),
          );
        }

        final sorted = _sorted(state.subscriptions);
        final primaryId = state.primarySubscription?.id;

        return RefreshIndicator(
          onRefresh: () => context.read<SubscriptionsCubit>().load(),
          child: ListView.separated(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: EdgeInsets.fromLTRB(
              safe.left + AppSpacing.lg,
              AppSpacing.lg,
              safe.right + AppSpacing.lg,
              AppSpacing.xl + safe.bottom,
            ),
            itemCount: sorted.length,
            separatorBuilder: (_, __) => SizedBox(height: AppSpacing.md),
            itemBuilder: (context, index) {
              final s = sorted[index];
              final timeline = _timeline(s);
              final isPrimary = primaryId != null && primaryId == s.id;
              return _SubscriptionHistoryCard(
                subscription: s,
                timeline: timeline,
                isPrimaryOnOtherTab: isPrimary,
                isDark: isDark,
                planTitle: _planTitle(s, context),
                entitlementLine: _entitlementLine(s),
                priceLine: _priceLine(s),
                sessionsLine: _sessionsLine(s),
                periodLine: _periodLine(context, s),
                freezeSummary: (f) => _freezeSummary(context, f),
                canCancelFreeze: _canCancelFreeze,
                onCancelFreeze: (freeze) => _cancelFreeze(context, s, freeze),
                showPause: _canPause(s),
                onPause: () {
                  Navigator.push<bool>(
                    context,
                    MaterialPageRoute<bool>(
                      builder: (context) => PauseSubscriptionView(
                        subscriptionId: s.id,
                        planStartsAt: s.startsAt ?? DateTime.now(),
                        planExpiresAt: s.expiresAt,
                        maxFreezeDays:
                            s.maxFreezeDays ?? s.product?.maxFreezeDays ?? 30,
                      ),
                    ),
                  ).then((refreshed) {
                    if (refreshed == true && context.mounted) {
                      context.read<SubscriptionsCubit>().load();
                    }
                  });
                },
              );
            },
          ),
        );
      },
    );
  }
}

enum _PlanTimeline { active, upcoming, ended, inactive }

class _SubscriptionHistoryCard extends StatelessWidget {
  const _SubscriptionHistoryCard({
    required this.subscription,
    required this.timeline,
    required this.isPrimaryOnOtherTab,
    required this.isDark,
    required this.planTitle,
    required this.entitlementLine,
    required this.priceLine,
    required this.sessionsLine,
    required this.periodLine,
    required this.freezeSummary,
    required this.canCancelFreeze,
    required this.onCancelFreeze,
    required this.showPause,
    required this.onPause,
  });

  final CustomerSubscriptionResource subscription;
  final _PlanTimeline timeline;
  final bool isPrimaryOnOtherTab;
  final bool isDark;
  final String planTitle;
  final String entitlementLine;
  final String priceLine;
  final String sessionsLine;
  final String periodLine;
  final String Function(SubscriptionFreeze f) freezeSummary;
  final bool Function(SubscriptionFreeze f) canCancelFreeze;
  final void Function(SubscriptionFreeze freeze) onCancelFreeze;
  final bool showPause;
  final VoidCallback onPause;

  Color _toneBackground(BuildContext context) {
    switch (timeline) {
      case _PlanTimeline.active:
        return AppColors.successColor.withValues(alpha: isDark ? 0.22 : 0.14);
      case _PlanTimeline.upcoming:
        return AppColors.warningColor.withValues(alpha: isDark ? 0.2 : 0.12);
      case _PlanTimeline.ended:
        return isDark
            ? AppColors.greyText.withValues(alpha: 0.25)
            : AppColors.seekBarLight;
      case _PlanTimeline.inactive:
        return isDark
            ? AppColors.greyText.withValues(alpha: 0.2)
            : AppColors.containerGreyBg;
    }
  }

  Color _toneForeground(BuildContext context) {
    switch (timeline) {
      case _PlanTimeline.active:
        return isDark ? AppColors.lightText : Colors.white;
      case _PlanTimeline.upcoming:
        return AppColors.darkText;
      case _PlanTimeline.ended:
      case _PlanTimeline.inactive:
        return isDark ? AppColors.darkGreyText : AppColors.lightGrey;
    }
  }

  String _timelineLabel(BuildContext context) {
    switch (timeline) {
      case _PlanTimeline.active:
        return context.l10n.active;
      case _PlanTimeline.upcoming:
        return context.l10n.upcoming;
      case _PlanTimeline.ended:
        return context.l10n.subscriptionEnded;
      case _PlanTimeline.inactive:
        if (subscription.status.isNotEmpty) return subscription.status;
        return context.l10n.cancelled;
    }
  }

  @override
  Widget build(BuildContext context) {
    final borderColor = isDark ? AppColors.greyText : AppColors.buttonBorder;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: isDark ? AppColors.homeBackground : Colors.white,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: borderColor, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.sm,
            alignment: WrapAlignment.start,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: AppSpacing.sm,
                  vertical: 3,
                ),
                decoration: BoxDecoration(
                  color: _toneBackground(context),
                  borderRadius: BorderRadius.circular(AppRadius.base),
                ),
                child: AppText(
                  _timelineLabel(context),
                  style: (ctx) => AppTextStyles.bodyTextSmall(ctx).copyWith(
                    color: _toneForeground(context),
                    fontWeight: FontWeight.w600,
                    fontSize: 11,
                    height: 1.2,
                  ),
                ),
              ),
              if (isPrimaryOnOtherTab)
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: AppSpacing.sm,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(AppRadius.base),
                  ),
                  child: AppText(
                    context.l10n.currentPlan,
                    style: (ctx) => AppTextStyles.bodyTextSmall(ctx).copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w600,
                      fontSize: 11,
                      height: 1.2,
                    ),
                  ),
                ),
              if (subscription.isTransferable)
                SizedBox(
                  width: double.infinity,
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: AppSpacing.sm,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(color: borderColor),
                      borderRadius: BorderRadius.circular(AppRadius.base),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 1),
                          child: Icon(
                            Icons.swap_horiz_rounded,
                            size: 14,
                            color: isDark
                                ? AppColors.darkGreyText
                                : AppColors.lightGrey,
                          ),
                        ),
                        SizedBox(width: AppSpacing.xi),
                        Expanded(
                          child: AppText(
                            context.l10n.subscriptionTransferable,
                            style: (ctx) =>
                                AppTextStyles.bodyTextSmall(ctx).copyWith(
                                  fontSize: 11,
                                  height: 1.25,
                                  color: isDark
                                      ? AppColors.darkGreyText
                                      : AppColors.lightGrey,
                                ),
                            maxLines: 3,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
          SizedBox(height: AppSpacing.base),
          AppText(
            planTitle,
            style: (ctx) => AppTextStyles.experienceButton(ctx).copyWith(
              color: isDark ? AppColors.lightText : AppColors.darkText,
            ),
            maxLines: 4,
          ),
          if (entitlementLine.isNotEmpty) ...[
            SizedBox(height: AppSpacing.sm),
            AppText(
              entitlementLine,
              style: (ctx) => AppTextStyles.bodyTextSmall(
                ctx,
              ).copyWith(color: AppColors.lightGrey),
              maxLines: 3,
            ),
          ],
          SizedBox(height: AppSpacing.md),
          Divider(height: 1, color: borderColor),
          SizedBox(height: AppSpacing.md),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppText(
                      context.l10n.totalPaid,
                      style: (ctx) => AppTextStyles.bodyTextSmall(
                        ctx,
                      ).copyWith(color: AppColors.lightGrey),
                    ),
                    SizedBox(height: AppSpacing.xi),
                    AppText(
                      priceLine,
                      style: (ctx) => AppTextStyles.bodyText(ctx).copyWith(
                        fontWeight: FontWeight.w600,
                        color: isDark
                            ? AppColors.lightText
                            : AppColors.darkText,
                      ),
                      maxLines: 2,
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppText(
                      context.l10n.classesUsed,
                      style: (ctx) => AppTextStyles.bodyTextSmall(
                        ctx,
                      ).copyWith(color: AppColors.lightGrey),
                    ),
                    SizedBox(height: AppSpacing.xi),
                    AppText(
                      sessionsLine,
                      style: (ctx) => AppTextStyles.bodyText(ctx).copyWith(
                        fontWeight: FontWeight.w600,
                        color: isDark
                            ? AppColors.lightText
                            : AppColors.darkText,
                      ),
                      maxLines: 3,
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: AppSpacing.md),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                Icons.calendar_today_outlined,
                size: 16,
                color: AppColors.lightGrey,
              ),
              SizedBox(width: AppSpacing.sm),
              Expanded(
                child: AppText(
                  periodLine,
                  style: (ctx) => AppTextStyles.bodyTextSmall(
                    ctx,
                  ).copyWith(color: AppColors.lightGrey, height: 1.35),
                  maxLines: 4,
                ),
              ),
            ],
          ),
          if (subscription.freezes.isNotEmpty) ...[
            SizedBox(height: AppSpacing.md),
            Divider(height: 1, color: borderColor),
            SizedBox(height: AppSpacing.sm),
            AppText(
              context.l10n.pauseHistory,
              style: (ctx) => AppTextStyles.bodyText(ctx).copyWith(
                fontWeight: FontWeight.w600,
                fontSize: 13,
                color: isDark ? AppColors.lightText : AppColors.darkText,
              ),
            ),
            SizedBox(height: AppSpacing.sm),
            ...subscription.freezes.map((f) {
              final cancelable = canCancelFreeze(f);
              return Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final narrow = constraints.maxWidth < 340;
                    final summary = Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AppText(
                          freezeSummary(f),
                          style: (ctx) =>
                              AppTextStyles.bodyTextSmall(ctx).copyWith(
                                color: isDark
                                    ? AppColors.darkGreyText
                                    : AppColors.lightGrey,
                                height: 1.35,
                              ),
                          maxLines: 5,
                        ),
                        if (f.status.isNotEmpty)
                          AppText(
                            f.status,
                            style: (ctx) =>
                                AppTextStyles.bodyTextSmall(ctx).copyWith(
                                  fontSize: 11,
                                  color: AppColors.lightGrey,
                                ),
                            maxLines: 2,
                          ),
                      ],
                    );
                    final cancelBtn = TextButton(
                      onPressed: () => onCancelFreeze(f),
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.symmetric(
                          horizontal: AppSpacing.sm,
                          vertical: AppSpacing.xi,
                        ),
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        foregroundColor: AppColors.redLight,
                      ),
                      child: Text(context.l10n.cancel),
                    );
                    if (!cancelable) return summary;
                    if (narrow) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          summary,
                          SizedBox(height: AppSpacing.xi),
                          Align(
                            alignment: AlignmentDirectional.centerEnd,
                            child: cancelBtn,
                          ),
                        ],
                      );
                    }
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(child: summary),
                        SizedBox(width: AppSpacing.sm),
                        cancelBtn,
                      ],
                    );
                  },
                ),
              );
            }),
          ],
          if (showPause) ...[
            SizedBox(height: AppSpacing.md),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: onPause,
                style: OutlinedButton.styleFrom(
                  foregroundColor: isDark
                      ? AppColors.lightText
                      : AppColors.darkText,
                  side: BorderSide(color: borderColor),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppRadius.md),
                  ),
                  padding: EdgeInsets.symmetric(vertical: AppSpacing.sm),
                ),
                child: Text(context.l10n.pauseSubscription),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
