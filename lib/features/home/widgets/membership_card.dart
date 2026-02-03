import 'package:flutter/material.dart';
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
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppRadius.lg),
        color: AppColors.primaryBrown,
        image: const DecorationImage(
          image: NetworkImage('https://www.transparenttextures.com/patterns/carbon-fibre.png'),
          opacity: 0.1,
          fit: BoxFit.cover,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(AppSpacing.sm),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.workspace_premium, color: Colors.orange, size: 24),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText(
                  context.l10n.noActiveSubscriptions,
                  style: (context) => AppTextStyles.boldBody(context).copyWith(color: Colors.white),
                ),
                AppText(
                  context.l10n.startJourneyToday,
                  style: (context) => AppTextStyles.captionText(context).copyWith(color: Colors.white70),
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: AppColors.primaryBrown,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.pillRadius)),
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
              minimumSize: const Size(0, 32),
            ),
            child: AppText(
              context.l10n.viewPlans,
              style: (context) => AppTextStyles.boldBody(context).copyWith(fontSize: 10, color: AppColors.primaryBrown),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExistingCard(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppRadius.lg),
        color: AppColors.primaryBrown,
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(AppSpacing.sm),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.workspace_premium, color: Colors.orange, size: 20),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText(
                  context.l10n.premiumMember,
                  style: (context) => AppTextStyles.boldBody(context).copyWith(color: Colors.white),
                ),
                AppText(
                  context.l10n.unlimitedClasses,
                  style: (context) => AppTextStyles.captionText(context).copyWith(color: Colors.white70),
                ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: AppColors.primaryBrown,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.pillRadius)),
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
              minimumSize: const Size(0, 32),
            ),
            child: AppText(
              context.l10n.viewPlans,
              style: (context) => AppTextStyles.boldBody(context).copyWith(fontSize: 10, color: AppColors.primaryBrown),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExpiredCard(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppRadius.lg),
        color: const Color(0xFFFEF2F2),
        border: Border.all(color: const Color(0xFFFCA5A5).withOpacity(0.5)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(AppSpacing.sm),
            decoration: BoxDecoration(
              color: const Color(0xFFFFEDD5),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.workspace_premium, color: Colors.orange, size: 20),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText(
                  context.l10n.membershipExpired,
                  style: (context) => AppTextStyles.boldBody(context).copyWith(color: const Color(0xFF991B1B)),
                ),
                AppText(
                  context.l10n.expiredOn("29 Jan, 2024"),
                  style: (context) => AppTextStyles.captionText(context).copyWith(color: const Color(0xFFB91C1C)),
                ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF78350F),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.pillRadius)),
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
              minimumSize: const Size(0, 32),
            ),
            child: AppText(
              context.l10n.renew,
              style: (context) => AppTextStyles.boldBody(context).copyWith(fontSize: 10, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
