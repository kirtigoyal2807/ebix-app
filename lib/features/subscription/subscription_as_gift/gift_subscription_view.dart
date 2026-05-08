import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pilates_app/config/theme/app_spacing.dart';
import 'package:pilates_app/core/constants/api_config.dart';
import 'package:pilates_app/core/validation/contact_validators.dart';
import 'package:pilates_app/core/validation/personal_information_validators.dart';
import 'package:pilates_app/features/checkout/data/checkout_repository.dart';
import 'package:pilates_app/features/subscription/purchase_subscription/cubit/subscription_cubit.dart';
import 'package:pilates_app/features/subscription/subscription_as_gift/cubit/gift_subscription_cubit.dart';
import 'package:pilates_app/features/subscription/subscription_as_gift/cubit/gift_subscription_state.dart';
import 'package:pilates_app/features/subscription/subscription_as_gift/view/plan_details_view.dart';
import 'package:pilates_app/features/subscription/subscription_as_gift/widget/gift_card.dart';
import 'package:pilates_app/features/subscription/subscription_as_gift/widget/receipt_details.dart';
import 'package:pilates_app/widgets/app_app_bar.dart';

import '../../../config/theme/app_colors.dart';

import '../../../core/localization/arb/app_localizations.dart';
import '../../../core/localization/localization_extension.dart';
import '../../../widgets/app_button.dart';

/// Gift checkout recipient step.
///
/// When [checkoutId] is set (from the purchase/checkout session), **Continue**
/// calls `POST /checkout/{checkout}/gift` and shows the API `message` on failure
/// (e.g. `"Not a gift"` when the session is not gift-eligible).
///
/// When no checkout session id is available (and no `GIFT_CHECKOUT_ID`
/// dart-define), **Continue** shows an error snackbar — the POST is not sent.
///
/// **Checkout id** resolution:
/// 1. [checkoutId] constructor argument
/// 2. `ModalRoute.settings.arguments` as [String] (the id)
/// 3. `arguments` as [Map] with key `checkoutId`
///
/// Example:
/// `Navigator.push(context, MaterialPageRoute(settings: RouteSettings(arguments: checkoutUuid), builder: (_) => const GiftSubscriptionView()))`
class GiftSubscriptionView extends StatefulWidget {
  const GiftSubscriptionView({super.key, this.checkoutId});

  /// Session id from checkout creation (UUID).
  final String? checkoutId;

  @override
  State<GiftSubscriptionView> createState() => _GiftSubscriptionViewState();
}

