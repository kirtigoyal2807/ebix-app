import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pilates_app/config/theme/app_spacing.dart';
import 'package:pilates_app/features/my_booking/cubit/my_bookings_cubit.dart';
import 'package:pilates_app/features/my_booking/cubit/my_bookings_status_group.dart';
import 'package:pilates_app/features/my_booking/data/my_bookings_repository.dart';
import 'package:pilates_app/features/my_booking/view/cancel_booking_view.dart';
import 'package:pilates_app/features/my_booking/view/current_booking_view.dart';
import 'package:pilates_app/features/my_booking/view/past_booking_view.dart';
import 'package:pilates_app/features/my_booking/view/upcoming_booking_view.dart';
import 'package:pilates_app/features/my_booking/widget/tab_bar.dart';

import '../../config/theme/app_colors.dart';
import '../../core/localization/localization_extension.dart';
import '../../widgets/app_app_bar.dart';

class MyBookingView extends StatelessWidget {
  const MyBookingView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => MyBookingsCubit(context.read<MyBookingsRepository>()),
      child: const _MyBookingScaffold(),
    );
  }
}

class _MyBookingScaffold extends StatefulWidget {
  const _MyBookingScaffold();

  @override
  State<_MyBookingScaffold> createState() => _MyBookingScaffoldState();
}

class _MyBookingScaffoldState extends State<_MyBookingScaffold>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _tabController.addListener(_onTabChanged);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.read<MyBookingsCubit>().ensureLoaded(MyBookingsStatusGroup.upcoming);
    });
  }

  void _onTabChanged() {
    if (_tabController.indexIsChanging) return;
    final group = MyBookingsStatusGroup.values[_tabController.index];
    context.read<MyBookingsCubit>().ensureLoaded(group);
  }

  @override
  void dispose() {
    _tabController.removeListener(_onTabChanged);
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      backgroundColor:
          isDark ? AppColors.homeBackground : AppColors.whiteColor,
      appBar: AppAppBar(
        leading: Padding(
          padding: const EdgeInsets.only(left: AppSpacing.lmd),
          child: IconButton(
            icon: const Icon(Icons.arrow_back_ios_rounded, size: 20),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        onBack: () => Navigator.of(context).pop(),
        title: context.l10n.myBookings,
        isMoreMenu: false,
        bottomPreferredSize: PreferredSize(
          preferredSize: const Size.fromHeight(94),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                child: bookingTabBar(
                  context: context,
                  isDark: isDark,
                  controller: _tabController,
                ),
              ),
              Divider(
                height: 1,
                thickness: 1,
                color: isDark ? AppColors.greyText : AppColors.buttonBorder,
              ),
            ],
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          UpcomingBookingView(),
          CurrentBookingView(),
          PastBookingView(),
          CancelBookingView(),
        ],
      ),
    );
  }
}

enum BookingStatus { confirmed, waitListed, completed, cancelled }
