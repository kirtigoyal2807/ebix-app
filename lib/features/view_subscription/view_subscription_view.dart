import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pilates_app/features/auth/cubit/auth_cubit.dart';
import 'package:pilates_app/features/invoice_history/data/subscriptions_repository.dart';
import 'package:pilates_app/features/view_subscription/cubit/subscriptions_cubit.dart';
import 'package:pilates_app/features/view_subscription/view/existing_plan_view.dart';
import 'package:pilates_app/features/view_subscription/widget/subscription_tab_bar.dart';

import '../../config/theme/app_colors.dart';
import '../../config/theme/app_spacing.dart';
import '../../core/localization/localization_extension.dart';
import '../../widgets/app_app_bar.dart';
import 'view/current_plan_view.dart';

/// My Subscriptions — loads §9.3 via [SubscriptionsCubit].
class ViewSubscriptionView extends StatelessWidget {
  const ViewSubscriptionView({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return BlocProvider(
      create: (context) => SubscriptionsCubit(
        context.read<SubscriptionsRepository>(),
        context.read<AuthCubit>(),
      )..load(),
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
            title: context.l10n.mySubscription,
            isMoreMenu: false,
            bottomPreferredSize: PreferredSize(
              preferredSize: const Size.fromHeight(94),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.lg,
                    ),
                    child: subscriptionTabBar(context: context, isDark: isDark),
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
            children: [CurrentPlanView(), ExistingPlanView()],
          ),
        ),
      ),
    );
  }
}
