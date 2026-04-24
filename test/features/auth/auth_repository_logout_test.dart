import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pilates_app/features/auth/data/auth_repository.dart';

import '../../core/network/test_repository.dart';

void main() {
  group('AuthRepository.logout', () {
    test('POST /auth/logout', () async {
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

      final result = await repo.logout();

      expect(result.isSuccess, isTrue);
      expect(seen?.path, '/auth/logout');
    });
  });
}
