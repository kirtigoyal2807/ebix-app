import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:pilates_app/config/theme/app_spacing.dart';
import 'package:pilates_app/widgets/app_shadow.dart';
import 'package:pilates_app/widgets/app_text.dart';
import '../../../config/theme/app_colors.dart';
import '../../../config/theme/app_radius.dart';
import '../../../config/theme/app_text_styles.dart';
import '../../../core/localization/arb/app_localizations.dart';
import '../../../widgets/app_button.dart';
import '../../../widgets/dotted_underline.dart';
import '../cubit/booking_cubit.dart';
import '../cubit/booking_state.dart';
import 'class_detail_view.dart';


class BookingSuccessScreen extends StatelessWidget {
  const BookingSuccessScreen({super.key, required this.successPage});

  final SuccessPage successPage;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundDark : Colors.white,
      body: SingleChildScrollView(
        padding: EdgeInsetsDirectional.only(
          top: MediaQuery.of(context).viewPadding.top,
          bottom: MediaQuery.of(context).viewPadding.bottom,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: AppSpacing.xl),

            Container(
              height: 100,
              width: 100,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: AppColors.successColor,
                borderRadius: BorderRadius.circular(AppRadius.pillRadius),
              ),
              child: const Icon(Icons.done, color: Colors.white, size: 80),
            ),

            const SizedBox(height: AppSpacing.md),

            AppText(
              successPage == SuccessPage.booking
                  ? l10n.bookingSuccess
                  : l10n.onWaitList,
              style: (context) => AppTextStyles.gelasioMedium(context).copyWith(
                fontSize: 24,
                color: isDark ? AppColors.lightText : const Color(0xff0D0D12),
              ),
            ),

            const SizedBox(height: AppSpacing.sm),

            AppText(
              successPage == SuccessPage.booking
                  ? l10n.successMessage
                  : l10n.onWaitListDescription,
              style: (context) => AppTextStyles.bodyText(context),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: AppSpacing.lg),

            successPage == SuccessPage.booking
                ? _buildCheckInSection(context, isDark)
                : _buildPositionCard(context, isDark),

            const SizedBox(height: AppSpacing.lg),

            _buildClassDetailsSection(context, isDark),

            const SizedBox(height: AppSpacing.lg),

            _buildActionButtons(context, isDark),

            const SizedBox(height: AppSpacing.lg),

            Padding(
              padding: const EdgeInsetsDirectional.symmetric(
                horizontal: AppSpacing.lg,
              ),
              child: AppText(
                l10n.cancelBooking,
                style: (context) =>
                    AppTextStyles.helpAndSupportItemSubLabel(context),
                textAlign: TextAlign.start,
              ),
            ),

