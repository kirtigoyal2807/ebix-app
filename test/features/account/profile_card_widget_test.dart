import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pilates_app/core/localization/arb/app_localizations.dart';
import 'package:pilates_app/core/network/auth_locale_bridge.dart';
import 'package:pilates_app/core/storage/token_storage.dart';
import 'package:pilates_app/features/account/widget/profile_card.dart';
import 'package:pilates_app/features/auth/cubit/auth_cubit.dart';
import 'package:pilates_app/features/auth/cubit/auth_flow.dart';
import 'package:pilates_app/features/auth/cubit/auth_state.dart';
import 'package:pilates_app/features/auth/data/models/auth_user.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../auth/fake_auth_repository.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('ProfileCard shows name, email, and plan badge from AuthState', (
    tester,
  ) async {
    SharedPreferences.setMockInitialValues({});
    final fake = FakeAuthRepository();
    final cubit = AuthCubit.forTesting(
      authRepository: fake,
      tokenStorage: TokenStorage(await SharedPreferences.getInstance()),
      localeBridge: AuthLocaleBridge(),
      seed: AuthState.initial().copyWith(
        flow: AuthFlow.authenticated,
        user: const AuthUser(
          name: 'Noor Ali',
          email: 'noor@example.com',
          membershipPlanName: 'Basic Plan',
        ),
      ),
    );

    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        supportedLocales: AppLocalizations.supportedLocales,
        locale: const Locale('en'),
        home: BlocProvider<AuthCubit>.value(
          value: cubit,
          child: const Scaffold(body: ProfileCard()),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Noor Ali'), findsOneWidget);
    expect(find.text('noor@example.com'), findsOneWidget);
    expect(find.text('BASIC'), findsOneWidget);

    await cubit.close();
  });
}
