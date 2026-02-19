import 'package:flutter/material.dart';
import 'package:pilates_app/config/theme/app_colors.dart';
import 'package:pilates_app/config/theme/app_radius.dart';
import 'package:pilates_app/config/theme/app_spacing.dart';
import 'package:pilates_app/config/theme/app_text_styles.dart';
import 'package:pilates_app/features/view_subscription/view/pause_subscription_view.dart';
import 'package:pilates_app/features/view_subscription/widget/progress_card.dart';
import 'package:pilates_app/widgets/app_text.dart';

import '../../../core/localization/localization_extension.dart';
import '../../../widgets/app_button.dart';
import '../../../widgets/app_shadow.dart';
import '../../../widgets/dotted_underline.dart';

class CurrentPlanView extends StatelessWidget {
  const CurrentPlanView({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return SingleChildScrollView(
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
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
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
                mainAxisAlignment: MainAxisAlignment.start,
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
                      context.l10n.active,
                      style: (context) =>
                          AppTextStyles.bodyText(context).copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                            fontSize: 12,
                          ),
                    ),
                  ),

                  SizedBox(height: AppSpacing.base),
                  AppText(
                    context.l10n.premiumPlan,
                    style: (context) =>
                        AppTextStyles.bodyText(context).copyWith(
                          color: isDark ? AppColors.lightText : Colors.white,
                          fontWeight: FontWeight.w500,
                          fontSize: 24,
                          height: 0,
                        ),
                  ),
                  SizedBox(height: AppSpacing.md),
                  AppText(
                    context.l10n.pricePerMonth,
                    style: (context) =>
                        AppTextStyles.bodyText(context).copyWith(
                          color: AppColors.seekBarLight,
                          fontWeight: FontWeight.w500,
                          fontSize: 18,
                          height: 0,
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
                    subtitle: "Mar 15, 2025",
                    isDark: isDark,
                  ),
                  SizedBox(height: AppSpacing.sm),
                  _buildRow(
                    label: context.l10n.classesUsed,
                    subtitle: "12 / 15",
                    isDark: isDark,
                  ),
                  SizedBox(height: AppSpacing.sm),
                  _buildRow(
                    label: context.l10n.pauseUsed,
                    subtitle: "1 / 3",
                    isDark: isDark,
                  ),
                  // _buildRow(label: context.l10n.featureStudios, isDark: isDark),
                  // _buildRow(
                  //   label: context.l10n.featureEquipment,
                  //   isDark: isDark,
                  // ),
                  // _buildRow(
                  //   label: context.l10n.featurePriority,
                  //   isDark: isDark,
                  // ),
                  // _buildRow(label: context.l10n.featurePause, isDark: isDark),
                  // SizedBox(height: AppSpacing.sm),
                  // ProgressBarCard(),
                ],
              ),
            ),
            SizedBox(height: AppSpacing.lg),

            Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: AppColors.buttonBorder, // your border color
                  width: 1,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Theme(
                data: Theme.of(context).copyWith(
                  dividerColor: Colors.transparent, // removes inside line
                ),
                child: ExpansionTile(
                  tilePadding: const EdgeInsets.symmetric(horizontal: 16),
                  childrenPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),

                  title: AppText(
                    context.l10n.planDetails,
                    style: (context) => AppTextStyles.gelasioRegular(context),
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

            Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: AppColors.buttonBorder, // your border color
                  width: 1,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Theme(
                data: Theme.of(context).copyWith(
                  dividerColor: Colors.transparent, // removes inside line
                ),
                child: ExpansionTile(
                  tilePadding: const EdgeInsets.symmetric(horizontal: 16),
                  childrenPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),

                  title: AppText(
                    context.l10n.pauseHistory,
                    style: (context) => AppTextStyles.gelasioRegular(context),
                  ),

                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        AppText(
                          "Dec 20 - Dec 27, 2025",
                          style: (context) =>
                              AppTextStyles.bodyText(context).copyWith(
                                color: isDark
                                    ? AppColors.darkGreyText
                                    : AppColors.lightGrey,
                                height: 1.2,
                              ),
                        ),
                        AppText(
                          "7 days",
                          style: (context) =>
                              AppTextStyles.bodyText(context).copyWith(
                                color: isDark
                                    ? AppColors.lightText
                                    : AppColors.darkText,
                                fontWeight: FontWeight.w500,
                                // height: 2,
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

            // Container(
            //   padding: EdgeInsets.all(AppSpacing.md),
            //   decoration: BoxDecoration(
            //     color: isDark
            //         ? AppColors.primaryDarkButton
            //         : AppColors.containerGreyBg,
            //     borderRadius: BorderRadius.circular(AppRadius.md),
            //     border: Border.all(
            //       color: isDark ? AppColors.greyText : AppColors.buttonBorder,
            //       width: 1,
            //     ),
            //   ),
            //   child: Column(
            //     children: [
            //       _buildPauseRow(
            //         label: context.l10n.pastPauses,
            //         subtitle: "Dec 20 - Dec 27, 2025",
            //         content: "7 days",
            //         contentColor: isDark
            //             ? AppColors.lightText
            //             : AppColors.darkText,
            //         isDark: isDark,
            //       ),
            //       SizedBox(height: AppSpacing.md),
            //       Divider(
            //         color: isDark ? AppColors.greyText : AppColors.buttonBorder,
            //         height: 1,
            //       ),
            //       SizedBox(height: AppSpacing.md),
            //       _buildPauseRow(
            //         label: context.l10n.remainingThisYear,
            //         subtitle: context.l10n.pauseAttemptsRemaining,
            //         content: context.l10n.attemptCount,
            //         contentColor: isDark
            //             ? AppColors.successBorderDark
            //             : AppColors.successColor,
            //         isDark: isDark,
            //       ),
            //     ],
            //   ),
            // ),
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
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PauseSubscriptionView(),
                    ),
                  );
                },
                variant: AppButtonVariant.secondary,
              ),
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
          ],
        ),
      ),
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
            color: isDark ? AppColors.lightText : AppColors.languageIcon,
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
          style: (context) => AppTextStyles.bodyText(context).copyWith(
            color: contentColor,
            fontWeight: FontWeight.w500,
            // height: 2,
          ),
        ),
      ],
    );
  }
}
