import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pilates_app/core/network/network_exception.dart';

void main() {
  final ro = RequestOptions(path: '/');

  group('NetworkException.fromDioException', () {
    test('maps timeouts to NetworkFailureType.timeout', () {
      for (final t in [
        DioExceptionType.connectionTimeout,
        DioExceptionType.sendTimeout,
        DioExceptionType.receiveTimeout,
      ]) {
        final e = DioException(requestOptions: ro, type: t);
        final n = NetworkException.fromDioException(e);
        expect(n.type, NetworkFailureType.timeout, reason: '$t');
      }
    });

    test('maps badCertificate', () {
      final n = NetworkException.fromDioException(
        DioException(requestOptions: ro, type: DioExceptionType.badCertificate),
      );
      expect(n.type, NetworkFailureType.badCertificate);
    });

    test('maps cancel', () {
      final n = NetworkException.fromDioException(
        DioException(requestOptions: ro, type: DioExceptionType.cancel),
      );
      expect(n.type, NetworkFailureType.cancelled);
    });

    test('maps connectionError', () {
      final n = NetworkException.fromDioException(
        DioException(
          requestOptions: ro,
          type: DioExceptionType.connectionError,
        ),
      );
      expect(n.type, NetworkFailureType.connection);
    });

    test('maps badResponse with status and body', () {
      final n = NetworkException.fromDioException(
        DioException(
          requestOptions: ro,
          type: DioExceptionType.badResponse,
          response: Response(
            requestOptions: ro,
            statusCode: 503,
            data: const {'retry': false},
          ),
        ),
      );
      expect(n.type, NetworkFailureType.badResponse);
      expect(n.statusCode, 503);
      expect(n.responseData, const {'retry': false});
    });
  });

  group('NetworkException.fromUnknown', () {
    test('delegates nested DioException', () {
      final inner = DioException(
        requestOptions: ro,
        type: DioExceptionType.cancel,
      );
      final n = NetworkException.fromUnknown(inner);
      expect(n.type, NetworkFailureType.cancelled);
    });

    test('maps standalone SocketException', () {
      final n = NetworkException.fromUnknown(SocketException('reset'));
      expect(n.type, NetworkFailureType.connection);
    });

    test('maps arbitrary error to unknown', () {
      final n = NetworkException.fromUnknown('plain');
      expect(n.type, NetworkFailureType.unknown);
    });
  });
}
