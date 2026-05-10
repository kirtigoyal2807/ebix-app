import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';

import 'package:pilates_app/config/theme/app_spacing.dart';
import 'package:pilates_app/features/booking/cubit/waitlist_cubit.dart';
import 'package:pilates_app/features/booking/cubit/waitlist_state.dart';
import 'package:pilates_app/features/booking/data/classes_repository.dart';
import 'package:pilates_app/features/booking/data/models/class_slot_view_model.dart';
import 'package:pilates_app/widgets/app_app_bar.dart';
import 'package:pilates_app/widgets/app_shadow.dart';
import 'package:pilates_app/widgets/app_text.dart';

import '../../../config/theme/app_colors.dart';
import '../../../config/theme/app_radius.dart';
import '../../../config/theme/app_text_styles.dart';
import '../../../core/localization/arb/app_localizations.dart';
import '../../../widgets/app_button.dart';
import '../../home/booking_flow_navigation.dart';
import 'booking_success_view.dart';

class JoinWaitlistView extends StatelessWidget {
  const JoinWaitlistView({super.key, required this.slot});

  final ClassSlotViewModel slot;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (ctx) => WaitlistCubit(
        ctx.read<ClassesRepository>(),
        calendarEventId: slot.calendarEventId,
        waitlistCount: slot.waitlistCount,
      ),
      child: _JoinWaitlistBody(slot: slot),
    );
  }
}

class _JoinWaitlistBody extends StatelessWidget {
  const _JoinWaitlistBody({required this.slot});

  final ClassSlotViewModel slot;

