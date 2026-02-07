import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pilates_app/config/theme/app_colors.dart';
import 'package:pilates_app/config/theme/app_radius.dart';
import 'package:pilates_app/config/theme/app_spacing.dart';
import 'package:pilates_app/config/theme/app_text_styles.dart';
import 'package:pilates_app/core/localization/localization_extension.dart';
import 'package:pilates_app/widgets/app_text.dart';
import '../cubit/home_state.dart';

class MembershipCard extends StatelessWidget {
  final HomeUserStatus status;

  const MembershipCard({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    switch (status) {
      case HomeUserStatus.empty:
        return _buildEmptyCard(context);
      case HomeUserStatus.existing:
        return _buildExistingCard(context);
      case HomeUserStatus.expired:
        return _buildExpiredCard(context);
    }
  }

  Widget _buildEmptyCard(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      // padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg,vertical: AppSpacing.md),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppRadius.md),
        color: AppColors.splashBackgroundDark,
        // image: const DecorationImage(
        //   image: NetworkImage('https://www.transparenttextures.com/patterns/carbon-fibre.png'),
        //   opacity: 0.1,
        //   fit: BoxFit.cover,
        // ),
      ),
      child: Stack(
        children: [
          Positioned(
            right: 0,
            bottom: 0,
            top: 0,
            child: Opacity(
              opacity: 1,
              child: SvgPicture.asset(
                'assets/images/svg/ic_card_background_lines.svg',
                fit: BoxFit.fill,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.lg,
              vertical: AppSpacing.md,
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
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
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              AppText(
                                context.l10n.noActiveSubscriptions,
                                style: (context) =>
                                    AppTextStyles.heading1(context).copyWith(
                                      color: AppColors.seekBarLight,
                                      fontSize: 16,
                                    ),
                              ),
                              AppText(
                                context.l10n.startJourneyToday,
                                style: (context) => AppTextStyles.captionText(
                                  context,
                                ).copyWith(color: AppColors.lightGreyText),
                              ),
                            ],
                          ),
                          const SizedBox(height: AppSpacing.sm),
                          ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.whiteColor,
                              // foregroundColor: const Color(0xFF65422C),
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                  AppRadius.pillRadius,
                                ),
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: AppSpacing.lg,
                                vertical: AppSpacing.sm,
                              ),
                              minimumSize: const Size(0, 32),
                            ),
                            child: AppText(
                              context.l10n.viewPlans,
                              style: (context) =>
                                  AppTextStyles.boldBody(context).copyWith(
                                    color: isDark
                                        ? AppColors.blackColor
                                        : AppColors.darkText,
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
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExistingCard(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.lg,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppRadius.md),
        color: AppColors.splashBackgroundDark,
        // image: const DecorationImage(
        //   image: NetworkImage('https://www.transparenttextures.com/patterns/carbon-fibre.png'),
        //   opacity: 0.1,
        //   fit: BoxFit.cover,
        // ),
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText(
                  context.l10n.premiumMember,
                  style: (context) =>
                      AppTextStyles.heading1(context).copyWith(
                        color: AppColors.seekBarLight,
                        fontSize: 16,
                      ),
                ),
                AppText(
                  context.l10n.unlimitedClasses,
                  style: (context) => AppTextStyles.captionText(
                    context,
                  ).copyWith(color: AppColors.lightGreyText),
                ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.whiteColor,
              // foregroundColor: const Color(0xFF65422C),
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(
                  AppRadius.pillRadius,
                ),
              ),
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.md,
                vertical: AppSpacing.sm,
              ),
              minimumSize: const Size(0, 32),
            ),
            child: AppText(
              context.l10n.viewPlans,
              style: (context) =>
                  AppTextStyles.boldBody(context).copyWith(
                    color: isDark
                        ? AppColors.blackColor
                        : AppColors.darkText,
                    fontSize: size.width * 0.035 > 14
                        ? 14
                        : size.width * 0.035,
                  ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExpiredCard(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.lg,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppRadius.md),
        color: isDark
            ? AppColors.primaryDarkButton
            : AppColors.cardLightBackground,
        // image: const DecorationImage(
        //   image: NetworkImage('https://www.transparenttextures.com/patterns/carbon-fibre.png'),
        //   opacity: 0.1,
        //   fit: BoxFit.cover,
        // ),
      ),
      child: Row(
        children: [
          Container(
            child: SvgPicture.asset(
              isDark
                  ? 'assets/images/svg/ic_king.svg'
                  : 'assets/images/svg/ic_king_gold.svg',
              width: size.width * 0.05,
              height: size.height * 0.05,
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText(
                  context.l10n.membershipExpired,
                  style: (context) => AppTextStyles.heading1(context).copyWith(
                    color: isDark ? AppColors.seekBarLight : AppColors.darkText,
                    fontSize: 16,
                  ),
                ),
                AppText(
                  context.l10n.expiredOn("29 Jan, 2024"),
                  style: (context) =>
                      AppTextStyles.captionText(context).copyWith(
                        color: isDark
                            ? AppColors.lightGreyText
                            : AppColors.redLight,
                      ),
                ),
              ],
            ),
          ),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppRadius.pillRadius),
              gradient: const LinearGradient(
                begin: Alignment.bottomLeft,
                end: Alignment.topRight,
                colors: [Color(0xFF65422C), Color(0xFFC79B7F)],
              ),
            ),
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                foregroundColor: Colors.white,
                shadowColor: Colors.transparent,
                surfaceTintColor: Colors.transparent,
                elevation: 0,
                padding: const EdgeInsets.symmetric(
                  // 🔥 SAME AS OTHER BUTTON
                  horizontal: AppSpacing.lg,
                  vertical: AppSpacing.sm,
                ),
                // shape: RoundedRectangleBorder(
                //   borderRadius: BorderRadius.circular(AppRadius.pillRadius),
                // ),
                minimumSize: const Size(0, 32),
              ),
              child: AppText(
                context.l10n.renew,
                style: (context) => AppTextStyles.boldBody(context).copyWith(
                  fontSize: size.width * 0.035 > 14 ? 14 : size.width * 0.035,
                  color: AppColors.lightText,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
