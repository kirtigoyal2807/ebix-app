import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:pilates_app/config/theme/app_colors.dart';
import 'package:pilates_app/config/theme/app_radius.dart';
import 'package:pilates_app/config/theme/app_spacing.dart';
import 'package:pilates_app/config/theme/app_text_styles.dart';
import 'package:pilates_app/features/invoice_history/data/models/customer_subscription_resource.dart';
import 'package:pilates_app/features/view_subscription/cubit/subscriptions_cubit.dart';
import 'package:pilates_app/features/view_subscription/cubit/subscriptions_state.dart';
import 'package:pilates_app/features/view_subscription/view/pause_subscription_view.dart';
import 'package:pilates_app/widgets/app_text.dart';

import '../../../core/localization/localization_extension.dart';
import '../../../widgets/app_button.dart';
import '../../../widgets/app_shadow.dart';
import '../../../widgets/dotted_underline.dart';

/// Current plan tab — primary subscription from §9.3 list.
class CurrentPlanView extends StatelessWidget {
  const CurrentPlanView({super.key});

  String _planTitle(CustomerSubscriptionResource p, BuildContext context) {
    final n = p.product?.name?.trim();
    if (n != null && n.isNotEmpty) return n;
    final t = p.entitlementType.trim();
    if (t.isNotEmpty) return t.replaceAll('_', ' ');
    return context.l10n.subscriptionTitle;
  }

  String _priceLine(CustomerSubscriptionResource p) {
    if (p.pricePaid <= 0) return '—';
    return '${p.pricePaid.toStringAsFixed(2)} SAR';
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

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
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
                    onPressed: () =>
                        context.read<SubscriptionsCubit>().load(),
                    child: AppText(
                      context.l10n.retry,
                      style: (context) => AppTextStyles.body(context).copyWith(
                            color: AppColors.languageIcon,
                          ),
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
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: AppText(
                context.l10n.noSubscriptionsYet,
                textAlign: TextAlign.center,
                style: (context) => AppTextStyles.bodyLightText(context),
              ),
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: () => context.read<SubscriptionsCubit>().load(),
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
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
                        SizedBox(height: AppSpacing.md),
                        AppText(
                          context.l10n.pricePerMonth,
                          style: (context) =>
                              AppTextStyles.bodyText(
                                context,
                                fontWeight: FontWeight.w500,
                              ).copyWith(
                                color: AppColors.seekBarLight,
                                fontSize: 18,
                                height: 0,
                              ),
                        ),
                        SizedBox(height: AppSpacing.xs),
                        AppText(
                          _priceLine(primary),
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
                        color: isDark ? AppColors.greyText : AppColors.buttonBorder,
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Theme(
                      data: Theme.of(context).copyWith(
                        dividerColor: Colors.transparent,
                      ),
                      child: ExpansionTile(
                        iconColor:
                            isDark ? AppColors.lightGrey : AppColors.darkText,
                        tilePadding:
                            const EdgeInsets.symmetric(horizontal: 16),
                        childrenPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        title: AppText(
                          context.l10n.planDetails,
                          style: (context) =>
                              AppTextStyles.gelasioRegular(context),
                        ),
                        children: [
                          _buildCheckRow(
                            label: context.l10n.featureClasses,
                            isDark: isDark,
                          ),
                          _buildCheckRow(
                            label: context.l10n.featureStudios,
                            isDark: isDark,
                          ),
                          _buildCheckRow(
                            label: context.l10n.featureEquipment,
                            isDark: isDark,
                          ),
                          _buildCheckRow(
                            label: context.l10n.featurePriority,
                            isDark: isDark,
                          ),
                          _buildCheckRow(
                            label: context.l10n.featurePause,
                            isDark: isDark,
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
                          color:
                              isDark ? AppColors.greyText : AppColors.buttonBorder,
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Theme(
                        data: Theme.of(context).copyWith(
                          dividerColor: Colors.transparent,
                        ),
                        child: ExpansionTile(
                          tilePadding:
                              const EdgeInsets.symmetric(horizontal: 16),
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
                                            AppTextStyles.bodyText(context)
                                                .copyWith(
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
                  SizedBox(height: AppSpacing.lg),
                  AppButton(
                    label: context.l10n.changePlan,
                    onPressed: () {},
                    variant: AppButtonVariant.primary,
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Container(
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.homeBackground : Colors.white,
                      borderRadius: BorderRadius.circular(AppRadius.xl),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.shadowColor.withValues(alpha: 0.06),
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
                            ),
                          ),
                        ).then((refreshed) {
                          if (refreshed != true || !context.mounted) return;
                          context.read<SubscriptionsCubit>().load();
                        });
                      },
                      variant: AppButtonVariant.secondary,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Center(
                    child: GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: (AppSpacing.buttonHeight - 30) / 2,
                        ),
                        child: AppText(
                          context.l10n.cancelSubscription,
                          style: (context) => AppTextStyles.button(
                            context,
                          ).copyWith(color: AppColors.redLight),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
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
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
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
                      color:
                          isDark ? AppColors.darkGreyText : AppColors.lightGrey,
                      height: 1.2,
                    ),
              ),
            ],
          ),
        ),
        AppText(
          content,
          style: (context) =>
              AppTextStyles.bodyText(
                context,
                fontWeight: FontWeight.w500,
              ).copyWith(
                color: contentColor,
              ),
        ),
      ],
    );
  }
}
