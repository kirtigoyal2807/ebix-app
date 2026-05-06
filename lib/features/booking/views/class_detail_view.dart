import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pilates_app/config/theme/app_colors.dart';
import 'package:pilates_app/config/theme/app_radius.dart';
import 'package:pilates_app/config/theme/app_spacing.dart';
import 'package:pilates_app/config/theme/app_text_styles.dart';
import 'package:pilates_app/core/localization/localization_extension.dart';
import 'package:pilates_app/features/booking/cubit/class_detail_cubit.dart';
import 'package:pilates_app/features/booking/cubit/class_detail_state.dart';
import 'package:pilates_app/features/booking/data/classes_repository.dart';
import 'package:pilates_app/features/booking/data/models/class_slot_view_model.dart';
import 'package:pilates_app/features/booking/widgets/class_detail_header.dart';
import 'package:pilates_app/features/booking/widgets/class_info_grid.dart';
import 'package:pilates_app/features/booking/widgets/class_location_card.dart';
import 'package:pilates_app/features/booking/widgets/class_about_section.dart';
import 'package:pilates_app/features/booking/widgets/class_reviews_section.dart';
import 'package:pilates_app/widgets/app_app_bar.dart';
import 'package:pilates_app/widgets/app_text.dart';

import 'book_class_confirm_view.dart';
import 'join_waitlist_view.dart';

class ClassDetailView extends StatelessWidget {
  const ClassDetailView({
    super.key,
    required this.classId,
    this.preloadedSlot,
  });

  /// Class type id for `GET /classes/{classId}`.
  final String classId;

  /// Optional slot from the list — used as an optimistic placeholder while the
  /// class-detail fetch is in-flight.
  final ClassSlotViewModel? preloadedSlot;

  @override
  Widget build(BuildContext context) {
    final id = classId.trim();
    return BlocProvider(
      create: (ctx) => ClassDetailCubit(
        ctx.read<ClassesRepository>(),
        id,
        preloadedSlot: preloadedSlot,
      )..loadClassDetail(),
      child: const _ClassDetailBody(),
    );
  }
}

class _ClassDetailBody extends StatelessWidget {
  const _ClassDetailBody();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final size = MediaQuery.sizeOf(context);

    return Scaffold(
      backgroundColor: isDark ? AppColors.homeBackground : AppColors.whiteColor,
      appBar: AppAppBar(
        onBack: () => Navigator.of(context).pop(),
        title: context.l10n.classDetails,
        isMoreMenu: false,
      ),
      body: BlocBuilder<ClassDetailCubit, ClassDetailState>(
        builder: (context, state) {
          // Show full-screen loader only when there's no preloaded data
          if (state.isLoading && state.slot == null) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.hasError && state.slot == null) {
            return _ErrorBody(
              message: state.errorMessage ?? context.l10n.somethingWentWrong,
              onRetry: () =>
                  context.read<ClassDetailCubit>().loadClassDetail(),
            );
          }

          final slot = state.slot;
          if (slot == null) {
            return const Center(child: CircularProgressIndicator());
          }

          final canBookOrWaitlist = slot.hasBookableSlot;

          return Stack(
            children: [
              // Thin top-of-screen progress bar while background fetch is running
              if (state.isLoading)
                const Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: LinearProgressIndicator(minHeight: 3),
                ),
              SingleChildScrollView(
                padding: EdgeInsets.only(bottom: size.height * 0.15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.lg,
                      ),
                      child: ClassDetailHeader(slot: slot),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.lg,
                      ),
                      child: ClassInfoGrid(slot: slot),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.lg,
                      ),
                      child: ClassLocationCard(slot: slot),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.lg,
                      ),
                      child: ClassAboutSection(slot: slot),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    ClassReviewsSection(
                      embeddedRecentReviews: slot.recentReviews,
                      reviewableType:
                          slot.recentReviews == null ? 'class' : null,
                      reviewableId:
                          slot.recentReviews == null ? slot.classId : null,
                      summaryAvgRating: slot.averageRatingDisplayLabel,
                      summaryReviewsCount: slot.reviewsCount,
                    ),
                  ],
                ),
              ),

              // Sticky action button
              Positioned(
                left: 0,
                right: 0,
                bottom: size.height * 0.04,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.lg,
                  ),
                  child: ElevatedButton(
                    onPressed: !canBookOrWaitlist
                        ? null
                        : () {
                            if (!slot.hasOpenSpots) {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => JoinWaitlistView(slot: slot),
                                ),
                              );
                            } else {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => BookClassConfirmView(
                                    calendarEventId: slot.calendarEventId,
                                    slot: slot,
                                  ),
                                ),
                              );
                            }
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.splashBackgroundDark,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          AppRadius.pillRadius,
                        ),
                      ),
                      minimumSize: const Size(double.infinity, 48),
                    ),
                    child: AppText(
                      !canBookOrWaitlist
                          ? context.l10n.noUpcomingClasses
                          : slot.hasOpenSpots
                              ? context.l10n.bookThisClass
                              : context.l10n.joinWailList,
                      style: (ctx) => AppTextStyles.button(ctx).copyWith(
                        fontSize: size.width * 0.04 > 16
                            ? 16
                            : size.width * 0.04,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _ErrorBody extends StatelessWidget {
  const _ErrorBody({required this.message, required this.onRetry});
  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AppText(
              message,
              style: (ctx) => AppTextStyles.bodyText(ctx),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.md),
            TextButton(
              onPressed: onRetry,
              child: AppText(
                context.l10n.retry,
                style: (ctx) => AppTextStyles.bodyText(ctx),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
