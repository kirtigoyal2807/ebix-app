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
import 'package:pilates_app/features/auth/forgot_password/forgot_otp_view.dart';
import 'package:pilates_app/features/auth/forgot_password/forgot_password_view.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'fake_auth_repository.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Resend on OTP does not stack a second ForgotOtpView route', (
    tester,
  ) async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    final storage = TokenStorage(prefs);
    final fake = FakeAuthRepository();

    final cubit = AuthCubit.forTesting(
      authRepository: fake,
      tokenStorage: storage,
      localeBridge: AuthLocaleBridge(),
      seed: AuthState.initial().copyWith(flow: AuthFlow.signIn),
    );

    await tester.pumpWidget(
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
          home: const ForgotPasswordView(),
        ),
      ),
    );

    await tester.pumpAndSettle();

    await tester.enterText(
      find.byKey(const ValueKey('forgot_email')),
      'noor@example.com',
    );
    await tester.tap(find.byKey(const ValueKey('forgot_send_code')));
    await tester.pumpAndSettle();

    expect(find.byType(ForgotOtpView), findsOneWidget);

    await tester.tap(find.byKey(const ValueKey('forgot_resend_code')));
    await tester.pumpAndSettle();

    expect(find.byType(ForgotOtpView), findsOneWidget);

    await cubit.close();
  });
}
