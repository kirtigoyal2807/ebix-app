import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:pilates_app/config/theme/app_colors.dart';
import 'package:pilates_app/config/theme/app_spacing.dart';
import 'package:pilates_app/config/theme/app_text_styles.dart';
import 'package:pilates_app/widgets/app_app_bar.dart';
import 'package:pilates_app/widgets/app_text.dart';

import '../../../config/theme/app_radius.dart';
import '../../../core/localization/localization_extension.dart';
import '../../../widgets/app_button.dart';
import '../cubit/pause_subscription_cubit.dart';
import '../cubit/pause_subscription_state.dart';

class PauseSubscriptionView extends StatelessWidget {
  const PauseSubscriptionView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: AppAppBar(
        title: context.l10n.pauseSubscription,
        isMoreMenu: false,
        leading: Padding(
          padding: const EdgeInsets.only(left: 12.0),
          child: IconButton(
            icon: const Icon(Icons.arrow_back_ios_rounded, size: 20),
            onPressed: Navigator.of(context).pop,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: AppSpacing.md,
            horizontal: AppSpacing.lg,
          ),
          child: BlocProvider(
            create: (context) => PauseSubscriptionCubit(),
            child: BlocBuilder<PauseSubscriptionCubit, PauseSubscriptionState>(
              builder: (context, state) {
                return Column(
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
                    SizedBox(height: AppSpacing.base),
                    AppText(
                      context.l10n.startDate,
                      style: (context) => AppTextStyles.helpAndSupportItemLabel(
                        context,
                      ).copyWith(height: 1.55),
                    ),
                    SizedBox(height: AppSpacing.xi),
                    buildDateRow(
                      context,
                      state.startDate ?? DateTime.now(),
                      true,
                    ),
                    SizedBox(height: AppSpacing.base),
                    AppText(
                      context.l10n.endDate,
                      style: (context) => AppTextStyles.helpAndSupportItemLabel(
                        context,
                      ).copyWith(height: 1.55),
                    ),
                    SizedBox(height: AppSpacing.xi),
                    buildDateRow(
                      context,
                      state.endDate ?? DateTime.now(),
                      false,
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
                            context.l10n.daysCount(8),
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
                              "Feb 22, 2026",
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

                    SizedBox(height: AppSpacing.lg),
                    AppButton(
                      label: context.l10n.confirmPause,
                      onPressed: () {},
                      variant: AppButtonVariant.primary,
                    ),

                    const SizedBox(height: AppSpacing.sm),

                    // Cancel
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
                    const SizedBox(height: AppSpacing.xl),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget buildDateRow(BuildContext context, DateTime date, bool isStart) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return GestureDetector(
      onTap: () async {
        final DateTime? picked = await showDatePicker(
          context: context,
          initialDate: date,
          firstDate: DateTime(2000),
          lastDate: DateTime(2100),
        );

        if (picked != null) {
          date = picked;
          if (isStart) {
            context.read<PauseSubscriptionCubit>().setStartDate(date);
          } else {
            context.read<PauseSubscriptionCubit>().setEndDate(date);
          }

          // context.read<PauseSubscriptionCubit>().emit(state.copyWith>()
          // use selected date
        }
      },
      child: Container(
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
            AppText(
              DateFormat("dd-MM-yyyy").format(date),
              style: (context) => AppTextStyles.textField(
                context,
              ).copyWith(color: AppColors.lightGrey),
            ),
            Icon(
              Icons.calendar_today_outlined,
              color: AppColors.darkGreyText,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRow({required String label, required bool isDark}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppText(
            "• ",
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
