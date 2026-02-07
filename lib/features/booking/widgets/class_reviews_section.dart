import 'package:flutter/material.dart';
import 'package:pilates_app/config/theme/app_colors.dart';
import 'package:pilates_app/config/theme/app_radius.dart';
import 'package:pilates_app/config/theme/app_spacing.dart';
import 'package:pilates_app/config/theme/app_text_styles.dart';
import 'package:pilates_app/core/localization/localization_extension.dart';
import 'package:pilates_app/widgets/app_text.dart';

class ClassReviewsSection extends StatelessWidget {
  const ClassReviewsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final size = MediaQuery.sizeOf(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: AppText(
                context.l10n.recentReviews,
                style: (context) => AppTextStyles.heading1(context).copyWith(
                  color: isDark ? AppColors.lightText : AppColors.darkText,
                  fontSize: size.width * 0.055 > 18 ? 18 : size.width * 0.055,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            AppText(
              context.l10n.seeAll,
              style: (context) => AppTextStyles.captionText(context).copyWith(
                color: isDark ? AppColors.languageTextDark : AppColors.languageIcon,
                fontSize: size.width * 0.03 > 14 ? 14 : size.width * 0.03,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.md),

        // Reviews Summary
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(AppSpacing.lg),
          decoration: BoxDecoration(
            color: isDark ? AppColors.homeBackground : AppColors.whiteColor,
            borderRadius: BorderRadius.circular(AppRadius.md),
            border: Border.all(
              color: isDark ? AppColors.greyText : AppColors.buttonBorder,
            ),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  AppText(
                    '4.8',
                    style: (context) => AppTextStyles.bottomSheetTitle(context).copyWith(
                      fontSize: 40,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const _StarRating(rating: 5, size: 14),
                      const SizedBox(height: 4),
                      AppText(
                        context.l10n.basedOnReviews(27),
                        style: (context) => AppTextStyles.captionText(context).copyWith(
                          fontSize: 12,
                          color: isDark ? AppColors.darkGreyText : AppColors.greyText,
                        ),
                      ),
                    ],
                  )
                ],
              ),
              const SizedBox(height: AppSpacing.md),
              const Column(
                children: [
                  _RatingBar(stars: 5, progress: 0.6),
                  _RatingBar(stars: 4, progress: 0.2),
                  _RatingBar(stars: 3, progress: 0.1),
                  _RatingBar(stars: 2, progress: 0.05),
                  _RatingBar(stars: 1, progress: 0.05),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.lg),

        // Review Cards - Horizontal
        SizedBox(
          height: size.height * 0.18,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: 3,
            separatorBuilder: (context, index) => const SizedBox(width: AppSpacing.md),
            itemBuilder: (context, index) => const _ReviewCard(),
          ),
        ),
      ],
    );
  }
}

class _RatingBar extends StatelessWidget {
  final int stars;
  final double progress;

  const _RatingBar({required this.stars, required this.progress});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.only(bottom: 2.0),
      child: Row(
        children: [
          const Icon(Icons.star, color: AppColors.goldStarColor, size: 14),
          const SizedBox(width: 4),
          AppText(
            stars.toString(),
            style: (context) => AppTextStyles.helpAndSupportItemLabel(context).copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(2),
              child: LinearProgressIndicator(
                value: progress,
                backgroundColor: isDark ? AppColors.primaryDarkButton : AppColors.ratingBarBackground,
                color: AppColors.goldStarColor,
                minHeight: 6,
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          AppText(
            (progress * 12).toInt().toString(), // Dummy count
            style: (context) => AppTextStyles.captionText(context).copyWith(
              fontSize: 10,
              color: AppColors.lightGrey,
            ),
          ),
        ],
      ),
    );
  }
}

class _StarRating extends StatelessWidget {
  final int rating;
  final double size;

  const _StarRating({required this.rating, this.size = 18});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        return Icon(
          index < rating ? Icons.star : Icons.star_border,
          color: const Color(0xFFEAB308),
          size: size,
        );
      }),
    );
  }
}

class _ReviewCard extends StatelessWidget {
  const _ReviewCard();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: MediaQuery.sizeOf(context).width * 0.7,
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: isDark ? AppColors.homeBackground : AppColors.whiteColor,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(
          color: isDark ? AppColors.greyText : AppColors.buttonBorder,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppText(
                    context.l10n.reviewerName1,
                    style: (context) => AppTextStyles.boldBody(context).copyWith(
                      color: isDark ? AppColors.lightText : AppColors.darkText,
                    ),
                  ),
                  AppText(
                    context.l10n.reviewerTime1,
                    style: (context) => AppTextStyles.helpAndSupportItemSubLabel(context),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Icon(Icons.star, color: AppColors.goldStarColor, size: 14),
                  const SizedBox(width: 4),
                  AppText(
                    '4.5',
                    style: (context) => AppTextStyles.boldBody(context).copyWith(
                      fontSize: 14,
                      color: isDark ? AppColors.lightText : AppColors.darkText,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          AppText(
            context.l10n.reviewerComment1,
            style: (context) => AppTextStyles.bodyText(context).copyWith(
              height: 1.4,
            ),
            maxLines: 5,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
