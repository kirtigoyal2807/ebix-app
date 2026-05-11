import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pilates_app/config/theme/app_spacing.dart';
import 'package:pilates_app/config/theme/app_text_styles.dart';
import 'package:pilates_app/config/theme/app_colors.dart';
import 'package:pilates_app/core/localization/localization_extension.dart';

import '../../../../widgets/app_button.dart';
import '../../../../widgets/app_text.dart';
import '../../badge_collection/badge_collection_view.dart';

class BadgeSheetBottomSheet extends StatelessWidget {
  final String imageIcon;
  final String title;

  const BadgeSheetBottomSheet({
    super.key,
    required this.imageIcon,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    final isRTL = Directionality.of(context) == TextDirection.rtl;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Material(
      color: isDark ? AppColors.homeBackground : Colors.white,
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
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
                  // Header with title and close button
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
                        SvgPicture.asset(imageIcon, height: 72, width: 72),
                        SizedBox(height: AppSpacing.md),
                        AppText(
                          title,
                          style: (context) => AppTextStyles.appBarText(
                            context,
                          ).copyWith(fontSize: 18),
                        ),
                        SizedBox(height: AppSpacing.sm),
                        AppText(
                          context.l10n.badge_complete_classes(10, "February"),
                          style: (context) => AppTextStyles.bodyText(
                            context,
                          ).copyWith(height: 1),
                        ),
                        SizedBox(height: AppSpacing.md),
                        AppText(
                          context.l10n.badge_earned_on(
                            "Feb 10, 2026", // later you can format with intl DateFormat
                          ),
                          style: (context) =>
                              AppTextStyles.bodyText(context).copyWith(
                                height: 1.55,
                                color: isDark
                                    ? AppColors.successBorderDark
                                    : AppColors.successColor,
                              ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Confirm button with white background extending to bottom
            Container(
              width: double.infinity,
              // color: Colors.white,
              padding: EdgeInsets.fromLTRB(
                AppSpacing.lg,
                0,
                AppSpacing.lg,
                AppSpacing.md + 2,
              ),
              child: AppButton(
                label: context.l10n.share_badge,
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BadgeCollectionView(),
                    ),
                  );
                },
                variant: AppButtonVariant.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
