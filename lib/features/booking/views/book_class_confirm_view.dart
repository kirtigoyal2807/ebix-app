import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';

import 'package:pilates_app/config/theme/app_spacing.dart';
import 'package:pilates_app/core/network/api_result.dart';
import 'package:pilates_app/core/utils/checkout_payment_launcher.dart';
import 'package:pilates_app/core/utils/hosted_payment_webview_page.dart';
import 'package:pilates_app/features/auth/cubit/auth_cubit.dart';
import 'package:pilates_app/features/booking/booking_entitlements.dart';
import 'package:pilates_app/features/booking/data/models/class_slot_view_model.dart';
import 'package:pilates_app/features/my_booking/data/models/booking_resource.dart';
import 'package:pilates_app/widgets/app_app_bar.dart';
import 'package:pilates_app/widgets/app_shadow.dart';
import 'package:pilates_app/widgets/app_text.dart';

import '../../../config/theme/app_colors.dart';
import '../../../config/theme/app_radius.dart';
import '../../../config/theme/app_text_styles.dart';
import '../../../core/localization/arb/app_localizations.dart';
import '../../../core/utils/currency_display.dart';
import '../../../widgets/app_button.dart';
import '../cubit/confirm_booking_cubit.dart';
import '../cubit/confirm_booking_state.dart';
import '../data/classes_repository.dart';
import 'booking_success_view.dart';

class BookClassConfirmView extends StatelessWidget {
  const BookClassConfirmView({
    super.key,
    required this.calendarEventId,
    required this.slot,
  });

  final String calendarEventId;
  final ClassSlotViewModel slot;

  String get _timeLabel {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final slotDay = DateTime(
      slot.startAt.year,
      slot.startAt.month,
      slot.startAt.day,
    );
    final start = DateFormat('h:mm a').format(slot.startAt.toLocal());
    final end = DateFormat('h:mm a').format(slot.endAt.toLocal());
    final prefix = slotDay == today
        ? 'Today'
        : slotDay == today.add(const Duration(days: 1))
        ? 'Tomorrow'
        : DateFormat('EEE, MMM d').format(slot.startAt.toLocal());
    return '$prefix, $start – $end';
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: isDark ? AppColors.homeBackground : AppColors.whiteColor,

      appBar: AppAppBar(
        onBack: () => Navigator.of(context).pop(),
        title: l10n.bookYourClass,
        isMoreMenu: false,
      ),
      body: BlocProvider(
        create: (context) {
          final membership = userShowsPackageMembership(
            context.read<AuthCubit>().state.user,
          );
          return ConfirmBookingCubit(
            context.read<ClassesRepository>(),
            calendarEventId: calendarEventId,
            usePlanSessionBooking:
                membership && slot.allowPackageBooking,
            allowSinglePurchaseCheckout: slot.allowSinglePurchase,
          );
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildClassDetailsCard(isDark: isDark),
            SizedBox(height: AppSpacing.sm),
            Divider(
              color: isDark ? AppColors.greyText : AppColors.buttonBorder,
              height: 1,
            ),
            SizedBox(height: AppSpacing.lg),

            _buildPaymentSummary(context: context, isDark: isDark, l10n: l10n),
            SizedBox(height: AppSpacing.lg),

            _buildPolicyAgreement(l10n: l10n, isDark: isDark),
            Spacer(),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg),
              child: BlocBuilder<ConfirmBookingCubit, ConfirmBookingState>(
                builder: (context, state) {
                  final membership = userShowsPackageMembership(
                    context.read<AuthCubit>().state.user,
                  );
                  final canCheckout = (membership && slot.allowPackageBooking) ||
                      slot.allowSinglePurchase;
                  return AppButton(
                    label: l10n.confirmBooking,
                    isLoading: state.isSubmitting,
                    onPressed: state.isSubmitting || !canCheckout
                        ? null
                        : () async {
                            final cubit = context.read<ConfirmBookingCubit>();
                            if (!cubit.state.agreePolicy) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(l10n.acceptPolicyToContinue),
                                ),
                              );
                              return;
                            }

                            final classesRepo =
                                context.read<ClassesRepository>();
                            final messenger = ScaffoldMessenger.of(context);

                            final result = await cubit.submit();
                            if (!context.mounted) return;

                            if (result.confirmedBooking != null) {
                              _pushBookingSuccess(
                                context,
                                result.confirmedBooking!,
                              );
                              return;
                            }

                            final pending = result.pendingHostedPayment;
                            if (pending != null) {
                              final webResult =
                                  await CheckoutPaymentLauncher
                                      .openInAppPaymentWebView(
                                context,
                                pending.paymentUrl,
                              );
                              if (!context.mounted) return;
                              if (webResult?.outcome !=
                                  HostedPaymentWebViewOutcome.success) {
                                return;
                              }
                              final confirmed = await classesRepo.confirmPayment(
                                paymentReference: pending.paymentReference,
                                paidAmount: pending.amount,
                                currency: pending.currency,
                              );
                              if (!context.mounted) return;
                              switch (confirmed) {
                                case ApiSuccess(:final data):
                                  _pushBookingSuccess(context, data);
                                case ApiFailure(:final exception):
                                  messenger.showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        exception.message ??
                                            l10n.somethingWentWrong,
                                      ),
                                    ),
                                  );
                              }
                              return;
                            }

