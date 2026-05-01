import 'package:dio/dio.dart';

import 'package:pilates_app/core/network/api_envelope.dart';
import 'package:pilates_app/core/network/api_result.dart';
import 'package:pilates_app/core/network/base_repository.dart';
import 'package:pilates_app/core/network/network_exception.dart';
import 'package:pilates_app/features/auth/data/models/pagination_meta.dart';
import 'package:pilates_app/features/my_booking/data/models/booking_resource.dart';
import 'package:pilates_app/features/my_booking/data/models/my_bookings_page_result.dart';

/// Pilates API §13.12 — `GET /my-bookings`, §13.11 — check-in, §13.10 — cancel.
class MyBookingsRepository extends BaseRepository {
  MyBookingsRepository(super.dio);

  /// §13.10 — empty body; success returns [BookingResource] with `cancelled` status.
  Future<ApiResult<BookingResource>> cancelEnrollment(String enrollmentId) {
    final id = enrollmentId.trim();
    return delete<BookingResource>(
      'enrollments/$id',
      fromJson: (json) =>
          BookingResource.fromJson(json as Map<String, dynamic>),
    );
  }

  /// §13.11 — empty body; idempotent on the server.
  Future<ApiResult<BookingResource>> checkIn(String enrollmentId) {
    final id = enrollmentId.trim();
    return post<BookingResource>(
      'enrollments/$id/check-in',
      data: <String, dynamic>{},
      fromJson: (json) =>
          BookingResource.fromJson(json as Map<String, dynamic>),
    );
  }

  /// [statusGroup] — `upcoming` | `current` | `past` | `cancelled`.
  Future<ApiResult<MyBookingsPageResult>> listMyBookings({
    required String statusGroup,
    int page = 1,
    int perPage = 20,
  }) async {
    try {
      final response = await httpClient.get<dynamic>(
        'my-bookings',
        queryParameters: {
          'status_group': statusGroup,
          'page': page,
          'per_page': perPage.clamp(1, 100),
        },
      );
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
      PaginationMeta? pagination;
      if (raw is Map<String, dynamic>) {
        final meta = raw['meta'];
        if (meta is Map<String, dynamic>) {
          final p = meta['pagination'];
          if (p is Map<String, dynamic>) {
            pagination = PaginationMeta.fromJson(p);
          } else if (p is Map) {
            pagination = PaginationMeta.fromJson(Map<String, dynamic>.from(p));
          }
        }
      }

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
        final items = _parseBookingsList(envelope.data);
        return ApiSuccess(
          MyBookingsPageResult(items: items, pagination: pagination),
          statusCode: code,
        );
      }

      final items = _parseBookingsList(raw is Map ? raw['data'] : raw);
      return ApiSuccess(
        MyBookingsPageResult(items: items, pagination: pagination),
        statusCode: code,
      );
    } on DioException catch (e, st) {
      return ApiFailure(NetworkException.fromDioException(e, st));
    } catch (e, st) {
      return ApiFailure(NetworkException.fromUnknown(e, st));
    }
  }

  static List<BookingResource> _parseBookingsList(dynamic payload) {
    if (payload is List<dynamic>) {
      return _mapBookingRows(payload);
    }
    if (payload is Map) {
      final m = Map<String, dynamic>.from(payload);
      for (final key in <String>[
        'data',
        'bookings',
        'items',
        'enrollments',
        'reservations',
        'classes',
        'myBookings',
        'my_bookings',
      ]) {
        final v = m[key];
        if (v is List) {
          return _mapBookingRows(v);
        }
        if (v is Map) {
          final inner = _parseBookingsList(v);
          if (inner.isNotEmpty) return inner;
        }
      }
    }
    return [];
  }

  static List<BookingResource> _mapBookingRows(List<dynamic> list) {
    final out = <BookingResource>[];
    for (final e in list) {
      if (e is Map<String, dynamic>) {
        out.add(BookingResource.fromJson(e));
      } else if (e is Map) {
        out.add(BookingResource.fromJson(Map<String, dynamic>.from(e)));
      }
    }
    return out;
  }
}
