import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:hyprspace_flutter/features/home/presentation/widgets/peer_list_item.dart';
import 'package:hyprspace_flutter/core/config/config_model.dart';

void main() {
  group('PeerListItem', () {
    testWidgets('shows peer name when provided', (tester) async {
      const peer = PeerConfig(id: 'peer-1', name: 'Alice');
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: PeerListItem(vpnIp: '10.1.1.2', peer: peer),
            ),
          ),
        ),
      );

      expect(find.text('Alice'), findsOneWidget);
      expect(find.text('10.1.1.2'), findsOneWidget);
    });

    testWidgets('shows peer id when name is not provided', (tester) async {
      const peer = PeerConfig(id: 'QmYyQSo1c1Ym7orWxLYvCrzRX5As14boGgrF1DhySeg8P7');
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: PeerListItem(
                  vpnIp: '10.1.1.3',
                  peer: peer),
            ),
          ),
        ),
      );

      expect(find.text('QmYyQSo1c1Ym7orWxLYvCrzRX5As14boGgrF1DhySeg8P7'),
          findsOneWidget);
    });

    testWidgets('shows Connected chip when peer is connected', (tester) async {
      const peer = PeerConfig(
        id: 'p1',
        status: ConnectionStatus.connected,
      );
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: PeerListItem(vpnIp: '10.1.1.4', peer: peer),
            ),
          ),
        ),
      );

      expect(find.text('Connected'), findsOneWidget);
    });
  });
}
