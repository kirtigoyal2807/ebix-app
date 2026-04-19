import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pilates_app/features/auth/data/auth_repository.dart';

import '../../core/network/test_repository.dart';

void main() {
  group('AuthRepository.submitUserGoal', () {
    test('POST /auth/goal sends experience, goal, monthlyGoal', () async {
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
                'message': 'ok',
                'data': null,
              },
            ),
          );
        },
      );
      final repo = AuthRepository(dio);

      final result = await repo.submitUserGoal(
        experience: 'intermediate',
        goal: 'Lose weight',
        monthlyGoal: 12,
      );

      expect(result.isSuccess, isTrue);
      expect(seen?.path, '/auth/goal');
      final data = seen?.data as Map<String, dynamic>;
      expect(data['experience'], 'intermediate');
      expect(data['goal'], 'Lose weight');
      expect(data['monthlyGoal'], 12);
    });
  });
}
