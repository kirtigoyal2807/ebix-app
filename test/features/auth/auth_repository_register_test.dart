import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pilates_app/features/auth/data/auth_repository.dart';
import 'package:pilates_app/features/auth/data/models/register_gender.dart';

import '../../core/network/test_repository.dart';

void main() {
  group('AuthRepository.register', () {
    test(
      'POST /auth/register includes required fields and optional gender/dob',
      () async {
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
                  'message': 'OTP sent',
                  'data': null,
                },
              ),
            );
          },
        );
        final repo = AuthRepository(dio);

        final result = await repo.register(
          firstName: 'Noor',
          lastName: 'Ali',
          email: 'noor@example.com',
          phone: '+966500000001',
          password: 'Secret@123',
          gender: RegisterGender.female,
          dob: DateTime(1995, 1, 20),
        );

        expect(result.isSuccess, isTrue);
        expect(seen?.method, 'POST');
        expect(seen?.path, '/auth/register');
        final data = seen?.data as Map<String, dynamic>;
        expect(data['firstName'], 'Noor');
        expect(data['lastName'], 'Ali');
        expect(data['email'], 'noor@example.com');
        expect(data['phone'], '+966500000001');
        expect(data['password'], 'Secret@123');
        expect(data['gender'], 'female');
        expect(data['dob'], '1995-01-20');
        expect(data['referralCode'], '');
      },
    );

    test('always sends referralCode trimmed; whitespace-only becomes empty', () async {
      RequestOptions? seen;
      final dio = createTestDio(
        onRequest: (options, handler) {
          seen = options;
          handler.resolve(
            Response(
              requestOptions: options,
              statusCode: 200,
              data: const {'success': true, 'message': 'ok', 'data': null},
            ),
          );
        },
      );
      final repo = AuthRepository(dio);

      await repo.register(
        firstName: 'Noor',
        email: 'noor@example.com',
        phone: '+966500000001',
        password: 'Secret@123',
        referralCode: '  FRIEND20  ',
      );

      final data = seen?.data as Map<String, dynamic>;
      expect(data['referralCode'], 'FRIEND20');

      await repo.register(
        firstName: 'Noor',
        email: 'noor@example.com',
        phone: '+966500000001',
        password: 'Secret@123',
        referralCode: '   ',
      );

      expect((seen?.data as Map<String, dynamic>)['referralCode'], '');
    });

    test('omits lastName when empty and optional fields when null', () async {
      RequestOptions? seen;
      final dio = createTestDio(
        onRequest: (options, handler) {
          seen = options;
          handler.resolve(
            Response(
              requestOptions: options,
              statusCode: 200,
              data: const {'success': true, 'message': 'ok', 'data': null},
            ),
          );
        },
      );
      final repo = AuthRepository(dio);

      await repo.register(
        firstName: 'Noor',
        lastName: '  ',
        email: 'noor@example.com',
        phone: '+966500000001',
        password: 'Secret@123',
      );

      final data = seen?.data as Map<String, dynamic>;
      expect(data.containsKey('lastName'), isFalse);
      expect(data.containsKey('gender'), isFalse);
      expect(data.containsKey('dob'), isFalse);
      expect(data['referralCode'], '');
    });
  });
}
