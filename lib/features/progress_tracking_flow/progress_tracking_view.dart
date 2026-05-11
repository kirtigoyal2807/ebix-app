import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pilates_app/core/localization/localization_extension.dart';
import 'package:pilates_app/features/loyalty/data/loyalty_repository.dart';
import 'package:pilates_app/features/progress_tracking_flow/achievement/cubit/loyalty_achievements_cubit.dart';
import 'package:pilates_app/features/progress_tracking_flow/data/progress_repository.dart';
import 'package:pilates_app/features/progress_tracking_flow/progrees_overview/cubit/progress_goal_cubit.dart';
import 'package:pilates_app/features/progress_tracking_flow/progrees_overview/cubit/progress_overview_cubit.dart';
import 'package:pilates_app/features/progress_tracking_flow/progrees_overview/cubit/weekly_activity_cubit.dart';
import 'package:pilates_app/features/progress_tracking_flow/progrees_overview/view/overview_view.dart';
import 'package:pilates_app/features/progress_tracking_flow/progrees_overview/widget/progress_tab_bar.dart';
import 'package:pilates_app/features/progress_tracking_flow/view_session_history/cubit/session_history_cubit.dart';
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
    final progressRepo = context.read<ProgressRepository>();
    final loyaltyRepo = context.read<LoyaltyRepository>();
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => ProgressOverviewCubit(progressRepo)..load(),
        ),
        BlocProvider(create: (_) => WeeklyActivityCubit(progressRepo)..load()),
        BlocProvider(create: (_) => ProgressGoalCubit(progressRepo)..load()),
        BlocProvider(create: (_) => SessionHistoryCubit(progressRepo)),
        BlocProvider(
          create: (_) => LoyaltyAchievementsCubit(loyaltyRepo)..load(),
        ),
      ],
      child: DefaultTabController(
        length: 3,
        child: Scaffold(
          backgroundColor: isDark
              ? AppColors.homeBackground
              : AppColors.whiteColor,
          appBar: AppAppBar(
            leading: Padding(
              padding: EdgeInsets.only(left: AppSpacing.lmd),
              child: IconButton(
                icon: const Icon(Icons.arrow_back_ios_rounded, size: 20),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
            onBack: () => Navigator.of(context).pop(),
            title: context.l10n.progress_tracking_title,
            isMoreMenu: false,

            bottomPreferredSize: PreferredSize(
              preferredSize: const Size.fromHeight(110),
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                      left: AppSpacing.lg,
                      right: AppSpacing.lg,
                      top: AppSpacing.md,
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
      ),
    );
  }
}
