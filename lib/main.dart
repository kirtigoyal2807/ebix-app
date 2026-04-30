import 'package:flutter/foundation.dart';
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
import 'features/checkout/data/checkout_repository.dart';
import 'features/booking/data/classes_repository.dart';
import 'features/booking/data/reviews_repository.dart';
import 'features/booking/data/trainers_repository.dart';
import 'features/invoice_history/data/invoices_repository.dart';
import 'features/invoice_history/data/subscriptions_repository.dart';
import 'features/loyalty/data/loyalty_repository.dart';
import 'features/my_booking/data/my_bookings_repository.dart';
import 'features/progress_tracking_flow/data/progress_repository.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  final tokenStorage = TokenStorage(prefs);
  final authInitialState = initialAuthStateFromTokenStorage(tokenStorage);
  if (kDebugMode) {
    final t = tokenStorage.readToken();
    if (t != null && t.trim().isNotEmpty) {
      debugPrint('[Auth] access token (restored session): $t');
    }
  }
  final localeBridge = AuthLocaleBridge();
  final dio = DioClient(
    baseUrl: ApiConfig.baseUrl,
    resolveLanguage: () => localeBridge.languageCode,
    accessToken: () => tokenStorage.readToken(),
  ).dio;
  final authRepository = AuthRepository(dio);

  runApp(
    RepositoryProvider<MyBookingsRepository>(
      create: (_) => MyBookingsRepository(dio),
      child: RepositoryProvider<TrainersRepository>(
        create: (_) => TrainersRepository(dio),
        child: RepositoryProvider<ReviewsRepository>(
          create: (_) => ReviewsRepository(dio),
          child: RepositoryProvider<LoyaltyRepository>(
            create: (_) => LoyaltyRepository(dio),
            child: RepositoryProvider<InvoicesRepository>(
              create: (_) => InvoicesRepository(dio),
              child: RepositoryProvider<ClassesRepository>(
                create: (_) => ClassesRepository(dio),
                child: RepositoryProvider<ProgressRepository>(
                  create: (_) => ProgressRepository(dio),
                  child: RepositoryProvider<SubscriptionsRepository>(
                    create: (_) => SubscriptionsRepository(dio),
                    child: RepositoryProvider<CheckoutRepository>(
                      create: (_) => CheckoutRepository(dio),
                      child: PilatesApp(
                        authRepository: authRepository,
                        tokenStorage: tokenStorage,
                        localeBridge: localeBridge,
                        authInitialState: authInitialState,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    ),
  );
}

class PilatesApp extends StatelessWidget {
  const PilatesApp({
    super.key,
    required this.authRepository,
    required this.tokenStorage,
    required this.localeBridge,
    required this.authInitialState,
  });

  final AuthRepository authRepository;
  final TokenStorage tokenStorage;
  final AuthLocaleBridge localeBridge;
  final AuthState authInitialState;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AuthCubit(
        authRepository: authRepository,
        tokenStorage: tokenStorage,
        localeBridge: localeBridge,
        seed: authInitialState,
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
