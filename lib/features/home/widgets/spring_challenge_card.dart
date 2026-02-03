import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pilates_app/config/theme/app_colors.dart';
import 'package:pilates_app/config/theme/app_radius.dart';
import 'package:pilates_app/config/theme/app_spacing.dart';
import 'package:pilates_app/config/theme/app_text_styles.dart';
import 'package:pilates_app/core/localization/localization_extension.dart';
import 'package:pilates_app/widgets/app_text.dart';

class SpringChallengeCard extends StatefulWidget {
  const SpringChallengeCard({super.key});

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
    final size = MediaQuery.sizeOf(context);
    final cardHeight = size.height * 0.25 > 200 ? 200.0 : size.height * 0.25;

    return Column(
      children: [
        SizedBox(
          height: cardHeight,
          child: PageView.builder(
            controller: _pageController,
            onPageChanged: (index) => setState(() => _currentPage = index),
            itemCount: 3, // For demonstration
            itemBuilder: (context, index) {
              return _buildCard(context, cardHeight);
            },
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        _buildPageIndicator(),
      ],
    );
  }

  Widget _buildCard(BuildContext context, double height) {
    final size = MediaQuery.sizeOf(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppSpacing.xs),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppRadius.lg),
        gradient: const LinearGradient(
          begin: Alignment.bottomLeft,
          end: Alignment.topRight,
          colors: [
            Color(0xFF65422C),
            Color(0xFF8B6C5A),
          ],
        ),
      ),
      child: Stack(
        children: [
          // Background Illustration
          Positioned(
            right: 0,
            bottom: 0,
            top: 0,
            child: Opacity(
              opacity: 0.3,
              child: SvgPicture.asset(
                'assets/images/svg/ic_onboarding.svg',
                height: height,
                fit: BoxFit.contain,
              ),
            ),
          ),

          // Content
          Padding(
            padding: EdgeInsets.all(size.height < 667 ? AppSpacing.md : AppSpacing.xl),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: size.width * 0.55,
                  child: AppText(
                    context.l10n.springResetChallenge,
                    style: (context) => AppTextStyles.heading1(context).copyWith(
                      color: Colors.white,
                      fontSize: size.width * 0.055 > 22 ? 22 : size.width * 0.055,
                      height: 1.1,
                    ),
                  ),
                ),
                SizedBox(height: size.height < 667 ? 2 : AppSpacing.xs),
                AppText(
                  '21 days to renewed energy',
                  style: (context) => AppTextStyles.bodyText(context).copyWith(
                    color: Colors.white.withOpacity(0.8),
                    fontSize: size.width * 0.035 > 14 ? 14 : size.width * 0.035,
                  ),
                ),
                SizedBox(height: size.height < 667 ? AppSpacing.md : AppSpacing.lg),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isDark
                        ? AppColors.primaryDarkButton
                        : AppColors.whiteColor,
                    foregroundColor: const Color(0xFF65422C),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppRadius.pillRadius),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.lg,
                      vertical: AppSpacing.sm,
                    ),
                    minimumSize: const Size(0, 32),
                  ),
                  child: AppText(
                    context.l10n.startYourJourney,
                    style: (context) => AppTextStyles.boldBody(context).copyWith(
                      color: const Color(0xFF65422C),
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

  Widget _buildPageIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(3, (index) {
        final isSelected = _currentPage == index;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          height: 4,
          width: isSelected ? 24 : 12,
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFF65422C) : const Color(0xFFD9D9D9),
            borderRadius: BorderRadius.circular(2),
          ),
        );
      }),
    );
  }
}
