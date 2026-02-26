import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pilates_app/config/theme/app_colors.dart';
import 'package:pilates_app/config/theme/app_spacing.dart';
import 'package:pilates_app/config/theme/app_text_styles.dart';
import 'package:pilates_app/widgets/app_text.dart';

import '../../../config/theme/app_radius.dart';
import '../../../core/localization/localization_extension.dart';
import '../../../widgets/app_button.dart';

class BranchNotInPlanSheet extends StatelessWidget {
  const BranchNotInPlanSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 45, 24, 21),
      decoration: BoxDecoration(
        color: isDark ? AppColors.homeBackground : Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          isDark
              ? SvgPicture.asset("assets/images/svg/ic_warning_dark.svg")
              : SvgPicture.asset("assets/images/svg/ic_warning.svg"),

          const SizedBox(height: AppSpacing.lmd),
          AppText(
            context.l10n.branchNotInPlanTitle,
            textAlign: TextAlign.center,
            style: (context) => AppTextStyles.gelasioMedium(context),
          ),

          const SizedBox(height: AppSpacing.xs),

          AppText(
            context.l10n.branchNotInPlanDescription,
            textAlign: TextAlign.center,
            style: (context) =>
                AppTextStyles.bodyText(context).copyWith(height: 1.55),
            maxLines: 3,
          ),

          const SizedBox(height: AppSpacing.lg),

          // Plan card
          Container(
            padding: EdgeInsets.all(AppSpacing.lmd),
            decoration: BoxDecoration(
              color: isDark
                  ? AppColors.primaryDarkButton
                  : AppColors.seekBarLight,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                _PlanRow(
                  label: "${context.l10n.yourPlan}:",
                  value: context.l10n.premiumPlan,
                ),
                SizedBox(height: AppSpacing.sm),
                _PlanRow(
                  label: context.l10n.neededPlan,
                  value: context.l10n.elitePlan,
                ),
              ],
            ),
          ),

          const SizedBox(height: AppSpacing.lg),

          AppButton(
            label: context.l10n.upgradeToElite,
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
              label: context.l10n.paySingleClass,
              onPressed: () {},
              variant: AppButtonVariant.secondary,
            ),
          ),

          const SizedBox(height: AppSpacing.sm),

          // Cancel
          GestureDetector(
            onTap: () => Navigator.pop(context),

            child: Padding(
              padding: EdgeInsets.symmetric(
                vertical: (AppSpacing.buttonHeight - 30) / 2,
              ),
              child: AppText(
                context.l10n.cancel,
                style: (context) => AppTextStyles.button(
                  context,
                ).copyWith(color: AppColors.lightGrey),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PlanRow extends StatelessWidget {
  final String label;
  final String value;

  const _PlanRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText(
          label,
          style: (context) => AppTextStyles.bodyText(
            context,
          ).copyWith(fontWeight: FontWeight.w600),
        ),
        const SizedBox(width: 6),
        Expanded(
          child: AppText(
            value,
            style: (context) => AppTextStyles.bodyText(context),
          ),
        ),
      ],
    );
  }
}
