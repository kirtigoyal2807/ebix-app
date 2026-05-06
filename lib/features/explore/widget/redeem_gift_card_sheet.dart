import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pilates_app/config/theme/app_colors.dart';
import 'package:pilates_app/config/theme/app_spacing.dart';
import 'package:pilates_app/config/theme/app_text_styles.dart';
import 'package:pilates_app/core/localization/localization_extension.dart';
import 'package:pilates_app/features/explore/cubit/redeem_gift_cubit.dart';
import 'package:pilates_app/features/explore/cubit/redeem_gift_state.dart';
import 'package:pilates_app/features/explore/data/gift_repository.dart';
import 'package:pilates_app/widgets/app_button.dart';
import 'package:pilates_app/widgets/app_text.dart';
import 'package:pilates_app/widgets/app_text_field.dart';

import 'gift_redeem_success_sheet.dart';

/// Opens the redeem flow: code entry sheet → API → success sheet from [parentContext].
Future<void> showRedeemGiftCardBottomSheet(BuildContext parentContext) async {
  final repository = parentContext.read<GiftRepository>();
  await showModalBottomSheet<void>(
    context: parentContext,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    barrierColor: AppColors.bottomSheetShadow,
    isDismissible: true,
    enableDrag: true,
    builder: (sheetContext) => BlocProvider<RedeemGiftCubit>(
      create: (_) => RedeemGiftCubit(repository),
      child: _RedeemGiftSheetListener(
        parentContext: parentContext,
        child: const RedeemGiftCardSheet(),
      ),
    ),
  );
}

class _RedeemGiftSheetListener extends StatelessWidget {
  const _RedeemGiftSheetListener({
    required this.parentContext,
    required this.child,
  });

  final BuildContext parentContext;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return BlocListener<RedeemGiftCubit, RedeemGiftState>(
      listenWhen: (previous, current) =>
          current.successPending && !previous.successPending,
      listener: (context, state) {
        context.read<RedeemGiftCubit>().consumeSuccess();
        Navigator.of(context).pop();
        showModalBottomSheet<void>(
          context: parentContext,
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          barrierColor: AppColors.bottomSheetShadow,
          builder: (_) => const GiftRedeemSuccessSheet(),
        );
      },
      child: child,
    );
  }
}

class RedeemGiftCardSheet extends StatefulWidget {
  const RedeemGiftCardSheet({super.key});

  @override
  State<RedeemGiftCardSheet> createState() => _RedeemGiftCardSheetState();
}

class _RedeemGiftCardSheetState extends State<RedeemGiftCardSheet> {
  late final TextEditingController _codeController;

  @override
  void initState() {
    super.initState();
    _codeController = TextEditingController();
  }

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return BlocBuilder<RedeemGiftCubit, RedeemGiftState>(
      builder: (context, state) {
        final fieldError = switch (state.validation) {
          RedeemCodeValidation.empty => context.l10n.redeemCodeRequired,
          RedeemCodeValidation.none => state.serverError,
        };

        return PopScope(
          canPop: !state.isSubmitting,
          child: Material(
            color: isDark ? AppColors.homeBackground : AppColors.whiteColor,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            child: SafeArea(
              top: false,
              child: AnimatedPadding(
                duration: const Duration(milliseconds: 150),
                curve: Curves.easeOut,
                padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom,
                ),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.lg,
                      vertical: AppSpacing.lg,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: AppText(
                                context.l10n.redeemGiftCard,
                                style: AppTextStyles.bottomSheetTitle,
                              ),
                            ),
                            GestureDetector(
                              onTap: state.isSubmitting
                                  ? null
                                  : () => Navigator.of(context).pop(),
                              child: Icon(
                                Icons.close,
                                color: state.isSubmitting
                                    ? (isDark
                                          ? AppColors.greyText
                                          : AppColors.lightGrey)
                                    : (isDark
                                          ? AppColors.whiteColor
                                          : AppColors.blackColor),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: AppSpacing.xl),
                        Center(
                          child: ClipOval(
                            child: SizedBox(
                              height: 192,
                              width: 192,
                              child: SvgPicture.asset(
                                isDark
                                    ? 'assets/images/svg/ic_dark_gift_card.svg'
                                    : 'assets/images/svg/ic_gift_card.svg',
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: AppSpacing.lg),
                        AppTextField(
                          controller: _codeController,
                          hint: context.l10n.enterGiftCardCode,
                          label: context.l10n.enterRedeemCode,
                          errorText: fieldError,
                          onChanged: (_) => context
                              .read<RedeemGiftCubit>()
                              .clearFieldFeedback(),
                        ),
                        const SizedBox(height: AppSpacing.xl),
                        AppButton(
                          label: context.l10n.redeemGift,
                          isLoading: state.isSubmitting,
                          onPressed: state.isSubmitting
                              ? null
                              : () {
                                  FocusScope.of(context).unfocus();
                                  context.read<RedeemGiftCubit>().redeem(
                                    _codeController.text,
                                  );
                                },
                          variant: AppButtonVariant.primary,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
