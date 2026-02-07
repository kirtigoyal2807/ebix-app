import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pilates_app/config/theme/app_colors.dart';
import 'package:pilates_app/config/theme/app_spacing.dart';
import 'package:pilates_app/config/theme/app_text_styles.dart';
import 'package:pilates_app/core/localization/localization_extension.dart';
import 'package:pilates_app/widgets/app_text.dart';
import 'cubit/booking_cubit.dart';
import 'cubit/booking_state.dart';
import 'widgets/booking_tabs.dart';
import 'widgets/booking_search_bar.dart';
import 'widgets/booking_filter_chips.dart';
import 'widgets/booking_subscription_card.dart';
import 'widgets/booking_class_card.dart';

class BookingView extends StatelessWidget {
  const BookingView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => BookingCubit(),
      child: const BookingBody(),
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

    return Scaffold(
      backgroundColor: isDark
          ? AppColors.backgroundDark
          : AppColors.backgroundLight,
      body: SafeArea(
        child: Column(
          children: [
            const BookingTabs(),
            Expanded(
              child: BlocBuilder<BookingCubit, BookingState>(
                builder: (context, state) {
                  if (state.selectedTab == BookingTab.trainers) {
                    return const Center(
                      child: Text('Trainers List coming soon...'),
                    );
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
    );
  }
}
