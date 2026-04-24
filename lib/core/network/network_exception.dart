import 'dart:io';

import 'package:dio/dio.dart';

import 'api_envelope.dart';

/// Failure type for mapping to user-facing messages (e.g. l10n) in Cubits.
enum NetworkFailureType {
  timeout,
  connection,
  cancelled,
  badResponse,
  badCertificate,
  unknown,

  /// HTTP 401 or API rejection of credentials.
  unauthenticated,

  /// HTTP 422, 400 (validation), or envelope `success: false` with field errors.
  validation,
}

/// Normalized error from Dio / HTTP / platform failures.
class NetworkException implements Exception {
  const NetworkException({
    required this.type,
    this.message,
    this.statusCode,
    this.responseData,
    this.dioExceptionType,
    this.cause,
    this.stackTrace,
    this.fieldErrors,
  });

  final NetworkFailureType type;
  final String? message;
  final int? statusCode;
  final dynamic responseData;
  final DioExceptionType? dioExceptionType;
  final Object? cause;
  final StackTrace? stackTrace;

  /// API `errors` map: field -> messages (standard envelope).
  final Map<String, List<String>>? fieldErrors;

  /// Business envelope reported `success: false` (any HTTP status with parseable body).
  factory NetworkException.fromApiEnvelope({
    required int? statusCode,
    required String message,
    Map<String, List<String>>? fieldErrors,
    dynamic responseData,
  }) {
    final hasFieldErrors = fieldErrors != null && fieldErrors.isNotEmpty;
    final type = _typeForHttpCode(statusCode, validationHint: hasFieldErrors);
    return NetworkException(
      type: type,
      message: message,
      statusCode: statusCode,
      responseData: responseData,
      fieldErrors: fieldErrors,
    );
  }

  static NetworkFailureType _typeForHttpCode(
    int? code, {
    bool validationHint = false,
  }) {
    if (code == 401) return NetworkFailureType.unauthenticated;
    if (code == 422 || code == 400) {
      return NetworkFailureType.validation;
    }
    if (code == 409) return NetworkFailureType.badResponse;
    if (validationHint) return NetworkFailureType.validation;
    return NetworkFailureType.badResponse;
  }

  factory NetworkException.fromDioException(
    DioException e, [
    StackTrace? catchStackTrace,
  ]) {
    final st = catchStackTrace ?? e.stackTrace;
    final type = e.type;
    switch (type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return NetworkException(
          type: NetworkFailureType.timeout,
          message: e.message,
          dioExceptionType: type,
          cause: e,
          stackTrace: st,
        );
      case DioExceptionType.badCertificate:
        return NetworkException(
          type: NetworkFailureType.badCertificate,
          message: e.message,
          dioExceptionType: type,
          cause: e,
          stackTrace: st,
        );
      case DioExceptionType.cancel:
        return NetworkException(
          type: NetworkFailureType.cancelled,
          message: e.message,
          dioExceptionType: type,
          cause: e,
          stackTrace: st,
        );
      case DioExceptionType.connectionError:
        return NetworkException(
          type: NetworkFailureType.connection,
          message: e.message,
          dioExceptionType: type,
          cause: e,
          stackTrace: st,
        );
      case DioExceptionType.badResponse:
        final response = e.response;
        return _fromHttpResponse(
          statusCode: response?.statusCode,
          data: response?.data,
          dioExceptionType: type,
          cause: e,
          stackTrace: st,
          fallbackMessage: e.message,
        );
      case DioExceptionType.unknown:
        final err = e.error;
        if (err is SocketException) {
          return NetworkException(
            type: NetworkFailureType.connection,
            message: err.message,
            dioExceptionType: type,
            cause: e,
            stackTrace: st,
          );
        }
        return NetworkException(
          type: NetworkFailureType.unknown,
          message: e.message ?? err?.toString(),
          dioExceptionType: type,
          cause: e,
          stackTrace: st,
        );
    }
  }

  static NetworkException _fromHttpResponse({
    required int? statusCode,
    required dynamic data,
    required DioExceptionType? dioExceptionType,
    required Object? cause,
    required StackTrace? stackTrace,
    required String? fallbackMessage,
  }) {
    final envelope = ApiEnvelopeParser.tryParse(data);
    if (envelope != null && !envelope.success) {
      return NetworkException.fromApiEnvelope(
        statusCode: statusCode,
        message: envelope.message,
        fieldErrors: envelope.fieldErrors,
        responseData: data,
      );
    }
    if (envelope != null && envelope.success) {
      return NetworkException(
        type: NetworkFailureType.badResponse,
        message: envelope.message.isNotEmpty
            ? envelope.message
            : (fallbackMessage ?? 'HTTP $statusCode'),
        statusCode: statusCode,
        responseData: data,
        dioExceptionType: dioExceptionType,
        cause: cause,
        stackTrace: stackTrace,
      );
    }

    final type = _typeForHttpCode(statusCode);
    final plain = _plainMessageFromBody(data);
    return NetworkException(
      type: type,
      message: plain ?? fallbackMessage ?? 'HTTP $statusCode',
      statusCode: statusCode,
      responseData: data,
      dioExceptionType: dioExceptionType,
      cause: cause,
      stackTrace: stackTrace,
    );
  }

  /// Laravel / plain JSON errors without a `success` envelope (e.g. 422 `message`).
  static String? _plainMessageFromBody(dynamic data) {
    if (data is! Map) return null;
    final m = Map<String, dynamic>.from(data);
    for (final key in <String>['message', 'error', 'detail']) {
      final v = m[key];
      if (v is String && v.trim().isNotEmpty) return v.trim();
    }
    return null;
  }

  factory NetworkException.fromUnknown(Object error, [StackTrace? st]) {
    if (error is DioException) {
      return NetworkException.fromDioException(error);
    }
    if (error is SocketException) {
      return NetworkException(
        type: NetworkFailureType.connection,
        message: error.message,
        cause: error,
        stackTrace: st,
      );
    }
    return NetworkException(
      type: NetworkFailureType.unknown,
      message: error.toString(),
      cause: error,
      stackTrace: st,
    );
  }

  @override
  String toString() =>
      'NetworkException($type, status: $statusCode, message: $message)';
}
