import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pilates_app/config/theme/app_colors.dart';
import 'package:pilates_app/config/theme/app_spacing.dart';
import 'package:pilates_app/config/theme/app_text_styles.dart';
import 'package:pilates_app/core/localization/arb/app_localizations.dart';
import 'package:pilates_app/features/auth/cubit/auth_cubit.dart';
import 'package:pilates_app/features/auth/data/models/branch.dart';
import 'package:pilates_app/features/checkout/data/checkout_repository.dart';
import 'package:pilates_app/features/checkout/data/models/catalog_product.dart';
import 'package:pilates_app/features/subscription/purchase_subscription/cubit/subscription_cubit.dart';
import 'package:pilates_app/features/subscription/purchase_subscription/subscription_api_ids.dart';
import 'package:pilates_app/features/subscription/purchase_subscription/view/review_screen_view.dart';
import 'package:pilates_app/features/subscription/purchase_subscription/view/widgets/branch_selector.dart';
import 'package:pilates_app/features/subscription/purchase_subscription/view/widgets/plan_card.dart';
import 'package:pilates_app/features/subscription/purchase_subscription/view/widgets/plan_details_modal.dart';
import 'package:pilates_app/features/subscription/purchase_subscription/view/widgets/gift_toggle_card.dart';
import 'package:pilates_app/features/subscription/purchase_subscription/view/health_information_view.dart';
import 'package:pilates_app/features/subscription/purchase_subscription/view/medical_history_view.dart';
import 'package:pilates_app/features/subscription/purchase_subscription/view/physical_activity_view.dart'; // Import
import 'package:pilates_app/features/subscription/purchase_subscription/view/pregnancy_view.dart'; // Import
import 'package:pilates_app/features/subscription/purchase_subscription/view/goals_view.dart'; // Import
import 'package:pilates_app/features/subscription/purchase_subscription/view/declaration_view.dart';
import 'package:pilates_app/features/subscription/purchase_subscription/view/terms_and_conditions_view.dart';
import 'package:pilates_app/features/subscription/purchase_subscription/view/required_information_view.dart';
import 'package:pilates_app/features/subscription/purchase_subscription/view/widgets/safety_view.dart';
import 'package:pilates_app/widgets/app_app_bar.dart';
import 'package:pilates_app/widgets/app_button.dart';
import 'package:pilates_app/widgets/app_text.dart';
import 'package:pilates_app/widgets/inline_validation_banner.dart';
import 'package:pilates_app/widgets/app_loading_indicator.dart';

import '../../subscription_as_gift/gift_subscription_view.dart';

class SubscriptionView extends StatelessWidget {
  const SubscriptionView({super.key, this.initialIsGift = false});

  /// When `true` (e.g. Account → Gift subscription), checkout uses `isGift: true` and
  /// opens [GiftSubscriptionView] after session creation.
  final bool initialIsGift;

  static const String routePath = '/subscription';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SubscriptionCubit(initialIsGift: initialIsGift),
      child: const _SubscriptionViewContent(),
    );
  }
}

class _SubscriptionViewContent extends StatelessWidget {
  const _SubscriptionViewContent();

