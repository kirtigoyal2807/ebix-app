import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart' as intl;
import 'package:pilates_app/config/theme/app_colors.dart';
import 'package:pilates_app/config/theme/app_spacing.dart';
import 'package:pilates_app/config/theme/app_text_styles.dart';
import 'package:pilates_app/core/localization/localization_extension.dart';
import 'package:pilates_app/core/utils/badge_share.dart';
import 'package:pilates_app/features/loyalty/data/models/loyalty_badge.dart';
import 'package:pilates_app/widgets/app_button.dart';
import 'package:pilates_app/widgets/app_text.dart';

class BadgeSheetBottomSheet extends StatelessWidget {
  const BadgeSheetBottomSheet({super.key, required this.badge});

  final LoyaltyBadge badge;

  @override
  Widget build(BuildContext context) {
    final isRTL = Directionality.of(context) == TextDirection.rtl;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final locale = Localizations.localeOf(context).toLanguageTag();
    final description = badge.description?.trim() ?? '';
    final earnedWhen = badge.earnedAt != null
        ? intl.DateFormat.yMMMd(locale).format(badge.earnedAt!.toLocal())
        : null;

    return Material(
      color: isDark ? AppColors.homeBackground : Colors.white,
      borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(vertical: AppSpacing.lg),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                      left: isRTL ? AppSpacing.base : AppSpacing.lg,
                      right: isRTL ? AppSpacing.lg : AppSpacing.base,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Align(
                          alignment: Alignment.centerRight,
                          child: IconButton(
                            icon: const Icon(
                              Icons.close,
                              color: AppColors.arrowIcon,
                            ),
                            onPressed: () => Navigator.of(context).pop(),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        _BadgeSheetLead(badge: badge, isDark: isDark),
                        SizedBox(height: AppSpacing.md),
                        AppText(
                          badge.name.trim().isNotEmpty
                              ? badge.name
                              : badge.badgeKey,
                          style: (context) => AppTextStyles.appBarText(
                            context,
                          ).copyWith(fontSize: 18),
                          textAlign: TextAlign.center,
                        ),
                        if (description.isNotEmpty) ...[
                          SizedBox(height: AppSpacing.sm),
                          AppText(
                            description,
                            style: (context) =>
                                AppTextStyles.bodyText(context).copyWith(
                              height: 1.35,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                        SizedBox(height: AppSpacing.md),
                        if (badge.isEarned && earnedWhen != null)
                          AppText(
                            context.l10n.badge_earned_on(earnedWhen),
                            style: (context) =>
                                AppTextStyles.bodyText(context).copyWith(
                              height: 1.55,
                              color: isDark
                                  ? AppColors.successBorderDark
                                  : AppColors.successColor,
                            ),
                            textAlign: TextAlign.center,
                          )
                        else
                          AppText(
                            context.l10n.locked,
                            style: (context) =>
                                AppTextStyles.bodyLightText(context).copyWith(
                              height: 1.55,
                            ),
                            textAlign: TextAlign.center,
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: double.infinity,
              padding: EdgeInsets.fromLTRB(
                AppSpacing.lg,
                0,
                AppSpacing.lg,
                AppSpacing.bottomActionPadding,
              ),
              child: Builder(
                builder: (buttonContext) {
                  return AppButton(
                    label: context.l10n.share_badge,
                    onPressed: () async {
                      final ok = await shareLoyaltyBadge(
                        context: buttonContext,
                        badge: badge,
                        formattedEarnedDate: earnedWhen,
                      );
                      if (buttonContext.mounted && ok) {
                        Navigator.of(buttonContext).pop();
                      }
                    },
                    variant: AppButtonVariant.primary,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BadgeSheetLead extends StatelessWidget {
  const _BadgeSheetLead({required this.badge, required this.isDark});

  final LoyaltyBadge badge;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final url = badge.iconUrl;
    if (url != null && url.isNotEmpty) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Image.network(
          url,
          height: 72,
          width: 72,
          fit: BoxFit.cover,
          errorBuilder: (_, _, _) => _svg(isDark),
        ),
      );
    }
    return _svg(isDark);
  }

  Widget _svg(bool isDark) {
    return SvgPicture.asset(
      isDark
          ? 'assets/images/svg/progress_tracking/ic_dark_consistency_flow.svg'
          : 'assets/images/svg/progress_tracking/ic_consistency_flow.svg',
      height: 72,
      width: 72,
    );
  }
}
