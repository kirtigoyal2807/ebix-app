import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lottie/lottie.dart';
import 'package:pilates_app/config/theme/app_colors.dart';
import 'package:pilates_app/config/theme/app_radius.dart';
import 'package:pilates_app/config/theme/app_spacing.dart';
import 'package:pilates_app/core/localization/localization_extension.dart';
import 'package:pilates_app/features/auth/data/models/auth_user.dart';
import 'package:pilates_app/features/explore/cubit/redeem_gift_cubit.dart';
import 'package:pilates_app/features/explore/cubit/redeem_gift_state.dart';
import 'package:pilates_app/features/explore/data/gift_repository.dart';
import 'package:pilates_app/features/explore/widget/gift_redeem_success_sheet.dart';
import 'package:pilates_app/widgets/app_button.dart';

import '../../../config/theme/app_text_styles.dart';
import '../../../widgets/app_text.dart';
import '../../../widgets/dotted_underline.dart';
import '../widget/redeem_gift_card_sheet.dart';

class RedeemCardView extends StatelessWidget {
  const RedeemCardView({super.key, this.pendingGift, this.onRedeemed});

  /// When provided, the screen renders the actual gift content (sender/message/code)
  /// and the "Redeem Your Gift" button calls `POST /gifts/redeem` directly with
  /// [PendingGift.redemptionCode]. When null, falls back to the legacy flow that
  /// opens the manual code-entry bottom sheet.
  final PendingGift? pendingGift;

  /// Optional callback fired after the success sheet's Continue is tapped — e.g.
  /// to refresh the profile so `pendingGift` clears from `/auth/me`.
  final VoidCallback? onRedeemed;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final body = _RedeemCardBody(
      pendingGift: pendingGift,
      onRedeemed: onRedeemed,
    );

    final scaffold = Container(
      decoration: const BoxDecoration(
        color: AppColors.homeBackground,
        gradient: LinearGradient(
          begin: Alignment(-0.2, -1.0),
          end: Alignment(0.8, 1.0),
          colors: [
            AppColors.subscriptionCardGradient1,
            AppColors.subscriptionCardGradient2,
          ],
          stops: [0.1514, 1.0],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          surfaceTintColor: Colors.transparent,
          backgroundColor: Colors.transparent,
          scrolledUnderElevation: 0,
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios_rounded,
              size: 20,
              color: Colors.white,
            ),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: AppText(
            context.l10n.redeemGiftCard,
            style: (context) => AppTextStyles.appBarTitle(
              context,
            ).copyWith(color: isDark ? AppColors.lightText : Colors.white),
          ),
          centerTitle: true,
          elevation: 0,
        ),
        body: body,
      ),
    );

    if (pendingGift == null) {
      return scaffold;
    }
    return BlocProvider<RedeemGiftCubit>(
      create: (_) => RedeemGiftCubit(context.read<GiftRepository>()),
      child: scaffold,
    );
  }
}

class _RedeemCardBody extends StatelessWidget {
  const _RedeemCardBody({required this.pendingGift, required this.onRedeemed});

  final PendingGift? pendingGift;
  final VoidCallback? onRedeemed;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final senderLine = _senderLine(context);

