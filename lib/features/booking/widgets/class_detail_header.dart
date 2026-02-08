import 'package:flutter/material.dart';

import 'package:pilates_app/config/theme/app_colors.dart';
import 'package:pilates_app/config/theme/app_radius.dart';
import 'package:pilates_app/config/theme/app_spacing.dart';
import 'package:pilates_app/config/theme/app_text_styles.dart';
import 'package:pilates_app/core/localization/localization_extension.dart';
import 'package:pilates_app/widgets/app_text.dart';

class ClassDetailHeader extends StatelessWidget {
  const ClassDetailHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final size = MediaQuery.sizeOf(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: AppSpacing.md),
        // Hero Image
        ClipRRect(
          borderRadius: BorderRadius.circular(AppRadius.lg + 4),
          child:
              // SvgPicture.asset(
              //   'assets/images/svg/ic_yoga.svg',
              //   width: double.infinity,
              //   height: size.height * 0.28,
              //   fit: BoxFit.cover,
              // ),
              Image.asset(
                "assets/images/demo images/Class Image.png",
                height: size.height * 0.28,
                // width: width * 0.6,
                fit: BoxFit.cover,
              ),
        ),
        const SizedBox(height: AppSpacing.lg),

        // Title and Rating
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: AppText(
                context.l10n.powerPilates,
                style: (context) => AppTextStyles.heading1(
                  context,
                ).copyWith(fontSize: 24, fontWeight: FontWeight.w500),
              ),
            ),
            Row(
              children: [
                const Icon(
                  Icons.star,
                  color: AppColors.goldStarColor,
                  size: 20,
                ),
                const SizedBox(width: 4),
                AppText(
                  '4.5',
                  style: (context) => AppTextStyles.boldBody(context).copyWith(
                    fontSize: 16,
                    color: isDark ? AppColors.lightText : AppColors.darkText,
                  ),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.xs),
        Padding(
          padding: const EdgeInsets.only(right: AppSpacing.xxl),
          child: AppText(
            context.l10n.classDescriptionShort,
            style: (context) => AppTextStyles.bodyText(context),
          ),
        ),
      ],
    );
  }
}
