import 'package:flutter/material.dart';
import 'package:pilates_app/config/theme/app_colors.dart';
import 'package:pilates_app/config/theme/app_text_styles.dart';

import '../../../core/localization/localization_extension.dart';

PreferredSizeWidget bookingTabBar({
  required BuildContext context,
  required bool isDark,
}) {
  return TabBar(
    isScrollable: false,
    labelStyle: AppTextStyles.body(context),
    unselectedLabelColor: AppColors.lightGrey,
    unselectedLabelStyle: AppTextStyles.caption(
      context,
    ).copyWith(fontWeight: FontWeight.w400),
    dividerColor: isDark ? AppColors.greyText : AppColors.buttonBorder,
    dividerHeight: 1,
    indicatorColor: isDark ? AppColors.darkGreyBorder : AppColors.primary,

    indicatorPadding: const EdgeInsets.symmetric(horizontal: -12),

    tabs: [
      Tab(text: context.l10n.tabUpcoming),
      Tab(text: context.l10n.tabCurrent),
      Tab(text: context.l10n.tabPast),
      Tab(text: context.l10n.tabCancelled),
    ],
  );
}