    final content = SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: AppSpacing.md,
          horizontal: AppSpacing.lg,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Lottie.asset(
              "assets/json/gift.json",
              height: 120,
              width: 120,
              repeat: false,
            ),
            const SizedBox(height: AppSpacing.md),
            AppText(
              context.l10n.receivedGiftTitle,
              style: (context) => AppTextStyles.gelasioMedium(context).copyWith(
                color: isDark ? AppColors.lightText : Colors.white,
                height: 1.55,
              ),
            ),
            const SizedBox(height: AppSpacing.xs),
            AppText(
              senderLine,
              style: (context) => AppTextStyles.bodyText(context).copyWith(
                color: isDark
                    ? AppColors.darkGreyText
                    : AppColors.selectedLanguageBg,
                height: 1.55,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.lg),
            _MessageCard(pendingGift: pendingGift),
            const SizedBox(height: AppSpacing.lg),
            _RedeemButton(pendingGift: pendingGift, onRedeemed: onRedeemed),
          ],
        ),
      ),
    );

    return content;
  }

  String _senderLine(BuildContext context) {
    final fromMessage = _extractSenderFromMessage(pendingGift?.message);
    if (fromMessage != null && fromMessage.isNotEmpty) {
      return context.l10n.receivedGiftSubtitle.replaceFirst(
        RegExp(r'^[^\s]+'),
        fromMessage,
      );
    }
    return context.l10n.receivedGiftSubtitle;
  }

  /// Heuristic: messages often end with `— Sender` or `- Sender`. When found,
  /// surface that name so the subtitle matches the design.
  static String? _extractSenderFromMessage(String? message) {
    if (message == null) return null;
    final match = RegExp(
      r'(?:[—–-])\s*([^\n\r]+)\s*$',
    ).firstMatch(message.trim());
    final name = match?.group(1)?.trim();
    if (name == null || name.isEmpty) return null;
    return name;
  }
}

class _MessageCard extends StatelessWidget {
  const _MessageCard({required this.pendingGift});

  final PendingGift? pendingGift;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final code = pendingGift?.redemptionCode?.trim();
    final hasCode = code != null && code.isNotEmpty;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: isDark ? AppColors.trainerBlackBackgroundColor : Colors.white,
        borderRadius: BorderRadius.circular(AppRadius.base),
        border: Border.all(
          color: isDark ? AppColors.greyText : AppColors.buttonBorder,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          AppText(
            context.l10n.message,
            style: (context) => AppTextStyles.bodyText(
              context,
              fontWeight: FontWeight.w500,
            ).copyWith(height: 1.2),
          ),
          const SizedBox(height: AppSpacing.md),
          _messageBlock(context: context),
          const SizedBox(height: AppSpacing.xl),
          AppText(
            context.l10n.yourGiftIncludes,
            style: (context) => AppTextStyles.bodyText(
              context,
              fontWeight: FontWeight.w500,
            ).copyWith(height: 1.2),
          ),
          const SizedBox(height: AppSpacing.md),
          _checkedRow(context: context, feature: context.l10n.featureClasses),
          const SizedBox(height: AppSpacing.sm),
          _checkedRow(context: context, feature: context.l10n.featureStudios),
          const SizedBox(height: AppSpacing.sm),
          _checkedRow(context: context, feature: context.l10n.featureEquipment),
          const SizedBox(height: AppSpacing.sm),
          _checkedRow(context: context, feature: context.l10n.featurePriority),
          const SizedBox(height: AppSpacing.sm),
          _checkedRow(context: context, feature: context.l10n.featurePriority),
          const SizedBox(height: AppSpacing.xl),
          Divider(
            color: isDark ? AppColors.greyText : AppColors.buttonBorder,
            height: 1,
          ),
          const SizedBox(height: AppSpacing.xl),

          CustomPaint(
            painter: DashedUnderlinePainter(
              color: AppColors.languageIcon,
              dashWidth: 3,
              dashSpace: 3,
              top: true,
              left: true,
              right: true,
            ),
            child: Container(
              width: MediaQuery.of(context).size.width,
              padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(AppRadius.md),
                color: isDark
                    ? AppColors.primaryDarkContainer
                    : AppColors.selectedLanguageBg,
              ),
              child: Column(
                children: [
                  AppText(
                    context.l10n.redemptionCode,
                    style: (context) =>
                        AppTextStyles.bodyText(context).copyWith(
                          color: isDark
                              ? AppColors.darkGreyText
                              : AppColors.placeHolderText,
                          height: 1,
                        ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  AppText(
                    hasCode ? _formatCode(code) : "P I L A T E S   2 0 2 6",
                    style: (context) => AppTextStyles.bottomSheetTitle(
                      context,
                    ).copyWith(height: 1),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _messageBlock({required BuildContext context}) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final apiMessage = pendingGift?.message?.trim();
    final hasApiMessage = apiMessage != null && apiMessage.isNotEmpty;
    final messageText = hasApiMessage
        ? '"$apiMessage"'
        : '''"${context.l10n.birthdayMessage}"''';

    final senderName = _RedeemCardBody._extractSenderFromMessage(
      pendingGift?.message,
    );
    final senderLabel = senderName != null && senderName.isNotEmpty
        ? '— $senderName'
        : "";

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: isDark
            ? AppColors.subscriptionCardGradient1
            : AppColors.containerGreyBg,
        borderRadius: BorderRadius.circular(AppRadius.base),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          AppText(
            messageText,
            style: (context) => AppTextStyles.captionText(context).copyWith(
              color: isDark ? AppColors.lightText : AppColors.lightGrey,
              height: 1.5,
            ),
            maxLines: 6,
          ),
          const SizedBox(height: AppSpacing.sm),
          if (senderLabel.isNotEmpty)
            AppText(
              senderLabel,
              style: (context) => AppTextStyles.captionText(context).copyWith(
                color: isDark ? AppColors.darkGreyText : AppColors.lightGrey,
                height: 1.5,
              ),
            ),
        ],
      ),
    );
  }

  Widget _checkedRow({required BuildContext context, required String feature}) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          Icons.check,
          size: 12,
          color: isDark ? AppColors.languageIconDark : AppColors.languageIcon,
        ),
        const SizedBox(width: 4),
        Expanded(
          child: AppText(
            feature,
            style: (style) => AppTextStyles.bodyTextSmall(context).copyWith(
              color: isDark ? AppColors.lightText : AppColors.lightGrey,
              fontSize: 12,
              height: 1.2,
            ),
          ),
        ),
      ],
    );
  }

  /// Formats `GIFT-RPAF-BLHY` → `G I F T - R P A F - B L H Y`-like spacing
  /// (matches the dashed-tile presentation while preserving the API code).
  String _formatCode(String code) {
    final cleaned = code.trim();
    if (cleaned.isEmpty) return cleaned;
    return cleaned.split('').join(' ');
  }
}

