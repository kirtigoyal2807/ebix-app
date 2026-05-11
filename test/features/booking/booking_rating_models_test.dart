import 'package:flutter_test/flutter_test.dart';
import 'package:pilates_app/features/booking/data/models/class_slot_view_model.dart';
import 'package:pilates_app/features/booking/data/models/gym_class_resource.dart';
import 'package:pilates_app/features/booking/data/models/trainer_resource.dart';

void main() {
  group('GymClassResource avgRating', () {
    test('parses null when key absent', () {
      final c = GymClassResource.fromJson({
        'id': '1',
        'name': 'Mat',
        'allowSinglePurchase': true,
        'allowPackageBooking': true,
        'isActive': true,
        'upcomingEvents': <dynamic>[],
      });
      expect(c.avgRating, isNull);
    });

    test('parses zero', () {
      final c = GymClassResource.fromJson({
        'id': '1',
        'name': 'Mat',
        'allowSinglePurchase': true,
        'allowPackageBooking': true,
        'isActive': true,
        'avgRating': 0,
        'upcomingEvents': <dynamic>[],
      });
      expect(c.avgRating, 0.0);
    });

    test('parses fractional average', () {
      final c = GymClassResource.fromJson({
        'id': '1',
        'name': 'Mat',
        'allowSinglePurchase': true,
        'allowPackageBooking': true,
        'isActive': true,
        'avg_rating': 4.25,
        'upcomingEvents': <dynamic>[],
      });
      expect(c.avgRating, closeTo(4.25, 0.001));
    });
  });

  group('ClassSlotViewModel.averageRatingDisplayLabel', () {
    test('null when avgRating null', () {
      final slot = ClassSlotViewModel(
        classId: 'c',
        calendarEventId: 'e',
        name: 'N',
        allowPackageBooking: true,
        allowSinglePurchase: true,
        trainerName: 'T',
        branchName: 'B',
        startAt: _t,
        endAt: _t,
      );
      expect(slot.averageRatingDisplayLabel, isNull);
    });

    test('formats zero as 0', () {
      final slot = ClassSlotViewModel(
        classId: 'c',
        calendarEventId: 'e',
        name: 'N',
        avgRating: 0,
        allowPackageBooking: true,
        allowSinglePurchase: true,
        trainerName: 'T',
        branchName: 'B',
        startAt: _t,
        endAt: _t,
      );
      expect(slot.averageRatingDisplayLabel, '0');
    });

    test('formats 4.0 as 4', () {
      final slot = ClassSlotViewModel(
        classId: 'c',
        calendarEventId: 'e',
        name: 'N',
        avgRating: 4.0,
        allowPackageBooking: true,
        allowSinglePurchase: true,
        trainerName: 'T',
        branchName: 'B',
        startAt: _t,
        endAt: _t,
      );
      expect(slot.averageRatingDisplayLabel, '4');
    });
  });

  group('ClassSlotViewModel.hasOpenSpots', () {
    ClassSlotViewModel slot({int? slotsLeft}) => ClassSlotViewModel(
      classId: 'c',
      calendarEventId: 'e',
      name: 'N',
      allowPackageBooking: true,
      allowSinglePurchase: true,
      trainerName: 'T',
      branchName: 'B',
      startAt: _t,
      endAt: _t,
      slotsLeft: slotsLeft,
    );

    test('false when slotsLeft null', () {
      expect(slot(slotsLeft: null).hasOpenSpots, isFalse);
    });

    test('false when slotsLeft 0', () {
      expect(slot(slotsLeft: 0).hasOpenSpots, isFalse);
    });

    test('true when slotsLeft 1 or more', () {
      expect(slot(slotsLeft: 1).hasOpenSpots, isTrue);
      expect(slot(slotsLeft: 5).hasOpenSpots, isTrue);
    });
  });

  group('ClassSlotViewModel.pickUpcomingEvent', () {
    GymClassResource twoFutureEvents() {
      return GymClassResource(
        id: '1',
        name: 'C',
        allowSinglePurchase: true,
        allowPackageBooking: true,
        isActive: true,
        upcomingEvents: [
          UpcomingEvent(
            id: 'jun1',
            startAt: DateTime.utc(2026, 6, 1, 10),
            endAt: DateTime.utc(2026, 6, 1, 11),
            status: 'scheduled',
            branchName: 'Branch',
          ),
          UpcomingEvent(
            id: 'jun3',
            startAt: DateTime.utc(2026, 6, 3, 10),
            endAt: DateTime.utc(2026, 6, 3, 11),
            status: 'scheduled',
            branchName: 'Branch',
          ),
        ],
      );
    }

    test('empty list returns null', () {
      final g = GymClassResource(
        id: '1',
        name: 'C',
        allowSinglePurchase: true,
        allowPackageBooking: true,
        isActive: true,
        upcomingEvents: const [],
      );
      expect(
        ClassSlotViewModel.pickUpcomingEvent(
          g,
          referenceTime: DateTime.utc(2026, 5, 1),
        ),
        isNull,
      );
    });

    test('earliest event at or after referenceTime', () {
      final g = twoFutureEvents();
      final ref = DateTime.utc(2026, 6, 2, 12);
      expect(
        ClassSlotViewModel.pickUpcomingEvent(g, referenceTime: ref)?.id,
        'jun3',
      );
    });

    test('event exactly at referenceTime is eligible', () {
      final g = twoFutureEvents();
      final ref = DateTime.utc(2026, 6, 1, 10);
      expect(
        ClassSlotViewModel.pickUpcomingEvent(g, referenceTime: ref)?.id,
        'jun1',
      );
    });

    test('returns null when all events are strictly before referenceTime', () {
      final g = twoFutureEvents();
      final ref = DateTime.utc(2026, 7, 1);
      expect(
        ClassSlotViewModel.pickUpcomingEvent(g, referenceTime: ref),
        isNull,
      );
    });
  });

  group('TrainerResource rating UI', () {
    test('averageRatingValue is null for missing avg', () {
      final t = TrainerResource.fromJson({
        'id': '1',
        'displayName': 'A',
        'specialties': <dynamic>[],
        'certifications': <dynamic>[],
        'branches': <dynamic>[],
        'reviewsCount': 0,
      });
      expect(t.averageRatingValue, isNull);
      expect(t.displayAverageRating, '');
    });

    test('averageRatingValue includes zero', () {
      final t = TrainerResource.fromJson({
        'id': '1',
        'displayName': 'A',
        'specialties': <dynamic>[],
        'certifications': <dynamic>[],
        'branches': <dynamic>[],
        'avgRating': 0,
        'reviewsCount': 2,
      });
      expect(t.averageRatingValue, 0.0);
      expect(t.displayAverageRating, '0');
    });

    test('classesThisWeekCount from JSON', () {
      final t = TrainerResource.fromJson({
        'id': '1',
        'displayName': 'A',
        'specialties': <dynamic>[],
        'certifications': <dynamic>[],
        'branches': <dynamic>[],
        'classesThisWeek': 5,
      });
      expect(t.classesThisWeekCount, 5);
    });
  });
}

final DateTime _t = DateTime.utc(2026, 1, 1, 12);
