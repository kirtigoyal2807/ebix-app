import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pilates_app/core/network/dio_client.dart';

void main() {
  group('DioClient', () {
    test('configures timeouts and JSON headers', () {
      final client = DioClient(
        baseUrl: 'https://api.example/',
        connectTimeout: const Duration(seconds: 12),
        receiveTimeout: const Duration(seconds: 34),
        sendTimeout: const Duration(seconds: 56),
      );

      final o = client.dio.options;
      expect(o.baseUrl, 'https://api.example/');
      expect(o.connectTimeout, const Duration(seconds: 12));
      expect(o.receiveTimeout, const Duration(seconds: 34));
      expect(o.sendTimeout, const Duration(seconds: 56));
      expect(o.headers[Headers.acceptHeader], Headers.jsonContentType);
      expect(o.headers[Headers.contentTypeHeader], Headers.jsonContentType);
    });

    test('merges defaultHeaders', () {
      final client = DioClient(
        baseUrl: 'https://x/',
        defaultHeaders: const {'Authorization': 'Bearer t'},
      );

      expect(client.dio.options.headers['Authorization'], 'Bearer t');
    });

    test('validateStatus accepts HTTP 2xx only', () {
      final client = DioClient(baseUrl: 'https://x/');
      final vs = client.dio.options.validateStatus;
      expect(vs?.call(199), isFalse);
      expect(vs?.call(200), isTrue);
      expect(vs?.call(201), isTrue);
      expect(vs?.call(204), isTrue);
      expect(vs?.call(299), isTrue);
      expect(vs?.call(404), isFalse);
      expect(vs?.call(422), isFalse);
      expect(vs?.call(500), isFalse);
      expect(vs?.call(600), isFalse);
      expect(vs?.call(null), isFalse);
    });

    test(
      'interceptor sets X-Brand, Accept-Language, and Bearer when provided',
      () async {
        String? brand;
        String? lang;
        String? auth;
        final client = DioClient(
          baseUrl: 'https://x/',
          brand: 'pilates',
          resolveLanguage: () => 'ar',
          accessToken: () => 'jwt-token',
        );
        client.dio.interceptors.add(
          InterceptorsWrapper(
            onRequest: (options, handler) {
              brand = options.headers['X-Brand'] as String?;
              lang = options.headers['Accept-Language'] as String?;
              auth = options.headers['Authorization'] as String?;
              handler.resolve(
                Response(
                  requestOptions: options,
                  statusCode: 200,
                  data: const {},
                ),
              );
            },
          ),
        );
        await client.dio.get<Object?>('/');
        expect(brand, 'pilates');
        expect(lang, 'ar');
        expect(auth, 'Bearer jwt-token');
      },
    );

    test(
      'interceptor omits Authorization when accessToken is null or empty',
      () async {
        String? authPresent;
        final client = DioClient(baseUrl: 'https://y/', accessToken: () => '');
        client.dio.interceptors.add(
          InterceptorsWrapper(
            onRequest: (options, handler) {
              authPresent = options.headers['Authorization'] as String?;
              handler.resolve(
                Response(
                  requestOptions: options,
                  statusCode: 200,
                  data: const {},
                ),
              );
            },
          ),
        );
        await client.dio.get<Object?>('/');
        expect(authPresent, isNull);
      },
    );

    test('debug LogInterceptor is only added in debug mode', () {
      final client = DioClient(baseUrl: 'https://x/');
      final hasLog = client.dio.interceptors.any((i) => i is LogInterceptor);
      expect(hasLog, kDebugMode);
    });
  });
}
