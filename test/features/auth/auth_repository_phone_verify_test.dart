import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pilates_app/features/auth/data/auth_repository.dart';

import '../../core/network/test_repository.dart';

void main() {
  group('AuthRepository.verifyPhoneOtp', () {
    test('POST /auth/phone/verify sends phone and code', () async {
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
                'message': 'ok',
                'data': {
                  'user': {'email': 'a@b.com', 'phone': '+966500000001'},
                  'token': 'jwt-from-phone',
                },
              },
            ),
          );
        },
      );
      final repo = AuthRepository(dio);

      final result = await repo.verifyPhoneOtp(
        phone: ' +966500000001 ',
        code: ' 123456 ',
      );

      expect(result.isSuccess, isTrue);
      expect(seen?.path, 'auth/phone/verify');
      final body = seen?.data as Map<String, dynamic>;
      expect(body['phone'], '+966500000001');
      expect(body['code'], '123456');

      final data = result.dataOrNull!;
      expect(data.token, 'jwt-from-phone');
      expect(data.user.email, 'a@b.com');
    });
  });

  group('AuthRepository.verifyProfilePhone', () {
    test('POST /auth/profile/verify-phone sends phone and otp', () async {
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
                'message': 'ok',
                'data': {
                  'user': {'email': 'a@b.com', 'phone': '+966500000002'},
                  'token': 'jwt-profile-phone',
                },
              },
            ),
          );
        },
      );
      final repo = AuthRepository(dio);

      final result = await repo.verifyProfilePhone(
        phone: ' +966500000002 ',
        otp: ' 847261 ',
      );

      expect(result.isSuccess, isTrue);
      expect(seen?.path, 'auth/profile/verify-phone');
      final body = seen?.data as Map<String, dynamic>;
      expect(body['phone'], '+966500000002');
      expect(body['otp'], '847261');
      expect(body.containsKey('code'), isFalse);

      final data = result.dataOrNull!;
      expect(data.token, 'jwt-profile-phone');
      expect(data.user.phone, '+966500000002');
    });

    test('parses user without token', () async {
      final dio = createTestDio(
        onRequest: (options, handler) {
          handler.resolve(
            Response(
              requestOptions: options,
              statusCode: 200,
              data: {
                'success': true,
                'message': 'ok',
                'data': {
                  'user': {'email': 'a@b.com', 'phone': '+966500000002'},
                },
              },
            ),
          );
        },
      );
      final repo = AuthRepository(dio);

      final result = await repo.verifyProfilePhone(
        phone: '+966500000002',
        otp: '847261',
      );

      expect(result.isSuccess, isTrue);
      expect(result.dataOrNull?.token, isNull);
      expect(result.dataOrNull?.user.phone, '+966500000002');
    });

    test('parses flat profile data (no nested user key)', () async {
      final dio = createTestDio(
        onRequest: (options, handler) {
          handler.resolve(
            Response(
              requestOptions: options,
              statusCode: 200,
              data: {
                'success': true,
                'message': 'phone_updated_successfully',
                'data': {
                  'id': 19,
                  'name': 'Dilip Test',
                  'firstName': 'Dilip',
                  'lastName': 'Test',
                  'email': 'diliptest123@mailinator.com',
                  'phone': '+966123456787',
                  'dob': '1997-03-15',
                  'gender': 'female',
                  'phoneVerified': true,
                },
              },
            ),
          );
        },
      );
      final repo = AuthRepository(dio);

      final result = await repo.verifyProfilePhone(
        phone: '+966123456787',
        otp: '123456',
      );

      expect(result.isSuccess, isTrue);
      final data = result.dataOrNull!;
      expect(data.user.id, '19');
      expect(data.user.phone, '+966123456787');
      expect(data.user.email, 'diliptest123@mailinator.com');
      expect(data.token, isNull);
    });
  });

  group('AuthRepository.verifyProfileEmail', () {
    test('POST /auth/profile/verify-email sends email and code', () async {
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
                'message': 'ok',
                'data': {
                  'id': 1,
                  'email': 'new@example.com',
                },
              },
            ),
          );
        },
      );
      final repo = AuthRepository(dio);

      final result = await repo.verifyProfileEmail(
        email: ' new@example.com ',
        code: ' 391047 ',
      );

      expect(result.isSuccess, isTrue);
      expect(seen?.path, 'auth/profile/verify-email');
      final body = seen?.data as Map<String, dynamic>;
      expect(body['email'], 'new@example.com');
      expect(body['code'], '391047');
      expect(result.dataOrNull?.email, 'new@example.com');
    });
  });

  group('AuthRepository.sendPhoneOtp', () {
    test('POST /auth/phone/send sends phone', () async {
      RequestOptions? seen;
      final dio = createTestDio(
        onRequest: (options, handler) {
          seen = options;
          handler.resolve(
            Response(
              requestOptions: options,
              statusCode: 200,
              data: {'success': true, 'message': 'ok'},
            ),
          );
        },
      );
      final repo = AuthRepository(dio);

      final result = await repo.sendPhoneOtp(phone: ' +966500000001 ');

      expect(result.isSuccess, isTrue);
      expect(seen?.path, 'auth/phone/send');
      final body = seen?.data as Map<String, dynamic>;
      expect(body['phone'], '+966500000001');
    });
  });
}
