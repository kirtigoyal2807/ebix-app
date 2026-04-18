import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

/// Builds a [Dio] instance with timeouts and predictable status handling.
///
/// [baseUrl] may be empty if you always pass absolute URLs to requests.
class DioClient {
  DioClient({
    required String baseUrl,
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
            // Resolve success vs error in [BaseRepository] for consistent mapping.
            validateStatus: (status) => status != null && status < 600,
          ),
        ) {
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

  final Dio dio;
}
