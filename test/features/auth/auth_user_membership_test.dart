import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:pilates_app/features/auth/data/models/auth_user.dart';

void main() {
  test('AuthUser parses membership array from envelope-style user payload', () {
    final u = AuthUser.fromJson(<String, dynamic>{
      'id': 'x',
      'email': 'a@b.com',
      'membership': <dynamic>[
        <String, dynamic>{
          'status': 'active',
          'planName': 'Premium (Downtown + Uptown)',
          'totalSessions': 24,
          'sessionsRemaining': 20,
        },
      ],
    });
    expect(u.membershipPlanName, 'Premium (Downtown + Uptown)');
    expect(u.membershipTotalSessions, 24);
    expect(u.membershipSessionsRemaining, 20);
    expect(u.showsMembershipWithoutHomePayload, isTrue);

    final roundTrip = AuthUser.fromJson(
      jsonDecode(jsonEncode(u.toJson())) as Map<String, dynamic>,
    );
    expect(roundTrip.membershipPlanName, u.membershipPlanName);
    expect(roundTrip.membershipTotalSessions, u.membershipTotalSessions);
    expect(
      roundTrip.membershipSessionsRemaining,
      u.membershipSessionsRemaining,
    );
  });
}