  static List<Widget> _wizardSteps(Key wizardKey) => [
        HealthInformationView(key: wizardKey),
        MedicalHistoryView(key: wizardKey),
        PhysicalActivityView(key: wizardKey),
        PregnancyView(key: wizardKey),
        GoalsView(key: wizardKey),
        DeclarationView(key: wizardKey),
        SafetyView(key: wizardKey),
        TermsAndConditionsView(key: wizardKey),
        ReviewScreenView(key: wizardKey),
        RequiredInformationView(key: wizardKey),
      ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return BlocBuilder<SubscriptionCubit, SubscriptionState>(
      // Listen to currentStep usage
      builder: (context, state) {
        final l10n = AppLocalizations.of(context);
        String appBarTitle;
        if (state.currentStep == 0) {
          appBarTitle = l10n.subscriptionTitle;
        } else if (state.currentStep >= 1 && state.currentStep <= 6) {
          appBarTitle = switch (state.currentStep) {
            1 => l10n.personalInformation,
            2 => l10n.medicalHistory,
            3 => l10n.subscriptionHealthWizardPhysicalActivityTitle,
            4 => l10n.subscriptionHealthWizardPregnancyTitle,
            5 => l10n.goals,
            6 => l10n.declaration,
            _ => l10n.healthInformation,
          };
        } else if (state.currentStep == 7) {
          appBarTitle = l10n.safetyConsent;
        } else if (state.currentStep == 8) {
          appBarTitle = l10n.termsAndConditions;
        } else if (state.currentStep == 9) {
          appBarTitle = l10n.planDetails;
        } else if (state.currentStep == 10) {
          appBarTitle = l10n.requiredInformation;
        } else {
          appBarTitle = l10n.subscriptionTitle;
        }

        // Step 10: emergency contact + ID — mandatory; no back navigation.
        final isMandatoryRequiredInfoStep = state.currentStep == 10;

        return PopScope(
          canPop: !isMandatoryRequiredInfoStep,
          child: Stack(
            children: [
              Scaffold(
                // Plan details (step 9) has voucher + text fields — must resize with keyboard.
                resizeToAvoidBottomInset: true,
                backgroundColor: isDark
                    ? AppColors.homeBackground
                    : AppColors.whiteColor,
                appBar: AppAppBar(
                  title: appBarTitle,
                  isMoreMenu: false,
                  leading: isMandatoryRequiredInfoStep
                      ? const SizedBox.shrink()
                      : null,
                  onBack: isMandatoryRequiredInfoStep
                      ? null
                      : () {
                          if (state.currentStep > 0) {
                            context.read<SubscriptionCubit>().previousStep();
                          } else {
                            Navigator.of(context).pop();
                          }
                        },
                ),
                body: SafeArea(
                  child: IndexedStack(
                    index: state.currentStep,
                    children: [
                      const _PlanSelectionStep(),
                      // Remount wizard steps when plan or checkout session changes so
                      // local controllers do not show stale data after a plan switch.
                      ..._wizardSteps(
                        ValueKey<String>(
                          '${state.selectedPlanId}|${state.checkoutSessionId}',
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

class _PlanSelectionStep extends StatefulWidget {
  const _PlanSelectionStep();

  @override
  State<_PlanSelectionStep> createState() => _PlanSelectionStepState();
}

class _PlanSelectionStepState extends State<_PlanSelectionStep> {
  List<Branch> _branches = const [];
  bool _branchesLoading = true;
  bool _branchesLoadFailed = false;

  List<CatalogProduct> _catalogProducts = const [];
  bool _productsLoading = true;
  bool _productsLoadFailed = false;

  String? _planValidationMessage;
  String? _branchValidationMessage;
  String? _checkoutMessage;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => _loadBranchesAndProducts(),
    );
  }

  Future<void> _loadBranchesAndProducts() async {
    if (!mounted) return;
    setState(() {
      _branchesLoading = true;
      _branchesLoadFailed = false;
      _productsLoading = true;
      _productsLoadFailed = false;
    });

    final auth = context.read<AuthCubit>().authRepository;
    final checkout = context.read<CheckoutRepository>();

    final cubit = context.read<SubscriptionCubit>();
    final branchResult = await auth.listBranches();

    if (!mounted) return;

    branchResult.when(
      success: (data, _) {
        _branches = data.branches;
        _branchesLoadFailed = false;
      },
      failure: (_) {
        _branches = const [];
        _branchesLoadFailed = true;
      },
    );

    setState(() {
      _branchesLoading = false;
    });

    if (!mounted) return;

    if (!_branchesLoadFailed && _branches.isNotEmpty) {
      final bid = cubit.state.selectedBranchId;
      if (bid == null || bid <= 0) {
        cubit.selectBranch(_branches.first.id);
      }
    }

    final branchIdForProducts = cubit.state.selectedBranchId;
    final productResult = await checkout.listProducts(
      branchId: (branchIdForProducts != null && branchIdForProducts > 0)
          ? branchIdForProducts
          : null,
    );

    if (!mounted) return;

    productResult.when(
      success: (data, _) {
        _catalogProducts = data;
        _productsLoadFailed = false;
      },
      failure: (_) {
        _catalogProducts = const [];
        _productsLoadFailed = true;
      },
    );

    setState(() {
      _productsLoading = false;
    });

    if (!mounted) return;
    final l10n = AppLocalizations.of(context);
    _syncSelectedPlan(_resolvedPlans(l10n));
    await _prefetchQuestionnaireAfterCatalog();
  }

  Future<void> _reloadCatalogForBranch(int branchId) async {
    if (!mounted) return;
    setState(() {
      _productsLoading = true;
      _productsLoadFailed = false;
    });
    final checkout = context.read<CheckoutRepository>();
    final productResult = await checkout.listProducts(branchId: branchId);
    if (!mounted) return;
    productResult.when(
      success: (data, _) {
        _catalogProducts = data;
        _productsLoadFailed = false;
      },
      failure: (_) {
        _catalogProducts = const [];
        _productsLoadFailed = true;
      },
    );
    setState(() {
      _productsLoading = false;
    });
    if (!mounted) return;
    final l10n = AppLocalizations.of(context);
    _syncSelectedPlan(_resolvedPlans(l10n));
    await _prefetchQuestionnaireAfterCatalog();
  }

  /// After `GET /products` (catalog), warm questionnaire when the effective plan has
  /// `requiresHealthIntake: true` ([SubscriptionCubit.prefetchHealthQuestionnaireForSelectedPlan]).
  Future<void> _prefetchQuestionnaireAfterCatalog() async {
    final cubit = context.read<SubscriptionCubit>();
    final repo = context.read<CheckoutRepository>();
    await cubit.prefetchHealthQuestionnaireForSelectedPlan(repo);
  }

  /// `POST checkout/start` → bind session → prefetch questionnaire, then either
  /// push [GiftSubscriptionView] when [SubscriptionState.isGift] or advance to
  /// personal info ([SubscriptionCubit.nextStep]).
  Future<void> _startCheckoutAndNavigate() async {
    if (!mounted) return;
    final l10n = AppLocalizations.of(context);
    final cubit = context.read<SubscriptionCubit>();
    var state = cubit.state;

    setState(() {
      _planValidationMessage = null;
      _branchValidationMessage = null;
      _checkoutMessage = null;
    });

    if (state.selectedPlanId.trim().isEmpty) {
      setState(() => _planValidationMessage = l10n.pleaseSelectPlan);
      return;
    }
    if (state.selectedBranchId == null || state.selectedBranchId! <= 0) {
      setState(() => _branchValidationMessage = l10n.pleaseSelectBranch);
      return;
    }

    final productId = subscriptionProductApiId(state.selectedPlanId);
    final branchId = state.selectedBranchId!;
    if (productId <= 0) {
      setState(() => _checkoutMessage = l10n.loginErrorGeneric);
      return;
    }

    final repo = context.read<CheckoutRepository>();

    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) =>
          const AppLoadingIndicator(),
    );

    state = cubit.state;
    final result = await repo.startCheckout(
      productId: productId,
      branchId: branchId,
      isGift: state.isGift,
    );

    if (mounted) {
      Navigator.of(context, rootNavigator: true).pop();
    }

    if (!mounted) return;

    if (result.isSuccess) {
      final data = result.dataOrNull!;
      final resolvedProductId = data.resolvedProductId ?? productId;
      cubit.bindCheckoutSession(
        sessionId: data.id,
        productId: resolvedProductId,
        requiresHealthIntake: data.resolvedRequiresHealthIntake,
      );
      await cubit.fetchHealthQuestionnaireForCurrentProduct(repo);
      if (!mounted) return;
      if (cubit.state.isGift) {
        Navigator.push<void>(
          context,
          MaterialPageRoute<void>(
            builder: (context) => BlocProvider.value(
              value: cubit,
              child: GiftSubscriptionView(checkoutId: data.id),
            ),
          ),
        );
      } else {
        cubit.nextStep();
      }
    } else {
      final e = result.exceptionOrNull!;
      setState(() {
        _checkoutMessage = (e.message != null && e.message!.trim().isNotEmpty)
            ? e.message!
            : l10n.loginErrorGeneric;
      });
    }
  }

  /// Prefer membership subscriptions in the list so default selection and
  /// questionnaire prefetch follow the chosen plan; API order may list session
  /// packs first (e.g. product id 1).
  List<CatalogProduct> _orderedCatalogForDisplay(
    List<CatalogProduct> products,
  ) {
    final out = List<CatalogProduct>.from(products);
    int rank(CatalogProduct p) {
      final et = p.entitlementType.toLowerCase();
      final t = p.type.toLowerCase();
      if (t == 'membership' && et == 'subscription') return 0;
      if (t == 'membership') return 1;
      return 2;
    }

    out.sort((a, b) {
      final c = rank(a).compareTo(rank(b));
      if (c != 0) return c;
      if (a.isRecommended != b.isRecommended) {
        return (b.isRecommended ? 1 : 0).compareTo(a.isRecommended ? 1 : 0);
      }
      return a.id.compareTo(b.id);
    });
    return out;
  }

  /// Fallback when `GET /products` is unavailable. Use numeric `id` strings so
  /// `GET …/questionnaires/product/{id}` matches real product ids in your API.
  List<Map<String, dynamic>> _staticPlans(AppLocalizations l10n) {
    return [
      {
        'id': '1',
        'title': l10n.premiumPlanTitle,
        'price': '89',
        'currency': 'SAR',
        'badge': l10n.mostPopular,
        'isPopular': true,
        'requiresHealthIntake': true,
        'priceSubtitle': ' / Month',
        'features': [
          l10n.feature12Classes,
          l10n.featureDowntownUptown,
          l10n.featureFreeMatEquipment,
          l10n.featurePriorityBooking,
        ],
      },
      {
        'id': '2',
        'title': l10n.basicPlanTitle,
        'price': '49',
        'currency': 'SAR',
        'badge': null,
        'isPopular': false,
        'requiresHealthIntake': true,
        'priceSubtitle': ' / Month',
        'features': [
          l10n.feature8Classes,
          l10n.featureDowntownOnly,
          l10n.featureFreeMat,
        ],
      },
      {
        'id': '3',
        'title': l10n.unlimitedPlanTitle,
        'price': '149',
        'currency': 'SAR',
        'badge': null,
        'isPopular': false,
        'requiresHealthIntake': true,
        'priceSubtitle': ' / Month',
        'features': [
          l10n.featureUnlimitedClasses,
          l10n.featureAllStudios,
          l10n.featureFreeMatEquipment,
          l10n.featurePriorityGuest,
        ],
      },
    ];
  }

  List<Map<String, dynamic>> _resolvedPlans(AppLocalizations l10n) {
    if (_catalogProducts.isNotEmpty) {
      return _orderedCatalogForDisplay(
        _catalogProducts,
      ).map((p) => p.toPlanMap(l10n)).toList();
    }
    return _staticPlans(l10n);
  }

  void _syncSelectedPlan(List<Map<String, dynamic>> plans) {
    if (!mounted || plans.isEmpty) return;
    final cubit = context.read<SubscriptionCubit>();
    final selected = cubit.state.selectedPlanId;
    final Map<String, dynamic> effectivePlan;
    if (!plans.any((p) => p['id'] == selected)) {
      effectivePlan = plans.first;
    } else {
      effectivePlan = plans.firstWhere((p) => p['id'] == selected);
    }
    final req = effectivePlan['requiresHealthIntake'] as bool? ?? false;
    cubit.selectPlan(effectivePlan['id'] as String, requiresHealthIntake: req);
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<SubscriptionCubit>();
    final l10n = AppLocalizations.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final plans = _resolvedPlans(l10n);
    // Show loader on initial fetch and whenever branch changes trigger a new
    // `GET /products` — not only when catalog is empty (old products would hide it).
    final showPlansLoading = _productsLoading;

    return Stack(
      fit: StackFit.expand,
      children: [
        SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: EdgeInsets.symmetric(vertical: AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
                // Header
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                  child: AppText(
                    l10n.chooseYourPlan,
                    style: (context) => AppTextStyles.gelasioMedium(
                      context,
                    ).copyWith(fontSize: 24),
                  ),
                ),
                SizedBox(height: 4),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                  child: AppText(
                    l10n.selectPlanSubtitle,
                    style: (context) => AppTextStyles.bodyText(context),
                  ),
                ),
                SizedBox(height: AppSpacing.md),

                // Gift Toggle
                BlocBuilder<SubscriptionCubit, SubscriptionState>(
                  buildWhen: (p, c) => p.isGift != c.isGift,
                  builder: (context, state) {
                    return Padding(
                      padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                      child: GiftToggleCard(
                        isGift: state.isGift,
                        onToggle: (val) => cubit.toggleGift(val),
                      ),
                    );
                  },
                ),
                SizedBox(height: AppSpacing.lg),

                Padding(
                  padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppText(
                        l10n.select_branch,
                        style: (context) => AppTextStyles.gelasioMedium(
                          context,
                        ).copyWith(fontSize: 18),
                      ),
                      SizedBox(height: AppSpacing.sm),
                      if (_branchesLoading)
                        Padding(
                          padding: EdgeInsets.symmetric(
                            vertical: AppSpacing.md,
                          ),
                          child: Center(
                            child: AppInlineBusy(size: 28),
                          ),
                        )
                      else if (_branchesLoadFailed)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            AppText(
                              l10n.branchesCouldNotLoad,
                              style: (context) =>
                                  AppTextStyles.captionText(context),
                            ),
                            TextButton(
                              onPressed: _loadBranchesAndProducts,
                              child: Text(l10n.retry),
                            ),
                          ],
                        )
                      else if (_branches.isEmpty)
                        AppText(
                          l10n.noBranchesAvailable,
                          style: (context) =>
                              AppTextStyles.captionText(context),
                        )
                      else
                        BlocBuilder<SubscriptionCubit, SubscriptionState>(
                          buildWhen: (p, c) =>
                              p.selectedBranchId != c.selectedBranchId,
                          builder: (context, state) {
                            return BranchSelector(
                              branches: _branches,
                              selectedBranchId: state.selectedBranchId,
                              onSelect: (branchId) {
                                cubit.selectBranch(branchId);
                                setState(() => _branchValidationMessage = null);
                                _reloadCatalogForBranch(branchId);
                              },
                            );
                          },
                        ),
                      if (_branchValidationMessage != null) ...[
                        SizedBox(height: AppSpacing.sm),
                        InlineValidationBanner(
                          message: _branchValidationMessage!,
                        ),
                      ],
                    ],
                  ),
                ),
                SizedBox(height: AppSpacing.lg),

                if (_productsLoadFailed && _catalogProducts.isEmpty)
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AppText(
                          l10n.loginErrorGeneric,
                          style: (context) =>
                              AppTextStyles.captionText(context),
                        ),
                        TextButton(
                          onPressed: _loadBranchesAndProducts,
                          child: Text(l10n.retry),
                        ),
                      ],
                    ),
                  ),

                // Plans List (`GET /products` when available, else static fallback)
                if (showPlansLoading)
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: AppSpacing.lg,
                      vertical: AppSpacing.lg,
                    ),
                    child: Center(
                      child: AppInlineBusy(size: 28),
                    ),
                  )
                else
                  BlocBuilder<SubscriptionCubit, SubscriptionState>(
                    // Rebuild when branch changes catalog in parent [setState], not only when plan id changes.
                    builder: (context, state) {
                      return Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: AppSpacing.lg,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            if (_planValidationMessage != null) ...[
                              InlineValidationBanner(
                                message: _planValidationMessage!,
                              ),
                              SizedBox(height: AppSpacing.sm),
                            ],
                            ...plans.map((plan) {
                              return PlanCard(
                                id: plan['id'] as String,
                                title: plan['title'] as String,
                                price: plan['price'] as String,
                                currencyCode:
                                    (plan['currency'] as String?)
                                            ?.trim()
                                            .isNotEmpty ==
                                        true
                                    ? (plan['currency'] as String).trim()
                                    : 'SAR',
                                isSelected: state.selectedPlanId == plan['id'],
                                isPopular: plan['isPopular'] as bool? ?? false,
                                badgeText: plan['badge'] as String?,
                                priceSuffix: () {
                                  final s = (plan['priceSubtitle'] as String?)
                                      ?.trim();
                                  if (s != null && s.isNotEmpty) return s;
                                  return ' / Month';
                                }(),
                                onTap: () {
                                  setState(() => _planValidationMessage = null);
                                  cubit.selectPlan(
                                    plan['id'] as String,
                                    requiresHealthIntake:
                                        plan['requiresHealthIntake'] as bool? ??
                                        false,
                                  );
                                  if (cubit
                                          .state
                                          .selectedProductRequiresHealthIntake &&
                                      cubit
                                          .state
                                          .healthQuestionnaireQuestions
                                          .isEmpty) {
                                    _prefetchQuestionnaireAfterCatalog();
                                  }
                                  showModalBottomSheet(
                                    context: context,
                                    isScrollControlled: true,
                                    backgroundColor: Colors.transparent,
                                    barrierColor: AppColors.bottomSheetShadow,
                                    builder: (context) => PlanDetailsModal(
                                      plan: plan,
                                      onSubscribe: () {
                                        Navigator.pop(context);
                                        unawaited(_startCheckoutAndNavigate());
                                      },
                                    ),
                                  );
                                },
                              );
                            }),
                          ],
                        ),
                      );
                    },
                  ),
              SizedBox(height: AppSpacing.xxxl * 2),
            ],
          ),
        ),
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Container(
            height: AppSpacing.md + 52,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: isDark
                    ? [
                        AppColors.darkShadow,
                        AppColors.darkShadow.withValues(alpha: 0),
                      ]
                    : [
                        Colors.white,
                        Colors.white.withValues(alpha: 0),
                      ],
              ),
            ),
          ),
        ),
        Positioned(
          left: 0,
          right: 0,
          bottom: AppSpacing.md,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (_checkoutMessage != null)
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                  child: InlineValidationBanner(message: _checkoutMessage!),
                ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                child: AppButton(
                  label: l10n.continueTxt,
                  onPressed: () {
                    unawaited(_startCheckoutAndNavigate());
                  },
                  buttonColor:
                      isDark ? AppColors.primary : AppColors.primaryBrown,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
