import 'package:flutter_test/flutter_test.dart';
import 'package:pilates_app/features/home/data/models/home_response.dart';

void main() {
  group('HomeResponse membership', () {
    test('parses membership array with active row and sessionsRemaining', () {
      final response = HomeResponse.fromJson(<String, dynamic>{
        'banners': <dynamic>[],
        'membership': <dynamic>[
          <String, dynamic>{
            'status': 'active',
            'planName': '12 Sessions Pack',
            'totalSessions': 12,
            'sessionsRemaining': 7,
          },
        ],
        'progress': null,
        'featuredClass': <dynamic>[],
        'classTypes': <dynamic>[],
        'topTrainers': <dynamic>[],
        'receivedGifts': <dynamic>[],
      });
      final m = response.membership;
      expect(m, isNotNull);
      expect(m!.planName, '12 Sessions Pack');
      expect(m.totalSessions, 12);
      expect(m.sessionsRemaining, 7);
    });

    test('AuthUser-style flat keys still work on single map', () {
      final response = HomeResponse.fromJson(<String, dynamic>{
        'banners': <dynamic>[],
        'membership': <String, dynamic>{'planName': 'Solo', 'totalSessions': 5},
        'progress': null,
        'featuredClass': <dynamic>[],
        'classTypes': <dynamic>[],
        'topTrainers': <dynamic>[],
        'receivedGifts': <dynamic>[],
      });
      expect(response.membership?.planName, 'Solo');
      expect(response.membership?.totalSessions, 5);
    });
  });
}
