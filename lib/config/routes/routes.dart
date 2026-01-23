import 'package:go_router/go_router.dart';

import '../../pages/home/home_page.dart';
import '../../pages/settings/settings_page.dart';

final appRoutes = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      name: 'home',
      builder: (context, state) => const HomePage(),
      routes: [
        GoRoute(
          path: 'settings',
          name: 'settings',
          builder: (context, state) => const SettingsPage(),
        ),
      ],
    ),
  ],
);
