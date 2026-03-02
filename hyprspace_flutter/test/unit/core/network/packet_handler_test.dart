import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';

import 'package:hyprspace_flutter/core/network/packet_handler.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'package:hyprspace_flutter/core/network/vpn_native_bridge.dart';

import 'packet_handler_test.mocks.dart';

@GenerateMocks([VpnNativeBridge])
void main() {
  group('PacketHandler', () {
    late MockVpnNativeBridge mockBridge;
    late PacketHandler handler;

    setUp(() {
      mockBridge = MockVpnNativeBridge();
      handler = PacketHandler(bridge: mockBridge);
    });

    tearDown(() => handler.dispose());

    test('sendPacket calls bridge.sendPacket', () {
      when(mockBridge.sendPacket(any)).thenReturn(0);
      handler.start();
      final packet = Uint8List.fromList([1, 2, 3, 4]);
      handler.sendPacket(packet);
      verify(mockBridge.sendPacket(packet)).called(1);
    });

    test('does not send when not started', () {
      when(mockBridge.sendPacket(any)).thenReturn(0);
      final packet = Uint8List.fromList([1, 2, 3]);
      handler.sendPacket(packet);
      verifyNever(mockBridge.sendPacket(any));
    });

    test('inboundPackets stream emits received data', () async {
      final pkt = Uint8List.fromList(List.generate(20, (i) => i));
      var callCount = 0;
      when(mockBridge.receivePacket(any)).thenAnswer((_) {
        if (callCount == 0) {
          callCount++;
          final args = _.positionalArguments[0] as Uint8List;
          args.setAll(0, pkt);
          return pkt.length;
        }
        return 0;
      });

      final received = <Uint8List>[];
      final sub = handler.inboundPackets.listen(received.add);
      handler.start();

      await Future<void>.delayed(const Duration(milliseconds: 50));
      handler.stop();
      await sub.cancel();

      expect(received, isNotEmpty);
      expect(received.first, pkt);
    });
  });
}
