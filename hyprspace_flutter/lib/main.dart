import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';

import 'core/storage/database.dart';
import 'core/utils/logger.dart';
import 'shared/theme/app_theme.dart';
import 'app_router.dart';

final getIt = GetIt.instance;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize logger
  AppLogger.init();

  // Initialize dependency injection
  await _setupDependencies();

  runApp(
    const ProviderScope(
      child: HyprspaceApp(),
    ),
  );
}

Future<void> _setupDependencies() async {
  // Register database
  getIt.registerSingletonAsync<AppDatabase>(() async {
    final db = AppDatabase();
    return db;
  });

  await getIt.allReady();
}

class HyprspaceApp extends ConsumerWidget {
  const HyprspaceApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp.router(
      title: 'Hyprspace',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      routerConfig: appRouter,
      debugShowCheckedModeBanner: false,
    );
  }
}
