import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pilates_app/features/home/data/home_repository.dart';

import '../../core/network/test_repository.dart';

void main() {
  group('HomeRepository.fetchHome', () {
    test('GET home/ parses successful payload', () async {
      RequestOptions? seen;
      final dio = createTestDio(
        onRequest: (options, handler) {
          seen = options;
          handler.resolve(
            Response(
              requestOptions: options,
              statusCode: 200,
              data: {
                'success': true,
                'message': 'Success',
                'data': {
                  'banners': [
                    {
                      'id': 1,
                      'title': 'Banner',
                      'subtitle': 'Subtitle',
                      'imageUrl': 'https://example.com/banner.jpg',
                    },
                  ],
                  'membership': [],
                  'receivedGifts': [
                    {
                      'id': 'gift-1',
                      'title': 'You received a gift card',
                      'subtitle': 'Ayesha sent you a Pilates membership',
                    },
                  ],
                  'progress': {
                    'mtdAttendedClasses': 3,
                    'mtdAttendedMinutes': 120,
                    'monthlyTargetClasses': 8,
                    'goalPercent': 38,
                  },
                  'featuredClass': [
                    {
                      'className': 'Reformer Flow',
                      'trainerName': 'Sara',
                      'branchName': 'Riyadh',
                      'startAt': '2026-05-02T10:00:00+03:00',
                      'availability': {'spotsLeft': 5},
                      'flags': {
                        'inPlan': true,
                        'allowPackageBooking': true,
                        'upgradeRequired': false,
                      },
                    },
                  ],
                  'classTypes': [
                    {
                      'id': 2,
                      'name': 'Reformer',
                      'imageUrl': 'https://example.com/type.jpg',
                      'sortOrder': 1,
                    },
                  ],
                  'topTrainers': [
                    {
                      'id': 'abc',
                      'displayName': 'Lina Ahmed',
                      'avgRating': '4.8',
                      'specialties': ['prenatal'],
                      'imageUrl': 'https://example.com/trainer.jpg',
                    },
                  ],
                },
              },
            ),
          );
        },
      );
      final repo = HomeRepository(dio);

      final result = await repo.fetchHome();

      expect(result.isSuccess, isTrue);
      expect(seen?.path, 'home/');
      final data = result.dataOrNull!;
      expect(data.banners, hasLength(1));
      expect(data.progress?.mtdAttendedClasses, 3);
      expect(data.featuredClasses.first.className, 'Reformer Flow');
      expect(data.featuredClasses.first.allowPackageBooking, isTrue);
      expect(data.featuredClasses.first.showsUpgradeRequired, isFalse);
      expect(data.classTypes, hasLength(1));
      expect(data.topTrainers, hasLength(1));
      expect(data.receivedGifts, hasLength(1));
    });

    test('null modules are safely converted to hidden state', () async {
      final dio = createTestDio(
        onRequest: (options, handler) {
          handler.resolve(
            Response(
              requestOptions: options,
              statusCode: 200,
              data: {
                'success': true,
                'message': 'Success',
                'data': {
                  'banners': null,
                  'membership': null,
                  'receivedGifts': null,
                  'progress': null,
                  'featuredClass': null,
                  'classTypes': null,
                  'topTrainers': null,
                },
              },
            ),
          );
        },
      );
      final repo = HomeRepository(dio);

      final result = await repo.fetchHome();

      expect(result.isSuccess, isTrue);
      final data = result.dataOrNull!;
      expect(data.banners, isEmpty);
      expect(data.membership, isNull);
      expect(data.progress, isNull);
      expect(data.featuredClasses, isEmpty);
      expect(data.classTypes, isEmpty);
      expect(data.topTrainers, isEmpty);
      expect(data.receivedGifts, isEmpty);
    });

    test('membership session_pack fields are parsed', () async {
      final dio = createTestDio(
        onRequest: (options, handler) {
          handler.resolve(
            Response(
              requestOptions: options,
              statusCode: 200,
              data: {
                'success': true,
                'message': 'Success',
                'data': {
                  'banners': [],
                  'membership': {
                    'session_pack': {
                      'planName': 'Premium',
                      'totalSessions': 20,
                    },
                  },
                  'progress': null,
                  'featuredClass': null,
                  'classTypes': [],
                  'topTrainers': [],
                },
              },
            ),
          );
        },
      );
      final repo = HomeRepository(dio);

      final result = await repo.fetchHome();

      expect(result.isSuccess, isTrue);
      final data = result.dataOrNull!;
      expect(data.membership?.planName, 'Premium');
      expect(data.membership?.totalSessions, 20);
    });
  });
}
