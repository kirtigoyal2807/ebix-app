import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'config/theme/app_theme.dart';
import 'core/localization/arb/app_localizations.dart';
import 'features/auth/cubit/auth_cubit.dart';
import 'features/auth/auth_root_view.dart';
import 'features/auth/cubit/auth_state.dart';

void main() {
  runApp(const PilatesApp());
}

class PilatesApp extends StatelessWidget {
  const PilatesApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AuthCubit(),
      child: BlocBuilder<AuthCubit, AuthState>(
        builder: (context, state) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,

            locale: state.locale,
            supportedLocales: const [Locale('en'), Locale('ar')],

            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],

            theme: AppTheme.light(),
            darkTheme: AppTheme.dark(),
            themeMode: state.themeMode,

            home: const AuthRootView(),
          );
        },
      ),
    );
  }
}
