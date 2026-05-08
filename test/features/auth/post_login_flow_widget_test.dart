import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pilates_app/core/localization/arb/app_localizations.dart';
import 'package:pilates_app/core/network/api_result.dart';
import 'package:pilates_app/core/network/auth_locale_bridge.dart';
import 'package:pilates_app/core/network/network_exception.dart';
import 'package:pilates_app/core/storage/token_storage.dart';
import 'package:pilates_app/features/auth/cubit/auth_cubit.dart';
import 'package:pilates_app/features/auth/post_login/post_login_experience_view.dart';
import 'package:pilates_app/features/auth/post_login/post_login_goal_view.dart';
import 'package:pilates_app/features/auth/cubit/auth_flow.dart';
import 'package:pilates_app/features/auth/cubit/auth_state.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'fake_auth_repository.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  /// Avoids loading real [HomeView] (network images / complex layout in widget tests).
  Widget buildPostLoginShell(AuthCubit cubit) {
    return MaterialApp(
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      locale: const Locale('en'),
      home: BlocProvider<AuthCubit>.value(
        value: cubit,
        child: BlocBuilder<AuthCubit, AuthState>(
          builder: (context, state) {
            if (state.flow == AuthFlow.postLoginSetup) {
              return state.postLoginStep == 0
                  ? const PostLoginExperienceView()
                  : const PostLoginGoalView();
            }
            if (state.flow == AuthFlow.authenticated) {
              return const Scaffold(
                body: Center(child: Text('TEST_AUTHENTICATED')),
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  Widget buildGoalOnlyTestApp(AuthCubit cubit) {
    return MaterialApp(
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      locale: const Locale('en'),
      home: BlocProvider<AuthCubit>.value(
        value: cubit,
        child: const PostLoginGoalView(),
      ),
    );
  }

  group('Post-login flow (Experience → Goals → POST /auth/goal)', () {
    testWidgets(
      'default selections: submits beginner, Build Strength, monthly 12 and authenticates',
      (tester) async {
        SharedPreferences.setMockInitialValues({});
        final fake = FakeAuthRepository();
        fake.submitUserGoalResult = const ApiSuccess<bool>(true);

        final cubit = AuthCubit.forTesting(
          authRepository: fake,
          tokenStorage: TokenStorage(await SharedPreferences.getInstance()),
          localeBridge: AuthLocaleBridge(),
          seed: AuthState.initial().copyWith(
            flow: AuthFlow.postLoginSetup,
            postLoginStep: 0,
          ),
        );

        await tester.pumpWidget(buildPostLoginShell(cubit));
        await tester.pumpAndSettle();

        expect(
          find.byKey(const ValueKey('post_login_experience_continue')),
          findsOneWidget,
        );

        await tester.tap(
          find.byKey(const ValueKey('post_login_experience_continue')),
        );
        await tester.pumpAndSettle();

        expect(cubit.state.postLoginStep, 1);
        expect(cubit.state.postLoginExperience, 'beginner');

        await tester.tap(find.byKey(const ValueKey('post_login_goal_submit')));
        await tester.pumpAndSettle();

        expect(cubit.state.flow, AuthFlow.authenticated);
        expect(find.text('TEST_AUTHENTICATED'), findsOneWidget);
        expect(fake.submitUserGoalCalls, 1);
        expect(fake.lastSubmitExperience, 'beginner');
        expect(fake.lastSubmitGoal, 'Build Strength');
        expect(fake.lastSubmitMonthlyGoal, 12);

        await cubit.close();
      },
    );

    testWidgets('selecting Intermediate sends experience intermediate to API', (
      tester,
    ) async {
      SharedPreferences.setMockInitialValues({});
      final fake = FakeAuthRepository();
      fake.submitUserGoalResult = const ApiSuccess<bool>(true);

      final cubit = AuthCubit.forTesting(
        authRepository: fake,
        tokenStorage: TokenStorage(await SharedPreferences.getInstance()),
        localeBridge: AuthLocaleBridge(),
        seed: AuthState.initial().copyWith(
          flow: AuthFlow.postLoginSetup,
          postLoginStep: 0,
        ),
      );

      await tester.pumpWidget(buildPostLoginShell(cubit));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Intermediate'));
      await tester.pumpAndSettle();

      await tester.tap(
        find.byKey(const ValueKey('post_login_experience_continue')),
      );
      await tester.pumpAndSettle();

      expect(cubit.state.postLoginExperience, 'intermediate');

      await tester.tap(find.byKey(const ValueKey('post_login_goal_submit')));
      await tester.pumpAndSettle();

      expect(fake.lastSubmitExperience, 'intermediate');

      await cubit.close();
    });

    testWidgets('API failure shows snackbar with error message', (
      tester,
    ) async {
      SharedPreferences.setMockInitialValues({});
      final fake = FakeAuthRepository();
      fake.submitUserGoalResult = ApiFailure<bool>(
        NetworkException(
          type: NetworkFailureType.validation,
          message: 'Goal rejected',
        ),
      );

      final cubit = AuthCubit.forTesting(
        authRepository: fake,
        tokenStorage: TokenStorage(await SharedPreferences.getInstance()),
        localeBridge: AuthLocaleBridge(),
        seed: AuthState.initial().copyWith(
          flow: AuthFlow.postLoginSetup,
          postLoginStep: 1,
          postLoginExperience: 'beginner',
        ),
      );

      await tester.pumpWidget(buildGoalOnlyTestApp(cubit));
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(const ValueKey('post_login_goal_submit')));
      await tester.pumpAndSettle();

      expect(cubit.state.flow, AuthFlow.postLoginSetup);
      expect(find.text('Goal rejected'), findsOneWidget);
      expect(fake.submitUserGoalCalls, 1);

      await cubit.close();
    });

    testWidgets('field errors from API show under goal / monthly sections', (
      tester,
    ) async {
      SharedPreferences.setMockInitialValues({});
      final fake = FakeAuthRepository();
      fake.submitUserGoalResult = ApiFailure<bool>(
        NetworkException(
          type: NetworkFailureType.validation,
          message: '',
          fieldErrors: {
            'goal': ['Pick a valid goal'],
            'monthlyGoal': ['Invalid'],
          },
        ),
      );

      final cubit = AuthCubit.forTesting(
        authRepository: fake,
        tokenStorage: TokenStorage(await SharedPreferences.getInstance()),
        localeBridge: AuthLocaleBridge(),
        seed: AuthState.initial().copyWith(
          flow: AuthFlow.postLoginSetup,
          postLoginStep: 1,
          postLoginExperience: 'advanced',
        ),
      );

      await tester.pumpWidget(buildGoalOnlyTestApp(cubit));
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(const ValueKey('post_login_goal_submit')));
      await tester.pumpAndSettle();

      expect(find.text('Pick a valid goal'), findsOneWidget);
      expect(find.text('Invalid'), findsOneWidget);

      await cubit.close();
    });
  });
}
