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
import 'package:pilates_app/features/auth/cubit/auth_state.dart'
    show AuthState, LoginUiStatus;
import 'package:pilates_app/features/auth/data/models/auth_user.dart';
import 'package:pilates_app/features/auth/data/models/login_email_result.dart';
import 'package:pilates_app/features/auth/sign_in/sign_in_view.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'fake_auth_repository.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Email tab: successful login opens post-login setup', (tester) async {
    SharedPreferences.setMockInitialValues({});
    final fake = FakeAuthRepository();
    fake.loginResult = ApiSuccess<LoginEmailResult>(
      LoginEmailResult(
        user: const AuthUser(email: 'user@test.com'),
        token: 'jwt-from-test',
      ),
    );

    final cubit = AuthCubit.forTesting(
      authRepository: fake,
      tokenStorage: TokenStorage(await SharedPreferences.getInstance()),
      localeBridge: AuthLocaleBridge(),
      seed: AuthState.initial().copyWith(flow: AuthFlow.signIn),
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
          child: const SignInView(),
        ),
      ),
    );

    final textFields = find.byType(TextFormField);
    await tester.enterText(textFields.at(0), 'user@test.com');
    await tester.enterText(textFields.at(1), 'Secret@123');

    await tester.tap(find.byKey(const ValueKey('sign_in_submit')));
    await tester.pumpAndSettle();

    expect(cubit.state.flow, AuthFlow.postLoginSetup);
    expect(
      TokenStorage(await SharedPreferences.getInstance()).readToken(),
      'jwt-from-test',
    );

    await cubit.close();
  });

  testWidgets('Phone tab: OTP request shows success path', (tester) async {
    SharedPreferences.setMockInitialValues({});
    final fake = FakeAuthRepository();
    fake.phoneOtpResult = const ApiSuccess<bool>(true);

    final cubit = AuthCubit.forTesting(
      authRepository: fake,
      tokenStorage: TokenStorage(await SharedPreferences.getInstance()),
      localeBridge: AuthLocaleBridge(),
      seed: AuthState.initial().copyWith(flow: AuthFlow.signIn),
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
          child: const SignInView(),
        ),
      ),
    );

    await tester.tap(find.byKey(const ValueKey('sign_in_tab_phone')));
    await tester.pumpAndSettle();

    await tester.enterText(
      find.descendant(
        of: find.byType(SignInView),
        matching: find.byType(TextField),
      ),
      '500123456',
    );

    await tester.tap(find.byKey(const ValueKey('sign_in_submit')));
    await tester.pumpAndSettle();

    expect(fake.phoneOtpCalls, 1);
    expect(cubit.state.loginUiStatus, LoginUiStatus.idle);

    await cubit.close();
  });
}
