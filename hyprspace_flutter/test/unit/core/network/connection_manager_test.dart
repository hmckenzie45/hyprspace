import 'package:flutter_test/flutter_test.dart';

import 'package:hyprspace_flutter/core/config/config_model.dart';
import 'package:hyprspace_flutter/core/network/connection_manager.dart';
import 'package:hyprspace_flutter/core/network/vpn_native_bridge.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

import 'connection_manager_test.mocks.dart';

@GenerateMocks([VpnNativeBridge, Connectivity])
void main() {
  group('ConnectionManager', () {
    late MockVpnNativeBridge mockBridge;
    late ConnectionManager manager;

    setUp(() {
      mockBridge = MockVpnNativeBridge();
      manager = ConnectionManager(bridge: mockBridge);
    });

    tearDown(() => manager.dispose());

    test('initial status is disconnected', () {
      expect(manager.statusFor('any'), ConnectionStatus.disconnected);
    });

    test('connect sets status to connected on success', () async {
      when(mockBridge.addPeer('p1', '10.1.1.2')).thenReturn(0);
      await manager.connect('p1', '10.1.1.2');
      expect(manager.statusFor('p1'), ConnectionStatus.connected);
    });

    test('connect sets status to error on failure', () async {
      when(mockBridge.addPeer('p2', '10.1.1.3')).thenReturn(-1);
      await manager.connect('p2', '10.1.1.3');
      expect(manager.statusFor('p2'), ConnectionStatus.error);
    });

    test('disconnect calls removePeer and sets disconnected', () async {
      when(mockBridge.addPeer(any, any)).thenReturn(0);
      when(mockBridge.removePeer(any)).thenReturn(0);
      await manager.connect('p3', '10.1.1.4');
      await manager.disconnect('p3');
      verify(mockBridge.removePeer('p3')).called(1);
      expect(manager.statusFor('p3'), ConnectionStatus.disconnected);
    });
  });
}
