import 'package:flutter/material.dart';
import 'package:pilates_app/features/my_booking/my_booking_view.dart';

import '../../../config/theme/app_spacing.dart';
import '../../../core/localization/localization_extension.dart';
import '../widget/my_booking_class_card.dart';

class UpcomingBookingView extends StatelessWidget {
  const UpcomingBookingView({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.lg),
        child: Column(
          spacing: AppSpacing.md,
          children: [
            MyBookingClassCard(
              title: context.l10n.powerPilates,
              trainerName: 'Sarah Mitchell',
              studio: context.l10n.branchDowntown,
              // time: '${context.l10n.today}, 6:00 PM',
              time: '6:00 PM - 7:00 PM',
              date: '5 February 2026,',
              bookingStatus: BookingStatus.confirmed,
            ),
            MyBookingClassCard(
              title: context.l10n.powerPilates,
              trainerName: 'Sarah Mitchell',
              studio: context.l10n.branchDowntown,
              // time: '${context.l10n.today}, 6:00 PM',
              time: '6:00 PM - 7:00 PM',
              date: '5 February 2026,',
              spot: 3,
              position: 3,
              bookingStatus: BookingStatus.waitListed,
            ),
            MyBookingClassCard(
              title: context.l10n.powerPilates,
              trainerName: 'Sarah Mitchell',
              studio: context.l10n.branchDowntown,
              // time: '${context.l10n.today}, 6:00 PM',
              time: '6:00 PM - 7:00 PM',
              date: '5 February 2026,',
              bookingStatus: BookingStatus.completed,
            ),
            MyBookingClassCard(
              title: context.l10n.powerPilates,
              trainerName: 'Sarah Mitchell',
              studio: context.l10n.branchDowntown,
              // time: '${context.l10n.today}, 6:00 PM',
              time: '6:00 PM - 7:00 PM',
              date: '5 February 2026,',
              bookingStatus: BookingStatus.cancelled,
            ),
          ],
        ),
      ),
    );
  }
}
