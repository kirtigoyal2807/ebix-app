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
      expect(seen?.path, '/auth/phone/verify');
      final body = seen?.data as Map<String, dynamic>;
      expect(body['phone'], '+966500000001');
      expect(body['code'], '123456');

      final data = result.dataOrNull!;
      expect(data.token, 'jwt-from-phone');
      expect(data.user.email, 'a@b.com');
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
      expect(seen?.path, '/auth/phone/send');
      final body = seen?.data as Map<String, dynamic>;
      expect(body['phone'], '+966500000001');
    });
  });
}
