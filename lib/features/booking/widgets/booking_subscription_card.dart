import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pilates_app/config/theme/app_colors.dart';
import 'package:pilates_app/config/theme/app_radius.dart';
import 'package:pilates_app/config/theme/app_spacing.dart';
import 'package:pilates_app/config/theme/app_text_styles.dart';
import 'package:pilates_app/core/localization/localization_extension.dart';
import 'package:pilates_app/widgets/app_text.dart';

class BookingSubscriptionCard extends StatelessWidget {
  const BookingSubscriptionCard({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.lg,
      ),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.bottomRight,
          end: Alignment.topLeft,
          colors: [
            Color(0xFF3D281A),
            Color(0xFF9A7E6D),
          ],
        ),
        borderRadius: BorderRadius.circular(AppRadius.md),
        color: AppColors.splashBackgroundDark,
      ),
      child: Row(
        children: [
          Container(
            child: SvgPicture.asset(
              'assets/images/svg/ic_king.svg',
              width: size.width * 0.05,
              height: size.height * 0.05,
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: AppText(
              'Your Plan: Premium (Downtown + Uptown)', // Replace with dynamic if needed
              style: (context) => AppTextStyles.helpAndSupportItemLabel(context).copyWith(
                fontSize: size.width * 0.035 > 16 ? 16 : size.width * 0.035,
                color: AppColors.lightText,
                fontWeight: FontWeight.w500
              ),
            ),
          ),
        ],
      ),
    );
  }
}
