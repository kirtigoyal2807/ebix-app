import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'config/routes/routes.dart';
import 'config/theme/app_theme.dart';
import 'cubit/app/app_cubit.dart';
import 'cubit/theme/theme_cubit.dart';

void main() {
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => AppCubit()),
        BlocProvider(create: (context) => ThemeCubit()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeState>(
      builder: (context, themeState) {
        return BlocBuilder<AppCubit, AppState>(
          builder: (context, appState) {
            return MaterialApp.router(
              title: 'Pilates App',
              debugShowCheckedModeBanner: false,
              routerConfig: appRoutes,
              locale: appState.locale,
              localizationsDelegates: const [
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
              supportedLocales: const [
                Locale('en'),
                Locale('ar'),
              ],
              theme: AppTheme.getLightTheme(),
              darkTheme: AppTheme.getDarkTheme(),
              themeMode: themeState.themeMode,
            );
          },
        );
      },
    );
  }
}
