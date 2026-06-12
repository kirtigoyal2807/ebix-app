import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pilates_app/config/theme/app_colors.dart';
import 'package:pilates_app/core/localization/arb/app_localizations.dart';
import 'package:pilates_app/features/auth/cubit/auth_cubit.dart';
import 'package:pilates_app/features/auth/data/models/auth_user.dart';
import 'package:pilates_app/features/checkout/data/checkout_repository.dart';
import 'package:pilates_app/features/explore/gift_redeem_intake_product.dart';
import 'package:pilates_app/features/explore/gift_redeem_intake_scope.dart';
import 'package:pilates_app/features/subscription/purchase_subscription/cubit/subscription_cubit.dart';
import 'package:pilates_app/features/subscription/purchase_subscription/view/declaration_view.dart';
import 'package:pilates_app/features/subscription/purchase_subscription/view/goals_view.dart';
import 'package:pilates_app/features/subscription/purchase_subscription/view/health_information_view.dart';
import 'package:pilates_app/features/subscription/purchase_subscription/view/medical_history_view.dart';
import 'package:pilates_app/features/subscription/purchase_subscription/view/physical_activity_view.dart';
import 'package:pilates_app/features/subscription/purchase_subscription/view/pregnancy_view.dart';
import 'package:pilates_app/features/subscription/purchase_subscription/view/required_information_view.dart';
import 'package:pilates_app/features/subscription/purchase_subscription/view/terms_and_conditions_view.dart';
import 'package:pilates_app/features/subscription/purchase_subscription/view/widgets/safety_view.dart';
import 'package:pilates_app/core/network/api_result.dart';
import 'package:pilates_app/widgets/app_app_bar.dart';
import 'package:pilates_app/widgets/app_loading_indicator.dart';

/// Health intake + consent wizard shown before opening [RedeemCardView].
class GiftRedeemHealthIntakeView extends StatelessWidget {
  const GiftRedeemHealthIntakeView({
    super.key,
    required this.pendingGift,
    required this.onComplete,
  });

  final PendingGift pendingGift;
  final VoidCallback onComplete;

  static List<Widget> _wizardSteps(Key wizardKey) => [
        HealthInformationView(key: wizardKey),
        MedicalHistoryView(key: wizardKey),
        PhysicalActivityView(key: wizardKey),
        PregnancyView(key: wizardKey),
        GoalsView(key: wizardKey),
        DeclarationView(key: wizardKey),
        SafetyView(key: wizardKey),
        TermsAndConditionsView(key: wizardKey),
      ];

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SubscriptionCubit(),
      child: GiftRedeemIntakeScope(
        onComplete: onComplete,
        child: _GiftRedeemHealthIntakeBody(pendingGift: pendingGift),
      ),
    );
  }
}

class _GiftRedeemHealthIntakeBody extends StatefulWidget {
  const _GiftRedeemHealthIntakeBody({required this.pendingGift});

  final PendingGift pendingGift;

  @override
  State<_GiftRedeemHealthIntakeBody> createState() =>
      _GiftRedeemHealthIntakeBodyState();
}

