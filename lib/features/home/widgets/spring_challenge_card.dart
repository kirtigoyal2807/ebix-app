import 'package:flutter/material.dart';
import 'package:pilates_app/config/theme/app_colors.dart';
import 'package:pilates_app/config/theme/app_radius.dart';
import 'package:pilates_app/config/theme/app_spacing.dart';
import 'package:pilates_app/config/theme/app_text_styles.dart';
import 'package:pilates_app/core/localization/localization_extension.dart';
import 'package:pilates_app/features/home/data/models/home_response.dart';
import 'package:pilates_app/widgets/app_text.dart';

class SpringChallengeCard extends StatefulWidget {
  const SpringChallengeCard({
    super.key,
    required this.banners,
    required this.onBannerTap,
  });

  final List<HomeBanner> banners;
  final ValueChanged<HomeBanner> onBannerTap;

  @override
  State<SpringChallengeCard> createState() => _SpringChallengeCardState();
}

class _SpringChallengeCardState extends State<SpringChallengeCard> {
  final PageController _pageController = PageController(viewportFraction: 0.92);
  int _currentPage = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.banners.isEmpty) {
      return const SizedBox.shrink();
    }

    final size = MediaQuery.sizeOf(context);
    final cardHeight = (size.height * 0.25).clamp(180.0, 200.0);

    return Column(
      children: [
        SizedBox(
          height: cardHeight,
          child: PageView.builder(
            controller: _pageController,
            onPageChanged: (index) => setState(() => _currentPage = index),
            itemCount: widget.banners.length,
            itemBuilder: (context, index) {
              return _buildCard(context, cardHeight, widget.banners[index]);
            },
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        _buildPageIndicator(),
      ],
    );
  }

  Widget _buildCard(BuildContext context, double height, HomeBanner banner) {
    final size = MediaQuery.sizeOf(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppSpacing.xs),
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppRadius.lg),
        gradient: const LinearGradient(
          begin: Alignment.bottomRight,
          end: Alignment.topLeft,
          colors: [
            // Color(0xFF65422C),
            // Color(0xFFC4A089),
            Color(0xff65422C),
            Color(0xffB28E77),
          ],
        ),
      ),
      child: Stack(
        children: [
          Positioned.fill(
            child: Image.network(
              banner.imageUrl ?? '',
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) {
                return Container(color: AppColors.splashBackgroundDark);
              },
              loadingBuilder: (context, child, progress) {
                if (progress == null) {
                  return child;
                }
                return Container(color: AppColors.splashBackgroundDark);
              },
            ),
          ),
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    Colors.black.withValues(alpha: 0.45),
                    Colors.black.withValues(alpha: 0.1),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(
              size.height < 700 ? AppSpacing.md : AppSpacing.lmd,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: size.width * 0.5,
                  child: AppText(
                    banner.title ?? context.l10n.springResetChallenge,
                    maxLines: 2,
                    style: (context) =>
                        AppTextStyles.heading1(context).copyWith(
                          color: isDark ? AppColors.lightText : Colors.white,
                          fontSize: size.width * 0.055 > 22
                              ? 22
                              : size.width * 0.055,
                          height: 1.1,
                        ),
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                AppText(
                  banner.subtitle ?? context.l10n.springResetDesc,
                  maxLines: 1,
                  style: (context) =>
                      AppTextStyles.bodyTextSmall(context).copyWith(
                        color: isDark ? AppColors.seekBarLight : Colors.white,
                        fontSize: size.width * 0.035 > 14
                            ? 14
                            : size.width * 0.035,
                      ),
                ),
                Spacer(),
                // SizedBox(height: size.height < 700 ? AppSpacing.md : AppSpacing.lg),
                ElevatedButton(
                  onPressed: () => widget.onBannerTap(banner),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.whiteColor,
                    // foregroundColor: const Color(0xFF65422C),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppRadius.pillRadius),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.md,
                      vertical: AppSpacing.sm,
                    ),
                    minimumSize: const Size(0, 32),
                  ),
                  child: AppText(
                    context.l10n.startYourJourney,
                    maxLines: 1,
                    style: (context) =>
                        AppTextStyles.boldBody(context).copyWith(
                          color: isDark
                              ? AppColors.blackColor
                              : AppColors.languageIcon,
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

  Widget _buildPageIndicator() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(widget.banners.length, (index) {
        final isSelected = _currentPage == index;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          height: 4,
          width: isSelected ? 24 : 12,
          decoration: BoxDecoration(
            color: isSelected
                ? (isDark ? AppColors.languageIconDark : AppColors.languageIcon)
                : (isDark
                      ? AppColors.lightBlackColor
                      : AppColors.darkGreyBorder),
            borderRadius: BorderRadius.circular(2),
          ),
        );
      }),
    );
  }
}
