import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pilates_app/config/theme/app_colors.dart';
import 'package:pilates_app/config/theme/app_radius.dart';
import 'package:pilates_app/config/theme/app_spacing.dart';
import 'package:pilates_app/core/network/api_result.dart';
import 'package:pilates_app/features/loyalty/data/loyalty_repository.dart';
import 'package:pilates_app/features/loyalty/data/models/loyalty_reward.dart';
import 'package:pilates_app/widgets/app_app_bar.dart';
import 'package:pilates_app/widgets/app_button.dart';
import 'package:pilates_app/widgets/app_text.dart';

import '../../../../config/theme/app_text_styles.dart';
import '../../../../core/localization/localization_extension.dart';
import '../cubit/reward_cubit.dart';
import '../widget/redemption_details.dart';

class RedeemRewardView extends StatefulWidget {
  const RedeemRewardView({super.key, required this.reward});

  final LoyaltyReward reward;

  @override
  State<RedeemRewardView> createState() => _RedeemRewardViewState();
}

class _RedeemRewardViewState extends State<RedeemRewardView> {
  bool _submitting = false;

  Future<void> _onConfirm() async {
    if (_submitting) return;
    setState(() => _submitting = true);
    final repo = context.read<LoyaltyRepository>();
    final result = await repo.redeemReward(widget.reward.id);
    if (!mounted) return;
    setState(() => _submitting = false);

    switch (result) {
      case ApiSuccess(:final data):
        if (context.mounted) {
          context.read<RewardCubit>().loadRewards();
          context.read<RewardCubit>().loadPointsHistory();
        }
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              '${data.redemptionCode} · ${data.remainingPoints} pts left',
            ),
          ),
        );
        Navigator.of(context).pop();
      case ApiFailure(:final exception):
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              exception.message?.trim().isNotEmpty == true
                  ? exception.message!.trim()
                  : context.l10n.loginErrorGeneric,
            ),
          ),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final r = widget.reward;
    return Scaffold(
      appBar: AppAppBar(
        title: context.l10n.redeem_reward,
        onBack: () => Navigator.of(context).pop(),
        isMoreMenu: false,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsetsGeometry.symmetric(
            vertical: AppSpacing.md,
            horizontal: AppSpacing.lg,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _BookingCard(isDark: isDark, context: context, reward: r),
              SizedBox(height: AppSpacing.lg),
              _pointCard(isDark: isDark, context: context, reward: r),
              SizedBox(height: AppSpacing.lg),
              AppText(
                context.l10n.redemption_details,
                style: (context) => AppTextStyles.gelasioRegular(
                  context,
                ).copyWith(height: 1.55),
              ),
              SizedBox(height: AppSpacing.sm),
              RedemptionDetails(),
              SizedBox(height: AppSpacing.md),
              _messageCard(isDark: isDark, context: context),
              SizedBox(height: AppSpacing.lg),
              AppButton(
                label: context.l10n.confirm_redemption,
                onPressed: _submitting || !r.canRedeem ? null : _onConfirm,
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
                  label: context.l10n.cancel,
                  onPressed: _submitting
                      ? null
                      : () => Navigator.of(context).pop(),
                  variant: AppButtonVariant.secondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _BookingCard({
    required bool isDark,
    required BuildContext context,
    required LoyaltyReward reward,
  }) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        vertical: AppSpacing.lmd,
        horizontal: AppSpacing.lg,
      ),
      decoration: BoxDecoration(
        color: isDark ? AppColors.primaryDarkButton : AppColors.seekBarLight,
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          AppText(
            reward.name,
            style: (context) => AppTextStyles.appBarTitle(
              context,
              fontWeight: FontWeight.w600,
            ).copyWith(),
          ),
          SizedBox(height: AppSpacing.sm),
          AppText(
            reward.description,
            style: (context) =>
                AppTextStyles.bodyText(context).copyWith(height: 1),
          ),
          SizedBox(height: AppSpacing.md),
          Container(
            padding: EdgeInsetsGeometry.only(
              left: AppSpacing.sm,
              right: AppSpacing.base,
              top: AppSpacing.xi,
              bottom: AppSpacing.xi,
            ),
            decoration: BoxDecoration(
              color: isDark ? AppColors.progressBGColor : AppColors.whiteColor,
              borderRadius: BorderRadius.circular(AppRadius.lg),
            ),
            child: AppText(
              context.l10n.points(reward.pointsCost),
              style: (context) => AppTextStyles.body(context).copyWith(
                color: isDark ? AppColors.lightText : AppColors.languageIcon,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _pointCard({
    required bool isDark,
    required BuildContext context,
    required LoyaltyReward reward,
  }) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        vertical: AppSpacing.lmd,
        horizontal: AppSpacing.lmd,
      ),
      decoration: BoxDecoration(
        color: isDark ? AppColors.homeBackground : AppColors.whiteColor,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(
          color: isDark ? AppColors.greyText : AppColors.buttonBorder,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AppText(
                context.l10n.this_reward,
                style: (context) =>
                    AppTextStyles.bodyText(context).copyWith(height: 1.4),
              ),
              AppText(
                '-${context.l10n.points(reward.pointsCost)}',
                style: (context) => AppTextStyles.body(
                  context,
                ).copyWith(height: 1.55, color: AppColors.redLight),
              ),
            ],
          ),
          SizedBox(height: 10),
          Divider(
            color: isDark ? AppColors.greyText : AppColors.buttonBorder,
            height: 1,
          ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AppText(
                context.l10n.after_redemption,
                style: (context) => AppTextStyles.textFieldHeading(
                  context,
                ).copyWith(height: 1.4),
              ),
              AppText(
                '—',
                style: (context) => AppTextStyles.textFieldHeading(
                  context,
                ).copyWith(height: 1.55),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _messageCard({required bool isDark, required BuildContext context}) {
    return Container(
      padding: EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: isDark
            ? AppColors.warningColor.withValues(alpha: 0.11)
            : AppColors.upgradeLightBackgroundColor,
        borderRadius: BorderRadius.circular(AppRadius.base),
      ),
      child: AppText(
        context.l10n.redeem_warning,
        style: (context) => AppTextStyles.bodyLightText(context).copyWith(
          fontSize: 12,
          height: 1.55,
          color: isDark
              ? AppColors.upgradeDarkLockBackgroundColor
              : AppColors.lightGrey,
        ),
        maxLines: 3,
      ),
    );
  }
}
