import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pilates_app/config/theme/app_colors.dart';
import 'package:pilates_app/config/theme/app_radius.dart';
import 'package:pilates_app/config/theme/app_spacing.dart';
import 'package:pilates_app/config/theme/app_text_styles.dart';
import 'package:pilates_app/core/localization/localization_extension.dart';
import 'package:pilates_app/features/subscription/purchase_subscription/view/subscription_view.dart';
import 'package:pilates_app/widgets/app_text.dart';

import '../../my_booking/my_booking_view.dart';

class QuickActions extends StatelessWidget {
  const QuickActions({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Calculate precise width to ensure all items are identical
    final horizontalPadding = AppSpacing.lg;
    final gap = AppSpacing.md;
    final itemWidth = (size.width - (horizontalPadding * 2) - (gap * 2)) / 3;
    final itemPadding = size.width * 0.04;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MyBookingView()),
                );
              },
              child: _buildActionItem(
                context,
                context.l10n.bookNow,
                isDark
                    ? 'assets/images/svg/ic_calendar_dark.svg'
                    : 'assets/images/svg/ic_calendar_light.svg',
                itemPadding,
                itemWidth,
              ),
            ),
            SizedBox(width: gap),
            GestureDetector(
              onTap: (){
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SubscriptionView()),
                );
              },
              child: _buildActionItem(
                context,
                context.l10n.exploreBranches,
                isDark
                    ? 'assets/images/svg/ic_location_dark.svg'
                    : 'assets/images/svg/ic_location_light.svg',
                itemPadding,
                itemWidth,
              ),
            ),
            SizedBox(width: gap),
            _buildActionItem(
              context,
              context.l10n.viewSchedule,
              isDark
                  ? 'assets/images/svg/ic_view_dark.svg'
                  : 'assets/images/svg/ic_view_light.svg',
              itemPadding,
              itemWidth,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionItem(
    BuildContext context,
    String title,
    String icon,
    double padding,
    double width,
  ) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final size = MediaQuery.sizeOf(context);

    return Container(
      width: width,
      padding: EdgeInsets.symmetric(vertical: padding),
      decoration: BoxDecoration(
        color: isDark ? AppColors.homeBackground : AppColors.whiteColor,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(
          color: isDark ? AppColors.greyText : AppColors.buttonBorder,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          // const SizedBox(height: AppSpacing.md),
          SizedBox(
            height: 56,
            child: SvgPicture.asset(
              icon,
              height: 56,
              // width: width * 0.6,
              fit: BoxFit.contain,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Expanded(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: AppText(
                  title,
                  style: (context) => AppTextStyles.body(context).copyWith(
                    color: isDark ? AppColors.lightText : AppColors.darkText,
                    fontSize: 14,
                    // size.width * 0.03 > 12 ? 12 : size.width * 0.03,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ),
          // const SizedBox(height: AppSpacing.sm),
        ],
      ),
    );
  }
}