  String _formatTime(DateTime dt) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final slotDay = DateTime(dt.year, dt.month, dt.day);
    final timeStr = DateFormat('h:mm a').format(dt.toLocal());
    if (slotDay == today) return 'Today, $timeStr';
    if (slotDay == today.add(const Duration(days: 1))) {
      return 'Tomorrow, $timeStr';
    }
    return '${DateFormat('EEE, MMM d').format(dt.toLocal())}, $timeStr';
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: isDark ? AppColors.homeBackground : AppColors.whiteColor,
      appBar: AppAppBar(
        onBack: () => Navigator.of(context).pop(),
        title: l10n.joinWailList,
        isMoreMenu: false,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildClassDetailsCard(context, isDark),
            SizedBox(height: AppSpacing.sm),
            Divider(
              color: isDark ? AppColors.greyText : AppColors.buttonBorder,
            ),
            SizedBox(height: AppSpacing.lg),
            _buildClassCard(context, isDark),
            SizedBox(height: AppSpacing.lg),
            _buildWaitListCard(context, isDark),
            SizedBox(height: AppSpacing.lg),
            _buildSmartTip(context, isDark),
            SizedBox(height: AppSpacing.lg),
            _buildErrorText(context),
            _buildFooterLinks(context, isDark),
            SizedBox(height: MediaQuery.of(context).viewPadding.bottom),
          ],
        ),
      ),
    );
  }

  Widget _buildClassDetailsCard(BuildContext context, bool isDark) {
    return Container(
      margin: EdgeInsets.symmetric(
        vertical: AppSpacing.md,
        horizontal: AppSpacing.lg,
      ),
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? AppColors.homeBackground : AppColors.whiteColor,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(
          color: isDark ? AppColors.greyText : AppColors.buttonBorder,
        ),
        boxShadow: [
          AppShadows.lightShadow,
          AppShadows.mediumShadow,
          AppShadows.mediumHeavyShadow,
          AppShadows.heavyShadow,
          AppShadows.extraHeavyShadow,
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 72,
            width: 94,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
            child: ClipRRect(
              borderRadius: BorderRadius.vertical(
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
          SizedBox(width: AppSpacing.lmd),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText(
                  slot.name,
                  style: (ctx) =>
                      AppTextStyles.gelasioMedium(ctx).copyWith(height: 1.2),
                ),
                SizedBox(height: AppSpacing.md),
                _buildDetailRow(
                  Icons.location_on_outlined,
                  slot.branchName,
                  isDark,
                ),
                SizedBox(height: AppSpacing.sm),
                _buildDetailRow(
                  Icons.watch_later_outlined,
                  _formatTime(slot.startAt),
                  isDark,
                ),
                SizedBox(height: AppSpacing.sm),
                _buildDetailRow(Icons.person_outline, slot.trainerName, isDark),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String text, bool isDark) {
    return Row(
      children: [
        Icon(
          icon,
          size: 16,
          color: isDark ? AppColors.languageIconDark : AppColors.languageIcon,
        ),
        const SizedBox(width: 4),
        Expanded(
          child: AppText(
            text,
            style: (ctx) => AppTextStyles.bodyTextSmall(ctx),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildClassCard(BuildContext context, bool isDark) {
    final l10n = AppLocalizations.of(context);
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: AppSpacing.lmd, vertical: 40),
      margin: EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      decoration: BoxDecoration(
        color: isDark ? AppColors.homeBackground : AppColors.seekBarLight,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(
          color: isDark ? AppColors.greyText : AppColors.buttonBorder,
        ),
      ),
      child: Column(
        children: [
          SvgPicture.asset('assets/images/svg/ic_calender.svg'),
          SizedBox(height: AppSpacing.md),
          AppText(
            l10n.classIsFull,
            style: (ctx) => AppTextStyles.gelasioMedium(ctx),
          ),
          SizedBox(height: AppSpacing.xs),
          AppText(
            l10n.classIsFullDescription,
            style: (ctx) => AppTextStyles.textField(ctx).copyWith(
              color: isDark ? AppColors.darkGreyText : AppColors.greyText,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildWaitListCard(BuildContext context, bool isDark) {
    final l10n = AppLocalizations.of(context);
    final waitlistCount = slot.waitlistCount ?? 0;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 20, horizontal: 16),
        decoration: BoxDecoration(
          color: isDark ? AppColors.homeBackground : AppColors.whiteColor,
          borderRadius: BorderRadius.circular(AppRadius.md),
          border: Border.all(
            color: isDark ? AppColors.greyText : AppColors.buttonBorder,
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppText(
                    l10n.currentWaitList,
                    style: (ctx) =>
                        AppTextStyles.helpAndSupportItemSubLabel(ctx).copyWith(
                          color: AppColors.lightGrey,
                          fontWeight: FontWeight.w500,
                        ),
                  ),
                  SizedBox(height: AppSpacing.sm),
                  AppText(
                    '$waitlistCount ${l10n.people}',
                    style: (ctx) => AppTextStyles.experienceButton(
                      ctx,
                    ).copyWith(fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
            isDark
                ? SvgPicture.asset(
                    'assets/images/svg/ic_waitlist_person_dark.svg',
                  )
                : SvgPicture.asset('assets/images/svg/ic_waitlist_person.svg'),
          ],
        ),
      ),
    );
  }

  Widget _buildSmartTip(BuildContext context, bool isDark) {
    final l10n = AppLocalizations.of(context);
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      child: Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isDark
              ? AppColors.primaryDarkButton
              : AppColors.greyContainerBg,
          borderRadius: BorderRadius.circular(AppRadius.base),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SvgPicture.asset('assets/images/svg/ic_tip.svg'),
            SizedBox(width: AppSpacing.sm),
            Expanded(
              child: RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: '${l10n.smartTip}: ',
                      style: AppTextStyles.helpAndSupportItemSubLabel(
                        context,
                      ).copyWith(fontWeight: FontWeight.w600),
                    ),
                    TextSpan(
                      text: l10n.smartTipDescription,
                      style: AppTextStyles.helpAndSupportItemSubLabel(
                        context,
                      ).copyWith(height: 1.55),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorText(BuildContext context) {
    return BlocBuilder<WaitlistCubit, WaitlistState>(
      buildWhen: (prev, next) => prev.errorMessage != next.errorMessage,
      builder: (context, state) {
        final msg = state.errorMessage;
        if (msg == null || msg.isEmpty) return const SizedBox.shrink();
        return Padding(
          padding: EdgeInsets.fromLTRB(
            AppSpacing.lg,
            0,
            AppSpacing.lg,
            AppSpacing.md,
          ),
          child: AppText(
            msg,
            style: (ctx) => AppTextStyles.bodyTextSmall(
              ctx,
            ).copyWith(color: AppColors.lightRedColor),
          ),
        );
      },
    );
  }

  Widget _buildFooterLinks(BuildContext context, bool isDark) {
    final l10n = AppLocalizations.of(context);
    return Padding(
      padding: EdgeInsets.only(
        left: AppSpacing.lg,
        right: AppSpacing.lg,
        bottom: 34,
      ),
      child: Column(
        children: [
          BlocBuilder<WaitlistCubit, WaitlistState>(
            builder: (context, state) {
              return AppButton(
                label: l10n.joinWaitList,
                isLoading: state.isSubmitting,
                onPressed: state.isSubmitting
                    ? null
                    : () async {
                        final cubit = context.read<WaitlistCubit>();
                        final ok = await cubit.joinWaitlist();
                        if (!context.mounted) return;
                        if (ok) {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (_) => BookingSuccessScreen(
                                successPage: SuccessPage.waitList,
                                slot: slot,
                                booking: cubit.state.bookingResult,
                              ),
                            ),
                          );
                        }
                      },
              );
            },
          ),
          SizedBox(height: AppSpacing.sm),
          Container(
            decoration: BoxDecoration(
              color: isDark ? AppColors.homeBackground : Colors.white,
              borderRadius: BorderRadius.circular(AppRadius.xl),
              boxShadow: [
                BoxShadow(
                  color: AppColors.shadowColor.withValues(alpha: 0.06),
                  offset: const Offset(0, 1),
                  blurRadius: 2,
                  spreadRadius: 0,
                ),
              ],
            ),
            child: AppButton(
              label: l10n.browseOtherClasses,
              variant: AppButtonVariant.secondary,
              onPressed: () => popBookingFlowToClassesTab(context),
            ),
          ),
        ],
      ),
    );
  }
}
