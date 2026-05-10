import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../config/theme/app_colors.dart';
import '../../../config/theme/app_spacing.dart';
import '../../../config/theme/app_text_styles.dart';
import '../../../core/localization/localization_extension.dart';
import '../../../widgets/app_text.dart';
import '../cubit/booking_cubit.dart';
import '../cubit/booking_state.dart';
import '../cubit/trainers_cubit.dart';
import '../cubit/trainers_state.dart';
import '../widgets/booking_search_bar.dart';
import '../widgets/trainer_card.dart';
import '../widgets/trainer_filter_chip.dart';

class TrainerView extends StatelessWidget {
  const TrainerView({super.key});

  Future<void> _reload(BuildContext context) async {
    final booking = context.read<BookingCubit>().state;
    await context.read<TrainersCubit>().load(
      specialty: trainerSpecialtyQuery(booking.selectedTrainerType),
      search: booking.searchQuery.trim().isEmpty
          ? null
          : booking.searchQuery.trim(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return BlocBuilder<BookingCubit, BookingState>(
      builder: (context, bookingState) {
        final hasTrainerFilters =
            bookingState.searchQuery.trim().isNotEmpty ||
            bookingState.selectedTrainerType != TrainerType.allTrainers;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            BookingSearchBar(hintText: context.l10n.searchTrainers),
            SizedBox(height: AppSpacing.md),
            const TrainerFilterChip(),
            SizedBox(height: AppSpacing.md),
            Divider(
              color: isDark ? AppColors.greyText : AppColors.buttonBorder,
              height: 1,
            ),
            SizedBox(height: AppSpacing.lg),
            Expanded(
              child: BlocBuilder<TrainersCubit, TrainersState>(
                builder: (context, state) {
                  if (state.status == TrainersLoadStatus.loading &&
                      state.items.isEmpty) {
                    return const Center(
                      child: CircularProgressIndicator.adaptive(),
                    );
                  }

                  if (state.status == TrainersLoadStatus.failure &&
                      state.items.isEmpty) {
                    return Center(
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: AppSpacing.lg,
                        ),
                        child: AppText(
                          state.errorMessage ??
                              context.l10n.branchesCouldNotLoad,
                          textAlign: TextAlign.center,
                          maxLines: 5,
                          overflow: TextOverflow.ellipsis,
                          style: (c) => AppTextStyles.bodyText(c),
                        ),
                      ),
                    );
                  }

                  return RefreshIndicator(
                    onRefresh: () => _reload(context),
                    child: ListView(
                      padding: EdgeInsets.symmetric(vertical: AppSpacing.lg),
                      physics: const AlwaysScrollableScrollPhysics(),
                      children: [
                        if (state.items.isEmpty)
                          _NoTrainersEmpty(
                            isDark: isDark,
                            hasFilters: hasTrainerFilters,
                          )
                        else
                          for (final trainer in state.items) ...[
                            TrainerCard(trainer: trainer),
                            SizedBox(height: AppSpacing.md),
                          ],
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}

class _NoTrainersEmpty extends StatelessWidget {
  const _NoTrainersEmpty({required this.isDark, required this.hasFilters});

  final bool isDark;
  final bool hasFilters;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.xl,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: 32),
          Icon(
            Icons.people_outline,
            size: 56,
            color: isDark ? AppColors.darkGreyText : AppColors.lightGrey,
          ),
          SizedBox(height: AppSpacing.lg),
          AppText(
            context.l10n.noTrainersTitle,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: (c) => AppTextStyles.heading1(
              c,
            ).copyWith(fontSize: 20, fontWeight: FontWeight.w500),
          ),
          SizedBox(height: AppSpacing.sm),
          AppText(
            hasFilters
                ? context.l10n.noTrainersFilteredDescription
                : context.l10n.noTrainersDefaultDescription,
            textAlign: TextAlign.center,
            maxLines: 4,
            overflow: TextOverflow.ellipsis,
            style: (c) =>
                AppTextStyles.bodyText(c).copyWith(fontSize: 15, height: 1.5),
          ),
        ],
      ),
    );
  }
}
