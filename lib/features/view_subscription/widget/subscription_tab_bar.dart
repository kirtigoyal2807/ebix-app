import 'package:flutter/material.dart';
import 'package:pilates_app/config/theme/app_colors.dart';
import 'package:pilates_app/config/theme/app_text_styles.dart';

import '../../../../core/localization/localization_extension.dart';

PreferredSizeWidget subscriptionTabBar({
  required BuildContext context,
  required bool isDark,
}) {
  double indicatorPadding = MediaQuery.of(context).size.width * 0.095;
  return TabBar(
    isScrollable: false,
    labelStyle: AppTextStyles.body(
      context,
      fontWeight: FontWeight.w600,
    ).copyWith(fontSize: 16),
    unselectedLabelColor: AppColors.lightGrey,
    unselectedLabelStyle: AppTextStyles.caption(
      context,
      fontWeight: FontWeight.w400,
    ).copyWith(fontSize: 16),
    dividerColor: Colors.transparent,
    dividerHeight: 1,
    indicatorColor: isDark ? AppColors.darkGreyBorder : AppColors.primary,
    labelPadding: const EdgeInsets.symmetric(horizontal: 9),
    indicatorPadding: EdgeInsets.symmetric(horizontal: -indicatorPadding),
    indicator: BoxDecoration(
      color: Colors.transparent,
      border: Border(
        bottom: BorderSide(
          color: isDark ? AppColors.tabSelectedtLineDark : AppColors.primary,
          width: 2,
        ),
      ),
      borderRadius: BorderRadius.zero, // 👈 this ensures no rounded corners
    ),

    tabs: [
      Tab(text: context.l10n.currentPlan),
      Tab(text: context.l10n.existingPlan),
    ],
  );
}
