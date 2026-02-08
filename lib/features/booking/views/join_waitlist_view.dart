import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'package:pilates_app/config/theme/app_spacing.dart';
import 'package:pilates_app/widgets/app_app_bar.dart';
import 'package:pilates_app/widgets/app_shadow.dart';
import 'package:pilates_app/widgets/app_text.dart';

import '../../../config/theme/app_colors.dart';
import '../../../config/theme/app_radius.dart';
import '../../../config/theme/app_text_styles.dart';
import '../../../core/localization/arb/app_localizations.dart';
import '../../../widgets/app_button.dart';
import 'booking_success_view.dart';

class JoinWaitlistView extends StatelessWidget {
  const JoinWaitlistView({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundDark : Colors.white,
      appBar: AppAppBar(
        onBack: () => Navigator.of(context).pop(),
        title: l10n.joinWailList,
        isMoreMenu: false,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildClassDetailsCard(context, isDark),
            const SizedBox(height: AppSpacing.sm),
            Divider(
              color: isDark ? AppColors.greyText : AppColors.buttonBorder,
            ),
            const SizedBox(height: AppSpacing.lg),
            _buildClassCard(context, isDark),
            const SizedBox(height: AppSpacing.lg),
            _buildWaitListCard(context, isDark),
            const SizedBox(height: AppSpacing.lg),
            _buildSmartTip(context, isDark),
            const SizedBox(height: AppSpacing.lg),
            _buildFooterLinks(context, isDark),
            SizedBox(height: MediaQuery.of(context).viewPadding.bottom),
          ],
        ),
      ),
    );
  }

  /// CLASS DETAILS
  Widget _buildClassDetailsCard(BuildContext context, bool isDark) {
    // final l10n = AppLocalizations.of(context)!;

    return Container(
      margin: const EdgeInsets.symmetric(
        vertical: AppSpacing.md,
        horizontal: AppSpacing.lg,
      ),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? AppColors.homeBackground : AppColors.whiteColor,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(
          color: isDark ? AppColors.greyText : AppColors.buttonBorder,
        ),
        boxShadow: [
          AppShadows.lightShadow,
          AppShadows.mediumShadow,
          AppShadows.mediumHeavyShadow,
          AppShadows.heavyShadow,
          AppShadows.extraHeavyShadow,
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 72,
            width: 94,
            decoration: BoxDecoration(
              // color: Colors.grey,
              borderRadius: BorderRadius.circular(8),
            ),
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(AppRadius.md),
                bottom: Radius.circular(AppRadius.md),
              ),
              child: Image.asset(
                "assets/images/demo images/yoga.png",
                height: 72,
                width: 94,
                fit: BoxFit.fill,
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.lmd),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText(
                  "Core Strength & Balance",
                  style: (context) => AppTextStyles.gelasioMedium(context),
                ),
                const SizedBox(height: AppSpacing.md),
                _buildDetailRow(Icons.location_on_outlined, "Downtown Studio"),
                const SizedBox(height: AppSpacing.sm),
                _buildDetailRow(Icons.watch_later_outlined, "Today, 6:00 PM"),
                const SizedBox(height: AppSpacing.sm),
                _buildDetailRow(Icons.person_outline, "Fatima Al-Hashmi"),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 16, color: AppColors.languageIcon),
        const SizedBox(width: 4),
        AppText(text, style: (context) => AppTextStyles.bodyTextSmall(context)),
      ],
    );
  }

  /// CLASS FULL CARD
  Widget _buildClassCard(BuildContext context, bool isDark) {
    final l10n = AppLocalizations.of(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lmd,
        vertical: 40,
      ),
      margin: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      decoration: BoxDecoration(
        color: isDark ? AppColors.homeBackground : AppColors.seekBarLight,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(
          color: isDark ? AppColors.greyText : AppColors.buttonBorder,
        ),
      ),
      child: Column(
        children: [
          SvgPicture.asset("assets/images/svg/ic_calender.svg"),
          const SizedBox(height: AppSpacing.md),
          AppText(
            l10n.classIsFull,
            style: (context) => AppTextStyles.gelasioMedium(context),
          ),
          const SizedBox(height: AppSpacing.xs),
          AppText(
            l10n.classIsFullDescription,
            style: (context) => AppTextStyles.textField(context).copyWith(
              color: isDark ? AppColors.darkGreyText : AppColors.greyText,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  /// WAITLIST INFO
  Widget _buildWaitListCard(BuildContext context, bool isDark) {
    final l10n = AppLocalizations.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
        decoration: BoxDecoration(
          color: isDark ? AppColors.homeBackground : AppColors.whiteColor,
          borderRadius: BorderRadius.circular(AppRadius.md),
          border: Border.all(
            color: isDark ? AppColors.greyText : AppColors.buttonBorder,
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppText(
                    l10n.currentWaitList,
                    style: (context) =>
                        AppTextStyles.helpAndSupportItemSubLabel(
                          context,
                        ).copyWith(
                          color: AppColors.lightGrey,
                          fontWeight: FontWeight.w500,
                        ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  AppText(
                    '5 ${l10n.people}',
                    style: (context) => AppTextStyles.experienceButton(
                      context,
                    ).copyWith(fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
            isDark
                ? SvgPicture.asset(
                    "assets/images/svg/ic_waitlist_person_dark.svg",
                  )
                : SvgPicture.asset("assets/images/svg/ic_waitlist_person.svg"),
          ],
        ),
      ),
    );
  }

  /// SMART TIP
  Widget _buildSmartTip(BuildContext context, bool isDark) {
    final l10n = AppLocalizations.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isDark
              ? AppColors.primaryDarkButton
              : AppColors.greyContainerBg,
          borderRadius: BorderRadius.circular(AppRadius.base),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SvgPicture.asset("assets/images/svg/ic_tip.svg"),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: '${l10n.smartTip}: ',
                      style: AppTextStyles.helpAndSupportItemSubLabel(
                        context,
                      ).copyWith(fontWeight: FontWeight.w600),
                    ),
                    TextSpan(
                      text: l10n.smartTipDescription,
                      style: AppTextStyles.helpAndSupportItemSubLabel(
                        context,
                      ).copyWith(height: 1.55),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// FOOTER
  Widget _buildFooterLinks(BuildContext context, bool isDark) {
    final l10n = AppLocalizations.of(context);

    return Padding(
      padding: EdgeInsets.only(
        left: AppSpacing.lg,
        right: AppSpacing.lg,
        bottom: 34,
      ),
      child: Column(
        children: [
          AppButton(
            label: l10n.joinWaitList,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const BookingSuccessScreen(
                    successPage: SuccessPage.waitList,
                  ),
                ),
              );
            },
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
              label: l10n.browseOtherClasses,
              variant: AppButtonVariant.secondary,
              onPressed: () {},
            ),
          ),
        ],
      ),
    );
  }
}
