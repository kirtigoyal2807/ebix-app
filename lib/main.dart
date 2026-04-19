import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'config/theme/app_theme.dart';
import 'core/constants/api_config.dart';
import 'core/localization/arb/app_localizations.dart';
import 'core/network/auth_locale_bridge.dart';
import 'core/network/dio_client.dart';
import 'core/storage/token_storage.dart';
import 'features/auth/auth_root_view.dart';
import 'features/auth/cubit/auth_cubit.dart';
import 'features/auth/cubit/auth_state.dart';
import 'features/auth/data/auth_repository.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  final tokenStorage = TokenStorage(prefs);
  final localeBridge = AuthLocaleBridge();
  final dio = DioClient(
    baseUrl: ApiConfig.baseUrl,
    resolveLanguage: () => localeBridge.languageCode,
    accessToken: () => tokenStorage.readToken(),
  ).dio;
  final authRepository = AuthRepository(dio);

  runApp(
    PilatesApp(
      authRepository: authRepository,
      tokenStorage: tokenStorage,
      localeBridge: localeBridge,
    ),
  );
}

class PilatesApp extends StatelessWidget {
  const PilatesApp({
    super.key,
    required this.authRepository,
    required this.tokenStorage,
    required this.localeBridge,
  });

  final AuthRepository authRepository;
  final TokenStorage tokenStorage;
  final AuthLocaleBridge localeBridge;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AuthCubit(
        authRepository: authRepository,
        tokenStorage: tokenStorage,
        localeBridge: localeBridge,
      ),
      child: BlocBuilder<AuthCubit, AuthState>(
        builder: (context, state) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            locale: state.locale,
            supportedLocales: const [Locale('en'), Locale('ar')],
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            theme: AppTheme.light(),
            darkTheme: AppTheme.dark(),
            themeMode: state.themeMode,
            home: const AuthRootView(),
          );
        },
      ),
    );
  }
}
