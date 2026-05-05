import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pilates_app/config/theme/app_colors.dart';
import 'package:pilates_app/config/theme/app_spacing.dart';
import 'package:pilates_app/widgets/app_app_bar.dart';
import 'package:pilates_app/widgets/app_text.dart';
import 'package:pilates_app/widgets/app_text_field.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../config/theme/app_radius.dart';
import '../../../config/theme/app_text_styles.dart';
import '../../../core/localization/arb/app_localizations.dart';
import '../../../core/localization/localization_extension.dart';
import '../../../features/referral/cubit/referral_program_cubit.dart';
import '../../../features/referral/cubit/referral_program_state.dart';
import '../../../features/referral/data/referral_repository.dart';
import '../../../features/referral/referral_reward_format.dart';
import '../../../widgets/app_button.dart';
import '../../../widgets/app_shadow.dart';
import '../../../widgets/dotted_underline.dart';

class ReferralProgramView extends StatelessWidget {
  const ReferralProgramView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        final cubit = ReferralProgramCubit(context.read<ReferralRepository>());
        cubit.load();
        return cubit;
      },
      child: const _ReferralProgramScaffold(),
    );
  }
}

class _ReferralProgramScaffold extends StatelessWidget {
  const _ReferralProgramScaffold();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppAppBar(
        title: l10n.referralProgram,
        isMoreMenu: false,
        onBack: () => Navigator.of(context).pop(),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsetsGeometry.symmetric(
            vertical: AppSpacing.md,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _referralCodeCard(context: context),
              SizedBox(height: AppSpacing.xl),
              _orRow(context: context),
              SizedBox(height: AppSpacing.xl),
              _inviteDirectCard(context: context),
              SizedBox(height: AppSpacing.xl),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                child: AppText(
                  l10n.howItWorks,
                  style: (context) =>
                      AppTextStyles.gelasioMedium(context).copyWith(height: 1),
                ),
              ),
              SizedBox(height: AppSpacing.md),
              _howItWorksCard(context: context),
              SizedBox(height: AppSpacing.xl),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    AppText(
                      l10n.recentReferrals,
                      style: (context) => AppTextStyles.gelasioMedium(
                        context,
                      ).copyWith(height: 1),
                    ),
                    AppText(
                      l10n.seeAll,
                      style: (context) =>
                          AppTextStyles.body(context).copyWith(height: 1),
                    ),
                  ],
                ),
              ),
              SizedBox(height: AppSpacing.md),
              _recentReferralsCard(
                context: context,
                title: "Jessica M.",
                subTitle: l10n.joinedDaysAgo(2),
              ),
              SizedBox(height: AppSpacing.md),
              _recentReferralsCard(
                context: context,
                title: "Mike Davis",
                subTitle: l10n.joinedDaysAgo(2),
              ),
              SizedBox(height: AppSpacing.md),
              _recentReferralsCard(
                context: context,
                title: "Emily Wilson",
                subTitle: l10n.joinedDaysAgo(4),
              ),
              SizedBox(height: AppSpacing.md),
              _recentReferralsCard(
                context: context,
                title: "Emily Wilson",
                subTitle: l10n.joinedDaysAgo(4),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _referralCodeCard({required BuildContext context}) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context);
    return BlocBuilder<ReferralProgramCubit, ReferralProgramState>(
      builder: (context, state) {
        final program = state.program;
        final loading = state.status == ReferralProgramStatus.loading &&
            program == null;
        final failedFirstLoad = state.status == ReferralProgramStatus.failure &&
            program == null;

        final code = program?.referralCode ?? '';
        final spacedCode = code.isEmpty ? '' : code.split('').join(' ');
        final youReward = program != null
            ? referralRewardDisplay(l10n, program.referrerReward)
            : '';
        final friendReward = program != null
            ? referralRewardDisplay(l10n, program.referredReward)
            : '';

        late final Widget inner;
        if (loading) {
          inner = const Padding(
            padding: EdgeInsets.symmetric(vertical: AppSpacing.xl),
            child: Center(child: CircularProgressIndicator()),
          );
        } else if (failedFirstLoad) {
          inner = Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AppText(
                state.errorMessage ?? l10n.referralProgramLoadError,
                style: (context) =>
                    AppTextStyles.bodyText(context).copyWith(height: 1.3),
              ),
              SizedBox(height: AppSpacing.md),
              AppButton(
                label: l10n.referralRetry,
                onPressed: () =>
                    context.read<ReferralProgramCubit>().load(),
                variant: AppButtonVariant.primary,
              ),
            ],
          );
        } else {
          inner = Column(
            children: [
              AppText(
                spacedCode.isEmpty ? code : spacedCode,
                style: (context) => AppTextStyles.bottomSheetTitle(
                  context,
                ).copyWith(height: 1),
              ),
              SizedBox(height: AppSpacing.md),
              AppText(
                l10n.shareCodeWithFriends,
                style: (context) => AppTextStyles.bodyText(
                  context,
                ).copyWith(color: AppColors.placeHolderText, height: 1),
              ),
            ],
          );
        }

        return Container(
          margin: EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          padding: EdgeInsets.all(AppSpacing.lmd),
          decoration: BoxDecoration(
            color: isDark ? AppColors.homeBackground : AppColors.whiteColor,
            borderRadius: BorderRadius.circular(AppRadius.md),
            border: Border.all(
              color: isDark ? AppColors.greyText : AppColors.buttonBorder,
              width: 1,
            ),
            boxShadow: [
              AppShadows.lightShadow,
              AppShadows.mediumShadow,
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
              AppText(
                l10n.yourReferralCode,
                style: (context) =>
                    AppTextStyles.textField(context).copyWith(height: 1),
              ),
              SizedBox(height: AppSpacing.md),
              CustomPaint(
                painter: DashedUnderlinePainter(
                  color: AppColors.primary,
                  dashWidth: 3,
                  dashSpace: 3,
                  top: true,
                  left: true,
                  right: true,
                ),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.symmetric(vertical: AppSpacing.md),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(AppRadius.md),
                    color: isDark
                        ? AppColors.trainerBlackBackgroundColor
                        : AppColors.selectedLanguageBg,
                  ),
                  child: inner,
                ),
              ),
              SizedBox(height: AppSpacing.lg),
              AppButton(
                label: l10n.copyCode,
                onPressed: loading || failedFirstLoad || code.isEmpty
                    ? null
                    : () async {
                        await Clipboard.setData(ClipboardData(text: code));
                        if (!context.mounted) {
                          return;
                        }
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(l10n.referralCodeCopied)),
                        );
                      },
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
                  label: l10n.shareViaWhatsapp,
                  onPressed: loading ||
                          failedFirstLoad ||
                          (program?.shareUrl ?? '').isEmpty
                      ? null
                      : () async {
                          final url = program?.shareUrl ?? '';
                          if (url.isEmpty) {
                            return;
                          }
                          final uri = Uri.parse(
                            'https://wa.me/?text=${Uri.encodeComponent(url)}',
                          );
                          if (await canLaunchUrl(uri)) {
                            await launchUrl(
                              uri,
                              mode: LaunchMode.externalApplication,
                            );
                          }
                        },
                  variant: AppButtonVariant.secondary,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _orRow({required BuildContext context}) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context);
    return Stack(
      alignment: Alignment.center,
      children: [
        Divider(
          color: isDark ? AppColors.greyText : AppColors.buttonBorder,
          height: 1,
          thickness: 1,
        ),
        Container(
          width: 66,
          alignment: Alignment.center,
          color: isDark ? AppColors.homeBackground : AppColors.whiteColor,
          child: AppText(
            l10n.referralOrDivider,
            style: AppTextStyles.gelasioRegular,
          ),
        ),
      ],
    );
  }

  Widget _inviteDirectCard({required BuildContext context}) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context);
    return Container(
      margin: EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      padding: EdgeInsets.all(AppSpacing.lmd),
      decoration: BoxDecoration(
        color: isDark ? AppColors.homeBackground : AppColors.whiteColor,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(
          color: isDark ? AppColors.greyText : AppColors.buttonBorder,
          width: 1,
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
        children: [
          AppText(
            l10n.inviteDirectly,
            style: (context) =>
                AppTextStyles.experienceButton(context).copyWith(height: 1),
          ),
          SizedBox(height: AppSpacing.sm),
          AppText(
            l10n.sendPersonalInvitation,
            style: (context) =>
                AppTextStyles.bodyLightText(context).copyWith(height: 1),
          ),
          SizedBox(height: AppSpacing.lg),
          AppTextField(hint: l10n.friendsName, label: l10n.friendsName),
          SizedBox(height: AppSpacing.md),
          AppTextField(hint: "XXXXXXXXXX", label: l10n.phoneNumber),
          SizedBox(height: AppSpacing.lg),
          AppButton(
            label: l10n.sendInvitation,
            onPressed: () {},
            variant: AppButtonVariant.primary,
          ),
        ],
      ),
    );
  }

  Widget _howItWorksCard({required BuildContext context}) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context);
    return Container(
      margin: EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      padding: EdgeInsets.all(AppSpacing.lmd),
      decoration: BoxDecoration(
        color: isDark ? AppColors.homeBackground : AppColors.whiteColor,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(
          color: isDark ? AppColors.greyText : AppColors.buttonBorder,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _workRow(
            rank: 1,
            title: l10n.shareYourCode,
            subTitle: l10n.shareYourCodeDesc,
          ),
          SizedBox(height: AppSpacing.base),
          _workRow(
            rank: 2,
            title: l10n.theySignUp,
            subTitle: l10n.theySignUpDesc,
          ),
          SizedBox(height: AppSpacing.base),
          _workRow(
            rank: 3,
            title: l10n.youBothGetRewards,
            subTitle: l10n.youBothGetRewardsDesc,
          ),
        ],
      ),
    );
  }

  Widget _workRow({
    required int rank,
    required String title,
    required String subTitle,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          height: 32,
          width: 32,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.languageIcon,
          ),
          child: AppText(
            rank.toString(),
            style: (context) => AppTextStyles.bottomSheet(
              context,
            ).copyWith(color: AppColors.whiteColor),
          ),
        ),
        SizedBox(width: AppSpacing.md),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppText(
                title,
                style: (context) =>
                    AppTextStyles.textFieldHeading(context).copyWith(height: 1),
              ),
              SizedBox(height: AppSpacing.sm),
              AppText(
                subTitle,
                style: (context) => AppTextStyles.bodyLightText(
                  context,
                ).copyWith(fontSize: 12, height: 1.4),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _recentReferralsCard({
    required BuildContext context,
    required String title,
    required String subTitle,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      margin: EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      padding: EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: isDark ? AppColors.homeBackground : AppColors.whiteColor,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(
          color: isDark ? AppColors.greyText : AppColors.buttonBorder,
          width: 1,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText(
                  title,
                  style: (context) => AppTextStyles.textFieldHeading(context),
                ),
                SizedBox(height: AppSpacing.sm),
                AppText(
                  subTitle,
                  style: (context) => AppTextStyles.helpAndSupportItemSubLabel(
                    context,
                  ).copyWith(height: 1.55),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(
              vertical: 1,
              horizontal: AppSpacing.sm,
            ),
            decoration: BoxDecoration(
              color: isDark ? Colors.transparent : AppColors.greyContainerBg,
              borderRadius: BorderRadius.circular(AppRadius.base),
            ),
            child: AppText(
              "+${context.l10n.points_short(500)}",
              style: (context) => AppTextStyles.splashVersion(context).copyWith(
                color: isDark ? AppColors.lightText : AppColors.darkText,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
