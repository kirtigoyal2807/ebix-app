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
import 'package:pilates_app/features/subscription/purchase_subscription/view/health_information_view.dart';
import 'package:pilates_app/features/subscription/purchase_subscription/view/medical_history_view.dart';
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
    
    // We lift the l10n and cubit access inside BlocBuilder mostly, or here if stable.
    
    return BlocBuilder<SubscriptionCubit, SubscriptionState>(
      // Listen to currentStep usage
      builder: (context, state) {
        final l10n = AppLocalizations.of(context)!;
        String appBarTitle;
        if (state.currentStep == 0) {
          appBarTitle = l10n.subscriptionTitle;
        } else if (state.currentStep == 1 || state.currentStep == 2) {
          appBarTitle = l10n.healthInformation; // As per screenshot header
        } else {
          appBarTitle = l10n.subscriptionTitle;
        }

        return Scaffold(
          backgroundColor: isDark ? AppColors.homeBackground : AppColors.whiteColor,
          appBar: AppAppBar(
            title: appBarTitle,
            isMoreMenu: false,
            onBack: () {
              if (state.currentStep > 0) {
                context.read<SubscriptionCubit>().previousStep();
              } else {
                context.pop();
              }
            },
          ),
          body: SafeArea(
            child: IndexedStack(
              index: state.currentStep,
              children: [
                const _PlanSelectionStep(),
                const HealthInformationView(),
                const MedicalHistoryView(),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _PlanSelectionStep extends StatelessWidget {
  const _PlanSelectionStep();

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<SubscriptionCubit>();
    final l10n = AppLocalizations.of(context)!;

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

    return Column(
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
                    style:(style)=> AppTextStyles.gelasioMedium(context).copyWith(fontSize: 24),
                  ),
                ),
                const SizedBox(height: 4),
                Padding(
                   padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                   child: AppText(
                     l10n.selectPlanSubtitle,
                     style: (style)=> AppTextStyles.bodyText(context),
                   ),
                 ),
                const SizedBox(height: AppSpacing.md),

                 // Gift Toggle
                 BlocBuilder<SubscriptionCubit, SubscriptionState>(
                   buildWhen: (p, c) => p.isGift != c.isGift,
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
                   buildWhen: (p, c) => p.selectedBranchId != c.selectedBranchId,
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
                   buildWhen: (p, c) => p.selectedPlanId != c.selectedPlanId,
                   builder: (context, state) {
                     // Find the currently selected plan object to pass to the modal
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
               cubit.nextStep();
            },
            buttonColor: AppColors.primaryBrown,
            expanded: true,
          ),
        ),
      ],
    );
  }
}
