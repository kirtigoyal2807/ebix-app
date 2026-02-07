import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pilates_app/config/theme/app_colors.dart';
import 'package:pilates_app/config/theme/app_radius.dart';
import 'package:pilates_app/config/theme/app_spacing.dart';
import 'package:pilates_app/config/theme/app_text_styles.dart';
import 'package:pilates_app/core/localization/localization_extension.dart';
import 'package:pilates_app/widgets/app_button.dart';
import 'package:pilates_app/widgets/app_text.dart';

class ClassDetailView extends StatelessWidget {
  const ClassDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final size = MediaQuery.sizeOf(context);

    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Directionality.of(context) == TextDirection.rtl
                ? Icons.arrow_forward_ios
                : Icons.arrow_back_ios_new,
            color: isDark ? AppColors.whiteColor : AppColors.blackColor,
            size: 20,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: AppText(
          context.l10n.classDetails,
          style: (context) => AppTextStyles.appBarTitle(context).copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: EdgeInsets.only(
              left: AppSpacing.lg,
              right: AppSpacing.lg,
              bottom: size.height * 0.15, // Space for sticky button
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: AppSpacing.md),
                // Hero Image
                ClipRRect(
                  borderRadius: BorderRadius.circular(AppRadius.lg + 4),
                  child: SvgPicture.asset(
                    'assets/images/svg/ic_yoga.svg',
                    width: double.infinity,
                    height: size.height * 0.28,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),

                // Title and Rating
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    AppText(
                      'Power Pilates',
                      style: (context) => AppTextStyles.heading1(context).copyWith(
                        fontSize: 24,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Row(
                      children: [
                        const Icon(Icons.star, color: AppColors.goldStarColor, size: 20),
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
                    'Build strength, flexibility, and calm through guided Pilates sessions.',
                    style: (context) => AppTextStyles.bodyText(context),
                  ),
                ),
                const SizedBox(height: AppSpacing.xl),

                // Info Grid
                GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 2,
                  mainAxisSpacing: AppSpacing.md,
                  crossAxisSpacing: AppSpacing.md,
                  childAspectRatio: 2,
                  children: [
                    _InfoCard(
                      label: context.l10n.instructor,
                      value: 'Aisha Sherin',
                      showAvatar: true,
                    ),
                    _InfoCard(
                      label: context.l10n.duration,
                      value: context.l10n.minutesCount(40),
                    ),
                    _InfoCard(
                      label: context.l10n.dateTime,
                      value: '${context.l10n.today}, 6:00 PM',
                    ),
                    _InfoCard(
                      label: context.l10n.availability,
                      value: context.l10n.spotsLeft(3),
                    ),
                  ],
                ),
                // const SizedBox(height: AppSpacing.lg),

                // Location Card
                _LargeCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppText(
                        context.l10n.location,
                        style: (context) => AppTextStyles.captionText(context).copyWith(
                          color: isDark ? AppColors.lightGrey : AppColors.lightGrey,
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      AppText(
                        context.l10n.branchDowntown,
                        style: (context) => AppTextStyles.boldBody(context).copyWith(
                          fontSize: 14,
                          color: isDark ? AppColors.lightText : AppColors.darkText,
                        ),
                      ),
                      AppText(
                        '123 Main Street, Suite 200',
                        style: (context) => AppTextStyles.boldBody(context).copyWith(
                          fontSize: 14,
                          color: isDark ? AppColors.lightText : AppColors.darkText,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.xl),

                // About This Class
                AppText(
                  context.l10n.aboutThisClass,
                  style: (context) =>
                      AppTextStyles.heading1(context).copyWith(
                        color:
                        isDark ? AppColors.lightText : AppColors.darkText,
                        fontSize: size.width * 0.055 > 18
                            ? 18
                            : size.width * 0.055,
                        fontWeight: FontWeight.w400,
                      ),
                ),
                const SizedBox(height: AppSpacing.sm),
                AppText(
                  'This dynamic class focuses on building core strength and improving flexibility. Perfect for all levels, you\'ll flow through a series of controlled movements that challenge your body while promoting mindfulness and balance.',
                  style: (context) => AppTextStyles.bodyText(context).copyWith(
                    height: 1.6,
                  ),
                  maxLines: 5,
                ),
                const SizedBox(height: AppSpacing.xl),

                // What to Bring
                AppText(
                  context.l10n.whatToBring, // Fix later if typo in arb
                  style: (context) =>
                      AppTextStyles.heading1(context).copyWith(
                        color:
                        isDark ? AppColors.lightText : AppColors.darkText,
                        fontSize: size.width * 0.055 > 18
                            ? 18
                            : size.width * 0.055,
                        fontWeight: FontWeight.w400,
                      ),
                ),
                const SizedBox(height: AppSpacing.sm),
                _BulletList(
                  items: [
                    'Comfortable workout attire',
                    'Water bottle',
                    'Towel (optional)',
                    'Mat provided at studio',
                  ],
                ),
                const SizedBox(height: AppSpacing.xl),

                // Recent Reviews
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: AppText(
                        context.l10n.recentReviews,
                        style: (context) =>
                            AppTextStyles.heading1(context).copyWith(
                              color:
                              isDark ? AppColors.lightText : AppColors.darkText,
                              fontSize: size.width * 0.055 > 18
                                  ? 18
                                  : size.width * 0.055,
                              fontWeight: FontWeight.w400,
                            ),
                      ),
                    ),
                    AppText(
                      context.l10n.seeAll,
                      style: (context) =>
                          AppTextStyles.captionText(context).copyWith(
                            color: isDark
                                ? AppColors.languageTextDark
                                : AppColors.languageIcon,
                            fontSize: size.width * 0.03 > 14
                                ? 14
                                : size.width * 0.03,
                          ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.md),

                // Reviews Summary
                _LargeCard(
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
                              _StarRating(rating: 5, size: 14),
                              const SizedBox(height: 4),
                              AppText(
                                'Based on 27 reviews',
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
                      Column(
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
            ),
          ),

          // Sticky Button
          Positioned(
            left: 0,
            right: 0,
            bottom: size.height*0.08,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.splashBackgroundDark,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppRadius.pillRadius),
                  ),
                  minimumSize: const Size(double.infinity, 48),
                ),
                child: AppText(
                  context.l10n.bookThisClass,
                  style: (context) => AppTextStyles.button(context).copyWith(
                    fontSize: size.width * 0.04 > 16 ? 16 : size.width * 0.04,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final String label;
  final String value;
  final bool showAvatar;

  const _InfoCard({
    required this.label,
    required this.value,
    this.showAvatar = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
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
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AppText(
            label,
            style: (context) => AppTextStyles.captionText(context).copyWith(
              color: isDark ? AppColors.lightGrey : AppColors.lightGrey,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Row(
            children: [
              if (showAvatar) ...[
                CircleAvatar(
                  radius: 12,
                  backgroundColor: isDark ? AppColors.languageIconDark : AppColors.languageIcon,
                  child: AppText(
                    'A',
                    style: (context) => AppTextStyles.captionText(context).copyWith(
                      color: isDark ? AppColors.darkGreyText : AppColors.greyText,
                      fontSize: 12,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
              ],
              Expanded(
                child: AppText(
                  value,
                  style: (context) => AppTextStyles.boldBody(context).copyWith(
                    fontSize: 14,
                    color: isDark ? AppColors.lightText : AppColors.darkText,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _LargeCard extends StatelessWidget {
  final Widget child;

  const _LargeCard({required this.child});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: isDark ? AppColors.homeBackground : AppColors.whiteColor,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(
          color: isDark ? AppColors.greyText : AppColors.buttonBorder,
        ),
      ),
      child: child,
    );
  }
}

class _BulletList extends StatelessWidget {
  final List<String> items;

  const _BulletList({required this.items});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: items.map((item) {
        return Padding(
          padding: const EdgeInsets.only(bottom: AppSpacing.xs),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.only(top: 8.0),
                child: Icon(Icons.circle, size: 6, color: AppColors.greyText),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: AppText(
                  item,
                  style: (context) => AppTextStyles.bodyText(context),
                ),
              ),
            ],
          ),
        );
      }).toList(),
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
                    'Jessica M.',
                    style: (context) => AppTextStyles.boldBody(context).copyWith(
                      color: isDark ? AppColors.lightText : AppColors.darkText,
                    ),
                  ),
                  AppText(
                    '2 days ago',
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
            '"Sarah is incredible! Her classes are challenging but she makes sure everyone feels supported. I\'ve seen amazing progress in my core strength."',
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
