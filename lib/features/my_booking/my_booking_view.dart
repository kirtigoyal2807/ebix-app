import 'package:flutter/material.dart';
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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        backgroundColor: isDark
            ? AppColors.homeBackground
            : AppColors.whiteColor,
        appBar: AppAppBar(
          onBack: () => Navigator.of(context).pop(),
          title: context.l10n.myBookings,
          isMoreMenu: false,
          bottomPreferredSize: PreferredSize(
            preferredSize: Size(MediaQuery.of(context).size.width, 94),
            child: bookingTabBar(context: context, isDark: isDark),
          ),
        ),
        body: TabBarView(
          children: [
            UpcomingBookingView(),
            CurrentBookingView(),
            PastBookingView(),
            CancelBookingView(),
          ],
        ),
      ),
    );
  }
}

enum BookingStatus { confirmed, waitListed, completed, cancelled }
