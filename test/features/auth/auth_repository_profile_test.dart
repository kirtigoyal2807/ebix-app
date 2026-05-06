import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pilates_app/core/network/api_result.dart';
import 'package:pilates_app/features/auth/data/auth_repository.dart';
import 'package:pilates_app/features/auth/data/models/auth_user.dart';

import '../../core/network/test_repository.dart';

void main() {
  group('AuthRepository.getProfile', () {
    test('GET customers/profile parses envelope data into AuthUser', () async {
      RequestOptions? seen;
      final dio = createTestDio(
        onRequest: (options, handler) {
          seen = options;
          handler.resolve(
            Response(
              requestOptions: options,
              statusCode: 200,
              data: const {
                'success': true,
                'message': 'Profile fetched successfully',
                'data': {
                  'id': 'uuid-example',
                  'name': 'Noor Ali',
                  'email': 'noor@example.com',
                  'phone': '+966500000001',
                  'gender': 'female',
                  'dob': '1995-01-20',
                  'avatar': 'https://cdn.example.com/storage/avatars/noor.jpg',
                  'marketingOptIn': true,
                  'homeBranchId': 2,
                  'experience': 'intermediate',
                  'goal': 'Lose weight',
                  'monthlyGoal': 12,
                  'subscription': {
                    'planName': 'Basic',
                    'totalSessions': 12,
                    'sessionsRemaining': 10,
                  },
                },
              },
            ),
          );
        },
      );

      final result = await AuthRepository(dio).getProfile();

      expect(result.isSuccess, isTrue);
      expect(seen?.method, 'GET');
      expect(seen?.path, 'customers/profile');

      expect(result.dataOrNull, isA<AuthUser>());
      final user = result.dataOrNull!;
      expect(user.name, 'Noor Ali');
      expect(user.email, 'noor@example.com');
      expect(user.phone, '+966500000001');
      expect(
        user.avatarUrl,
        'https://cdn.example.com/storage/avatars/noor.jpg',
      );
      expect(user.homeBranchId, 2);
      expect(user.marketingOptIn, isTrue);
      expect(user.experience, 'intermediate');
      expect(user.goal, 'Lose weight');
      expect(user.monthlyGoal, 12);
      expect(user.membershipPlanName, 'Basic');
      expect(user.membershipTotalSessions, 12);
      expect(user.membershipSessionsRemaining, 10);
    });

    test('GET customers/profile uses envelope success path only', () async {
      RequestOptions? seen;
      final dio = createTestDio(
        onRequest: (options, handler) {
          seen = options;
          handler.resolve(
            Response(
              requestOptions: options,
              statusCode: 200,
              data: const {'success': false, 'message': 'nope', 'data': null},
            ),
          );
        },
      );
      final result = await AuthRepository(dio).getProfile();
      expect(result.isFailure, isTrue);
      expect(seen?.path, 'customers/profile');
      expect(result.exceptionOrNull?.message, 'nope');
    });
  });
}
