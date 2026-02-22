import 'package:flutter/material.dart';
import 'package:pilates_app/core/localization/localization_extension.dart';
import 'package:pilates_app/features/progress_tracking_flow/progrees_overview/view/overview_view.dart';
import 'package:pilates_app/features/progress_tracking_flow/progrees_overview/widget/progress_tab_bar.dart';
import 'package:pilates_app/features/progress_tracking_flow/view_session_history/history_view.dart';

import '../../config/theme/app_colors.dart';
import '../../config/theme/app_spacing.dart';
import '../../widgets/app_app_bar.dart';
import 'achievement/achievement_view.dart';

class ProgressTrackingView extends StatelessWidget {
  const ProgressTrackingView({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: isDark
            ? AppColors.homeBackground
            : AppColors.whiteColor,
        appBar: AppAppBar(
          leading: Padding(
            padding: const EdgeInsets.only(left: AppSpacing.lmd),
            child: IconButton(
              icon: const Icon(Icons.arrow_back_ios_rounded, size: 20),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
          onBack: () => Navigator.of(context).pop(),
          title: context.l10n.progress_tracking_title,
          isMoreMenu: false,

          bottomPreferredSize: PreferredSize(
            preferredSize: const Size.fromHeight(94),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.lg,
                  ),
                  child: progressTabBar(context: context, isDark: isDark),
                ),
                Divider(
                  height: 1,
                  thickness: 1,
                  color: isDark ? AppColors.greyText : AppColors.buttonBorder,
                ),
              ],
            ),
          ),
        ),
        body: TabBarView(
          children: [OverviewView(), HistoryView(), AchievementView()],
        ),
      ),
    );
  }
}
