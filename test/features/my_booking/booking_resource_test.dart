import 'package:flutter_test/flutter_test.dart';
import 'package:pilates_app/features/my_booking/data/models/booking_resource.dart';

void main() {
  group('BookingResource.fromJson enrollment id', () {
    test('reads enrollmentId when id is absent', () {
      final b = BookingResource.fromJson({
        'enrollmentId': 'e55-uuid',
        'status': 'booked',
        'statusLabel': 'Booked',
        'class': {'name': 'Yoga'},
        'event': {
          'startAt': '2026-06-01T10:00:00.000Z',
          'branch': {'name': 'Main'},
          'trainer': {'name': 'Ann'},
        },
      });
      expect(b.id, 'e55-uuid');
    });

    test('unwraps data.enrollmentId', () {
      final b = BookingResource.fromJson({
        'data': {
          'enrollment_id': 'nested-1',
          'status': 'booked',
          'statusLabel': 'Booked',
          'class': {'name': 'Mat'},
          'event': {
            'startAt': '2026-06-01T10:00:00.000Z',
            'branch': {'name': 'B'},
            'trainer': {'name': 'T'},
          },
        },
      });
      expect(b.id, 'nested-1');
    });

    test('prefers nested enrollment map id', () {
      final b = BookingResource.fromJson({
        'enrollment': {
          'id': 'from-nested',
          'status': 'booked',
          'statusLabel': 'Booked',
          'class': {'name': 'Mat'},
          'event': {
            'startAt': '2026-06-01T10:00:00.000Z',
            'branch': {'name': 'B'},
            'trainer': {'name': 'T'},
          },
        },
      });
      expect(b.id, 'from-nested');
    });
  });
}
