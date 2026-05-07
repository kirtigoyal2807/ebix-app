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
import 'package:pilates_app/features/auth/sign_up/step_goal_view.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'fake_auth_repository.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets(
    'SignUpGoalView Continue calls submitUserGoal and advances sign-up step',
    (tester) async {
      SharedPreferences.setMockInitialValues({});
      final fake = FakeAuthRepository();
      fake.submitUserGoalResult = const ApiSuccess<bool>(true);

      final cubit = AuthCubit.forTesting(
        authRepository: fake,
        tokenStorage: TokenStorage(await SharedPreferences.getInstance()),
        localeBridge: AuthLocaleBridge(),
        seed: AuthState.initial().copyWith(
          flow: AuthFlow.signUp,
          signUpStep: 3,
          signUpExperience: 'beginner',
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
            child: const SignUpGoalView(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      await tester.tap(find.text('Build Strength'));
      await tester.pump();
      await tester.tap(find.byKey(const ValueKey('sign_up_goal_submit')));
      await tester.pumpAndSettle();

      expect(cubit.state.signUpStep, 4);
      expect(fake.submitUserGoalCalls, 1);
      expect(fake.lastSubmitExperience, 'beginner');

      await cubit.close();
    },
  );
}
