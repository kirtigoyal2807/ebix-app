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
import 'package:pilates_app/features/auth/data/models/branch.dart';
import 'package:pilates_app/features/auth/data/models/branches_list_result.dart';
import 'package:pilates_app/features/auth/sign_up/step_branch_view.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'fake_auth_repository.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets(
    'SignUpBranchView loads branches; finish submits selected home branch',
    (tester) async {
      SharedPreferences.setMockInitialValues({});
      final fake = FakeAuthRepository();
      fake.listBranchesResult = ApiSuccess<BranchesListResult>(
        BranchesListResult(
          branches: const [
            Branch(
              id: 9,
              title: 'Downtown Studio',
              city: 'Riyadh',
              distance: '4 km',
              typeLabel: 'Premium',
            ),
          ],
        ),
      );
      fake.setHomeBranchResult = const ApiSuccess<bool>(true);

      final cubit = AuthCubit.forTesting(
        authRepository: fake,
        tokenStorage: TokenStorage(await SharedPreferences.getInstance()),
        localeBridge: AuthLocaleBridge(),
        seed: AuthState.initial().copyWith(
          flow: AuthFlow.signUp,
          signUpStep: 4,
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
            child: const SignUpBranchView(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Downtown Studio'), findsOneWidget);

      await tester.tap(find.byKey(const ValueKey('sign_up_branch_9')));
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(const ValueKey('sign_up_branch_finish')));
      await tester.pumpAndSettle();

      expect(cubit.state.flow, AuthFlow.authenticated);
      expect(fake.setHomeBranchCalls, 1);
      expect(fake.lastHomeBranchId, 9);

      await cubit.close();
    },
  );

  testWidgets(
    'SignUpBranchView finish without branch shows pleaseSelectBranch snackbar',
    (tester) async {
      SharedPreferences.setMockInitialValues({});
      final fake = FakeAuthRepository();
      fake.listBranchesResult = ApiSuccess<BranchesListResult>(
        BranchesListResult(
          branches: const [
            Branch(
              id: 1,
              title: 'A',
              city: 'B',
              distance: '1',
              typeLabel: 'Standard',
            ),
          ],
        ),
      );

      final cubit = AuthCubit.forTesting(
        authRepository: fake,
        tokenStorage: TokenStorage(await SharedPreferences.getInstance()),
        localeBridge: AuthLocaleBridge(),
        seed: AuthState.initial().copyWith(
          flow: AuthFlow.signUp,
          signUpStep: 4,
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
            child: const SignUpBranchView(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      await tester.tap(find.byKey(const ValueKey('sign_up_branch_finish')));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 400));

      expect(find.text('Please select a branch to continue.'), findsOneWidget);

      await cubit.close();
    },
  );
}
