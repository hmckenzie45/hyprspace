import 'package:go_router/go_router.dart';

import 'features/home/presentation/pages/home_page.dart';
import 'features/peers/presentation/pages/peers_page.dart';
import 'features/settings/presentation/pages/settings_page.dart';
import 'features/logs/presentation/pages/logs_page.dart';

final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const HomePage(),
    ),
    GoRoute(
      path: '/peers',
      builder: (context, state) => const PeersPage(),
    ),
    GoRoute(
      path: '/settings',
      builder: (context, state) => const SettingsPage(),
    ),
    GoRoute(
      path: '/logs',
      builder: (context, state) => const LogsPage(),
    ),
  ],
);
