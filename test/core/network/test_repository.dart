import 'package:dio/dio.dart';
import 'package:pilates_app/core/network/base_repository.dart';

/// Test double for [BaseRepository] — use only in tests.
class TestRepository extends BaseRepository {
  TestRepository(super.dio);
}

Dio createTestDio({
  required void Function(RequestOptions options, RequestInterceptorHandler handler)
      onRequest,
}) {
  final dio = Dio(
    BaseOptions(
      baseUrl: 'https://test.local',
      validateStatus: (status) =>
          status != null && status >= 200 && status < 300,
    ),
  );
  dio.interceptors.add(
    InterceptorsWrapper(
      onRequest: onRequest,
    ),
  );
  return dio;
}
