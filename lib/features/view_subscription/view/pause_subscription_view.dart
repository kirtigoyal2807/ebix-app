import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:pilates_app/config/theme/app_colors.dart';
import 'package:pilates_app/config/theme/app_spacing.dart';
import 'package:pilates_app/config/theme/app_text_styles.dart';
import 'package:pilates_app/features/invoice_history/data/subscriptions_repository.dart';
import 'package:pilates_app/widgets/app_app_bar.dart';
import 'package:pilates_app/widgets/app_text.dart';

import '../../../config/theme/app_radius.dart';
import '../../../core/localization/localization_extension.dart';
import '../../../widgets/app_button.dart';
import '../cubit/pause_subscription_cubit.dart';
import '../cubit/pause_subscription_state.dart';

/// Freeze flow — requires the subscription row `id` from the subscriptions API.
class PauseSubscriptionView extends StatelessWidget {
  const PauseSubscriptionView({
    super.key,
    required this.subscriptionId,
    required this.planStartsAt,
    this.planExpiresAt,
    required this.maxFreezeDays,
  });

  final String subscriptionId;

  /// Subscription/plan start (UTC or local from API); used to bound pause dates.
  final DateTime planStartsAt;

  /// Optional plan end; pause window cannot extend past this day.
  final DateTime? planExpiresAt;

  /// Max inclusive calendar days for one pause (from subscription or product).
  final int maxFreezeDays;

  static DateTime _dateOnly(DateTime d) {
    final l = d.toLocal();
    return DateTime(l.year, l.month, l.day);
  }