class _GiftSubscriptionViewState extends State<GiftSubscriptionView> {
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _phone = TextEditingController();
  final _message = TextEditingController();

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _phone.dispose();
    _message.dispose();
    super.dispose();
  }

  void _unfocusKeyboard() {
    FocusManager.instance.primaryFocus?.unfocus();
  }

  String? _effectiveCheckoutId(BuildContext context) {
    final w = widget.checkoutId?.trim();
    if (w != null && w.isNotEmpty) return w;
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args is String && args.trim().isNotEmpty) return args.trim();
    if (args is Map) {
      final id = args['checkoutId'];
      if (id is String && id.trim().isNotEmpty) return id.trim();
    }
    return null;
  }

  /// Widget / route args first, then optional `--dart-define=GIFT_CHECKOUT_ID=…`
  /// for local testing ([ApiConfig.debugGiftCheckoutSessionId]).
  String? _resolveCheckoutSessionId(BuildContext context) {
    final fromFlow = _effectiveCheckoutId(context);
    if (fromFlow != null && fromFlow.isNotEmpty) return fromFlow;

    final overrideId = ApiConfig.debugGiftCheckoutSessionId;
    if (overrideId != null && overrideId.isNotEmpty) {
      if (kDebugMode) {
        debugPrint(
          '[Gift checkout] no route/widget checkout id — using '
          'GIFT_CHECKOUT_ID dart-define',
        );
      }
      return overrideId;
    }
    return null;
  }

  /// Route/widget arg only — do not use this inside [BlocProvider.create]; route
  /// [ModalRoute.settings.arguments] can resolve after the first frame and would
  /// recreate the cubit mid-focus (Framework `FocusInheritedScope` assertion).
  String? get _constructorCheckoutId {
    final w = widget.checkoutId?.trim();
    return (w != null && w.isNotEmpty) ? w : null;
  }

  Future<void> _onContinue(BuildContext context) async {
    _unfocusKeyboard();
    final messenger = ScaffoldMessenger.of(context);
    final l10n = context.l10n;

    final trimmedId = _resolveCheckoutSessionId(context);
    if (trimmedId == null || trimmedId.isEmpty) {
      messenger.showSnackBar(
        SnackBar(content: Text(l10n.giftCheckoutSessionRequired)),
      );
      return;
    }

    final cubit = context.read<GiftSubscriptionCubit>();

    final name = _name.text.trim();
    final email = _email.text.trim();
    final phoneRaw = _phone.text;

    if (!ContactValidators.isValidPersonName(name)) {
      messenger.showSnackBar(
        SnackBar(content: Text(l10n.giftValidationRecipientName)),
      );
      return;
    }

    if (email.isEmpty) {
      messenger.showSnackBar(
        SnackBar(content: Text(l10n.giftValidationRecipientEmail)),
      );
      return;
    }

    if (!ContactValidators.isValidEmail(email)) {
      messenger.showSnackBar(
        SnackBar(content: Text(l10n.pleaseEnterValidEmail)),
      );
      return;
    }

    final phoneDigits = phoneRaw.replaceAll(RegExp(r'\D'), '');
    if (phoneDigits.isEmpty) {
      messenger.showSnackBar(
        SnackBar(content: Text(l10n.giftValidationRecipientPhone)),
      );
      return;
    }
    if (!PersonalInformationValidators.isTenDigitMobile(phoneRaw)) {
      messenger.showSnackBar(
        SnackBar(content: Text(l10n.phoneTenDigitsRequired)),
      );
      return;
    }

    String? deliveryDate;
    if (cubit.state.selectedDeliveryOption ==
        DeliveryOption.scheduledDelivery) {
      deliveryDate = cubit.state.scheduledDeliveryDateIso?.trim();
      if (deliveryDate == null || deliveryDate.isEmpty) {
        messenger.showSnackBar(
          SnackBar(content: Text(l10n.giftValidationScheduleDate)),
        );
        return;
      }
    }

    await cubit.submitGift(
      checkoutSessionId: trimmedId,
      recipientName: name,
      recipientEmail: email,
      recipientPhone: phoneDigits,
      message: _message.text.trim(),
      deliveryDate: deliveryDate,
    );

    if (!context.mounted) return;

    final status = cubit.state.submitStatus;
    if (status == GiftSubmitStatus.success) {
      final sessionId = trimmedId;
      SubscriptionCubit? subscriptionCubit;
      try {
        subscriptionCubit = context.read<SubscriptionCubit>();
      } catch (_) {}
      await Navigator.push<void>(
        context,
        MaterialPageRoute<void>(
          builder: (context) {
            final child = PlanDetailsView(checkoutId: sessionId);
            return MultiBlocProvider(
              providers: [
                BlocProvider<GiftSubscriptionCubit>.value(value: cubit),
                if (subscriptionCubit != null)
                  BlocProvider<SubscriptionCubit>.value(
                    value: subscriptionCubit,
                  ),
              ],
              child: child,
            );
          },
        ),
      );
      return;
    }

    if (status == GiftSubmitStatus.failure) {
      final msg = cubit.state.submitErrorMessage?.trim();
      messenger.showSnackBar(
        SnackBar(content: Text(_giftFailureDisplayMessage(msg, l10n))),
      );
    }
  }

  /// Maps noisy API copy (e.g. `dependent` validation) to clear l10n.
  String _giftFailureDisplayMessage(String? raw, AppLocalizations l10n) {
    final t = raw?.toLowerCase() ?? '';
    if (t.contains('not a gift')) {
      return l10n.giftCheckoutNotGiftSession;
    }
    if (t.contains('dependent') &&
        (t.contains('empty') || t.contains('not true'))) {
      return l10n.giftRecipientValidationError;
    }
    if (raw != null && raw.trim().isNotEmpty) return raw.trim();
    return l10n.loginErrorGeneric;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return BlocProvider(
      create: (context) => GiftSubscriptionCubit(
        context.read<CheckoutRepository>(),
        checkoutId: _constructorCheckoutId,
      ),
      child: Scaffold(
        appBar: AppAppBar(
          title: l10n.giftSubscription,
          isMoreMenu: false,
          onBack: () {
            Navigator.of(context).pop();
          },
        ),
        body: Padding(
          padding: EdgeInsets.only(
            left: AppSpacing.lg,
            right: AppSpacing.lg,
            bottom: AppSpacing.xl,
          ),
          child: Column(
            children: [
              Expanded(
                child: GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: _unfocusKeyboard,
                  child: SingleChildScrollView(
                    keyboardDismissBehavior:
                        ScrollViewKeyboardDismissBehavior.onDrag,
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: AppSpacing.md),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          PilatesGiftCard(
                            nameController: _name,
                            messageController: _message,
                          ),

                          SizedBox(height: AppSpacing.lg),
                          ReceiptDetails(
                            nameController: _name,
                            emailController: _email,
                            phoneController: _phone,
                            messageController: _message,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              BlocBuilder<GiftSubscriptionCubit, GiftSubscriptionState>(
                builder: (context, state) {
                  final loading =
                      state.submitStatus == GiftSubmitStatus.loading;
                  return AppButton(
                    label: l10n.continueToPayment,
                    isLoading: loading,
                    onPressed: loading ? null : () => _onContinue(context),
                    buttonColor: isDark
                        ? AppColors.primary
                        : AppColors.primaryBrown,
                    expanded: true,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
