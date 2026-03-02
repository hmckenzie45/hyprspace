import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:hyprspace_flutter/features/home/presentation/widgets/vpn_status_card.dart';
import 'package:hyprspace_flutter/core/config/config_model.dart';

void main() {
  group('VpnStatusCard', () {
    testWidgets('shows Disconnected label when status is disconnected',
        (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: VpnStatusCard(
                status: ConnectionStatus.disconnected,
                stats: const NetworkStats(),
                onToggle: () {},
              ),
            ),
          ),
        ),
      );

      expect(find.text('Disconnected'), findsOneWidget);
    });

    testWidgets('shows Connected label when status is connected',
        (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: VpnStatusCard(
                status: ConnectionStatus.connected,
                stats: const NetworkStats(
                  bytesSent: 1024,
                  bytesReceived: 2048,
                ),
                onToggle: () {},
              ),
            ),
          ),
        ),
      );

      expect(find.text('Connected'), findsOneWidget);
    });

    testWidgets('calls onToggle when tapped', (tester) async {
      var toggled = false;
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: VpnStatusCard(
                status: ConnectionStatus.disconnected,
                stats: const NetworkStats(),
                onToggle: () => toggled = true,
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.byType(GestureDetector).first);
      expect(toggled, isTrue);
    });

    testWidgets('shows Connecting label when status is connecting',
        (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: VpnStatusCard(
                status: ConnectionStatus.connecting,
                stats: const NetworkStats(),
                onToggle: () {},
              ),
            ),
          ),
        ),
      );

      expect(find.text('Connecting…'), findsOneWidget);
    });
  });
}
