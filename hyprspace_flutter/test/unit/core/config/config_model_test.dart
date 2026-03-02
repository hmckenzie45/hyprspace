import 'package:flutter_test/flutter_test.dart';

import 'package:hyprspace_flutter/core/config/config_model.dart';

void main() {
  group('HyprspaceConfig', () {
    test('round-trips through JSON', () {
      final config = const HyprspaceConfig(
        id: 'test-id',
        interface: const InterfaceConfig(
          name: 'hs0',
          id: 'iface-id',
          listenPort: 8001,
          address: '10.1.1.1/24',
          privateKey: 'test-private-key',
        ),
        peers: {
          '10.1.1.2': const PeerConfig(id: 'peer-1', name: 'Alice'),
        },
        autoReconnect: true,
        mtu: 1420,
      );

      final json = config.toJson();
      final restored = HyprspaceConfig.fromJson(json);

      expect(restored.id, config.id);
      expect(restored.interface.name, config.interface.name);
      expect(restored.interface.listenPort, config.interface.listenPort);
      expect(restored.mtu, config.mtu);
      expect(restored.autoReconnect, config.autoReconnect);
      expect(restored.peers.length, 1);
      expect(restored.peers['10.1.1.2']?.name, 'Alice');
    });

    test('default values are applied', () {
      const iface = InterfaceConfig(
        id: 'x',
        privateKey: 'k',
      );
      expect(iface.name, 'hs0');
      expect(iface.listenPort, 8001);
      expect(iface.address, '10.1.1.1/24');
    });

    test('copyWith produces updated instance', () {
      final original = const HyprspaceConfig(
        id: 'original',
        interface: const InterfaceConfig(id: 'x', privateKey: 'k'),
        mtu: 1420,
      );
      final updated = original.copyWith(mtu: 9000);
      expect(updated.mtu, 9000);
      expect(updated.id, 'original');
    });
  });

  group('PeerConfig', () {
    test('default status is disconnected', () {
      const peer = PeerConfig(id: 'p1');
      expect(peer.status, ConnectionStatus.disconnected);
    });

    test('round-trips through JSON with nullable fields', () {
      final peer = PeerConfig(
        id: 'p2',
        name: 'Bob',
        lastSeen: DateTime(2024, 6, 1),
        status: ConnectionStatus.connected,
      );
      final json = peer.toJson();
      final restored = PeerConfig.fromJson(json);
      expect(restored.name, 'Bob');
      expect(restored.status, ConnectionStatus.connected);
      expect(restored.lastSeen?.year, 2024);
    });
  });

  group('NetworkStats', () {
    test('default values are all zero', () {
      const stats = NetworkStats();
      expect(stats.bytesSent, 0);
      expect(stats.bytesReceived, 0);
      expect(stats.latencyMs, 0);
      expect(stats.connectedSince, isNull);
    });

    test('copyWith updates only specified fields', () {
      const stats = NetworkStats(bytesSent: 100, bytesReceived: 200);
      final updated = stats.copyWith(bytesSent: 300);
      expect(updated.bytesSent, 300);
      expect(updated.bytesReceived, 200);
    });
  });
}
