import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pilates_app/config/theme/app_colors.dart';
import 'package:pilates_app/config/theme/app_spacing.dart';
import 'package:pilates_app/config/theme/app_text_styles.dart';
import 'package:pilates_app/core/localization/localization_extension.dart';
import 'package:pilates_app/features/booking/cubit/classes_cubit.dart';
import 'package:pilates_app/features/booking/cubit/classes_state.dart';
import 'package:pilates_app/features/booking/data/classes_repository.dart';
import 'package:pilates_app/features/booking/data/models/class_slot_view_model.dart';
import 'package:pilates_app/features/booking/data/trainers_repository.dart';
import 'package:pilates_app/features/home/cubit/home_cubit.dart';
import 'package:pilates_app/features/home/cubit/home_state.dart';
import 'package:pilates_app/features/booking/views/trainer_view.dart';
import 'package:pilates_app/widgets/app_text.dart';
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
        BlocProvider(create: (_) => BookingCubit(initialTab: initialTab)),
        BlocProvider(
          create: (ctx) => TrainersCubit(ctx.read<TrainersRepository>()),
        ),
        BlocProvider(
          create: (ctx) => ClassesCubit(ctx.read<ClassesRepository>()),
        ),
      ],
      child: BlocListener<HomeCubit, HomeState>(
        listener: (context, homeState) {
          final bookingCubit = context.read<BookingCubit>();
          if (homeState.currentIndex == 1 &&
              bookingCubit.state.selectedTab != homeState.selectedBookingTab) {
            bookingCubit.setTab(homeState.selectedBookingTab);
          }
          if (homeState.currentIndex == 1 &&
              bookingCubit.state.selectedTab == BookingTab.classes) {
            final booking = bookingCubit.state;
            context.read<ClassesCubit>().load(
              search: booking.searchQuery.trim().isEmpty
                  ? null
                  : booking.searchQuery.trim(),
            );
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

    return MultiBlocListener(
      listeners: [
        // Classes tab: load when user switches from Trainers to Classes in-app
        // (bottom-nav entry is handled by HomeCubit listener above).
        BlocListener<BookingCubit, BookingState>(
          listenWhen: (previous, current) {
            return current.selectedTab == BookingTab.classes &&
                previous.selectedTab != BookingTab.classes;
          },
          listener: (context, bookingState) {
            context.read<ClassesCubit>().load(
              search: bookingState.searchQuery.trim().isEmpty
                  ? null
                  : bookingState.searchQuery.trim(),
            );
          },
        ),
        // Trainers tab: reload on tab change / search / type filter
        BlocListener<BookingCubit, BookingState>(
          listenWhen: (previous, current) {
            if (current.selectedTab != BookingTab.trainers) return false;
            return previous.selectedTab != current.selectedTab ||
                previous.searchQuery != current.searchQuery ||
                previous.selectedTrainerType != current.selectedTrainerType;
          },
          listener: (context, bookingState) {
            context.read<TrainersCubit>().load(
              specialty: trainerSpecialtyQuery(
                bookingState.selectedTrainerType,
              ),
              search: bookingState.searchQuery.trim().isEmpty
                  ? null
                  : bookingState.searchQuery.trim(),
            );
          },
        ),
        // Classes tab: reload from API when search query changes
        BlocListener<BookingCubit, BookingState>(
          listenWhen: (previous, current) {
            if (current.selectedTab != BookingTab.classes) return false;
            return previous.searchQuery != current.searchQuery;
          },
          listener: (context, bookingState) {
            context.read<ClassesCubit>().load(
              search: bookingState.searchQuery.trim().isEmpty
                  ? null
                  : bookingState.searchQuery.trim(),
              force: true,
            );
          },
        ),
      ],
      child: Scaffold(
        backgroundColor: isDark
            ? AppColors.homeBackground
            : AppColors.whiteColor,
        body: SafeArea(
          child: Column(
            children: [
              const BookingTabs(),
              const SizedBox(height: AppSpacing.md),
              Expanded(
                child: BlocBuilder<BookingCubit, BookingState>(
                  builder: (context, bookingState) {
                    if (bookingState.selectedTab == BookingTab.trainers) {
                      return const TrainerView();
                    }
                    return _ClassesTab(bookingState: bookingState);
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

// ---------------------------------------------------------------------------
// Classes tab body — reads ClassesCubit + BookingState for local filtering
// ---------------------------------------------------------------------------

class _ClassesTab extends StatelessWidget {
  const _ClassesTab({required this.bookingState});

  final BookingState bookingState;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Keep search / filters / subscription outside ClassesCubit rebuilds so the
    // search field is not recreated when loading or data updates (fixes cleared text).
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const BookingSearchBar(),
        const SizedBox(height: AppSpacing.md),
        const BookingFilterChips(),
        const SizedBox(height: AppSpacing.lg),
        const BookingSubscriptionCard(),
        const SizedBox(height: AppSpacing.lg),
        Divider(
          color: isDark ? AppColors.greyText : AppColors.buttonBorder,
          height: 1,
        ),
        Expanded(
          child: BlocBuilder<ClassesCubit, ClassesState>(
            builder: (context, classesState) {
              if (classesState.isLoading && classesState.allClasses.isEmpty) {
                return const Center(child: CircularProgressIndicator());
              }

              if (classesState.hasError && classesState.allClasses.isEmpty) {
                return _ErrorView(
                  message:
                      classesState.errorMessage ??
                      context.l10n.somethingWentWrong,
                  onRetry: () => context.read<ClassesCubit>().refresh(
                    search: bookingState.searchQuery.trim().isEmpty
                        ? null
                        : bookingState.searchQuery.trim(),
                  ),
                );
              }

              return RefreshIndicator(
                onRefresh: () => context.read<ClassesCubit>().refresh(
                  search: bookingState.searchQuery.trim().isEmpty
                      ? null
                      : bookingState.searchQuery.trim(),
                ),
                child: Stack(
                  children: [
                    ListView(
                      padding: const EdgeInsets.symmetric(
                        vertical: AppSpacing.lg,
                      ),
                      children: _buildClassCards(
                        context,
                        classesState,
                        bookingState,
                        isDark,
                      ),
                    ),
                    if (classesState.isLoading)
                      const Positioned(
                        top: 0,
                        left: 0,
                        right: 0,
                        child: LinearProgressIndicator(minHeight: 3),
                      ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  List<Widget> _buildClassCards(
    BuildContext context,
    ClassesState classesState,
    BookingState bookingState,
    bool isDark,
  ) {
    final filtered = _applyLocalFilters(classesState.allSlots, bookingState);

    if (filtered.isEmpty && classesState.isLoaded) {
      return [
        Padding(
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: Center(
            child: AppText(
              context.l10n.noClassesFound,
              style: (ctx) => AppTextStyles.bodyText(ctx),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ];
    }

    final widgets = <Widget>[];
    for (var i = 0; i < filtered.length; i++) {
      final slot = filtered[i];
      widgets.add(BookingClassCard.fromSlot(slot));
      if (i < filtered.length - 1) {
        widgets.add(const SizedBox(height: AppSpacing.md));
      }
    }
    return widgets;
  }

  /// Local filtering on the already-fetched class slots (per client spec:
  /// branch, category, gender, date are all local — only search goes to API).
  List<ClassSlotViewModel> _applyLocalFilters(
    List<ClassSlotViewModel> slots,
    BookingState state,
  ) {
    var result = slots;

    // Branch filter
    if (state.selectedBranch != 'All Branches') {
      final selectedBranch = _normalizedToken(state.selectedBranch);
      result = result.where((s) {
        final branchName = _normalizedToken(s.branchName);
        return branchName == selectedBranch ||
            branchName.contains(selectedBranch) ||
            selectedBranch.contains(branchName);
      }).toList();
    }

    // Category filter (class name match)
    if (state.selectedCategory != 'All Categories') {
      final selectedCategory = _normalizedToken(state.selectedCategory);
      result = result.where((s) {
        final slotCategory = _normalizedToken(s.category ?? '');
        final slotName = _normalizedToken(s.name);
        if (slotCategory.isNotEmpty) {
          return slotCategory == selectedCategory ||
              slotCategory.contains(selectedCategory) ||
              selectedCategory.contains(slotCategory);
        }
        return slotName.contains(selectedCategory);
      }).toList();
    }

    // Gender filter
    if (state.selectedGender != 'All Gender') {
      final selectedGender = _normalizedGender(state.selectedGender);
      result = result.where((s) {
        final slotGender = _normalizedGender(s.gender);
        if (slotGender == null || slotGender == 'all') return false;
        return slotGender == selectedGender;
      }).toList();
    }

    // Date filter
    if (state.selectedDate != 'All Dates') {
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      result = result.where((s) {
        final slotDay = DateTime(
          s.startAt.year,
          s.startAt.month,
          s.startAt.day,
        );
        switch (state.selectedDate) {
          case 'Today':
            return slotDay == today;
          case 'Tomorrow':
            return slotDay == today.add(const Duration(days: 1));
          case 'This Week':
            final weekEnd = today.add(Duration(days: 7 - today.weekday));
            return !slotDay.isBefore(today) && !slotDay.isAfter(weekEnd);
          case 'Next Week':
            final nextWeekStart = today.add(Duration(days: 8 - today.weekday));
            final nextWeekEnd = nextWeekStart.add(const Duration(days: 6));
            return !slotDay.isBefore(nextWeekStart) &&
                !slotDay.isAfter(nextWeekEnd);
          case 'This Weekend':
            final daysUntilSat = (6 - today.weekday) % 7;
            final sat = today.add(Duration(days: daysUntilSat));
            final sun = sat.add(const Duration(days: 1));
            return slotDay == sat || slotDay == sun;
          default:
            return true;
        }
      }).toList();
    }

    return result;
  }

  String _normalizedToken(String value) {
    return value.trim().toLowerCase().replaceAll(RegExp(r'[\s_-]+'), '');
  }

  String? _normalizedGender(String? value) {
    if (value == null) return null;
    final normalized = _normalizedToken(value);
    if (normalized.isEmpty) return null;
    const maleTokens = {'male', 'man', 'men', 'boy', 'boys', 'm'};
    const femaleTokens = {'female', 'woman', 'women', 'girl', 'girls', 'f'};
    const allTokens = {
      'all',
      'any',
      'mixed',
      'unisex',
      'coed',
      'both',
      'everyone',
    };
    if (maleTokens.contains(normalized)) return 'male';
    if (femaleTokens.contains(normalized)) return 'female';
    if (allTokens.contains(normalized)) return 'all';
    return normalized;
  }
}

class _ErrorView extends StatelessWidget {
  const _ErrorView({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.xl),
      child: Column(
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
    );
  }
}
