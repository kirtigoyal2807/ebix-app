import 'package:flutter/material.dart';

import 'package:pilates_app/config/theme/app_spacing.dart';
import 'package:pilates_app/widgets/app_shadow.dart';
import 'package:pilates_app/widgets/app_text.dart';

import '../../../config/theme/app_colors.dart';
import '../../../config/theme/app_radius.dart';
import '../../../config/theme/app_text_styles.dart';
import '../../../core/localization/arb/app_localizations.dart';
import '../../../widgets/app_button.dart';
import 'booking_success_view.dart';

class BookClassConfirmView extends StatelessWidget {
  const BookClassConfirmView({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundDark : Colors.white,
      appBar: AppBar(
        title: AppText(
          l10n.bookYourClass,
          style: (context) => AppTextStyles.appBarText(context),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          padding: const EdgeInsets.only(
            left: AppSpacing.md,
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildClassDetailsCard(isDark: isDark),
          const SizedBox(height: AppSpacing.sm),
          Divider(
            color: isDark ? AppColors.greyText : AppColors.buttonBorder,
            height: 1,
          ),
          const SizedBox(height: AppSpacing.lg),

          _buildPaymentSummary(isDark: isDark, l10n: l10n),
          const SizedBox(height: AppSpacing.lg),

          _buildPolicyAgreement(l10n: l10n),
          const Spacer(),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
            child: AppButton(
              label: l10n.confirmBooking,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const BookingSuccessScreen(
                      successPage: SuccessPage.booking,
                    ),
                  ),
                );
              },
              variant: AppButtonVariant.primary,
            ),
          ),
          const SizedBox(height: 34),
        ],
      ),
    );
  }

  Widget _buildClassDetailsCard({required bool isDark}) {
    return Container(
      margin: const EdgeInsets.symmetric(
        vertical: AppSpacing.md,
        horizontal: AppSpacing.lg,
      ),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? AppColors.primaryDarkButton : Colors.white,
        borderRadius: BorderRadius.circular(12),
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
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText(
                  'Power Pilates',
                  style: (context) => AppTextStyles.gelasioMedium(context),
                ),
                const SizedBox(height: 20),
                _buildDetailRow(
                  icon: Icons.location_on_outlined,
                  text: 'Downtown Studio',
                ),
                const SizedBox(height: 12),
                _buildDetailRow(
                  icon: Icons.watch_later_outlined,
                  text: 'Today, 6:00 PM',
                ),
                const SizedBox(height: 12),
                _buildDetailRow(
                  icon: Icons.person_outline,
                  text: 'Aisha Sherin',
                ),
              ],
            ),
          ),
          Container(
            height: 72,
            width: 94,
            decoration: BoxDecoration(
              color: Colors.grey,
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow({required IconData icon, required String text}) {
    return Row(
      children: [
        Icon(icon, color: AppColors.languageIcon, size: 16),
        const SizedBox(width: 4),
        AppText(text, style: (context) => AppTextStyles.bodyTextSmall(context)),
      ],
    );
  }

  Widget _buildPaymentSummary({
    required bool isDark,
    required AppLocalizations l10n,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppText(
            l10n.paymentSummery,
            style: (context) => AppTextStyles.gelasioMedium(context),
          ),
          const SizedBox(height: AppSpacing.md),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: isDark
                  ? AppColors.primaryDarkButton
                  : AppColors.seekBarLight,
              borderRadius: BorderRadius.circular(AppRadius.base),
            ),
            child: Column(
              children: [
                _buildPaymentRow(
                  title: l10n.classFee,
                  value: 'Included in plan',
                ),
                const SizedBox(height: AppSpacing.md),
                Divider(
                  color: isDark ? AppColors.greyText : AppColors.darkGreyBorder,
                  height: 1,
                ),
                const SizedBox(height: AppSpacing.md),
                _buildPaymentRow(title: l10n.total, value: '\$0.00'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentRow({required String title, required String value}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        AppText(
          title,
          style: (context) => AppTextStyles.bodyTextSmall(context),
        ),
        AppText(
          value,
          style: (context) => AppTextStyles.textFieldHeading(context),
        ),
      ],
    );
  }

  Widget _buildPolicyAgreement({required AppLocalizations l10n}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Checkbox(
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            visualDensity: VisualDensity.compact,
            value: false,
            onChanged: (value) {},
            activeColor: AppColors.primary,
            checkColor: Colors.white,
            side: const BorderSide(color: AppColors.buttonBorder, width: 1),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          const SizedBox(width: AppSpacing.base),
          Expanded(
            child: AppText(
              l10n.cancelPolicyDescription,
              style: (context) =>
                  AppTextStyles.helpAndSupportItemSubLabel(context),
              maxLines: 3,
            ),
          ),
        ],
      ),
    );
  }
}
