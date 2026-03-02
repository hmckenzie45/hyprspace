import 'dart:async';
import 'dart:typed_data';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../utils/logger.dart';
import 'vpn_native_bridge.dart';

/// The maximum IP packet size we handle (standard Hyprspace MTU).
const int kDefaultMtu = 1420;

/// Packet handler callback signature.
typedef PacketCallback = void Function(Uint8List packet);

/// Manages low-level packet I/O between the TUN device and the native bridge.
///
/// Consumers register [PacketCallback]s to react to inbound packets.
class PacketHandler {
  final VpnNativeBridge _bridge;
  final _inboundController = StreamController<Uint8List>.broadcast();

  bool _running = false;
  Timer? _pollTimer;

  PacketHandler({VpnNativeBridge? bridge})
      : _bridge = bridge ?? VpnNativeBridge.instance;

  /// Stream of inbound packets received from the VPN tunnel.
  Stream<Uint8List> get inboundPackets => _inboundController.stream;

  /// Starts polling for inbound packets.
  void start() {
    if (_running) return;
    _running = true;
    // Poll the native bridge for inbound packets every 5 ms.
    _pollTimer = Timer.periodic(const Duration(milliseconds: 5), (_) {
      _pollPacket();
    });
    AppLogger.info('PacketHandler started');
  }

  /// Stops packet polling and closes the stream.
  void stop() {
    _running = false;
    _pollTimer?.cancel();
    _pollTimer = null;
    AppLogger.info('PacketHandler stopped');
  }

  /// Sends a raw IP [packet] through the native bridge.
  void sendPacket(Uint8List packet) {
    if (!_running) return;
    try {
      _bridge.sendPacket(packet);
    } catch (e, st) {
      AppLogger.error('sendPacket error', e, st);
    }
  }

  void _pollPacket() {
    try {
      final buffer = Uint8List(kDefaultMtu);
      final bytesRead = _bridge.receivePacket(buffer);
      if (bytesRead > 0) {
        _inboundController.add(buffer.sublist(0, bytesRead));
      }
    } catch (e) {
      // Suppress polling errors to avoid log spam.
    }
  }

  void dispose() {
    stop();
    _inboundController.close();
  }
}

/// Riverpod provider for [PacketHandler].
final packetHandlerProvider = Provider<PacketHandler>((ref) {
  final handler = PacketHandler();
  ref.onDispose(handler.dispose);
  return handler;
});
