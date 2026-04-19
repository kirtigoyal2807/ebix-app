import 'package:flutter_test/flutter_test.dart';
import 'package:pilates_app/core/network/api_result.dart';
import 'package:pilates_app/core/network/network_exception.dart';

void main() {
  group('ApiResult', () {
    test('ApiSuccess: isSuccess, dataOrNull, when', () {
      const r = ApiSuccess<String>('ok', statusCode: 200);
      expect(r.isSuccess, isTrue);
      expect(r.isFailure, isFalse);
      expect(r.dataOrNull, 'ok');
      expect(r.exceptionOrNull, isNull);

      final out = r.when(
        success: (d, c) => '$d-$c',
        failure: (_) => 'fail',
      );
      expect(out, 'ok-200');
    });

    test('ApiFailure: isFailure, exceptionOrNull, when', () {
      const ex = NetworkException(type: NetworkFailureType.timeout);
      const r = ApiFailure<int>(ex);

      expect(r.isFailure, isTrue);
      expect(r.isSuccess, isFalse);
      expect(r.dataOrNull, isNull);
      expect(r.exceptionOrNull, ex);

      final out = r.when(
        success: (_, __) => 's',
        failure: (e) => e.type.name,
      );
      expect(out, 'timeout');
    });
  });
}
