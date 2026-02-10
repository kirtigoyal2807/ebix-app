import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:pilates_app/config/theme/app_colors.dart';
import 'package:pilates_app/config/theme/app_spacing.dart';
import 'package:pilates_app/config/theme/app_text_styles.dart';
import 'package:pilates_app/core/localization/arb/app_localizations.dart';
import 'package:pilates_app/features/subscription/purchase_subscription/cubit/subscription_cubit.dart';
import 'package:pilates_app/features/subscription/purchase_subscription/view/widgets/branch_selector.dart';
import 'package:pilates_app/features/subscription/purchase_subscription/view/widgets/gift_toggle_card.dart';
import 'package:pilates_app/features/subscription/purchase_subscription/view/widgets/plan_card.dart';
import 'package:pilates_app/features/subscription/purchase_subscription/view/widgets/plan_details_modal.dart';
import 'package:pilates_app/widgets/app_app_bar.dart';
import 'package:pilates_app/widgets/app_button.dart';
import 'package:pilates_app/widgets/app_text.dart';

class SubscriptionView extends StatelessWidget {
  const SubscriptionView({super.key});

  static const String routePath = '/subscription';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SubscriptionCubit(),
      child: const _SubscriptionViewContent(),
    );
  }
}

class _SubscriptionViewContent extends StatelessWidget {
  const _SubscriptionViewContent();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cubit = context.read<SubscriptionCubit>();
    final l10n = AppLocalizations.of(context);

    // We use a function or build context to get localized strings
    final List<Map<String, dynamic>> plans = [
      {
        'id': 'premium',
        'title': l10n.premiumPlanTitle,
        'price': '89\$',
        'badge': l10n.mostPopular,
        'isPopular': true,
        'features': [
          l10n.feature12Classes,
          l10n.featureDowntownUptown,
          l10n.featureFreeMatEquipment,
          l10n.featurePriorityBooking,
        ]
      },
      {
        'id': 'basic',
        'title': l10n.basicPlanTitle,
        'price': '49\$',
        'badge': l10n.starter, 
        'isPopular': false,
        'features': [
          l10n.feature8Classes,
          l10n.featureDowntownOnly,
          l10n.featureFreeMat,
        ]
      },
      {
        'id': 'unlimited',
        'title': l10n.unlimitedPlanTitle,
        'price': '149\$',
        'badge': null, 
        'features': [
          l10n.featureUnlimitedClasses,
          l10n.featureAllStudios,
          l10n.featureFreeMatEquipment,
          l10n.featurePriorityGuest,
        ]
      },
    ];

    return Scaffold(
      backgroundColor: isDark ? AppColors.homeBackground : AppColors.whiteColor,
      appBar: AppAppBar(
        title: l10n.subscriptionTitle,
        onBack: () => context.pop(),
        isMoreMenu: false,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(vertical: AppSpacing.lg),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                      child: AppText(
                        l10n.chooseYourPlan,
                        style: (context) => AppTextStyles.gelasioMedium(context).copyWith(fontSize: 24),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                      child: AppText(
                        l10n.selectPlanSubtitle,
                        style: AppTextStyles.bodyText,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),

                    // Gift Toggle
                    BlocBuilder<SubscriptionCubit, SubscriptionState>(
                      buildWhen: (previous, current) => previous.isGift != current.isGift,
                      builder: (context, state) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                          child: GiftToggleCard(
                            isGift: state.isGift,
                            onToggle: (val) => cubit.toggleGift(val),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: AppSpacing.md),

                    // Branch Selector
                    BlocBuilder<SubscriptionCubit, SubscriptionState>(
                      buildWhen: (previous, current) => previous.selectedBranchId != current.selectedBranchId,
                      builder: (context, state) {
                        return BranchSelector(
                          branches: const ['Branch A', 'Branch B', 'Branch C', 'Branch D'],
                          selectedBranchId: state.selectedBranchId,
                          onSelect: (branchId) => cubit.selectBranch(branchId),
                        );
                      },
                    ),
                    const SizedBox(height: AppSpacing.md),

                    // Plans List
                    BlocBuilder<SubscriptionCubit, SubscriptionState>(
                      buildWhen: (previous, current) => previous.selectedPlanId != current.selectedPlanId,
                      builder: (context, state) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                          child: Column(
                            children: plans.map((plan) {
                              return PlanCard(
                                id: plan['id'],
                                title: plan['title'],
                                price: plan['price'],
                                isSelected: state.selectedPlanId == plan['id'],
                                isPopular: plan['isPopular'] ?? false,
                                badgeText: plan['badge'],
                                onTap: () {
                                  cubit.selectPlan(plan['id']);
                                  showModalBottomSheet(
                                    context: context,
                                    isScrollControlled: true,
                                    backgroundColor: Colors.transparent,
                                    builder: (context) => PlanDetailsModal(plan: plan),
                                  );
                                },
                              );
                            }).toList(),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
            
            // Fixed Bottom Button
            Padding(
              padding: const EdgeInsets.all(24),
              child: AppButton(
                label: l10n.continueTxt,
                onPressed: () {
                  // Handle subscription flow
                },
                buttonColor: AppColors.primaryBrown,
                expanded: true,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
