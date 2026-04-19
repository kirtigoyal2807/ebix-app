import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pilates_app/core/localization/arb/app_localizations.dart';
import 'package:pilates_app/core/network/auth_locale_bridge.dart';
import 'package:pilates_app/core/storage/token_storage.dart';
import 'package:pilates_app/features/auth/cubit/auth_cubit.dart';
import 'package:pilates_app/features/auth/cubit/auth_flow.dart';
import 'package:pilates_app/features/auth/cubit/auth_state.dart';
import 'package:pilates_app/features/auth/sign_up/step_experience_view.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'fake_auth_repository.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('SignUpExperienceView Continue stores API experience and advances',
      (tester) async {
    SharedPreferences.setMockInitialValues({});

    final cubit = AuthCubit.forTesting(
      authRepository: FakeAuthRepository(),
      tokenStorage: TokenStorage(await SharedPreferences.getInstance()),
      localeBridge: AuthLocaleBridge(),
      seed: AuthState.initial().copyWith(
        flow: AuthFlow.signUp,
        signUpStep: 2,
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
          child: const SignUpExperienceView(),
        ),
      ),
    );

    await tester.pumpAndSettle();

    await tester.tap(find.text('Intermediate'));
    await tester.pump();
    await tester.tap(find.byKey(const ValueKey('sign_up_experience_continue')));
    await tester.pumpAndSettle();

    expect(cubit.state.signUpStep, 3);
    expect(cubit.state.signUpExperience, 'intermediate');

    await cubit.close();
  });
}
