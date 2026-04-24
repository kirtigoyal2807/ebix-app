import 'package:flutter/material.dart';

import 'package:pilates_app/features/my_booking/cubit/my_bookings_status_group.dart';
import 'package:pilates_app/features/my_booking/view/my_bookings_tab_body.dart';

class CancelBookingView extends StatelessWidget {
  const CancelBookingView({super.key});

  @override
  Widget build(BuildContext context) {
    return const MyBookingsTabBody(group: MyBookingsStatusGroup.cancelled);
  }
}
