import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pilates_app/config/theme/app_colors.dart';
import 'package:pilates_app/config/theme/app_spacing.dart';
import 'package:pilates_app/core/localization/localization_extension.dart';
import 'package:pilates_app/features/booking/data/trainers_repository.dart';
import 'package:pilates_app/features/home/cubit/home_cubit.dart';
import 'package:pilates_app/features/home/cubit/home_state.dart';
import 'package:pilates_app/features/booking/views/trainer_view.dart';
import 'cubit/booking_cubit.dart';
import 'cubit/booking_state.dart';
import 'cubit/trainers_cubit.dart';
import 'widgets/booking_tabs.dart';
import 'widgets/booking_search_bar.dart';
import 'widgets/booking_filter_chips.dart';
import 'widgets/booking_subscription_card.dart';
import 'widgets/booking_class_card.dart';

class BookingView extends StatelessWidget {
  const BookingView({super.key, this.initialTab = BookingTab.classes});

  final BookingTab initialTab;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => BookingCubit(initialTab: initialTab),
        ),
        BlocProvider(
          create: (ctx) => TrainersCubit(ctx.read<TrainersRepository>()),
        ),
      ],
      child: BlocListener<HomeCubit, HomeState>(
        listener: (context, homeState) {
          if (homeState.currentIndex == 1 &&
              context.read<BookingCubit>().state.selectedTab !=
                  homeState.selectedBookingTab) {
            context.read<BookingCubit>().setTab(homeState.selectedBookingTab);
          }
        },
        child: const BookingBody(),
      ),
    );
  }
}

class BookingBody extends StatefulWidget {
  const BookingBody({super.key});

  @override
  State<BookingBody> createState() => _BookingBodyState();
}

class _BookingBodyState extends State<BookingBody> {
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return BlocListener<BookingCubit, BookingState>(
      listenWhen: (previous, current) {
        if (current.selectedTab != BookingTab.trainers) return false;
        return previous.selectedTab != current.selectedTab ||
            previous.searchQuery != current.searchQuery ||
            previous.selectedTrainerType != current.selectedTrainerType;
      },
      listener: (context, bookingState) {
        context.read<TrainersCubit>().load(
              specialty: trainerSpecialtyQuery(bookingState.selectedTrainerType),
              search: bookingState.searchQuery.trim().isEmpty
                  ? null
                  : bookingState.searchQuery.trim(),
            );
      },
      child: Scaffold(
        backgroundColor: isDark ? AppColors.homeBackground : AppColors.whiteColor,
        body: SafeArea(
          child: Column(
            children: [
              const BookingTabs(),
              Expanded(
                child: BlocBuilder<BookingCubit, BookingState>(
                  builder: (context, state) {
                    if (state.selectedTab == BookingTab.trainers) {
                      return const TrainerView();
                    }

                    return ListView(
                      padding: const EdgeInsets.symmetric(
                        vertical: AppSpacing.lg,
                      ),
                      children: [
                        const BookingSearchBar(),
                        const SizedBox(height: AppSpacing.md),
                        const BookingFilterChips(),
                        const SizedBox(height: AppSpacing.lg),
                        const BookingSubscriptionCard(),
                        const SizedBox(height: AppSpacing.lg),
                        Divider(
                          color: isDark
                              ? AppColors.greyText
                              : AppColors.buttonBorder,
                          height: 1,
                        ),
                        const SizedBox(height: AppSpacing.lg),
                        BookingClassCard(
                          title: 'Power Pilates',
                          trainerName: 'Sarah Mitchell',
                          studio: context.l10n.branchDowntown,
                          time: '${context.l10n.today}, 6:00 PM',
                          spotsLeft: 3,
                          isInPlan: true,
                        ),
                        const SizedBox(height: AppSpacing.md),
                        BookingClassCard(
                          title: 'Power Pilates',
                          trainerName: 'Sarah Mitchell',
                          studio: context.l10n.branchDowntown,
                          time: '${context.l10n.today}, 6:00 PM',
                          spotsLeft: 0,
                          isInPlan: false,
                          upgradeRequired: true,
                        ),
                        const SizedBox(height: AppSpacing.md),
                        BookingClassCard(
                          title: 'Power Pilates',
                          trainerName: 'Sarah Mitchell',
                          studio: context.l10n.branchDowntown,
                          time: '${context.l10n.today}, 6:00 PM',
                          spotsLeft: 3,
                          isInPlan: true,
                        ),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
