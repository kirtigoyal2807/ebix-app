import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pilates_app/core/network/api_result.dart';
import 'package:pilates_app/features/auth/data/auth_repository.dart';
import 'package:pilates_app/features/auth/data/models/auth_user.dart';

import '../../core/network/test_repository.dart';

void main() {
  group('AuthRepository.updateProfile', () {
    test('sends JSON payload when avatar is not provided', () async {
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
                'message': 'Profile updated successfully',
                'data': {
                  'name': 'Noor Mohammed Ali',
                  'phone': '+966500000001',
                  'gender': 'female',
                  'dob': '1995-01-20',
                  'marketingOptIn': false,
                },
              },
            ),
          );
        },
      );

      final result = await AuthRepository(dio).updateProfile(
        name: 'Noor Mohammed Ali',
        phone: '+966500000001',
        dob: DateTime(1995, 1, 20),
        gender: 'female',
        marketingOptIn: false,
      );

      expect(result.isSuccess, isTrue);
      expect(seen?.method, 'PUT');
      expect(seen?.path, '/customers/profile');
      expect(seen?.data, isA<Map<String, dynamic>>());
      final body = Map<String, dynamic>.from(seen!.data as Map);
      expect(body['name'], 'Noor Mohammed Ali');
      expect(body['phone'], '+966500000001');
      expect(body['dob'], '1995-01-20');
      expect(body['gender'], 'female');
      expect(body['marketingOptIn'], false);
      expect(result.dataOrNull, isA<AuthUser>());
    });

    test('sends multipart payload when avatar is provided', () async {
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
                'message': 'Profile updated successfully',
                'data': {
                  'name': 'Noor',
                  'avatar': 'https://cdn.example.com/noor.jpg',
                },
              },
            ),
          );
        },
      );

      final result = await AuthRepository(
        dio,
      ).updateProfile(name: 'Noor', avatarPath: 'test/fixtures/avatar.jpg');

      expect(result.isSuccess, isTrue);
      expect(seen?.method, 'PUT');
      expect(seen?.path, '/customers/profile');
      expect(seen?.data, isA<FormData>());
      final formData = seen!.data as FormData;
      final fields = Map<String, String>.fromEntries(formData.fields);
      expect(fields['name'], 'Noor');
      final hasAvatarPart = formData.files.any(
        (entry) => entry.key == 'avatar',
      );
      expect(hasAvatarPart, isTrue);
      expect(result, isA<ApiSuccess<AuthUser>>());
    });
  });
}
