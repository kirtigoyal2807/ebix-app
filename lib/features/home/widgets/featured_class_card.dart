import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import 'package:pilates_app/config/theme/app_colors.dart';
import 'package:pilates_app/config/theme/app_radius.dart';
import 'package:pilates_app/config/theme/app_spacing.dart';
import 'package:pilates_app/config/theme/app_text_styles.dart';
import 'package:pilates_app/core/localization/localization_extension.dart';
import 'package:pilates_app/features/auth/cubit/auth_cubit.dart';
import 'package:pilates_app/features/auth/data/models/auth_user.dart';
import 'package:pilates_app/features/booking/booking_entitlements.dart';
import 'package:pilates_app/features/home/data/models/home_response.dart';
import 'package:pilates_app/widgets/app_text.dart';

import '../../../widgets/app_shadow.dart';
import '../../booking/views/class_detail_view.dart';
import 'package:pilates_app/widgets/class_plan_badges.dart';

class FeaturedClassCard extends StatelessWidget {
  const FeaturedClassCard({super.key, required this.featuredClass});

  final HomeFeaturedClass featuredClass;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final size = MediaQuery.sizeOf(context);
    final imageHeight = size.height * 0.18;
    final user = context.select<AuthCubit, AuthUser?>((c) => c.state.user);
    final showInPlanBadge =
        featuredClass.inPlan == true && userShowsPackageMembership(user);
    final upgradeRequired = featuredClass.showsUpgradeRequired;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : Colors.white,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(
          color: isDark ? AppColors.greyText : AppColors.buttonBorder,
        ),
        boxShadow: isDark
            ? null
            : [
                AppShadows.lightShadow,
                AppShadows.mediumShadow,
                AppShadows.mediumHeavyShadow,
                BoxShadow(
                  color: AppColors.shadowColor.withValues(alpha: 0.01),
                  offset: const Offset(0, 64),
                  blurRadius: 25,
                  spreadRadius: 0,
                ),
                BoxShadow(
                  color: AppColors.shadowColor.withValues(alpha: 0.00),
                  offset: const Offset(0, 99),
                  blurRadius: 28,
                  spreadRadius: 0,
                ),
              ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(AppRadius.md),
            ),
            child: SizedBox(
              width: double.infinity,
              height: imageHeight,
              child: Image.network(
                featuredClass.image ?? '',
                width: double.infinity,
                height: imageHeight,
                fit: BoxFit.cover,
                errorBuilder: (dynamic _, dynamic _, dynamic _) => Image.asset(
                  'assets/images/demo images/Class Image.png',
                  width: double.infinity,
                  height: imageHeight,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          if (showInPlanBadge || upgradeRequired)
            Padding(
              padding: EdgeInsets.only(
                right: AppSpacing.md,
                left: AppSpacing.md,
                top: AppSpacing.base,
              ),
              child: Row(
                children: [
                  if (showInPlanBadge)
                    const Flexible(child: InYourPlanBadge()),
                  if (upgradeRequired)
                    const Flexible(child: UpgradeRequiredBadge()),
                ],
              ),
          ),
          Padding(
            padding: EdgeInsets.only(
              right: AppSpacing.md,
              left: AppSpacing.md,
              bottom: AppSpacing.md,
              top: (showInPlanBadge || upgradeRequired)
                  ? AppSpacing.sm
                  : AppSpacing.base,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  text: TextSpan(
                    text: featuredClass.className ?? context.l10n.powerPilates,
                    style: AppTextStyles.boldBody(context).copyWith(
                      fontSize: size.width * 0.04 > 16 ? 16 : size.width * 0.04,
                      color: isDark ? AppColors.lightText : AppColors.darkText,
                    ),
                    children: [
                      if ((featuredClass.trainerName ?? '')
                          .trim()
                          .isNotEmpty) ...[
                        TextSpan(
                          text: ' ${context.l10n.withKey} ',
                          style: AppTextStyles.bodyText(context).copyWith(
                            fontSize: size.width * 0.04 > 16
                                ? 16
                                : size.width * 0.04,
                          ),
                        ),
                        TextSpan(
                          text: featuredClass.trainerName,
                          style: AppTextStyles.boldBody(context).copyWith(
                            fontSize: size.width * 0.04 > 16
                                ? 16
                                : size.width * 0.04,
                            color: isDark
                                ? AppColors.lightText
                                : AppColors.darkText,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),

                SizedBox(height: AppSpacing.xs),
                AppText(
                  _buildSubtitle(context),
                  style: (context) =>
                      AppTextStyles.captionText(context).copyWith(
                        fontSize: size.width * 0.03 > 14
                            ? 14
                            : size.width * 0.03,
                        color: isDark
                            ? AppColors.darkGreyText
                            : AppColors.lightGrey,
                      ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: AppSpacing.md),
                ElevatedButton(
                  onPressed: () {
                    final classId = featuredClass.classId?.trim() ?? '';
                    if (classId.isEmpty) return;
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => ClassDetailView(classId: classId),
                      ),
                    );
                  },
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

  String _buildSubtitle(BuildContext context) {
    final values = <String>[];
    final branch = featuredClass.branchName?.trim();
    if (branch != null && branch.isNotEmpty) {
      values.add(branch);
    }
    if (featuredClass.startAt != null) {
      values.add(DateFormat('MMM d, h:mm a').format(featuredClass.startAt!));
    }
    if (featuredClass.spotsLeft != null) {
      values.add(context.l10n.spotsLeft(featuredClass.spotsLeft!));
    }
    return values.join(' • ');
  }
}
