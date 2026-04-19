import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:pilates_app/core/constants/api_config.dart';
import 'package:pilates_app/core/network/auth_locale_bridge.dart';
import 'package:pilates_app/core/network/dio_client.dart';
import 'package:pilates_app/core/storage/token_storage.dart';
import 'package:pilates_app/features/auth/data/auth_repository.dart';
import 'package:pilates_app/main.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Pilates app smoke test', (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    final tokenStorage = TokenStorage(prefs);
    final localeBridge = AuthLocaleBridge();
    final dio = DioClient(
      baseUrl: ApiConfig.baseUrl,
      resolveLanguage: () => localeBridge.languageCode,
      accessToken: () => tokenStorage.readToken(),
    ).dio;
    final authRepository = AuthRepository(dio);

    await tester.pumpWidget(
      PilatesApp(
        authRepository: authRepository,
        tokenStorage: tokenStorage,
        localeBridge: localeBridge,
      ),
    );

    await tester.pump(const Duration(seconds: 5));
    await tester.pumpAndSettle();

    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
