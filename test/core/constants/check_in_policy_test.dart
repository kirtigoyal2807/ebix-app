import 'package:flutter_test/flutter_test.dart';
import 'package:pilates_app/core/constants/check_in_policy.dart';

void main() {
  group('CheckInPolicy', () {
    test('opens 30 minutes before class start (local)', () {
      final start = DateTime(2026, 6, 1, 10, 0);
      final open = CheckInPolicy.opensAt(start);
      expect(open, DateTime(2026, 6, 1, 9, 30));
    });

    test('window without end time closes at class start', () {
      final start = DateTime(2026, 6, 1, 10, 0);
      final before = DateTime(2026, 6, 1, 9, 29);
      final atOpen = DateTime(2026, 6, 1, 9, 30);
      final lastMinute = DateTime(2026, 6, 1, 10, 0);
      final after = DateTime(2026, 6, 1, 10, 1);

      expect(
        CheckInPolicy.timeBandFor(
          nowLocal: before,
          classStartUtcOrLocal: start,
          classEndUtcOrLocal: null,
        ),
        CheckInTimeBand.tooEarly,
      );
      expect(
        CheckInPolicy.timeBandFor(
          nowLocal: atOpen,
          classStartUtcOrLocal: start,
          classEndUtcOrLocal: null,
        ),
        CheckInTimeBand.inWindow,
      );
      expect(
        CheckInPolicy.timeBandFor(
          nowLocal: lastMinute,
          classStartUtcOrLocal: start,
          classEndUtcOrLocal: null,
        ),
        CheckInTimeBand.inWindow,
      );
      expect(
        CheckInPolicy.timeBandFor(
          nowLocal: after,
          classStartUtcOrLocal: start,
          classEndUtcOrLocal: null,
        ),
        CheckInTimeBand.tooLate,
      );
    });

    test('with end time, window extends until end', () {
      final start = DateTime(2026, 6, 1, 10, 0);
      final end = DateTime(2026, 6, 1, 11, 0);
      final mid = DateTime(2026, 6, 1, 10, 30);

      expect(
        CheckInPolicy.timeBandFor(
          nowLocal: mid,
          classStartUtcOrLocal: start,
          classEndUtcOrLocal: end,
        ),
        CheckInTimeBand.inWindow,
      );
      expect(
        CheckInPolicy.timeBandFor(
          nowLocal: DateTime(2026, 6, 1, 11, 1),
          classStartUtcOrLocal: start,
          classEndUtcOrLocal: end,
        ),
        CheckInTimeBand.tooLate,
      );
    });
  });
}
