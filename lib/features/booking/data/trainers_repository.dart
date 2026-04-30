import 'package:dio/dio.dart';

import 'package:pilates_app/core/network/api_envelope.dart';
import 'package:pilates_app/core/network/api_result.dart';
import 'package:pilates_app/core/network/base_repository.dart';
import 'package:pilates_app/core/network/network_exception.dart';
import 'package:pilates_app/features/auth/data/models/pagination_meta.dart';
import 'package:pilates_app/features/booking/data/models/trainer_resource.dart';
import 'package:pilates_app/features/booking/data/models/trainers_page_result.dart';

/// Pilates API §12 — Trainers module (`GET /trainers`, `GET /trainers/{id}`).
class TrainersRepository extends BaseRepository {
  TrainersRepository(super.dio);

  /// Query: [branchId], [specialty] (exact match in API), [search], [page].
  Future<ApiResult<TrainersPageResult>> listTrainers({
    String? branchId,
    String? specialty,
    String? search,
    int page = 1,
  }) async {
    try {
      final query = <String, dynamic>{
        'page': page,
        if (branchId != null && branchId.trim().isNotEmpty) 'branch_id': branchId.trim(),
        if (specialty != null && specialty.trim().isNotEmpty) 'specialty': specialty.trim(),
        if (search != null && search.trim().isNotEmpty) 'search': search.trim(),
      };

      final response = await httpClient.get<dynamic>('trainers', queryParameters: query);
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
        final items = _parseTrainerList(envelope.data);
        return ApiSuccess(
          TrainersPageResult(items: items, pagination: pagination),
          statusCode: code,
        );
      }

      final items = _parseTrainerList(raw is Map ? raw['data'] : raw);
      return ApiSuccess(
        TrainersPageResult(items: items, pagination: pagination),
        statusCode: code,
      );
    } on DioException catch (e, st) {
      return ApiFailure(NetworkException.fromDioException(e, st));
    } catch (e, st) {
      return ApiFailure(NetworkException.fromUnknown(e, st));
    }
  }

  Future<ApiResult<TrainerResource>> getTrainer(String id) {
    final trimmed = id.trim();
    return get<TrainerResource>(
      'trainers/$trimmed',
      fromJson: (json) => TrainerResource.fromJson(json as Map<String, dynamic>),
    );
  }

  static List<TrainerResource> _parseTrainerList(dynamic payload) {
    if (payload is! List<dynamic>) return [];
    final out = <TrainerResource>[];
    for (final e in payload) {
      if (e is Map<String, dynamic>) {
        out.add(TrainerResource.fromJson(e));
      } else if (e is Map) {
        out.add(TrainerResource.fromJson(Map<String, dynamic>.from(e)));
      }
    }
    return out;
  }
}