                            final err = result.errorMessage;
                            if (err != null && err.startsWith('_')) {
                              messenger.showSnackBar(
                                SnackBar(content: Text(l10n.somethingWentWrong)),
                              );
                              return;
                            }
                            if (err != null && err.isNotEmpty) {
                              messenger.showSnackBar(
                                SnackBar(content: Text(err)),
                              );
                              return;
                            }
                            if (!cubit.usePlanSessionBooking &&
                                !cubit.allowSinglePurchaseCheckout) {
                              messenger.showSnackBar(
                                SnackBar(content: Text(l10n.upgradeRequired)),
                              );
                            }
                          },
                    variant: AppButtonVariant.primary,
                  );
                },
              ),
            ),
            const SizedBox(height: 34),
          ],
        ),
      ),
    );
  }

  Widget _buildClassDetailsCard({required bool isDark}) {
    return Container(
      margin: EdgeInsets.symmetric(
        vertical: AppSpacing.md,
        horizontal: AppSpacing.lg,
      ),
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? AppColors.primaryDarkButton : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? AppColors.greyText : AppColors.buttonBorder,
          width: 0.5,
        ),
        boxShadow: isDark
            ? [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.06),
                  offset: const Offset(0, 4),
                  blurRadius: 8,
                  spreadRadius: 0,
                ),
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.04),
                  offset: const Offset(0, 0),
                  blurRadius: 4,
                  spreadRadius: 0,
                ),
              ]
            : [
                AppShadows.lightShadow,
                AppShadows.mediumShadow,
                AppShadows.mediumHeavyShadow,
                BoxShadow(
                  color: AppColors.shadowColor.withValues(alpha: 0.01),
                  offset: const Offset(0, 64),
                  blurRadius: 25,
                  spreadRadius: 0,
                ),
                BoxShadow(
                  color: AppColors.shadowColor.withValues(alpha: 0.00),
                  offset: const Offset(0, 99),
                  blurRadius: 28,
                  spreadRadius: 0,
                ),
              ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText(
                  slot.name,
                  style: (context) => AppTextStyles.gelasioMedium(context),
                ),
                SizedBox(height: AppSpacing.lmd),
                _buildDetailRow(
                  icon: Icons.location_on_outlined,
                  text: slot.branchName,
                  isDark: isDark,
                ),
                SizedBox(height: AppSpacing.sm),
                _buildDetailRow(
                  icon: Icons.watch_later_outlined,
                  text: _timeLabel,
                  isDark: isDark,
                ),
                SizedBox(height: AppSpacing.sm),
                _buildDetailRow(
                  icon: Icons.person_outline,
                  text: slot.trainerName,
                  isDark: isDark,
                ),
              ],
            ),
          ),
          Container(
            height: 72,
            width: 94,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(AppRadius.md),
                bottom: Radius.circular(AppRadius.md),
              ),
              child: slot.imageUrl != null && slot.imageUrl!.isNotEmpty
                  ? Image.network(
                      slot.imageUrl!,
                      height: 72,
                      width: 94,
                      fit: BoxFit.fill,
                      errorBuilder: (_, _, _) => Image.asset(
                        'assets/images/demo images/yoga.png',
                        height: 72,
                        width: 94,
                        fit: BoxFit.fill,
                      ),
                    )
                  : Image.asset(
                      'assets/images/demo images/yoga.png',
                      height: 72,
                      width: 94,
                      fit: BoxFit.fill,
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow({
    required IconData icon,
    required String text,
    required bool isDark,
  }) {
    return Row(
      children: [
        Icon(
          icon,
          color: isDark ? AppColors.languageIconDark : AppColors.languageIcon,
          size: 16,
        ),
        const SizedBox(width: 4),
        AppText(text, style: (context) => AppTextStyles.bodyTextSmall(context)),
      ],
    );
  }

  Widget _buildPaymentSummary({
    required BuildContext context,
    required bool isDark,
    required AppLocalizations l10n,
  }) {
    final price = slot.basePrice;
    final priceLabel = price != null
        ? _formatClassPrice(context, price)
        : l10n.bookingPriceUnavailable;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppText(
            l10n.paymentSummery,
            style: (context) => AppTextStyles.gelasioRegular(context),
          ),
          SizedBox(height: AppSpacing.md),
          Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: isDark
                  ? AppColors.primaryDarkButton
                  : AppColors.seekBarLight,
              borderRadius: BorderRadius.circular(AppRadius.base),
            ),
            child: Column(
              children: [
                _buildPaymentRow(title: l10n.classFee, value: priceLabel),
                SizedBox(height: AppSpacing.md),
                Divider(
                  color: isDark ? AppColors.greyText : AppColors.darkGreyBorder,
                  height: 1,
                ),
                SizedBox(height: AppSpacing.md),
                _buildPaymentRow(title: l10n.total, value: priceLabel),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static String _formatClassPrice(BuildContext context, double amount) {
    return formatCurrencyAmount(amount: amount, code: 'SAR');
  }

  void _pushBookingSuccess(BuildContext context, BookingResource booking) {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute<void>(
        builder: (_) => BookingSuccessScreen(
          successPage: SuccessPage.booking,
          slot: slot,
          booking: booking,
        ),
      ),
    );
  }

  Widget _buildPaymentRow({required String title, required String value}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        AppText(
          title,
          style: (context) => AppTextStyles.bodyTextSmall(context),
        ),
        AppText(
          value,
          style: (context) => AppTextStyles.textFieldHeading(context),
        ),
      ],
    );
  }

  Widget _buildPolicyAgreement({
    required AppLocalizations l10n,
    required bool isDark,
  }) {
    return BlocBuilder<ConfirmBookingCubit, ConfirmBookingState>(
      builder: (context, state) {
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () {
                  context.read<ConfirmBookingCubit>().setAgree();
                },
                child: state.agreePolicy == true
                    ? Container(
                        width: 20,
                        height: 20,
                        decoration: BoxDecoration(
                          color: (isDark
                              ? AppColors.languageIconDark
                              : AppColors.languageIcon),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Center(
                          child: SvgPicture.asset(
                            "assets/images/svg/ic_checkbox_white.svg",
                            width: 8,
                            height: 8,
                            fit: BoxFit.contain,
                            alignment: Alignment.center,
                          ),
                        ),
                      )
                    : SizedBox(
                        height: 20,
                        width: 20,
                        child: Checkbox(
                          value: state.agreePolicy,
                          onChanged: (value) {
                            context.read<ConfirmBookingCubit>().setAgree();
                          },
                          materialTapTargetSize:
                              MaterialTapTargetSize.shrinkWrap,
                          visualDensity: const VisualDensity(
                            horizontal: -4,
                            vertical: -4,
                          ),
                          activeColor: AppColors.languageIcon,
                          checkColor: Colors.white,
                          side: const BorderSide(
                            color: AppColors.buttonBorder,
                            width: 1,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ),
              ),

              SizedBox(width: AppSpacing.base),
              Expanded(
                child: AppText(
                  l10n.cancelPolicyDescription,
                  style: (context) =>
                      AppTextStyles.helpAndSupportItemSubLabel(context),
                  maxLines: 3,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
