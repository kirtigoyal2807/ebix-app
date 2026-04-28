import 'package:flutter_test/flutter_test.dart';
import 'package:pilates_app/core/models/membership_snapshot.dart';

void main() {
  group('parseMembershipField', () {
    test('returns null for null', () {
      expect(parseMembershipField(null), isNull);
    });

    test('returns null for empty list', () {
      expect(parseMembershipField(<dynamic>[]), isNull);
    });

    test('parses membership map with sessionsRemaining', () {
      final snap = parseMembershipField(<String, dynamic>{
        'entitlementType': 'session_pack',
        'planName': '12 Sessions Pack',
        'status': 'active',
        'totalSessions': 12,
        'sessionsRemaining': 5,
      });
      expect(snap, isNotNull);
      expect(snap!.planName, '12 Sessions Pack');
      expect(snap.totalSessions, 12);
      expect(snap.sessionsRemaining, 5);
    });

    test('prefers active row when multiple in list', () {
      final snap = parseMembershipField(<dynamic>[
        <String, dynamic>{
          'status': 'expired',
          'planName': 'Old Pack',
          'totalSessions': 8,
          'sessionsRemaining': 0,
        },
        <String, dynamic>{
          'status': 'active',
          'planName': 'Premium (Downtown + Uptown)',
          'totalSessions': 24,
          'sessionsRemaining': 24,
        },
      ]);
      expect(snap!.planName, 'Premium (Downtown + Uptown)');
      expect(snap.totalSessions, 24);
      expect(snap.sessionsRemaining, 24);
    });

    test('falls back to first row when none active', () {
      final snap = parseMembershipField(<dynamic>[
        <String, dynamic>{
          'status': 'expired',
          'planName': 'Only Row',
          'totalSessions': 3,
        },
      ]);
      expect(snap!.planName, 'Only Row');
    });
  });

  group('MembershipSnapshot.fromJsonMap', () {
    test('reads nested session_pack', () {
      final snap = MembershipSnapshot.fromJsonMap(<String, dynamic>{
        'session_pack': {'planName': 'Nested Plan', 'totalSessions': 10},
      });
      expect(snap.planName, 'Nested Plan');
      expect(snap.totalSessions, 10);
    });
  });

  group('Auth-style membership strings', () {
    test('AuthUser merges via parseMembershipField in integration style', () {
      final snap = parseMembershipField(<dynamic>[
        <String, dynamic>{
          'status': 'active',
          'planName': 'X',
          'totalSessions': 12,
          'sessionsRemaining': 7,
        },
      ]);
      expect(snap!.hasAnyMembershipHint, isTrue);
    });
  });
}
