import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pilates_app/core/connectivity/connectivity_service.dart';

void main() {
  group('ConnectivityService._isConnected', () {
    test('returns false for none only', () {
      expect(
        ConnectivityService.hasConnectionForResults([
          ConnectivityResult.none,
        ]),
        isFalse,
      );
    });

    test('returns false for empty results', () {
      expect(ConnectivityService.hasConnectionForResults([]), isFalse);
    });

    test('returns true for wifi', () {
      expect(
        ConnectivityService.hasConnectionForResults([
          ConnectivityResult.wifi,
        ]),
        isTrue,
      );
    });

    test('returns true for mobile', () {
      expect(
        ConnectivityService.hasConnectionForResults([
          ConnectivityResult.mobile,
        ]),
        isTrue,
      );
    });

    test('returns true when wifi and none are both reported', () {
      expect(
        ConnectivityService.hasConnectionForResults([
          ConnectivityResult.wifi,
          ConnectivityResult.none,
        ]),
        isTrue,
      );
    });
  });
}
