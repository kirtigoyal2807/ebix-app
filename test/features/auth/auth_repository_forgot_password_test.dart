import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pilates_app/features/auth/data/auth_repository.dart';

import '../../core/network/test_repository.dart';

void main() {
  group('AuthRepository forgot password flow', () {
    test('POST /auth/password/forgot sends trimmed email', () async {
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
                'message': 'code sent',
                'data': null,
              },
            ),
          );
        },
      );
      final repo = AuthRepository(dio);

      final result = await repo.requestPasswordForgot(email: '  noor@example.com  ');

      expect(result.isSuccess, isTrue);
      expect(seen?.path, '/auth/password/forgot');
      final data = seen?.data as Map<String, dynamic>;
      expect(data['email'], 'noor@example.com');
    });

    test('POST /auth/email/send sends trimmed email', () async {
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
                'message': 'sent',
                'data': null,
              },
            ),
          );
        },
      );
      final repo = AuthRepository(dio);

      final result = await repo.sendEmailVerification(
        email: '  noor@example.com  ',
      );

      expect(result.isSuccess, isTrue);
      expect(seen?.path, '/auth/email/send');
      final data = seen?.data as Map<String, dynamic>;
      expect(data['email'], 'noor@example.com');
    });

    test('POST /auth/email/verify sends email and code', () async {
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
                'message': 'verified',
                'data': null,
              },
            ),
          );
        },
      );
      final repo = AuthRepository(dio);

      final result = await repo.verifyEmailCode(
        email: 'noor@example.com',
        code: '123456',
      );

      expect(result.isSuccess, isTrue);
      expect(seen?.path, '/auth/email/verify');
      final data = seen?.data as Map<String, dynamic>;
      expect(data['email'], 'noor@example.com');
      expect(data['code'], '123456');
    });

    test('POST /auth/password/reset sends email and password', () async {
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
                'message': 'updated',
                'data': null,
              },
            ),
          );
        },
      );
      final repo = AuthRepository(dio);

      final result = await repo.resetPassword(
        email: 'noor@example.com',
        password: 'NewSecret@123',
      );

      expect(result.isSuccess, isTrue);
      expect(seen?.path, '/auth/password/reset');
      final data = seen?.data as Map<String, dynamic>;
      expect(data['email'], 'noor@example.com');
      expect(data['password'], 'NewSecret@123');
    });
  });
}
