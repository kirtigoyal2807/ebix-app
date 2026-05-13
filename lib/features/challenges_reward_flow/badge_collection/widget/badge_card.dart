import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pilates_app/config/theme/app_colors.dart';
import 'package:pilates_app/config/theme/app_spacing.dart';
import 'package:pilates_app/core/localization/localization_extension.dart';
import 'package:pilates_app/features/loyalty/data/models/loyalty_badge.dart';
import 'package:pilates_app/widgets/app_text.dart';

import '../../../../config/theme/app_radius.dart';
import '../../../../config/theme/app_text_styles.dart';
import '../cubit/badge_cubit.dart';
import '../cubit/badge_state.dart';
import 'badge_sheet.dart';

class BadgeCard extends StatelessWidget {
  const BadgeCard({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return BlocBuilder<BadgeCubit, BadgeState>(
      buildWhen: (p, c) =>
          p.badges != c.badges ||
          p.selectedBadgeTypeKey != c.selectedBadgeTypeKey ||
          p.status != c.status,
      builder: (context, state) {
        final items = state.filteredBadges;
        if (items.isEmpty) {
          return Padding(
            padding: EdgeInsets.symmetric(vertical: AppSpacing.xl),
            child: AppText(
              context.l10n.contentNoDataAvailable,
              style: (c) =>
                  AppTextStyles.bodyLightText(c).copyWith(height: 1.55),
            ),
          );
        }
        return GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: AppSpacing.md,
            crossAxisSpacing: AppSpacing.md,
          ),
          itemCount: items.length,
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemBuilder: (context, index) {
            final badge = items[index];
            return GestureDetector(
              onTap: () {
                showModalBottomSheet<void>(
                  context: context,
                  isScrollControlled: true,
                  barrierColor: AppColors.bottomSheetShadow,
                  builder: (_) => BadgeSheetBottomSheet(badge: badge),
                );
              },
              child: Container(
                padding: EdgeInsets.all(AppSpacing.md),
                decoration: BoxDecoration(
                  color: isDark
                      ? AppColors.homeBackground
                      : AppColors.whiteColor,
                  border: Border.all(
                    color: badge.isEarned
                        ? (isDark ? AppColors.darkGreyBorder : AppColors.primary)
                        : (isDark
                            ? AppColors.greyText
                            : AppColors.buttonBorder),
                  ),
                  borderRadius: BorderRadius.circular(AppRadius.md),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    _BadgeThumb(badge: badge, isDark: isDark),
                    SizedBox(height: AppSpacing.md),
                    Flexible(
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            AppText(
                              badge.name.trim().isNotEmpty
                                  ? badge.name
                                  : badge.badgeKey,
                              style: (context) =>
                                  AppTextStyles.textFieldHeading(context),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: 2),
                            AppText(
                              badge.isEarned
                                  ? context.l10n.earned
                                  : context.l10n.locked,
                              style: (context) =>
                                  AppTextStyles.bodyLightText(
                                    context,
                                  ).copyWith(fontSize: 12),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}

class _BadgeThumb extends StatelessWidget {
  const _BadgeThumb({required this.badge, required this.isDark});

  final LoyaltyBadge badge;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final url = badge.iconUrl;
    if (url != null && url.isNotEmpty) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.network(
          url,
          height: 56,
          width: 56,
          fit: BoxFit.cover,
          errorBuilder: (_, _, _) => _fallbackSvg(isDark),
        ),
      );
    }
    return _fallbackSvg(isDark);
  }

  Widget _fallbackSvg(bool isDark) {
    return SvgPicture.asset(
      isDark
          ? 'assets/images/svg/progress_tracking/ic_dark_consistency_flow.svg'
          : 'assets/images/svg/progress_tracking/ic_consistency_flow.svg',
      height: 56,
      width: 56,
    );
  }
}
