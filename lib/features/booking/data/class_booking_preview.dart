/// UI summary for confirm / detail screens until class catalogue APIs drive this.
class ClassBookingPreview {
  const ClassBookingPreview({
    required this.title,
    required this.trainerName,
    required this.studio,
    required this.time,
  });

  final String title;
  final String trainerName;
  final String studio;
  final String time;
}

/// Placeholder slot id for demo UI — replace with real `calendarEventId` from `GET /classes/upcoming` etc.
abstract final class BookingDemoCalendarEvent {
  static const String id = 'f3bc8180-ba52-47f3-ab7e-6c9ef571afc9';
}

/// Placeholder class type id for demo UI — pair with [BookingDemoCalendarEvent] for `GET /classes/{id}`.
abstract final class BookingDemoClass {
  static const String id = 'c4d5e6f0-aa52-47f3-ab7e-6c9ef571afc9';
}
