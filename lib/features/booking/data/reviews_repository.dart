import 'package:dio/dio.dart';

import 'package:pilates_app/core/network/api_envelope.dart';
import 'package:pilates_app/core/network/api_result.dart';
import 'package:pilates_app/core/network/base_repository.dart';
import 'package:pilates_app/core/network/network_exception.dart';
import 'package:pilates_app/features/auth/data/models/pagination_meta.dart';
import 'package:pilates_app/features/booking/data/models/review_resource.dart';
import 'package:pilates_app/features/booking/data/models/reviews_list_result.dart';

/// Pilates API §14.1 — `GET /reviews`.
class ReviewsRepository extends BaseRepository {
  ReviewsRepository(super.dio);

  /// [reviewableType]: `class` | `trainer` | `branch` (per API).
  /// [reviewableId] is sent as a string; numeric IDs are supported.
  Future<ApiResult<ReviewsListResult>> listReviews({
    required String reviewableType,
    required String reviewableId,
    int page = 1,
    int perPage = 30,
  }) async {
    try {
      final query = <String, dynamic>{
        'reviewableType': reviewableType.trim(),
        'reviewableId': reviewableId.trim(),
        'page': page,
        'per_page': perPage.clamp(1, 100),
      };

      final response = await httpClient.get<dynamic>('reviews', queryParameters: query);
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
        final items = _parseList(envelope.data);
        return ApiSuccess(
          ReviewsListResult(items: items, pagination: pagination),
          statusCode: code,
        );
      }

      final items = _parseList(raw is Map ? raw['data'] : raw);
      return ApiSuccess(
        ReviewsListResult(items: items, pagination: pagination),
        statusCode: code,
      );
    } on DioException catch (e, st) {
      return ApiFailure(NetworkException.fromDioException(e, st));
    } catch (e, st) {
      return ApiFailure(NetworkException.fromUnknown(e, st));
    }
  }

  static List<ReviewResource> _parseList(dynamic payload) {
    if (payload is List<dynamic>) {
      return _mapReviewRows(payload);
    }
    if (payload is Map) {
      final m = Map<String, dynamic>.from(payload);
      final inner =
          m['data'] ?? m['items'] ?? m['reviews'] ?? m['recentReviews'] ?? m['recent_reviews'];
      if (inner is List) return _parseList(inner);
    }
    return [];
  }

  static List<ReviewResource> _mapReviewRows(List<dynamic> list) {
    final out = <ReviewResource>[];
    for (final e in list) {
      if (e is Map<String, dynamic>) {
        out.add(ReviewResource.fromJson(e));
      } else if (e is Map) {
        out.add(ReviewResource.fromJson(Map<String, dynamic>.from(e)));
      }
    }
    return out;
  }

  /// Pilates API §14.2 — `POST /reviews` (class, trainer, or branch).
  Future<ApiResult<bool>> submitReview({
    required String reviewableType,
    required String reviewableId,
    required int rating,
    String? body,
    String? calendarEventId,
  }) {
    final trimmedId = reviewableId.trim();
    if (trimmedId.isEmpty) {
      return Future.value(
        ApiFailure(
          NetworkException(
            type: NetworkFailureType.validation,
            message: 'Missing reviewable id',
          ),
        ),
      );
    }
    final idParam = int.tryParse(trimmedId) ?? trimmedId;
    final data = <String, dynamic>{
      'reviewableType': reviewableType.trim(),
      'reviewableId': idParam,
      'rating': rating.clamp(1, 5),
    };
    final b = body?.trim();
    if (b != null && b.isNotEmpty) {
      data['body'] = b;
    }
    final eventId = calendarEventId?.trim();
    if (eventId != null && eventId.isNotEmpty) {
      data['calendarEventId'] = eventId;
    }
    return post<bool>(
      'reviews',
      data: data,
      fromJson: (_) => true,
    );
  }
}
