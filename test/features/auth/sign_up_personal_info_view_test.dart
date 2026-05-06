import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pilates_app/core/localization/arb/app_localizations.dart';
import 'package:pilates_app/core/network/api_result.dart';
import 'package:pilates_app/core/network/auth_locale_bridge.dart';
import 'package:pilates_app/core/storage/token_storage.dart';
import 'package:pilates_app/features/auth/cubit/auth_cubit.dart';
import 'package:pilates_app/features/auth/cubit/auth_flow.dart';
import 'package:pilates_app/features/auth/cubit/auth_state.dart';
import 'package:pilates_app/features/auth/sign_up/step_personal_info_view.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'fake_auth_repository.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Continue calls register and advances to OTP step', (
    tester,
  ) async {
    SharedPreferences.setMockInitialValues({});
    final fake = FakeAuthRepository();
    fake.registerResult = const ApiSuccess<bool>(true);

    final cubit = AuthCubit.forTesting(
      authRepository: fake,
      tokenStorage: TokenStorage(await SharedPreferences.getInstance()),
      localeBridge: AuthLocaleBridge(),
      seed: AuthState.initial().copyWith(flow: AuthFlow.signUp, signUpStep: 0),
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
          child: const SignUpPersonalInfoView(),
        ),
      ),
    );

    await tester.enterText(
      find.byKey(const ValueKey('signup_firstName')),
      'Noor',
    );
    await tester.enterText(
      find.byKey(const ValueKey('signup_lastName')),
      'Ali',
    );
    await tester.enterText(
      find.byKey(const ValueKey('signup_email')),
      'noor@example.com',
    );
    await tester.enterText(
      find.byKey(const ValueKey('signup_password')),
      'Secret@123',
    );
    await tester.enterText(
      find.descendant(
        of: find.byKey(const ValueKey('signup_phone')),
        matching: find.byType(TextField),
      ),
      '500000001',
    );

    await tester.tap(find.byKey(const ValueKey('signup_continue')));
    await tester.pumpAndSettle();

    expect(cubit.state.signUpStep, 1);
    expect(cubit.state.signUpPendingPhone, '+966500000001');
    expect(fake.registerCalls, 1);
    expect(fake.lastRegisterEmail, 'noor@example.com');
    expect(fake.lastRegisterPhone, '+966500000001');

    await cubit.close();
  });
}
