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
                  'firstName': 'Noor',
                  'lastName': 'Mohammed Ali',
                  'email': 'noor@example.com',
                  'phone': '+966500000001',
                  'gender': 'female',
                  'dob': '1995-01-20',
                },
              },
            ),
          );
        },
      );

      final result = await AuthRepository(dio).updateProfile(
        firstName: 'Noor',
        lastName: 'Mohammed Ali',
        email: 'noor@example.com',
        phone: '+966500000001',
        dob: DateTime(1995, 1, 20),
        gender: 'female',
      );

      expect(result.isSuccess, isTrue);
      expect(seen?.method, 'PUT');
      expect(seen?.path, 'customers/profile');
      expect(seen?.data, isA<Map<String, dynamic>>());
      final body = Map<String, dynamic>.from(seen!.data as Map);
      expect(body['firstName'], 'Noor');
      expect(body['lastName'], 'Mohammed Ali');
      expect(body['email'], 'noor@example.com');
      expect(body['phone'], '+966500000001');
      expect(body['dob'], '1995-01-20');
      expect(body['gender'], 'female');
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
                  'firstName': 'Noor',
                  'lastName': 'Ali',
                  'avatar': 'https://cdn.example.com/noor.jpg',
                },
              },
            ),
          );
        },
      );

      final result = await AuthRepository(dio).updateProfile(
        firstName: 'Noor',
        lastName: 'Ali',
        avatarPath: 'test/fixtures/avatar.jpg',
      );

      expect(result.isSuccess, isTrue);
      // Multipart uses POST with _method: PUT spoofing for PHP/Laravel compatibility
      expect(seen?.method, 'POST');
      expect(seen?.path, 'customers/profile');
      expect(seen?.data, isA<FormData>());
      final formData = seen!.data as FormData;
      final fields = Map<String, String>.fromEntries(formData.fields);
      expect(fields['firstName'], 'Noor');
      expect(fields['lastName'], 'Ali');
      expect(fields['_method'], 'PUT');
      final hasAvatarPart = formData.files.any(
        (entry) => entry.key == 'avatar',
      );
      expect(hasAvatarPart, isTrue);
      expect(result, isA<ApiSuccess<AuthUser>>());
    });
  });
}
