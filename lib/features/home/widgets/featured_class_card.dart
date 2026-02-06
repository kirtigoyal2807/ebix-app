import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pilates_app/config/theme/app_colors.dart';
import 'package:pilates_app/config/theme/app_radius.dart';
import 'package:pilates_app/config/theme/app_spacing.dart';
import 'package:pilates_app/config/theme/app_text_styles.dart';
import 'package:pilates_app/core/localization/localization_extension.dart';
import 'package:pilates_app/widgets/app_text.dart';

class FeaturedClassCard extends StatelessWidget {
  const FeaturedClassCard({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final size = MediaQuery.sizeOf(context);
    final imageHeight = size.height * 0.22 > 180 ? 180.0 : size.height * 0.22;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : Colors.white,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(
          color: isDark ? AppColors.greyText : AppColors.buttonBorder,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(AppRadius.lg),
            ),
            child: SvgPicture.asset(
              'assets/images/svg/ic_yoga.svg',
              height: imageHeight,
              // width: width * 0.6,
              fit: BoxFit.fill,
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              // vertical: AppSpacing.xs,
            ),
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.sm,
              vertical: AppSpacing.xs,
            ),
            decoration: BoxDecoration(
              color: isDark ?AppColors.featuredTagBackgroundDarkColor:AppColors.featuredTagBackgroundColor,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                 Icon(Icons.check, color: isDark?AppColors.lightGreyColor :AppColors.GreyColor, size: 12),
                const SizedBox(width: AppSpacing.xs),
                AppText(
                  context.l10n.inYourPlan.toUpperCase(),
                  style: (context) => AppTextStyles.boldBody(context).copyWith(
                    fontSize: size.width * 0.025 > 10 ? 10 : size.width * 0.025,
                    color: isDark?AppColors.lightGreyColor :AppColors.GreyColor,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText(
                  'Power Pilates ${context.l10n.withTrainer("Aisha Sherin")}',
                  style: (context) => AppTextStyles.boldBody(context).copyWith(
                    fontSize: size.width * 0.04 > 16 ? 16 : size.width * 0.04,
                    color: isDark ? AppColors.lightText: AppColors.darkText,
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                AppText(
                  '${context.l10n.branchDowntown} • ${context.l10n.today} • ${context.l10n.spotsLeft(3)}',
                  style: (context) =>
                      AppTextStyles.captionText(context).copyWith(
                        fontSize: size.width * 0.03 > 14
                            ? 14
                            : size.width * 0.03,
                        color: isDark ? AppColors.lightGrey: AppColors.lightGrey,

                      ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: AppSpacing.md),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.splashBackgroundDark,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppRadius.xl),
                    ),
                    minimumSize: const Size(double.infinity, 40),
                  ),
                  child: AppText(
                    context.l10n.bookClass,
                    style: (context) =>
                        AppTextStyles.boldBody(context).copyWith(
                          color: Colors.white,
                          fontSize: size.width * 0.035 > 14
                              ? 14
                              : size.width * 0.035,
                        ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
