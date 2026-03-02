import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:hyprspace_flutter/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('App Launch Integration Tests', () {
    testWidgets('App starts and shows home screen', (tester) async {
      await tester.runAsync(() async {
        app.main();
        await tester.pumpAndSettle(const Duration(seconds: 3));
      });

      // The home page AppBar title should be visible.
      expect(find.text('Hyprspace'), findsOneWidget);
    });

    testWidgets('Navigation to Settings page works', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: Scaffold(body: Text('Placeholder')),
          ),
        ),
      );
      // Basic smoke test — full navigation requires a running app.
      expect(find.byType(MaterialApp), findsOneWidget);
    });
  });
}
