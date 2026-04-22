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
    final normalizedMessage = message.trim();
    final fallbackFieldMessage = _firstFieldErrorMessage(fieldErrors);
    final hasFieldErrors = fieldErrors != null && fieldErrors.isNotEmpty;
    final type = _typeForHttpCode(statusCode, validationHint: hasFieldErrors);
    return NetworkException(
      type: type,
      message: normalizedMessage.isNotEmpty
          ? normalizedMessage
          : fallbackFieldMessage,
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

    final extractedFieldErrors = _extractFieldErrorsFromAnyResponse(data);
    final extractedMessage =
        _extractMessageFromAnyResponse(data) ??
        _firstFieldErrorMessage(extractedFieldErrors) ??
        fallbackMessage ??
        'HTTP $statusCode';
    final type = _typeForHttpCode(statusCode);
    return NetworkException(
      type: type,
      message: extractedMessage,
      statusCode: statusCode,
      responseData: data,
      dioExceptionType: dioExceptionType,
      cause: cause,
      stackTrace: stackTrace,
      fieldErrors: extractedFieldErrors,
    );
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

  static String? _extractMessageFromAnyResponse(dynamic data) {
    if (data is String) {
      final trimmed = data.trim();
      return trimmed.isEmpty ? null : trimmed;
    }
    if (data is! Map) return null;

    String? readString(dynamic value) {
      if (value is String) {
        final trimmed = value.trim();
        return trimmed.isEmpty ? null : trimmed;
      }
      if (value == null) return null;
      final asText = value.toString().trim();
      return asText.isEmpty ? null : asText;
    }

    const directMessageKeys = ['message', 'error', 'detail', 'title', 'reason'];
    for (final key in directMessageKeys) {
      final candidate = readString(data[key]);
      if (candidate != null) return candidate;
    }

    const nestedMessageKeys = [
      'errors',
      'error_description',
      'error_description_ar',
    ];
    for (final key in nestedMessageKeys) {
      final candidate = _extractMessageFromNestedError(data[key]);
      if (candidate != null) return candidate;
    }

    return null;
  }

  static String? _extractMessageFromNestedError(dynamic value) {
    if (value is List && value.isNotEmpty) {
      final first = value.first;
      if (first is String) {
        final trimmed = first.trim();
        return trimmed.isEmpty ? null : trimmed;
      }
      return _extractMessageFromNestedError(first);
    }
    if (value is Map && value.isNotEmpty) {
      for (final entry in value.entries) {
        final nested = _extractMessageFromNestedError(entry.value);
        if (nested != null) return nested;
      }
    }
    if (value is String) {
      final trimmed = value.trim();
      return trimmed.isEmpty ? null : trimmed;
    }
    return null;
  }

  static String? _firstFieldErrorMessage(Map<String, List<String>>? fieldErrors) {
    if (fieldErrors == null || fieldErrors.isEmpty) return null;
    for (final value in fieldErrors.values) {
      if (value.isNotEmpty) {
        final first = value.first.trim();
        if (first.isNotEmpty) {
          return first;
        }
      }
    }
    return null;
  }

  static Map<String, List<String>>? _extractFieldErrorsFromAnyResponse(
    dynamic data,
  ) {
    if (data is! Map) return null;
    final errors = data['errors'];
    if (errors is! Map) return null;
    final out = <String, List<String>>{};
    for (final entry in errors.entries) {
      final key = entry.key.toString();
      final value = entry.value;
      if (value is List) {
        final messages = value
            .map((e) => e.toString().trim())
            .where((e) => e.isNotEmpty)
            .toList();
        if (messages.isNotEmpty) {
          out[key] = messages;
        }
        continue;
      }
      final asText = value?.toString().trim() ?? '';
      if (asText.isNotEmpty) {
        out[key] = [asText];
      }
    }
    return out.isEmpty ? null : out;
  }
}
