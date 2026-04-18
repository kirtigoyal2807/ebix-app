import 'dart:io';

import 'package:dio/dio.dart';

/// Failure type for mapping to user-facing messages (e.g. l10n) in Cubits.
enum NetworkFailureType {
  timeout,
  connection,
  cancelled,
  badResponse,
  badCertificate,
  unknown,
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
  });

  final NetworkFailureType type;
  final String? message;
  final int? statusCode;
  final dynamic responseData;
  final DioExceptionType? dioExceptionType;
  final Object? cause;
  final StackTrace? stackTrace;

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
        return NetworkException(
          type: NetworkFailureType.badResponse,
          message: e.message,
          statusCode: response?.statusCode,
          responseData: response?.data,
          dioExceptionType: type,
          cause: e,
          stackTrace: st,
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
