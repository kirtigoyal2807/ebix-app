import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pilates_app/core/localization/localization_extension.dart';
import 'package:pilates_app/features/auth/data/auth_repository.dart';
import 'package:pilates_app/features/challenges_reward_flow/reward_collection/view/reward_history_view.dart';
import 'package:pilates_app/features/challenges_reward_flow/reward_collection/view/reward_overview_view.dart';
import 'package:pilates_app/features/challenges_reward_flow/reward_collection/widget/reward_tab.dart';
import 'package:pilates_app/features/loyalty/data/loyalty_repository.dart';

import '../../../config/theme/app_colors.dart';
import '../../../config/theme/app_spacing.dart';
import '../../../widgets/app_app_bar.dart';
import 'cubit/reward_cubit.dart';

class RewardView extends StatelessWidget {
  const RewardView({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return BlocProvider(
      create: (context) => RewardCubit(
        context.read<LoyaltyRepository>(),
        context.read<AuthRepository>(),
      )
        ..loadBranches()
        ..loadRewards()
        ..loadPointsHistory(),
      child: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppAppBar(
            leading: Padding(
              padding: const EdgeInsets.only(left: AppSpacing.lmd),
              child: IconButton(
                icon: const Icon(Icons.arrow_back_ios_rounded, size: 20),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
            onBack: () => Navigator.of(context).pop(),
            title: context.l10n.rewards,
            isMoreMenu: false,
            bottomPreferredSize: PreferredSize(
              preferredSize: const Size.fromHeight(94),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.lg,
                    ),
                    child: rewardTabBar(context: context, isDark: isDark),
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
          body: const TabBarView(
            children: [RewardOverviewView(), RewardHistoryView()],
          ),
        ),
      ),
    );
  }
}
