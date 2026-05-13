import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pilates_app/core/localization/arb/app_localizations.dart';
import 'package:pilates_app/core/network/auth_locale_bridge.dart';
import 'package:pilates_app/core/storage/token_storage.dart';
import 'package:pilates_app/features/auth/cubit/auth_cubit.dart';
import 'package:pilates_app/features/auth/cubit/auth_flow.dart';
import 'package:pilates_app/features/auth/cubit/auth_state.dart';
import 'package:pilates_app/features/auth/forgot_password/create_new_password_view.dart';
import 'package:pilates_app/features/auth/forgot_password/forgot_otp_view.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'fake_auth_repository.dart';

/// [ForgotOtpView] starts a 30s resend cooldown in [initState]; advance fake time before tapping resend.
Future<void> pumpPastResendCooldown(WidgetTester tester) async {
  for (var i = 0; i < 32; i++) {
    await tester.pump(const Duration(seconds: 1));
  }
  await tester.pumpAndSettle();
}

Widget wrapForgotOtpTest(Widget child) {
  return ScreenUtilInit(
    designSize: const Size(375, 812),
    minTextAdapt: true,
    splitScreenMode: true,
    builder: (_, __) => child,
  );
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  Future<void> bindTallSurface(WidgetTester tester) async {
    tester.view.physicalSize = const Size(480, 1600);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });
  }

  Future<void> enterOtp(WidgetTester tester, String code) async {
    final field = find.byType(TextField);
    expect(field, findsOneWidget);
    await tester.tap(field);
    await tester.pump();
    await tester.enterText(field, code);
    await tester.pump();
  }

  testWidgets('ForgotOtpView resend calls sendEmailVerification', (
    tester,
  ) async {
    await bindTallSurface(tester);
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    final storage = TokenStorage(prefs);
    final fake = FakeAuthRepository();

    final cubit = AuthCubit.forTesting(
      authRepository: fake,
      tokenStorage: storage,
      localeBridge: AuthLocaleBridge(),
      seed: AuthState.initial().copyWith(
        flow: AuthFlow.signIn,
        forgotPasswordEmail: 'noor@example.com',
      ),
    );

    await tester.pumpWidget(
      wrapForgotOtpTest(
        BlocProvider<AuthCubit>.value(
          value: cubit,
          child: MaterialApp(
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
            ],
            supportedLocales: AppLocalizations.supportedLocales,
            locale: const Locale('en'),
            home: const ForgotOtpView(email: 'noor@example.com'),
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();
    await pumpPastResendCooldown(tester);

    final resendFinder = find.byKey(const ValueKey('forgot_resend_code'));
    await tester.ensureVisible(resendFinder);
    await tester.pumpAndSettle();
    await tester.tap(resendFinder);
    await tester.pumpAndSettle();

    expect(fake.sendEmailVerificationCalls, 1);
    expect(fake.passwordForgotCalls, 0);
    expect(fake.lastSendEmailVerificationEmail, 'noor@example.com');

    await cubit.close();
  });

  testWidgets('ForgotOtpView verify accepts debug-style code 000000', (
    tester,
  ) async {
    await bindTallSurface(tester);
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    final storage = TokenStorage(prefs);
    final fake = FakeAuthRepository();

    final cubit = AuthCubit.forTesting(
      authRepository: fake,
      tokenStorage: storage,
      localeBridge: AuthLocaleBridge(),
      seed: AuthState.initial().copyWith(
        flow: AuthFlow.signIn,
        forgotPasswordEmail: 'noor@example.com',
      ),
    );

    await tester.pumpWidget(
      wrapForgotOtpTest(
        BlocProvider<AuthCubit>.value(
          value: cubit,
          child: MaterialApp(
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
            ],
            supportedLocales: AppLocalizations.supportedLocales,
            locale: const Locale('en'),
            home: const ForgotOtpView(email: 'noor@example.com'),
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();

    const code = '000000';
    await enterOtp(tester, code);
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const ValueKey('forgot_verify_code')));
    await tester.pumpAndSettle();

    expect(fake.verifyEmailCodeCalls, 1);
    expect(fake.lastVerifyCode, code);
    expect(cubit.state.forgotEmailCodeVerified, isTrue);

    await cubit.close();
  });

  testWidgets(
    'ForgotOtpView resend after verify+pop stays on OTP (no extra create-password route)',
    (tester) async {
      await bindTallSurface(tester);
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();
      final storage = TokenStorage(prefs);
      final fake = FakeAuthRepository();

      final cubit = AuthCubit.forTesting(
        authRepository: fake,
        tokenStorage: storage,
        localeBridge: AuthLocaleBridge(),
        seed: AuthState.initial().copyWith(
          flow: AuthFlow.signIn,
          forgotPasswordEmail: 'noor@example.com',
        ),
      );

      await tester.pumpWidget(
        wrapForgotOtpTest(
          BlocProvider<AuthCubit>.value(
            value: cubit,
            child: MaterialApp(
              localizationsDelegates: const [
                AppLocalizations.delegate,
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
              ],
              supportedLocales: AppLocalizations.supportedLocales,
              locale: const Locale('en'),
              home: const ForgotOtpView(email: 'noor@example.com'),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      const code = '000000';
      await enterOtp(tester, code);
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(const ValueKey('forgot_verify_code')));
      await tester.pumpAndSettle();

      expect(find.byType(CreateNewPasswordView), findsOneWidget);

      final navigator = tester.state<NavigatorState>(find.byType(Navigator));
      navigator.pop();
      await tester.pumpAndSettle();

      expect(find.byType(ForgotOtpView), findsOneWidget);

      await pumpPastResendCooldown(tester);
      final resendFinder = find.byKey(const ValueKey('forgot_resend_code'));
      await tester.ensureVisible(resendFinder);
      await tester.pumpAndSettle();
      await tester.tap(resendFinder);
      await tester.pumpAndSettle();

      expect(find.byType(CreateNewPasswordView), findsNothing);
      expect(find.byType(ForgotOtpView), findsOneWidget);
      expect(fake.sendEmailVerificationCalls, 1);

      await cubit.close();
    },
  );
}