class _GiftRedeemHealthIntakeBodyState extends State<_GiftRedeemHealthIntakeBody> {
  bool _initializing = true;
  String? _initError;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _initialize());
  }

  Future<void> _initialize() async {
    if (!mounted) return;

    final repo = context.read<CheckoutRepository>();
    final branchId = context.read<AuthCubit>().state.user?.homeBranch?.id;
    final resolved = await resolveGiftRedeemIntakeProduct(
      checkoutRepository: repo,
      pendingGift: widget.pendingGift,
      branchId: branchId,
    );

    if (!mounted) return;

    if (resolved.productId <= 0) {
      setState(() {
        _initializing = false;
        _initError = AppLocalizations.of(context).loginErrorGeneric;
      });
      return;
    }

    final cubit = context.read<SubscriptionCubit>();
    cubit.beginGiftRedeemIntake(
      planId: resolved.planId,
      productId: resolved.productId,
      requiresHealthIntake: resolved.requiresHealthIntake,
    );

    final homeBranchId = branchId;
    if (homeBranchId != null && homeBranchId > 0) {
      final startResult = await repo.startCheckout(
        productId: resolved.productId,
        branchId: homeBranchId,
        isGift: false,
      );
      if (!mounted) return;
      if (startResult case ApiSuccess(:final data)) {
        final sessionProductId = data.resolvedProductId ?? resolved.productId;
        cubit.bindCheckoutSession(
          sessionId: data.id,
          productId: sessionProductId,
          requiresHealthIntake: data.resolvedRequiresHealthIntake,
        );
        cubit.selectBranch(homeBranchId);
      } else {
        setState(() {
          _initializing = false;
          _initError = AppLocalizations.of(context).loginErrorGeneric;
        });
        return;
      }
    }

    if (cubit.state.selectedProductRequiresHealthIntake &&
        cubit.state.checkoutProductId > 0) {
      await cubit.fetchHealthQuestionnaireForCurrentProduct(repo);
    }

    if (!mounted) return;
    setState(() => _initializing = false);
  }

  @override
  Widget build(BuildContext context) {
    if (_initializing) {
      return Scaffold(
        backgroundColor: Theme.of(context).brightness == Brightness.dark
            ? AppColors.homeBackground
            : AppColors.whiteColor,
        body: const Center(child: AppLoadingIndicator()),
      );
    }

    if (_initError != null) {
      final l10n = AppLocalizations.of(context);
      return Scaffold(
        backgroundColor: Theme.of(context).brightness == Brightness.dark
            ? AppColors.homeBackground
            : AppColors.whiteColor,
        appBar: AppAppBar(title: l10n.subscriptionTitle, isMoreMenu: false),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Text(
              _initError!,
              textAlign: TextAlign.center,
            ),
          ),
        ),
      );
    }

    final isDark = Theme.of(context).brightness == Brightness.dark;

    return BlocBuilder<SubscriptionCubit, SubscriptionState>(
      builder: (context, state) {
        final l10n = AppLocalizations.of(context);
        final appBarTitle = switch (state.currentStep) {
          1 => l10n.personalInformation,
          2 => l10n.medicalHistory,
          3 => l10n.subscriptionHealthWizardPhysicalActivityTitle,
          4 => l10n.subscriptionHealthWizardPregnancyTitle,
          5 => l10n.goals,
          6 => l10n.declaration,
          7 => l10n.safetyConsent,
          8 => l10n.termsAndConditions,
          10 => l10n.requiredInformation,
          _ => l10n.personalInformation,
        };

        final isMandatoryRequiredInfoStep = state.currentStep == 10;
        final isGiftRedeemPersonalInfoStep = state.currentStep == 1;
        final hideAppBarBack =
            isMandatoryRequiredInfoStep || isGiftRedeemPersonalInfoStep;

        return PopScope(
          canPop: !isMandatoryRequiredInfoStep && !isGiftRedeemPersonalInfoStep,
          child: Stack(
            children: [
              Scaffold(
                resizeToAvoidBottomInset: true,
                backgroundColor: isDark
                    ? AppColors.homeBackground
                    : AppColors.whiteColor,
                appBar: AppAppBar(
                  title: appBarTitle,
                  isMoreMenu: false,
                  leading: hideAppBarBack ? const SizedBox.shrink() : null,
                  onBack: hideAppBarBack
                      ? null
                      : () {
                          if (state.currentStep > 1) {
                            context.read<SubscriptionCubit>().previousStep();
                          }
                        },
                ),
                body: SafeArea(
                  child: IndexedStack(
                    index: state.currentStep.clamp(1, 10),
                    children: [
                      const SizedBox.shrink(),
                      ...GiftRedeemHealthIntakeView._wizardSteps(
                        ValueKey<String>(
                          '${state.selectedPlanId}|${state.checkoutSessionId}|gift-redeem-intake',
                        ),
                      ),
                      const SizedBox.shrink(),
                      RequiredInformationView(
                        key: ValueKey<String>(
                          'gift-required|${state.checkoutSessionId}',
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              if (isMandatoryRequiredInfoStep &&
                  state.isSubmittingRequiredInformation)
                const Positioned.fill(
                  child: RequiredInformationSubmitOverlay(),
                ),
            ],
          ),
        );
      },
    );
  }
}
