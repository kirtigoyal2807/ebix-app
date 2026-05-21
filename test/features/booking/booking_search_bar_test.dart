import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pilates_app/core/localization/arb/app_localizations.dart';
import 'package:pilates_app/features/booking/cubit/booking_cubit.dart';
import 'package:pilates_app/features/booking/widgets/booking_search_bar.dart';

import '../auth/fake_auth_repository.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  Future<void> pumpSearchHarness(WidgetTester tester, {required Widget child}) {
    return tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        supportedLocales: AppLocalizations.supportedLocales,
        locale: const Locale('en'),
        home: child,
      ),
    );
  }

  testWidgets('BookingSearchBar keeps text when parent rebuilds', (
    WidgetTester tester,
  ) async {
    final cubit = BookingCubit(
      authRepository: FakeAuthRepository(),
      initialLocaleLanguageCode: 'en',
    );
    await pumpSearchHarness(
      tester,
      child: BlocProvider<BookingCubit>.value(
        value: cubit,
        child: StatefulBuilder(
          builder: (context, setState) {
            return Scaffold(
              body: Column(
                children: [
                  const BookingSearchBar(),
                  TextButton(
                    onPressed: () => setState(() {}),
                    child: const Text('trigger_parent_rebuild'),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );

    await tester.enterText(find.byType(TextField), 'mat pilates');
    await tester.pump();
    expect(cubit.state.searchQuery, 'mat pilates');

    await tester.tap(find.text('trigger_parent_rebuild'));
    await tester.pump();

    final field = tester.widget<TextField>(find.byType(TextField));
    expect(field.controller?.text, 'mat pilates');

    await cubit.close();
  });

  testWidgets('BookingSearchBar syncs when cubit searchQuery changes', (
    WidgetTester tester,
  ) async {
    final cubit = BookingCubit(
      authRepository: FakeAuthRepository(),
      initialLocaleLanguageCode: 'en',
    );
    await pumpSearchHarness(
      tester,
      child: BlocProvider<BookingCubit>.value(
        value: cubit,
        child: const Scaffold(body: BookingSearchBar()),
      ),
    );

    cubit.updateSearchQuery('from_cubit');
    await tester.pump();

    final field = tester.widget<TextField>(find.byType(TextField));
    expect(field.controller?.text, 'from_cubit');

    await cubit.close();
  });
}
