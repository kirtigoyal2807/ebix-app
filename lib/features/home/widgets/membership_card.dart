import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pilates_app/config/theme/app_colors.dart';
import 'package:pilates_app/config/theme/app_radius.dart';
import 'package:pilates_app/config/theme/app_spacing.dart';
import 'package:pilates_app/config/theme/app_text_styles.dart';
import 'package:pilates_app/core/localization/localization_extension.dart';
import 'package:pilates_app/widgets/app_text.dart';
import '../../subscription/purchase_subscription/view/subscription_view.dart';
import '../cubit/home_state.dart';

class MembershipCard extends StatelessWidget {
  final HomeUserStatus status;
  final String? planName;
  final int? totalSessions;

  /// When both [sessionsRemaining] and [totalSessions] are set, subtitle shows
  /// "X of Y classes"; otherwise behavior matches the previous single field.
  final int? sessionsRemaining;

  const MembershipCard({
    super.key,
    required this.status,
    this.planName,
    this.totalSessions,
    this.sessionsRemaining,
  });

  String _sessionSubtitle(BuildContext context) {
    final r = sessionsRemaining;
    final t = totalSessions;
    if (r != null && t != null && t > 0) {
      return context.l10n.membershipClassesRemainingOfTotal(r, t);
    }
    if (r != null && r >= 0) {
      return '$r ${context.l10n.classes}';
    }
    if (t != null && t > 0) {
      return '$t ${context.l10n.classes}';
    }
    return context.l10n.unlimitedClasses;
  }

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
      clipBehavior: Clip.antiAlias,
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
              horizontal: AppSpacing.md,
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
                        width: 40,
                        height: 40,
                        // width: size.width * 0.05,
                        // height: size.height * 0.05,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.base),
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
                                      height: 1,
                                    ),
                              ),
                              SizedBox(height: AppSpacing.sm),

                              AppText(
                                context.l10n.startJourneyToday,
                                style: (context) =>
                                    AppTextStyles.captionText(context).copyWith(
                                      color: AppColors.lightGreyText,
                                      height: 1.2,
                                    ),
                              ),
                            ],
                          ),
                          const SizedBox(height: AppSpacing.md),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => SubscriptionView(),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: isDark
                                  ? AppColors.seekBarLight
                                  : AppColors.lightGreyText,
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

                              // ✂️ Remove extra touch padding
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
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
        horizontal: AppSpacing.md,
        vertical: AppSpacing.md,
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
              width: 40,
              height: 40,
              // width: size.width * 0.05,
              // height: size.height * 0.05,
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText(
                  (planName ?? '').trim().isNotEmpty
                      ? planName!.trim()
                      : context.l10n.premiumMember,
                  style: (context) => AppTextStyles.heading1(
                    context,
                  ).copyWith(color: AppColors.seekBarLight, fontSize: 16),
                ),
                SizedBox(height: 4),
                AppText(
                  _sessionSubtitle(context),
                  style: (context) => AppTextStyles.captionText(
                    context,
                  ).copyWith(color: AppColors.lightGreyText),
                ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SubscriptionView()),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: isDark
                  ? AppColors.seekBarLight
                  : AppColors.whiteColor,
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
              context.l10n.viewPlans,
              style: (context) => AppTextStyles.boldBody(context).copyWith(
                color: isDark ? AppColors.blackColor : AppColors.darkText,
                fontSize: size.width * 0.035 > 14 ? 14 : size.width * 0.035,
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
        horizontal: AppSpacing.md,
        vertical: AppSpacing.md,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppRadius.md),
        color: isDark
            ? AppColors.lightExpireCard.withValues(alpha: 0.32)
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
            height: 40,
            width: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.languageIcon,
            ),
            child: SvgPicture.asset(
              isDark
                  ? 'assets/images/svg/ic_king.svg'
                  : 'assets/images/svg/ic_king_gold.svg',
              width: 20,
              height: 16,
              fit: BoxFit.fill,
              // width: size.width * 0.04,
              // height: size.height * 0.04,
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
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
                SizedBox(height: 4),
                AppText(
                  context.l10n.expiredOn("29 Jan, 2024"),
                  style: (context) =>
                      AppTextStyles.captionText(context).copyWith(
                        color: isDark ? AppColors.redText : AppColors.redLight,
                      ),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 6.5),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(200),
              gradient: const LinearGradient(
                begin: Alignment.bottomLeft,
                end: Alignment.topRight,
                colors: [Color(0xFF65422C), Color(0xFFC79B7F)],
              ),
            ),
            child: AppText(
              context.l10n.renew,
              style: (context) => AppTextStyles.boldBody(context).copyWith(
                fontSize: size.width * 0.035 > 14 ? 14 : size.width * 0.035,
                color: AppColors.lightText,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
