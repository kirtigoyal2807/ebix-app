import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:lottie/lottie.dart';
import 'package:url_launcher/url_launcher.dart';
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
  const RedeemCardView({
    super.key,
    this.pendingGift,
    this.onRedeemSuccess,
    this.routePopsAfterSuccessModal = 1,
  });

  /// When provided, the screen renders the actual gift content (sender/message/code)
  /// and the "Redeem Your Gift" button calls `POST /gifts/redeem` directly with
  /// [PendingGift.redemptionCode]. When null, falls back to the legacy flow that
  /// opens the manual code-entry bottom sheet.
  final PendingGift? pendingGift;

  /// Optional callback fired once when `POST /gifts/redeem` succeeds — before
  /// the success sheet is shown (e.g. silent home + `/auth/me` refresh).
  final VoidCallback? onRedeemSuccess;

  /// How many routes to pop after the success modal is closed (not counting the
  /// modal). Use `2` when this screen was opened on top of [ReceiveGiftSheet]
  /// (pending gift on home); default `1` is only [RedeemCardView].
  final int routePopsAfterSuccessModal;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final body = _RedeemCardBody(
      pendingGift: pendingGift,
      onRedeemSuccess: onRedeemSuccess,
    );

    final scaffold = Container(
      decoration: BoxDecoration(
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
        body: Stack(
          fit: StackFit.expand,
          children: [
            body,
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
                    colors: [
                      AppColors.subscriptionCardGradient2,
                      AppColors.subscriptionCardGradient2.withValues(alpha: 0),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: AppSpacing.md,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                child: _RedeemButton(
                  pendingGift: pendingGift,
                  onRedeemSuccess: onRedeemSuccess,
                  routePopsAfterSuccessModal: routePopsAfterSuccessModal,
                ),
              ),
            ),
          ],
        ),
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
  const _RedeemCardBody({
    required this.pendingGift,
    required this.onRedeemSuccess,
  });

  final PendingGift? pendingGift;
  final VoidCallback? onRedeemSuccess;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final senderLine = _senderLine(context);

    final content = SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(
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
            SizedBox(height: AppSpacing.md),
            AppText(
              context.l10n.receivedGiftTitle,
              style: (context) => AppTextStyles.gelasioMedium(context).copyWith(
                color: isDark ? AppColors.lightText : Colors.white,
                height: 1.55,
              ),
            ),
            SizedBox(height: AppSpacing.xs),
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
            SizedBox(height: AppSpacing.lg),
            _MessageCard(pendingGift: pendingGift),
            SizedBox(height: AppSpacing.xxxl * 2),
          ],
        ),
      ),
    );

    return content;
  }

  String _senderLine(BuildContext context) {
    final name = pendingGift?.sender?.name?.trim();
    if (name != null && name.isNotEmpty) {
      return context.l10n.receivedGiftSubtitle.replaceFirst(
        RegExp(r'^[^\s]+'),
        name,
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
    final planDescriptionHtml = pendingGift?.plan?.description?.trim();
    final baseCaption = AppTextStyles.captionText(context).copyWith(
      color: isDark ? AppColors.lightText : AppColors.lightGrey,
      height: 1.5,
    );
    final giftPlanIncludesMaxLinesHeight =
        (baseCaption.fontSize ?? 12) * (baseCaption.height ?? 1.5) * 6;

    final apiMessage = pendingGift?.message?.trim();

    return Container(
      padding: EdgeInsets.all(AppSpacing.md),
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
          if (apiMessage !=null)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText(
                  context.l10n.message,
                  style: (context) => AppTextStyles.bodyText(
                    context,
                    fontWeight: FontWeight.w500,
                  ).copyWith(height: 1.2),
                ),
                SizedBox(height: AppSpacing.md),
                _messageBlock(context: context, apiMessage: apiMessage),
                SizedBox(height: AppSpacing.xl),
              ],
            ),
          AppText(
            context.l10n.yourGiftIncludes,
            style: (context) => AppTextStyles.bodyText(
              context,
              fontWeight: FontWeight.w500,
            ).copyWith(height: 1.2),
          ),
          SizedBox(height: AppSpacing.base),
          if (planDescriptionHtml != null && planDescriptionHtml.isNotEmpty)
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.0),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight: giftPlanIncludesMaxLinesHeight,
                ),
                child: ClipRect(
                  child: SizedBox(
                    width: double.infinity,
                    child: Html(
                      data: planDescriptionHtml,
                      shrinkWrap: true,
                      style: {
                        'body': Style(
                          margin: Margins.zero,
                          padding: HtmlPaddings.zero,
                          fontSize: FontSize(baseCaption.fontSize ?? 12),
                          color: baseCaption.color,
                          fontFamily: baseCaption.fontFamily,
                          textAlign: TextAlign.start,
                        ),
                        'p': Style(
                          margin: Margins.only(bottom: 8),
                          textAlign: TextAlign.start,
                        ),
                        'h1': Style(
                          margin: Margins.only(top: 8, bottom: 8),
                          textAlign: TextAlign.start,
                        ),
                        'h2': Style(
                          margin: Margins.only(top: 8, bottom: 8),
                          textAlign: TextAlign.start,
                        ),
                        'h3': Style(
                          margin: Margins.only(top: 8, bottom: 8),
                          textAlign: TextAlign.start,
                        ),
                        'ul': Style(
                          margin: Margins.only(bottom: 8),
                          textAlign: TextAlign.start,
                        ),
                        'ol': Style(
                          margin: Margins.only(bottom: 8),
                          textAlign: TextAlign.start,
                        ),
                        'div': Style(textAlign: TextAlign.start),
                        'li': Style(textAlign: TextAlign.start),
                      },
                      onLinkTap: (url, attributes, element) async {
                        if (url == null || url.isEmpty) return;
                        final uri = Uri.tryParse(url.trim());
                        if (uri == null) return;
                        try {
                          await launchUrl(
                            uri,
                            mode: LaunchMode.externalApplication,
                          );
                        } catch (_) {}
                      },
                    ),
                  ),
                ),
              ),
            ),
          SizedBox(height: AppSpacing.xl),
          Divider(
            color: isDark ? AppColors.greyText : AppColors.buttonBorder,
            height: 1,
          ),
          SizedBox(height: AppSpacing.xl),

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
              padding: EdgeInsets.symmetric(vertical: AppSpacing.md),
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
                  SizedBox(height: AppSpacing.md),
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

  Widget _messageBlock({
    required BuildContext context,
    required String? apiMessage,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final senderName = _RedeemCardBody._extractSenderFromMessage(
      pendingGift?.message,
    );
    final senderLabel = senderName != null && senderName.isNotEmpty
        ? '— $senderName'
        : "";

    return Container(
      padding: EdgeInsets.all(AppSpacing.md),
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
            apiMessage ?? '',
            style: (context) => AppTextStyles.captionText(context).copyWith(
              color: isDark ? AppColors.lightText : AppColors.lightGrey,
              height: 1.5,
            ),
            maxLines: 6,
          ),
          SizedBox(height: AppSpacing.sm),
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

  /// Formats `GIFT-RPAF-BLHY` → `G I F T - R P A F - B L H Y`-like spacing
  /// (matches the dashed-tile presentation while preserving the API code).
  String _formatCode(String code) {
    final cleaned = code.trim();
    if (cleaned.isEmpty) return cleaned;
    return cleaned.split('').join(' ');
  }
}

class _RedeemButton extends StatelessWidget {
  const _RedeemButton({
    required this.pendingGift,
    required this.onRedeemSuccess,
    required this.routePopsAfterSuccessModal,
  });

  final PendingGift? pendingGift;
  final VoidCallback? onRedeemSuccess;
  final int routePopsAfterSuccessModal;

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
          onRedeemSuccess?.call();
          _showSuccessSheet(
            context,
            routePopsAfterSuccessModal: routePopsAfterSuccessModal,
          );
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

  void _showSuccessSheet(
    BuildContext context, {
    required int routePopsAfterSuccessModal,
  }) {
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
          var remaining = routePopsAfterSuccessModal;
          while (remaining > 0 && context.mounted) {
            if (!Navigator.of(context).canPop()) break;
            Navigator.of(context).pop();
            remaining--;
          }
        },
      ),
    );
  }
}
