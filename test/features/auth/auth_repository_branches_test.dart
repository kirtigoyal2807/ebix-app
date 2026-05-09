import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pilates_app/features/auth/data/auth_repository.dart';
import 'package:pilates_app/features/auth/data/models/pagination_meta.dart';

import '../../core/network/test_repository.dart';

void main() {
  group('AuthRepository.listBranches', () {
    test(
      'GET /branches uses query params and parses data + meta.pagination',
      () async {
        RequestOptions? seen;
        final dio = createTestDio(
          onRequest: (options, handler) {
            seen = options;
            handler.resolve(
              Response(
                requestOptions: options,
                statusCode: 200,
                data: {
                  'success': true,
                  'message': 'ok',
                  'data': [
                    {
                      'id': 10,
                      'name': 'Downtown',
                      'city': 'Riyadh',
                      'distance': '3 km',
                      'type': 'Premium',
                      'rewardsCount': 9,
                    },
                  ],
                  'meta': {
                    'pagination': {
                      'current_page': 1,
                      'last_page': 3,
                      'per_page': 50,
                      'total': 120,
                    },
                  },
                },
              ),
            );
          },
        );
        final repo = AuthRepository(dio);

        final result = await repo.listBranches(
          queryParameters: const {'page': 1, 'per_page': 50},
        );

        expect(result.isSuccess, isTrue);
        expect(seen?.path, '/branches');
        expect(seen?.queryParameters['page'], 1);
        expect(seen?.queryParameters['per_page'], 50);

        final data = result.dataOrNull!;
        expect(data.branches, hasLength(1));
        expect(data.branches.first.id, 10);
        expect(data.branches.first.title, 'Downtown');
        expect(data.branches.first.rewardsCount, 9);
        expect(data.pagination, isA<PaginationMeta>());
        expect(data.pagination!.currentPage, 1);
        expect(data.pagination!.lastPage, 3);
        expect(data.pagination!.perPage, 50);
        expect(data.pagination!.total, 120);
      },
    );
  });

  group('AuthRepository.setHomeBranch', () {
    test('POST /auth/home-branch sends homeBranchId', () async {
      RequestOptions? seen;
      final dio = createTestDio(
        onRequest: (options, handler) {
          seen = options;
          handler.resolve(
            Response(
              requestOptions: options,
              statusCode: 200,
              data: const {'success': true, 'message': 'ok', 'data': null},
            ),
          );
        },
      );
      final repo = AuthRepository(dio);

      final result = await repo.setHomeBranch(homeBranchId: 42);

      expect(result.isSuccess, isTrue);
      expect(seen?.path, '/auth/home-branch');
      final body = seen?.data as Map<String, dynamic>;
      expect(body['homeBranchId'], 42);
    });
  });
}
