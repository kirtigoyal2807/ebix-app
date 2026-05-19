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
            // Taller than square: thumb + padding + 2-line title + caption.
            childAspectRatio: 0.88,
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
                padding: EdgeInsets.symmetric(
                  horizontal: AppSpacing.md,
                  vertical: AppSpacing.lmd,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(AppRadius.base),
                  border: Border.all(
                    color: isDark
                        ? AppColors.greyText
                        : AppColors.buttonBorder,
                    width: 1,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    _BadgeThumb(badge: badge, isDark: isDark),
                    SizedBox(height: AppSpacing.sm),
                    Flexible(
                      child: AppText(
                        badge.name.trim().isNotEmpty
                            ? badge.name
                            : badge.badgeKey,
                        style: (context) =>
                            AppTextStyles.textFieldHeading(context).copyWith(
                          height: 1.2,
                          fontWeight: FontWeight.w500,
                          color: isDark
                              ? AppColors.lightText
                              : AppColors.darkText,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    SizedBox(height: AppSpacing.xs),
                    AppText(
                      badge.isEarned
                          ? context.l10n.earned
                          : context.l10n.locked,
                      style: (context) => AppTextStyles.captionText(
                        context,
                      ).copyWith(
                        fontSize: 12,
                        height: 1,
                        color: isDark
                            ? AppColors.darkGreyText
                            : AppColors.lightGrey,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
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

Color _badgeAccentColor(LoyaltyBadge badge) {
  if (!badge.isEarned) {
    return AppColors.lightGrey;
  }
  final type = badge.badgeType.toLowerCase();
  if (type.contains('gold')) {
    return AppColors.upgradeDarkLockBackgroundColor;
  }
  if (type.contains('silver')) {
    return AppColors.primaryDark;
  }
  if (type.contains('bronze')) {
    return AppColors.primary;
  }
  return AppColors.primaryDark;
}

class _BadgeThumb extends StatelessWidget {
  const _BadgeThumb({required this.badge, required this.isDark});

  static const double _outerSize = 64;
  static const double _innerSize = 56;
  static const double _iconSize = 28;

  final LoyaltyBadge badge;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final accent = _badgeAccentColor(badge);
    return Container(
      width: _outerSize,
      height: _outerSize,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppRadius.md),
        boxShadow: isDark
            ? [
                BoxShadow(
                  color: AppColors.blackColor.withValues(alpha: 0.45),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ]
            : null,
      ),
      alignment: Alignment.center,
      child: Container(
        width: _innerSize,
        height: _innerSize,
        decoration: BoxDecoration(
          color: accent,
          borderRadius: BorderRadius.circular(AppRadius.sm),
        ),
        clipBehavior: Clip.antiAlias,
        child: _buildIcon(),
      ),
    );
  }

  Widget _buildIcon() {
    final url = badge.iconUrl?.trim();
    if (url != null && url.isNotEmpty) {
      return Image.network(
        url,
        width: _innerSize,
        height: _innerSize,
        fit: BoxFit.cover,
        errorBuilder: (_, _, _) => _fallbackSvg(),
      );
    }
    return _fallbackSvg();
  }

  Widget _fallbackSvg() {
    return Center(
      child: ColorFiltered(
        colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
        child: SvgPicture.asset(
          isDark
              ? 'assets/images/svg/progress_tracking/ic_dark_consistency_flow.svg'
              : 'assets/images/svg/progress_tracking/ic_consistency_flow.svg',
          height: _iconSize,
          width: _iconSize,
        ),
      ),
    );
  }
}
