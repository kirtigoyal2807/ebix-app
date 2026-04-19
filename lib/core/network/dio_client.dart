import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../constants/api_config.dart';

/// Builds a [Dio] instance aligned with the Pilates API:
/// JSON body, [ApiConfig.headerBrand], [ApiConfig.headerAcceptLanguage],
/// and optional Bearer JWT for protected routes.
///
/// [resolveLanguage] must return `en` or `ar` (API contract).
class DioClient {
  DioClient({
    required String baseUrl,
    String brand = ApiConfig.brand,
    String Function() resolveLanguage = _defaultLanguage,
    String? Function()? accessToken,
    Duration connectTimeout = const Duration(seconds: 30),
    Duration receiveTimeout = const Duration(seconds: 30),
    Duration sendTimeout = const Duration(seconds: 30),
    Map<String, dynamic>? defaultHeaders,
    List<Interceptor>? interceptors,
  }) : dio = Dio(
          BaseOptions(
            baseUrl: baseUrl,
            connectTimeout: connectTimeout,
            receiveTimeout: receiveTimeout,
            sendTimeout: sendTimeout,
            headers: {
              Headers.acceptHeader: Headers.jsonContentType,
              Headers.contentTypeHeader: Headers.jsonContentType,
              ...?defaultHeaders,
            },
            // Non-2xx responses throw [DioException] so failures go through
            // [NetworkException.fromDioException] (envelope-aware).
            validateStatus: (status) =>
                status != null && status >= 200 && status < 300,
          ),
        ) {
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          options.headers[ApiConfig.headerBrand] = brand;
          options.headers[ApiConfig.headerAcceptLanguage] = resolveLanguage();
          if (accessToken != null) {
            final token = accessToken();
            if (token != null && token.isNotEmpty) {
              options.headers[ApiConfig.headerAuthorization] = 'Bearer $token';
            } else {
              options.headers.remove(ApiConfig.headerAuthorization);
            }
          }
          handler.next(options);
        },
      ),
    );
    if (interceptors != null && interceptors.isNotEmpty) {
      dio.interceptors.addAll(interceptors);
    }
    if (kDebugMode) {
      dio.interceptors.add(
        LogInterceptor(
          requestBody: true,
          responseBody: true,
          error: true,
        ),
      );
    }
  }

  static String _defaultLanguage() => 'en';

  final Dio dio;
}