            const SizedBox(height: AppSpacing.lg),
            _buildFooterLinks(context, isDark),
          ],
        ),
      ),
    );
  }

  Widget _buildCheckInSection(BuildContext context, bool isDark) {
    final l10n = AppLocalizations.of(context);

    return Container(
      margin: const EdgeInsetsDirectional.symmetric(horizontal: AppSpacing.lg),
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: isDark ? AppColors.primaryDarkContainer : AppColors.seekBarLight,
        borderRadius: BorderRadius.circular(AppRadius.base),
        border: isDark ? null : Border.all(color: AppColors.darkGreyBorder),
      ),
      child: Column(
        children: [
          SvgPicture.asset("assets/images/svg/ic_clock.svg"),
          const SizedBox(height: AppSpacing.md),

          AppText(
            l10n.checkIn,
            style: (context) => AppTextStyles.experienceButton(context),
          ),

          const SizedBox(height: AppSpacing.xi),

          AppText(
            l10n.checkInDescription,
            style: (context) => AppTextStyles.bodyText(context),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: AppSpacing.md),

          AppButton(
            label: l10n.checkInButton,
            variant: AppButtonVariant.disable,
            onPressed: () {},
          ),

          const SizedBox(height: AppSpacing.md),

          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const Icon(
                Icons.warning_amber_rounded,
                size: 16,
                color: AppColors.languageIcon,
              ),
              const SizedBox(width: AppSpacing.xs),
              Expanded(
                child: AppText(
                  l10n.checkInLongDescription,
                  style: (context) =>
                      AppTextStyles.helpAndSupportItemSubLabel(context),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPositionCard(BuildContext context, bool isDark) {
    final l10n = AppLocalizations.of(context);

    return Column(
      children: [
        Divider(color: isDark ? AppColors.greyText : AppColors.buttonBorder),
        const SizedBox(height: AppSpacing.lg),
        Container(
          width: double.infinity,
          margin: const EdgeInsetsDirectional.symmetric(
            horizontal: AppSpacing.lg,
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.md,
          ),
          decoration: BoxDecoration(
            color: isDark
                ? AppColors.primaryDarkContainer
                : AppColors.seekBarLight,
            borderRadius: BorderRadius.circular(AppRadius.base),
            border: isDark
                ? null
                : Border.all(width: 1, color: AppColors.darkGreyBorder),
          ),
          child: Column(
            children: [
              AppText(
                l10n.yourPosition,
                style: (context) => AppTextStyles.captionText(
                  context,
                ).copyWith(color: isDark ? AppColors.darkGreyText:AppColors.lightGrey),
              ),
              const SizedBox(height: AppSpacing.md),
              AppText(
                '#3',
                style: (context) =>
                    AppTextStyles.appBarText(context).copyWith(fontSize: 32),
              ),
              const SizedBox(height: AppSpacing.sm),
              AppText(
                l10n.inLine,
                style: (context) => AppTextStyles.captionText(
                  context,
                ).copyWith(color: isDark ? AppColors.darkGreyText:AppColors.lightGrey),
              ),
            ],
          ),
        ),

        const SizedBox(height: AppSpacing.lg),
        Divider(color: isDark ? AppColors.greyText : AppColors.buttonBorder),
      ],
    );
  }

  Widget _buildClassDetailsSection(BuildContext context, bool isDark) {
    final l10n = AppLocalizations.of(context);

    return Container(
      margin: const EdgeInsetsDirectional.symmetric(horizontal: AppSpacing.lg),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? AppColors.homeBackground : AppColors.whiteColor,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(
          color: isDark ? AppColors.greyText : AppColors.buttonBorder,),
        boxShadow: [
          AppShadows.lightShadow,
          AppShadows.mediumShadow,
          AppShadows.mediumHeavyShadow,
          AppShadows.heavyShadow,
          AppShadows.extraHeavyShadow,
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppText(
            l10n.classDetail,
            style: (context) => AppTextStyles.gelasioMedium(context),
          ),

          const SizedBox(height: AppSpacing.lmd),

          _buildClassDetailRow(
            label: l10n.classFee,
            value: 'Core Strength & Balance',
          ),

          const SizedBox(height: AppSpacing.sm),

          _buildClassDetailRow(
            label: l10n.instructor,
            value: 'Fatima Al-Hashmi',
          ),

          const SizedBox(height: AppSpacing.sm),

          _buildClassDetailRow(
            label: l10n.date,
            value: 'Today, January 21, 2026',
          ),

          const SizedBox(height: AppSpacing.sm),

          _buildClassDetailRow(label: l10n.time, value: '6:00 PM - 7:00 PM'),

          const SizedBox(height: AppSpacing.sm),

          _buildClassDetailRow(
            label: l10n.location,
            value: 'Downtown Studio, 123 Main Street, Suite 200',
            isMultiLine: true,
            isBorder: false,
          ),
        ],
      ),
    );
  }

  Widget _buildClassDetailRow({
    required String label,
    required String value,
    bool isMultiLine = false,
    bool isBorder = true,
  }) {
    return SizedBox(
      width: double.infinity,
      child: CustomPaint(
        painter: isBorder
            ? DashedUnderlinePainter(color: AppColors.buttonBorder)
            : null,
        child: Padding(
          padding: EdgeInsets.only(bottom: isBorder ? AppSpacing.sm : 0),
          child: Row(
            crossAxisAlignment: isMultiLine
                ? CrossAxisAlignment.start
                : CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: 100,
                child: AppText(
                  label,
                  style: (context) => AppTextStyles.textFieldHeading(context),
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: AppText(
                  value,
                  style: (context) => AppTextStyles.bodyText(context),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context, bool isDark) {
    final l10n = AppLocalizations.of(context);

    return Padding(
      padding: const EdgeInsetsDirectional.symmetric(horizontal: AppSpacing.lg),
      child: Row(
        children: [
          Expanded(
            child: Container(
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
                label: l10n.addToCalender,
                onPressed: () {},
                variant: AppButtonVariant.secondary,
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.xi),
          Expanded(
            child: Container(
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
                label: l10n.getDirection,
                onPressed: () {},
                variant: AppButtonVariant.secondary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFooterLinks(BuildContext context, bool isDark) {
    final l10n = AppLocalizations.of(context);

    return Padding(
      padding: EdgeInsetsDirectional.only(start: 24, end: 24, bottom: 34),
      child: Column(
        children: [
          BlocProvider(
            create: (context) => BookingCubit(),
            child: BlocBuilder<BookingCubit, BookingState>(
              builder: (context, state) {
                return AppButton(
                  label: l10n.viewMyBooking,
                  onPressed: () {
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(builder: (_) => const JoinWaitlistView()),
                    // );
                    final cubit = BlocProvider.of<BookingCubit>(context);
                    cubit.loadClassDetails();
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (newContext) => BlocProvider.value(
                          value: cubit,
                          child: ClassDetailView(
                            classState: ClassState.waitList,
                          ),
                        ),
                      ),
                    );
                  },
                  variant: AppButtonVariant.primary,
                );
              },
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
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
              label: l10n.browseMoreClasses,
              onPressed: () {},
              variant: AppButtonVariant.secondary,
            ),
          ),
        ],
      ),
    );
  }
}

enum SuccessPage { booking, waitList }
