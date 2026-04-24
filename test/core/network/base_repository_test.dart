import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pilates_app/core/network/api_result.dart';
import 'package:pilates_app/core/network/network_exception.dart';

import 'test_repository.dart';

void main() {
  group('BaseRepository', () {
    test('GET: 200 returns ApiSuccess with raw data (Map)', () async {
      final dio = createTestDio(
        onRequest: (options, handler) {
          expect(options.method, 'GET');
          handler.resolve(
            Response(
              requestOptions: options,
              statusCode: 200,
              data: const {'user': 'a', 'id': 1},
            ),
          );
        },
      );
      final repo = TestRepository(dio);

      final result = await repo.get<Map<String, dynamic>>('/users/1');

      expect(result.isSuccess, isTrue);
      final data = result.dataOrNull;
      expect(data, const {'user': 'a', 'id': 1});
      expect(result.when(success: (_, c) => c, failure: (_) => null), 200);
    });

    test('GET: uses fromJson parser', () async {
      final dio = createTestDio(
        onRequest: (options, handler) {
          handler.resolve(
            Response(
              requestOptions: options,
              statusCode: 200,
              data: const {'name': 'N', 'age': 30},
            ),
          );
        },
      );
      final repo = TestRepository(dio);

      final result = await repo.get<({String name, int age})>(
        '/profile',
        fromJson: (json) {
          final m = json as Map<String, dynamic>;
          return (name: m['name']! as String, age: m['age']! as int);
        },
      );

      expect(result.isSuccess, isTrue);
      expect(result.dataOrNull?.name, 'N');
      expect(result.dataOrNull?.age, 30);
    });

    test('GET: 404 maps to ApiFailure with badResponse', () async {
      final dio = createTestDio(
        onRequest: (options, handler) {
          handler.reject(
            DioException(
              requestOptions: options,
              type: DioExceptionType.badResponse,
              response: Response(
                requestOptions: options,
                statusCode: 404,
                data: const {'message': 'Not found'},
              ),
            ),
          );
        },
      );
      final repo = TestRepository(dio);

      final result = await repo.get<Map<String, dynamic>>('/missing');

      expect(result.isFailure, isTrue);
      final ex = result.exceptionOrNull!;
      expect(ex.type, NetworkFailureType.badResponse);
      expect(ex.statusCode, 404);
      expect(ex.responseData, const {'message': 'Not found'});
    });

    test('GET: 500 maps to ApiFailure', () async {
      final dio = createTestDio(
        onRequest: (options, handler) {
          handler.reject(
            DioException(
              requestOptions: options,
              type: DioExceptionType.badResponse,
              response: Response(
                requestOptions: options,
                statusCode: 500,
                data: 'err',
              ),
            ),
          );
        },
      );
      final repo = TestRepository(dio);

      final result = await repo.get<void>('/fail');
      expect(result.isFailure, isTrue);
      expect(result.exceptionOrNull?.type, NetworkFailureType.badResponse);
      expect(result.exceptionOrNull?.statusCode, 500);
    });

    test('GET: 200 with success envelope unwraps data for fromJson', () async {
      final dio = createTestDio(
        onRequest: (options, handler) {
          handler.resolve(
            Response(
              requestOptions: options,
              statusCode: 200,
              data: const {
                'success': true,
                'message': 'Success',
                'data': {'id': 7, 'name': 'Test'},
              },
            ),
          );
        },
      );
      final repo = TestRepository(dio);

      final result = await repo.get<Map<String, dynamic>>(
        '/resource',
        fromJson: (json) => json as Map<String, dynamic>,
      );

      expect(result.isSuccess, isTrue);
      expect(result.dataOrNull, const {'id': 7, 'name': 'Test'});
    });

    test('GET: 200 success envelope without fromJson returns data payload',
        () async {
      final dio = createTestDio(
        onRequest: (options, handler) {
          handler.resolve(
            Response(
              requestOptions: options,
              statusCode: 200,
              data: const {
                'success': true,
                'message': 'Success',
                'data': {'k': 'v'},
              },
            ),
          );
        },
      );
      final repo = TestRepository(dio);

      final result = await repo.get<Map<String, dynamic>>('/resource');

      expect(result.isSuccess, isTrue);
      expect(result.dataOrNull, const {'k': 'v'});
    });

    test('GET: 200 with success false envelope maps to ApiFailure', () async {
      final dio = createTestDio(
        onRequest: (options, handler) {
          handler.resolve(
            Response(
              requestOptions: options,
              statusCode: 200,
              data: const {
                'success': false,
                'message': 'Not allowed',
                'errors': {'field': ['x']},
              },
            ),
          );
        },
      );
      final repo = TestRepository(dio);

      final result = await repo.get<Map<String, dynamic>>('/resource');

      expect(result.isFailure, isTrue);
      final ex = result.exceptionOrNull!;
      expect(ex.message, 'Not allowed');
      expect(ex.fieldErrors, const {'field': ['x']});
      expect(ex.type, NetworkFailureType.validation);
    });

    test('POST: 422 with error envelope maps to validation', () async {
      final dio = createTestDio(
        onRequest: (options, handler) {
          handler.reject(
            DioException(
              requestOptions: options,
              type: DioExceptionType.badResponse,
              response: Response(
                requestOptions: options,
                statusCode: 422,
                data: const {
                  'success': false,
                  'message': 'Validation failed',
                  'errors': {'email': ['invalid']},
                },
              ),
            ),
          );
        },
      );
      final repo = TestRepository(dio);

      final result = await repo.post<Map<String, dynamic>>('/x', data: const {});

      expect(result.isFailure, isTrue);
      final ex = result.exceptionOrNull!;
      expect(ex.type, NetworkFailureType.validation);
      expect(ex.statusCode, 422);
      expect(ex.fieldErrors, const {'email': ['invalid']});
    });

    test('POST: 422 plain message (no envelope) maps to validation message', () async {
      final dio = createTestDio(
        onRequest: (options, handler) {
          handler.reject(
            DioException(
              requestOptions: options,
              type: DioExceptionType.badResponse,
              response: Response(
                requestOptions: options,
                statusCode: 422,
                data: const {'message': 'Check-in is too early'},
              ),
            ),
          );
        },
      );
      final repo = TestRepository(dio);

      final result = await repo.post<Map<String, dynamic>>(
        '/enrollments/1/check-in',
        data: const <String, dynamic>{},
      );

      expect(result.isFailure, isTrue);
      final ex = result.exceptionOrNull!;
      expect(ex.type, NetworkFailureType.validation);
      expect(ex.statusCode, 422);
      expect(ex.message, 'Check-in is too early');
    });

    test('GET: missing statusCode maps to ApiFailure', () async {
      final dio = createTestDio(
        onRequest: (options, handler) {
          handler.resolve(
            Response(
              requestOptions: options,
              statusCode: null,
              data: const {},
            ),
          );
        },
      );
      final repo = TestRepository(dio);

      final result = await repo.get<Map<String, dynamic>>('/weird');
      expect(result.isFailure, isTrue);
      expect(result.exceptionOrNull?.message, contains('Missing status code'));
    });

    test('POST: 201 and body', () async {
      final dio = createTestDio(
        onRequest: (options, handler) {
          expect(options.method, 'POST');
          expect(options.data, const {'x': 1});
          handler.resolve(
            Response(
              requestOptions: options,
              statusCode: 201,
              data: const {'created': true},
            ),
          );
        },
      );
      final repo = TestRepository(dio);

      final result = await repo.post<Map<String, dynamic>>(
        '/items',
        data: const {'x': 1},
      );

      expect(result.isSuccess, isTrue);
      expect(result.dataOrNull, const {'created': true});
    });

    test('PUT: 200', () async {
      final dio = createTestDio(
        onRequest: (options, handler) {
          expect(options.method, 'PUT');
          handler.resolve(
            Response(
              requestOptions: options,
              statusCode: 200,
              data: const {'updated': true},
            ),
          );
        },
      );
      final repo = TestRepository(dio);

      final result =
          await repo.put<Map<String, dynamic>>('/items/1', data: const {});

      expect(result.isSuccess, isTrue);
    });

    test('PATCH: 200', () async {
      final dio = createTestDio(
        onRequest: (options, handler) {
          expect(options.method, 'PATCH');
          handler.resolve(
            Response(
              requestOptions: options,
              statusCode: 200,
              data: const {'patched': true},
            ),
          );
        },
      );
      final repo = TestRepository(dio);

      final result = await repo.patch<Map<String, dynamic>>(
        '/items/1',
        data: const {'a': 'b'},
      );

      expect(result.isSuccess, isTrue);
    });

    test('DELETE: 200', () async {
      final dio = createTestDio(
        onRequest: (options, handler) {
          expect(options.method, 'DELETE');
          handler.resolve(
            Response(
              requestOptions: options,
              statusCode: 200,
              data: const {'ok': true},
            ),
          );
        },
      );
      final repo = TestRepository(dio);

      final result =
          await repo.delete<Map<String, dynamic>>('/items/1');

      expect(result.isSuccess, isTrue);
    });

    test('DioException: connection timeout → ApiFailure timeout', () async {
      final dio = createTestDio(
        onRequest: (options, handler) {
          handler.reject(
            DioException(
              requestOptions: options,
              type: DioExceptionType.connectionTimeout,
            ),
          );
        },
      );
      final repo = TestRepository(dio);

      final result = await repo.get<Map<String, dynamic>>('/x');
      expect(result.isFailure, isTrue);
      expect(result.exceptionOrNull?.type, NetworkFailureType.timeout);
    });

    test('DioException: send timeout', () async {
      final dio = createTestDio(
        onRequest: (options, handler) {
          handler.reject(
            DioException(
              requestOptions: options,
              type: DioExceptionType.sendTimeout,
            ),
          );
        },
      );
      final repo = TestRepository(dio);

      final result = await repo.post<dynamic>('/x', data: {});
      expect(result.exceptionOrNull?.type, NetworkFailureType.timeout);
    });

    test('DioException: receive timeout', () async {
      final dio = createTestDio(
        onRequest: (options, handler) {
          handler.reject(
            DioException(
              requestOptions: options,
              type: DioExceptionType.receiveTimeout,
            ),
          );
        },
      );
      final repo = TestRepository(dio);

      final result = await repo.get<dynamic>('/x');
      expect(result.exceptionOrNull?.type, NetworkFailureType.timeout);
    });

    test('DioException: cancel', () async {
      final dio = createTestDio(
        onRequest: (options, handler) {
          handler.reject(
            DioException(
              requestOptions: options,
              type: DioExceptionType.cancel,
            ),
          );
        },
      );
      final repo = TestRepository(dio);

      final result = await repo.get<dynamic>('/x');
      expect(result.exceptionOrNull?.type, NetworkFailureType.cancelled);
    });

    test('DioException: connection error', () async {
      final dio = createTestDio(
        onRequest: (options, handler) {
          handler.reject(
            DioException(
              requestOptions: options,
              type: DioExceptionType.connectionError,
            ),
          );
        },
      );
      final repo = TestRepository(dio);

      final result = await repo.get<dynamic>('/x');
      expect(result.exceptionOrNull?.type, NetworkFailureType.connection);
    });

    test('DioException: bad certificate', () async {
      final dio = createTestDio(
        onRequest: (options, handler) {
          handler.reject(
            DioException(
              requestOptions: options,
              type: DioExceptionType.badCertificate,
            ),
          );
        },
      );
      final repo = TestRepository(dio);

      final result = await repo.get<dynamic>('/x');
      expect(result.exceptionOrNull?.type, NetworkFailureType.badCertificate);
    });

    test('DioException: bad response', () async {
      final dio = createTestDio(
        onRequest: (options, handler) {
          handler.reject(
            DioException(
              requestOptions: options,
              type: DioExceptionType.badResponse,
              response: Response(
                requestOptions: options,
                statusCode: 502,
                data: 'bad',
              ),
            ),
          );
        },
      );
      final repo = TestRepository(dio);

      final result = await repo.get<dynamic>('/x');
      expect(result.exceptionOrNull?.type, NetworkFailureType.badResponse);
      expect(result.exceptionOrNull?.statusCode, 502);
    });

    test('DioException: unknown with nested SocketException → connection',
        () async {
      final dio = createTestDio(
        onRequest: (options, handler) {
          handler.reject(
            DioException(
              requestOptions: options,
              type: DioExceptionType.unknown,
              error: SocketException('no host'),
            ),
          );
        },
      );
      final repo = TestRepository(dio);
      final result = await repo.get<dynamic>('/x');
      expect(result.exceptionOrNull?.type, NetworkFailureType.connection);
    });

    test('DioException: unknown with generic error', () async {
      final dio = createTestDio(
        onRequest: (options, handler) {
          handler.reject(
            DioException(
              requestOptions: options,
              type: DioExceptionType.unknown,
              error: Exception('wrapped'),
            ),
          );
        },
      );
      final repo = TestRepository(dio);
      final result = await repo.get<dynamic>('/x');
      expect(result.exceptionOrNull?.type, NetworkFailureType.unknown);
    });

    test('cast / parse failure on 200 → ApiFailure unknown', () async {
      final dio = createTestDio(
        onRequest: (options, handler) {
          handler.resolve(
            Response(
              requestOptions: options,
              statusCode: 200,
              data: 42,
            ),
          );
        },
      );
      final repo = TestRepository(dio);

      final result = await repo.get<String>('/n');
      expect(result.isFailure, isTrue);
      expect(result.exceptionOrNull?.type, NetworkFailureType.unknown);
      expect(result.exceptionOrNull?.message, contains('parse'));
    });

    test('fromJson throws → ApiFailure unknown', () async {
      final dio = createTestDio(
        onRequest: (options, handler) {
          handler.resolve(
            Response(
              requestOptions: options,
              statusCode: 200,
              data: const {},
            ),
          );
        },
      );
      final repo = TestRepository(dio);

      final result = await repo.get<int>(
        '/x',
        fromJson: (_) => throw FormatException('bad json'),
      );

      expect(result.isFailure, isTrue);
      expect(result.exceptionOrNull?.type, NetworkFailureType.unknown);
      expect(result.exceptionOrNull?.cause, isA<FormatException>());
    });

    test('sync throw in interceptor becomes DioException then ApiFailure',
        () async {
      final dio = Dio(
        BaseOptions(baseUrl: 'https://test.local'),
      );
      dio.interceptors.add(
        InterceptorsWrapper(
          onRequest: (options, handler) {
            throw StateError('unexpected');
          },
        ),
      );
      final repo = TestRepository(dio);

      final result = await repo.get<dynamic>('/x');
      expect(result.isFailure, isTrue);
      expect(result.exceptionOrNull?.cause, isA<DioException>());
      final dioErr = result.exceptionOrNull!.cause! as DioException;
      expect(dioErr.error, isA<StateError>());
    });

    test('queryParameters forwarded to Dio', () async {
      Map<String, dynamic>? seen;
      final dio = createTestDio(
        onRequest: (options, handler) {
          seen = options.queryParameters;
          handler.resolve(
            Response(requestOptions: options, statusCode: 200, data: const {}),
          );
        },
      );
      final repo = TestRepository(dio);

      await repo.get<dynamic>('/search', queryParameters: const {'q': 'pilates'});

      expect(seen, const {'q': 'pilates'});
    });
  });
}
