import 'package:flutter/material.dart';
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
        boxShadow: [
          if (!isDark)
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(AppRadius.lg)),
                child: Image.network(
                  'https://images.unsplash.com/photo-1518611012118-2960c8bac4d4?q=80&w=2070&auto=format&fit=crop',
                  height: imageHeight,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                top: AppSpacing.md,
                left: AppSpacing.md,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: AppSpacing.xs),
                  decoration: BoxDecoration(
                    color: const Color(0xFFDCFCE7),
                    borderRadius: BorderRadius.circular(AppRadius.sm),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.check, color: Color(0xFF166534), size: 12),
                      const SizedBox(width: AppSpacing.xs),
                      AppText(
                        context.l10n.inYourPlan.toUpperCase(),
                        style: (context) => AppTextStyles.boldBody(context).copyWith(
                          fontSize: size.width * 0.025 > 10 ? 10 : size.width * 0.025,
                          color: const Color(0xFF166534),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
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
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                AppText(
                  '${context.l10n.branchDowntown} • ${context.l10n.today} • ${context.l10n.spotsLeft(3)}',
                  style: (context) => AppTextStyles.captionText(context).copyWith(
                    fontSize: size.width * 0.03 > 12 ? 12 : size.width * 0.03,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: AppSpacing.md),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryBrown,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.md)),
                    minimumSize: const Size(double.infinity, 40),
                  ),
                  child: AppText(
                    context.l10n.bookClass,
                    style: (context) => AppTextStyles.boldBody(context).copyWith(
                      color: Colors.white,
                      fontSize: size.width * 0.035 > 14 ? 14 : size.width * 0.035,
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
