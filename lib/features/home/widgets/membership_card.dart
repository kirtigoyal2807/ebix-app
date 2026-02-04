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
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg,vertical: AppSpacing.md),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppRadius.md),
        color: AppColors.primaryBrown,
        // image: const DecorationImage(
        //   image: NetworkImage('https://www.transparenttextures.com/patterns/carbon-fibre.png'),
        //   opacity: 0.1,
        //   fit: BoxFit.cover,
        // ),
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
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppText(
                        context.l10n.noActiveSubscriptions,
                        style: (context) => AppTextStyles.heading1(
                          context,
                        ).copyWith(color: AppColors.seekBarLight, fontSize: 16),
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
                      backgroundColor: Colors.white,
                      foregroundColor: AppColors.primaryBrown,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          AppRadius.pillRadius,
                        ),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.md,
                      ),
                      minimumSize: const Size(0, 32),
                    ),
                    child: AppText(
                      context.l10n.viewPlans,
                      style: (context) => AppTextStyles.boldBody(
                        context,
                      ).copyWith(fontSize: 10, color: AppColors.primaryBrown),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildExistingCard(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg,vertical: AppSpacing.lg),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppRadius.md),
        color: AppColors.primaryBrown,
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
            child:  Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText(
                  context.l10n.premiumMember,
                  style: (context) => AppTextStyles.heading1(
                    context,
                  ).copyWith(color: AppColors.seekBarLight, fontSize: 16),
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
              backgroundColor: Colors.white,
              foregroundColor: AppColors.primaryBrown,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppRadius.pillRadius),
              ),
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
              minimumSize: const Size(0, 32),
            ),
            child: AppText(
              context.l10n.viewPlans,
              style: (context) => AppTextStyles.boldBody(
                context,
              ).copyWith(fontSize: 10, color: AppColors.primaryBrown),
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
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg,vertical: AppSpacing.lg),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppRadius.md),
        color: isDark
            ? AppColors.primaryDarkButton
            : AppColors.primary,
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
            child:  Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText(
                  context.l10n.membershipExpired,
                  style: (context) => AppTextStyles.heading1(
                    context,
                  ).copyWith(color: AppColors.seekBarLight, fontSize: 16),
                ),
                AppText(
                  context.l10n.expiredOn("29 Jan, 2024"),
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
              backgroundColor: const Color(0xFF78350F),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppRadius.pillRadius),
              ),
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
              minimumSize: const Size(0, 32),
            ),
            child: AppText(
              context.l10n.renew,
              style: (context) => AppTextStyles.boldBody(
                context,
              ).copyWith(fontSize: 10, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
