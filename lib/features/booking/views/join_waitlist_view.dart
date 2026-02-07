import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'package:pilates_app/config/theme/app_spacing.dart';
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
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundDark : Colors.white,
      appBar: AppBar(
        title: AppText(
          l10n.joinWaitList,
          style: (context) => AppTextStyles.appBarText(context),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          padding: const EdgeInsetsDirectional.only(
            start: AppSpacing.md,
            bottom: AppSpacing.xs,
          ),
          icon: Icon(
            Directionality.of(context) == TextDirection.rtl
                ? Icons.arrow_forward_ios
                : Icons.arrow_back_ios_new,
            color: isDark ? AppColors.whiteColor : AppColors.blackColor,
            size: 20,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
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
                ],
              ),
            ),
          ),
          _buildFooterLinks(context, isDark),
        ],
      ),
    );
  }

  /// CLASS DETAILS
  Widget _buildClassDetailsCard(BuildContext context, bool isDark) {
    final l10n = AppLocalizations.of(context)!;

    return Container(
      margin: const EdgeInsets.symmetric(
        vertical: AppSpacing.md,
        horizontal: AppSpacing.lg,
      ),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? AppColors.homeBackground : Colors.white,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(
          color: isDark ? AppColors.greyText : AppColors.buttonBorder,
          width: 0.5,
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
              color: Colors.grey,
              borderRadius: BorderRadius.circular(AppRadius.md),
            ),
          ),
          const SizedBox(width: AppSpacing.lmd),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText(
                  l10n.classDetail,
                  style: (context) => AppTextStyles.gelasioMedium(context),
                ),
                const SizedBox(height: AppSpacing.md),
                _buildDetailRow(Icons.location_on_outlined, l10n.getDirection),
                const SizedBox(height: 12),
                _buildDetailRow(Icons.watch_later_outlined, l10n.time),
                const SizedBox(height: 12),
                _buildDetailRow(Icons.person_outline, l10n.people),
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
    final l10n = AppLocalizations.of(context)!;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lmd,
        vertical: 40,
      ),
      margin: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      decoration: BoxDecoration(
        color: isDark ? AppColors.primaryDarkButton : AppColors.seekBarLight,
        borderRadius: BorderRadius.circular(AppRadius.base),
        border: isDark ? null : Border.all(color: AppColors.darkGreyBorder),
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
    final l10n = AppLocalizations.of(context)!;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isDark ? AppColors.homeBackground : Colors.white,
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
                        AppTextStyles.helpAndSupportItemSubLabel(context),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  AppText(
                    '5 ${l10n.people}',
                    style: (context) => AppTextStyles.experienceButton(context),
                  ),
                ],
              ),
            ),
            SvgPicture.asset("assets/images/svg/ic_waitlist_person.svg"),
          ],
        ),
      ),
    );
  }

  /// SMART TIP
  Widget _buildSmartTip(BuildContext context, bool isDark) {
    final l10n = AppLocalizations.of(context)!;

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
          children: [
            SvgPicture.asset("assets/images/svg/ic_tip.svg"),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: '${l10n.smartTip}: ',
                      style: AppTextStyles.helpAndSupportItemSubLabel(context)
                          .copyWith(
                            fontWeight: FontWeight.w600,
                            color: AppColors.primaryBrown,
                          ),
                    ),
                    TextSpan(
                      text: l10n.smartTipDescription,
                      style: AppTextStyles.helpAndSupportItemSubLabel(context),
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
    final l10n = AppLocalizations.of(context)!;

    return Padding(
      padding: EdgeInsets.only(
        left: AppSpacing.lg,
        right: AppSpacing.lg,
        bottom: MediaQuery.of(context).viewPadding.bottom,
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
          AppButton(
            label: l10n.browseOtherClasses,
            variant: AppButtonVariant.secondary,
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}
