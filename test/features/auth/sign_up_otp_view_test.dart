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
import 'package:pilates_app/features/auth/data/models/auth_user.dart';
import 'package:pilates_app/features/auth/data/models/login_email_result.dart';
import 'package:pilates_app/features/auth/sign_up/step_otp_view.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'fake_auth_repository.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('SignUpOtpView verify submits 6-digit code and advances', (
    tester,
  ) async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    final storage = TokenStorage(prefs);
    final fake = FakeAuthRepository();
    fake.verifyPhoneOtpResult = ApiSuccess<LoginEmailResult>(
      LoginEmailResult(
        user: AuthUser(email: 'u@example.com', phone: '+966500000001'),
        token: 'otp-test-token',
      ),
    );

    final cubit = AuthCubit.forTesting(
      authRepository: fake,
      tokenStorage: storage,
      localeBridge: AuthLocaleBridge(),
      seed: AuthState.initial().copyWith(
        flow: AuthFlow.signUp,
        signUpStep: 1,
        signUpPendingPhone: '+966500000001',
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
          child: const SignUpOtpView(),
        ),
      ),
    );

    await tester.pumpAndSettle();

    final fields = find.byType(TextField);
    expect(fields, findsNWidgets(6));
    const code = '987654';
    for (var i = 0; i < 6; i++) {
      await tester.enterText(fields.at(i), code.substring(i, i + 1));
      await tester.pump();
    }
    await tester.pumpAndSettle();

    expect(cubit.state.signUpStep, 2);
    expect(fake.verifyPhoneOtpCalls, 1);
    expect(fake.lastVerifyPhoneOtpCode, code);
    expect(storage.readToken(), 'otp-test-token');

    await cubit.close();
  });
}
