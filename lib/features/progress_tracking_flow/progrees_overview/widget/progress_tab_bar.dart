import 'package:flutter/material.dart';
import 'package:pilates_app/config/theme/app_colors.dart';
import 'package:pilates_app/config/theme/app_text_styles.dart';

import '../../../../core/localization/localization_extension.dart';

PreferredSizeWidget progressTabBar({
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
    dividerColor: Colors.transparent,
    dividerHeight: 1,
    indicatorColor: isDark ? AppColors.darkGreyBorder : AppColors.primary,
    labelPadding: const EdgeInsets.symmetric(horizontal: 9),
    indicatorPadding: const EdgeInsets.symmetric(horizontal: -12),

    tabs: [
      Tab(text: context.l10n.progress_tab_overview),
      Tab(text: context.l10n.progress_tab_history),
      Tab(text: context.l10n.progress_tab_achievements),
    ],
  );
}
