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
import 'package:pilates_app/features/auth/sign_in/sign_in_phone_otp_view.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'fake_auth_repository.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets(
    'Sign-in phone OTP screen verifies code and authenticates',
    (tester) async {
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();
      final storage = TokenStorage(prefs);
      final fake = FakeAuthRepository();
      fake.verifyPhoneOtpResult = ApiSuccess<LoginEmailResult>(
        LoginEmailResult(
          user: AuthUser(email: 'phone@login.com', phone: '+1500123456'),
          token: 'jwt-phone-login',
        ),
      );

      final cubit = AuthCubit.forTesting(
        authRepository: fake,
        tokenStorage: storage,
        localeBridge: AuthLocaleBridge(),
        seed: AuthState.initial().copyWith(
          flow: AuthFlow.signIn,
          signInPendingPhone: '+1500123456',
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
          home: BlocProvider<AuthCubit>.value(value: cubit, child: const SignInPhoneOtpView()),
        ),
      );
      await tester.pump();

      final fields = find.byType(TextField);
      expect(fields, findsNWidgets(6));
      const code = '654321';
      for (var i = 0; i < 6; i++) {
        await tester.enterText(fields.at(i), code.substring(i, i + 1));
        await tester.pump();
      }

      await tester.tap(find.byKey(const ValueKey('sign_in_phone_otp_verify')));
      await tester.pumpAndSettle();

      expect(fake.verifyPhoneOtpCalls, 1);
      expect(fake.lastVerifyPhoneOtpPhone, '+1500123456');
      expect(fake.lastVerifyPhoneOtpCode, code);
      expect(storage.readToken(), 'jwt-phone-login');
      expect(cubit.state.flow, AuthFlow.authenticated);

      await cubit.close();
    },
  );
}
