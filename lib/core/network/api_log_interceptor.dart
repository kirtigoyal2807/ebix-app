import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

/// Logs HTTP requests and full response bodies in debug builds (console / Flutter run).
class ApiLogInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (kDebugMode) {
      final buf = StringBuffer()
        ..writeln('')
        ..writeln('──────── API REQUEST ────────')
        ..writeln('${options.method} ${options.uri}');
      if (options.queryParameters.isNotEmpty) {
        buf.writeln('query: ${_stringify(options.queryParameters)}');
      }
      if (options.data != null) {
        buf.writeln('body: ${_stringify(options.data)}');
      }
      _debugPrintLong(buf.toString());
    }
    handler.next(options);
  }

  @override
  void onResponse(
    Response<dynamic> response,
    ResponseInterceptorHandler handler,
  ) {
    if (kDebugMode) {
      final buf = StringBuffer()
        ..writeln('')
        ..writeln('──────── API RESPONSE ────────')
        ..writeln(
          '${response.requestOptions.method} ${response.requestOptions.uri}',
        )
        ..writeln('status: ${response.statusCode}')
        ..writeln('data: ${_stringify(response.data)}')
        ..writeln('──────────────────────────────');
      _debugPrintLong(buf.toString());
    }
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (kDebugMode) {
      final buf = StringBuffer()
        ..writeln('')
        ..writeln('──────── API ERROR ────────')
        ..writeln('${err.requestOptions.method} ${err.requestOptions.uri}')
        ..writeln('type: ${err.type}')
        ..writeln('message: ${err.message}');
      if (err.response != null) {
        buf
          ..writeln('status: ${err.response?.statusCode}')
          ..writeln('data: ${_stringify(err.response?.data)}');
      }
      buf.writeln('──────────────────────────');
      _debugPrintLong(buf.toString());
    }
    handler.next(err);
  }

  static String _stringify(dynamic value) {
    if (value == null) return 'null';
    try {
      if (value is Map || value is List) {
        return const JsonEncoder.withIndent('  ').convert(value);
      }
    } catch (_) {
      /* fall through */
    }
    return value.toString();
  }

  /// Avoid truncating large JSON in some consoles.
  static void _debugPrintLong(String message) {
    const chunk = 800;
    for (var i = 0; i < message.length; i += chunk) {
      final end = (i + chunk < message.length) ? i + chunk : message.length;
      debugPrint(message.substring(i, end));
    }
  }
}