class _RedeemButton extends StatelessWidget {
  const _RedeemButton({required this.pendingGift, required this.onRedeemed});

  final PendingGift? pendingGift;
  final VoidCallback? onRedeemed;

  @override
  Widget build(BuildContext context) {
    final code = pendingGift?.redemptionCode?.trim() ?? '';
    final canDirectRedeem =
        pendingGift != null &&
        code.isNotEmpty &&
        (pendingGift!.canBeRedeemed ?? false);

    if (!canDirectRedeem) {
      return AppButton(
        label: context.l10n.redeemYourGift,
        onPressed: () => showRedeemGiftCardBottomSheet(context),
        variant: AppButtonVariant.primary,
      );
    }

    return BlocConsumer<RedeemGiftCubit, RedeemGiftState>(
      listenWhen: (previous, current) =>
          (current.successPending && !previous.successPending) ||
          (current.serverError != null &&
              current.serverError != previous.serverError),
      listener: (context, state) {
        if (state.successPending) {
          context.read<RedeemGiftCubit>().consumeSuccess();
          _showSuccessSheet(context);
        } else if (state.serverError != null && state.serverError!.isNotEmpty) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.serverError!)));
        }
      },
      builder: (context, state) {
        return AppButton(
          label: context.l10n.redeemYourGift,
          isLoading: state.isSubmitting,
          onPressed: state.isSubmitting
              ? null
              : () => context.read<RedeemGiftCubit>().redeem(code),
          variant: AppButtonVariant.primary,
        );
      },
    );
  }

  void _showSuccessSheet(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      isDismissible: false,
      enableDrag: false,
      backgroundColor: Colors.transparent,
      barrierColor: AppColors.bottomSheetShadow,
      builder: (_) => GiftRedeemSuccessSheet(
        onContinue: () {
          Navigator.of(context).pop();
          if (Navigator.of(context).canPop()) {
            Navigator.of(context).pop();
          }
          onRedeemed?.call();
        },
      ),
    );
  }
}
