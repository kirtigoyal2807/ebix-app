import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:pilates_app/core/storage/token_storage.dart';
import 'package:pilates_app/features/auth/cubit/auth_flow.dart';
import 'package:pilates_app/features/auth/cubit/auth_state.dart';

void main() {
  test(
    'initialAuthStateFromTokenStorage is authenticated when JWT exists',
    () async {
      SharedPreferences.setMockInitialValues({
        'auth_access_token': 'saved-jwt',
      });
      final prefs = await SharedPreferences.getInstance();
      final tokenStorage = TokenStorage(prefs);

      expect(
        initialAuthStateFromTokenStorage(tokenStorage).flow,
        AuthFlow.authenticated,
      );
    },
  );

  test('initialAuthStateFromTokenStorage is splash when no JWT', () async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    final tokenStorage = TokenStorage(prefs);

    expect(
      initialAuthStateFromTokenStorage(tokenStorage).flow,
      AuthFlow.splash,
    );
  });
}