  static DateTime _clampDay(DateTime day, DateTime min, DateTime max) {
    if (day.isBefore(min)) return min;
    if (day.isAfter(max)) return max;
    return day;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final locale = Localizations.localeOf(context).toLanguageTag();
    final effectiveMaxFreezeDays = maxFreezeDays < 1 ? 1 : maxFreezeDays;

    return Scaffold(
      appBar: AppAppBar(
        title: context.l10n.pauseSubscription,
        isMoreMenu: false,
        leading: Padding(
          padding: EdgeInsets.only(left: 12.0),
          child: IconButton(
            icon: const Icon(Icons.arrow_back_ios_rounded, size: 20),
            onPressed: Navigator.of(context).pop,
          ),
        ),
      ),
      body: BlocProvider(
        create: (context) => PauseSubscriptionCubit(
          subscriptionId: subscriptionId,
          repository: context.read<SubscriptionsRepository>(),
          planStartDateLocal: _dateOnly(planStartsAt),
          planExpiresAtLocal: planExpiresAt != null
              ? _dateOnly(planExpiresAt!)
              : null,
          maxFreezeDays: effectiveMaxFreezeDays,
        ),
        child: BlocBuilder<PauseSubscriptionCubit, PauseSubscriptionState>(
          builder: (context, state) {
            final cubit = context.read<PauseSubscriptionCubit>();
            final days = PauseSubscriptionCubit.inclusivePauseDays(
              state.startDate,
              state.endDate,
            );
            final stickyFooterHeight =
                AppSpacing.md + AppSpacing.buttonHeight;

            return Stack(
              fit: StackFit.expand,
              children: [
                SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: AppSpacing.md,
                      horizontal: AppSpacing.lg,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                    AppText(
                      context.l10n.pauseDescription,
                      style: (context) => AppTextStyles.bodyText(
                        context,
                      ).copyWith(color: AppColors.lightGrey),
                    ),
                    SizedBox(height: AppSpacing.lg),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: AppSpacing.md,
                        vertical: AppSpacing.md,
                      ),
                      decoration: BoxDecoration(
                        color: isDark
                            ? AppColors.redLight.withValues(alpha: 0.21)
                            : AppColors.cardLightBackground,
                        borderRadius: BorderRadius.circular(AppRadius.base),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.warning_amber,
                                color: AppColors.redLight,
                                size: 20,
                              ),
                              SizedBox(width: AppSpacing.sm),
                              AppText(
                                context.l10n.cannotPauseTitle,
                                style: (context) =>
                                    AppTextStyles.textField(context).copyWith(
                                      fontWeight: FontWeight.w500,
                                      height: 1,
                                      color: isDark
                                          ? AppColors.redLight
                                          : AppColors.darkText,
                                    ),
                              ),
                            ],
                          ),
                          SizedBox(height: AppSpacing.sm),
                          AppText(
                            context.l10n.cannotPauseMessage,
                            style: (context) =>
                                AppTextStyles.bodyText(context).copyWith(
                                  color: isDark
                                      ? AppColors.darkGreyText
                                      : AppColors.lightGrey,
                                  height: 1.5,
                                ),
                            maxLines: 3,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: AppSpacing.lg),
                    AppText(
                      context.l10n.selectPausePeriod,
                      style: (context) =>
                          AppTextStyles.gelasioRegular(context).copyWith(),
                    ),
                    SizedBox(height: AppSpacing.xi),
                    AppText(
                      context.l10n.pauseMaxFreezeDaysHint(
                        effectiveMaxFreezeDays,
                      ),
                      style: (context) =>
                          AppTextStyles.bodyText(context).copyWith(
                            fontSize: 12,
                            color: AppColors.lightGrey,
                            height: 1.35,
                          ),
                    ),
                    SizedBox(height: AppSpacing.base),
                    AppText(
                      context.l10n.startDate,
                      style: (context) => AppTextStyles.helpAndSupportItemLabel(
                        context,
                      ).copyWith(height: 1.55),
                    ),
                    SizedBox(height: AppSpacing.xi),
                    _buildDateRow(
                      context: context,
                      cubit: cubit,
                      state: state,
                      isDark: isDark,
                      locale: locale,
                      isStart: true,
                    ),
                    SizedBox(height: AppSpacing.base),
                    AppText(
                      context.l10n.endDate,
                      style: (context) => AppTextStyles.helpAndSupportItemLabel(
                        context,
                      ).copyWith(height: 1.55),
                    ),
                    SizedBox(height: AppSpacing.xi),
                    _buildDateRow(
                      context: context,
                      cubit: cubit,
                      state: state,
                      isDark: isDark,
                      locale: locale,
                      isStart: false,
                    ),
                    SizedBox(height: AppSpacing.base),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: AppSpacing.lmd,
                        vertical: 22.5,
                      ),
                      decoration: BoxDecoration(
                        color: isDark
                            ? AppColors.trainerBlackBackgroundColor
                            : AppColors.seekBarLight,
                        borderRadius: BorderRadius.circular(AppRadius.md),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          AppText(
                            context.l10n.duration,
                            style: (context) =>
                                AppTextStyles.bodyText(context).copyWith(
                                  color: isDark
                                      ? AppColors.lightGreyText
                                      : AppColors.greyText,
                                ),
                          ),
                          AppText(
                            context.l10n.daysCount(days),
                            style: (context) =>
                                AppTextStyles.bodyText(context).copyWith(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 18,
                                  color: isDark
                                      ? AppColors.lightText
                                      : AppColors.darkText,
                                  height: 1,
                                ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: AppSpacing.lg),
                    AppText(
                      context.l10n.yourPlan,
                      style: (context) => AppTextStyles.gelasioRegular(context),
                    ),
                    SizedBox(height: AppSpacing.base),
                    Container(
                      padding: EdgeInsets.all(AppSpacing.md),
                      decoration: BoxDecoration(
                        color: isDark
                            ? AppColors.primaryDarkButton
                            : AppColors.containerGreyBg,
                        border: Border.all(
                          color: isDark
                              ? AppColors.greyText
                              : AppColors.buttonBorder,
                        ),
                        borderRadius: BorderRadius.circular(AppRadius.md),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.done,
                                size: 16,
                                color: isDark
                                    ? AppColors.languageIconDark
                                    : AppColors.languageIcon,
                              ),
                              SizedBox(width: AppSpacing.xs),
                              AppText(
                                context.l10n.pauseAttemptsPerYear,
                                style: (context) =>
                                    AppTextStyles.bodyText(context).copyWith(
                                      fontSize: 12,
                                      color: isDark
                                          ? AppColors.darkGreyText
                                          : AppColors.lightGrey,
                                      height: 1.2,
                                    ),
                              ),
                            ],
                          ),
                          SizedBox(height: AppSpacing.md),
                          Divider(
                            color: isDark
                                ? AppColors.greyText
                                : AppColors.buttonBorder,
                            height: 1,
                          ),
                          SizedBox(height: AppSpacing.md),
                          AppText(
                            context.l10n.remainingThisYear,
                            style: (context) =>
                                AppTextStyles.bodyText(context).copyWith(
                                  fontSize: 12,
                                  color: AppColors.lightGrey,
                                  height: 1.2,
                                ),
                          ),
                          SizedBox(height: AppSpacing.sm),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              AppText(
                                context.l10n.pauseAttempts,
                                style: (context) =>
                                    AppTextStyles.bodyText(context).copyWith(
                                      color: isDark
                                          ? AppColors.darkGreyText
                                          : AppColors.lightGrey,
                                      height: 1,
                                    ),
                              ),
                              AppText(
                                context.l10n.attemptRemaining(1),
                                style: (context) =>
                                    AppTextStyles.textFieldHeading(context),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: AppSpacing.lg),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: AppSpacing.md,
                        vertical: AppSpacing.md,
                      ),
                      decoration: BoxDecoration(
                        color: isDark
                            ? AppColors.warningColor.withValues(alpha: 0.11)
                            : AppColors.upgradeLightBackgroundColor,
                        borderRadius: BorderRadius.circular(AppRadius.base),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AppText(
                            context.l10n.duringPausePeriod,
                            style: (context) =>
                                AppTextStyles.textFieldHeading(
                                  context,
                                ).copyWith(
                                  fontSize: 12,
                                  height: 1.2,
                                  color: isDark
                                      ? AppColors.upgradeDarkLockBackgroundColor
                                      : AppColors.darkText,
                                ),
                          ),
                          SizedBox(height: AppSpacing.sm),
                          _buildRow(
                            label: context.l10n.noBillingCharges,
                            isDark: isDark,
                          ),
                          _buildRow(
                            label: context.l10n.noBookingAllowed,
                            isDark: isDark,
                          ),
                          _buildRow(
                            label: context.l10n.subscriptionExtended,
                            isDark: isDark,
                          ),
                          _buildRow(
                            label: context.l10n.nextBillingDate(
                              'Feb 22, 2026',
                              7,
                            ),
                            isDark: isDark,
                          ),
                          _buildRow(
                            label: context.l10n.creditsPreserved,
                            isDark: isDark,
                          ),
                        ],
                      ),
                    ),
                    if (state.submitError != null) ...[
                      AppText(
                        state.submitError!,
                        style: (context) => AppTextStyles.bodyText(
                          context,
                        ).copyWith(color: AppColors.redLight),
                      ),
                      SizedBox(height: AppSpacing.md),
                    ],
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
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                    child: AppButton(
                      label: context.l10n.confirmPause,
                      isLoading: state.isSubmitting,
                      onPressed: () async {
                        final ok = await context
                            .read<PauseSubscriptionCubit>()
                            .confirmFreeze(context.l10n);
                        if (!context.mounted) return;
                        if (ok) Navigator.of(context).pop(true);
                      },
                      variant: AppButtonVariant.primary,
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildDateRow({
    required BuildContext context,
    required PauseSubscriptionCubit cubit,
    required PauseSubscriptionState state,
    required bool isDark,
    required String locale,
    required bool isStart,
  }) {
    final firstStart = cubit.earliestPauseStart;
    final lastStart = cubit.latestPauseStart;

    if (isStart) {
      final selected = state.startDate;
      final initial = _clampDay(selected ?? firstStart, firstStart, lastStart);
      return GestureDetector(
        onTap: () async {
          final picked = await showDatePicker(
            context: context,
            initialDate: initial,
            firstDate: firstStart,
            lastDate: lastStart,
          );
          if (picked != null) {
            cubit.setStartDate(picked);
          }
        },
        child: _dateFieldShell(
          isDark: isDark,
          child: AppText(
            selected != null
                ? DateFormat.yMMMd(locale).format(selected)
                : context.l10n.tapToSelectDate,
            style: (context) => AppTextStyles.textField(context).copyWith(
              color: selected != null
                  ? (isDark ? AppColors.lightText : AppColors.darkText)
                  : AppColors.lightGrey,
            ),
          ),
        ),
      );
    }

    final start = state.startDate;
    final enabled = start != null;

    return Opacity(
      opacity: enabled ? 1 : 0.45,
      child: GestureDetector(
        onTap: () async {
          if (!enabled) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(context.l10n.pauseSelectStartFirst)),
            );
            return;
          }
          final s = start;
          final lastEnd = cubit.latestPauseEndFor(s);
          final picked = await showDatePicker(
            context: context,
            initialDate: _clampDay(state.endDate ?? s, s, lastEnd),
            firstDate: s,
            lastDate: lastEnd,
          );
          if (picked != null) {
            cubit.setEndDate(picked);
          }
        },
        child: _dateFieldShell(
          isDark: isDark,
          child: AppText(
            !enabled
                ? context.l10n.tapToSelectDate
                : (state.endDate != null
                      ? DateFormat.yMMMd(locale).format(state.endDate!)
                      : context.l10n.tapToSelectDate),
            style: (context) => AppTextStyles.textField(context).copyWith(
              color: !enabled
                  ? AppColors.lightGrey
                  : (state.endDate != null
                        ? (isDark ? AppColors.lightText : AppColors.darkText)
                        : AppColors.lightGrey),
            ),
          ),
        ),
      ),
    );
  }

  Widget _dateFieldShell({required bool isDark, required Widget child}) {
    return Container(
      height: 48,
      padding: EdgeInsets.symmetric(horizontal: AppSpacing.base),
      decoration: BoxDecoration(
        color: isDark ? AppColors.homeBackground : Colors.white,
        border: Border.all(
          color: isDark ? AppColors.greyText : AppColors.buttonBorder,
        ),
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(child: child),
          Icon(
            Icons.calendar_today_outlined,
            color: AppColors.darkGreyText,
            size: 20,
          ),
        ],
      ),
    );
  }

  Widget _buildRow({required String label, required bool isDark}) {
    return Padding(
      padding: EdgeInsets.only(bottom: AppSpacing.sm),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppText(
            '• ',
            style: (context) => AppTextStyles.bodyText(context).copyWith(
              fontSize: 12,
              color: isDark ? AppColors.darkGreyText : AppColors.lightGrey,
              height: 1.2,
            ),
          ),
          Expanded(
            child: AppText(
              label,
              style: (context) => AppTextStyles.bodyText(context).copyWith(
                fontSize: 12,
                color: isDark ? AppColors.darkGreyText : AppColors.lightGrey,
                height: 1.2,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
