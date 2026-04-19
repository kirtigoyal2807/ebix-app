import 'package:dio/dio.dart';

import 'api_envelope.dart';
import 'api_result.dart';
import 'network_exception.dart';

/// Central HTTP layer for feature repositories. Inject the same [Dio] from [DioClient].
abstract class BaseRepository {
  BaseRepository(this._dio);

  final Dio _dio;

  /// For requests that need the full JSON body (e.g. [meta] next to envelope [data]).
  Dio get httpClient => _dio;

  Future<ApiResult<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onReceiveProgress,
    T Function(dynamic json)? fromJson,
  }) {
    return _guard(() async {
      final response = await _dio.get<dynamic>(
        path,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onReceiveProgress: onReceiveProgress,
      );
      return _toResult<T>(response, fromJson);
    });
  }

  Future<ApiResult<T>> post<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
    T Function(dynamic json)? fromJson,
  }) {
    return _guard(() async {
      final response = await _dio.post<dynamic>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
      return _toResult<T>(response, fromJson);
    });
  }

  Future<ApiResult<T>> put<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
    T Function(dynamic json)? fromJson,
  }) {
    return _guard(() async {
      final response = await _dio.put<dynamic>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
      return _toResult<T>(response, fromJson);
    });
  }

  Future<ApiResult<T>> patch<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
    T Function(dynamic json)? fromJson,
  }) {
    return _guard(() async {
      final response = await _dio.patch<dynamic>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
      return _toResult<T>(response, fromJson);
    });
  }

  Future<ApiResult<T>> delete<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    T Function(dynamic json)? fromJson,
  }) {
    return _guard(() async {
      final response = await _dio.delete<dynamic>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
      return _toResult<T>(response, fromJson);
    });
  }

  Future<ApiResult<T>> _guard<T>(Future<ApiResult<T>> Function() run) async {
    try {
      return await run();
    } on DioException catch (e, st) {
      return ApiFailure(NetworkException.fromDioException(e, st));
    } catch (e, st) {
      return ApiFailure(NetworkException.fromUnknown(e, st));
    }
  }

  ApiResult<T> _toResult<T>(
    Response<dynamic> response,
    T Function(dynamic json)? fromJson,
  ) {
    final code = response.statusCode;
    if (code == null) {
      return ApiFailure(
        NetworkException(
          type: NetworkFailureType.badResponse,
          message: 'Missing status code',
          responseData: response.data,
        ),
      );
    }

    if (code < 200 || code >= 300) {
      return ApiFailure(
        NetworkException(
          type: NetworkFailureType.badResponse,
          message: 'HTTP $code',
          statusCode: code,
          responseData: response.data,
        ),
      );
    }

    final raw = response.data;

    try {
      final envelope = ApiEnvelopeParser.tryParse(raw);
      if (envelope != null) {
        if (!envelope.success) {
          return ApiFailure(
            NetworkException.fromApiEnvelope(
              statusCode: code,
              message: envelope.message.isEmpty ? 'Request failed' : envelope.message,
              fieldErrors: envelope.fieldErrors,
              responseData: raw,
            ),
          );
        }
        final payload = envelope.data;
        if (fromJson != null) {
          return ApiSuccess(fromJson(payload), statusCode: code);
        }
        final asT = payload as T;
        return ApiSuccess(asT, statusCode: code);
      }

      if (fromJson != null) {
        return ApiSuccess(fromJson(raw), statusCode: code);
      }
      final asT = raw as T;
      return ApiSuccess(asT, statusCode: code);
    } catch (e, st) {
      return ApiFailure(
        NetworkException(
          type: NetworkFailureType.unknown,
          message: 'Failed to parse response: $e',
          statusCode: code,
          responseData: raw,
          cause: e,
          stackTrace: st,
        ),
      );
    }
  }
}
