import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../config/config_model.dart';
import '../utils/logger.dart';
import 'vpn_native_bridge.dart';

/// Manages the lifecycle of individual peer connections.
///
/// Tracks connection state, handles reconnection with exponential back-off,
/// and responds to network-change events.
class ConnectionManager {
  final VpnNativeBridge _bridge;
  final Connectivity _connectivity;

  final _peerStatuses = <String, ConnectionStatus>{};
  StreamSubscription<List<ConnectivityResult>>? _connectivitySub;

  // Reconnection configuration
  static const int _maxReconnectAttempts = 5;
  static const Duration _baseBackoff = Duration(seconds: 2);

  ConnectionManager({
    VpnNativeBridge? bridge,
    Connectivity? connectivity,
  })  : _bridge = bridge ?? VpnNativeBridge.instance,
        _connectivity = connectivity ?? Connectivity();

  /// Returns the current connection status for [peerId].
  ConnectionStatus statusFor(String peerId) =>
      _peerStatuses[peerId] ?? ConnectionStatus.disconnected;

  /// Adds [peerId] with VPN IP [peerIp] and starts connecting.
  Future<void> connect(String peerId, String peerIp) async {
    _peerStatuses[peerId] = ConnectionStatus.connecting;
    AppLogger.info('Connecting to peer $peerId ($peerIp)');
    final result = _bridge.addPeer(peerId, peerIp);
    if (result == 0) {
      _peerStatuses[peerId] = ConnectionStatus.connected;
      AppLogger.info('Connected to peer $peerId');
    } else {
      _peerStatuses[peerId] = ConnectionStatus.error;
      AppLogger.warning('Failed to connect to peer $peerId (code $result)');
    }
  }

  /// Disconnects from [peerId].
  Future<void> disconnect(String peerId) async {
    _bridge.removePeer(peerId);
    _peerStatuses[peerId] = ConnectionStatus.disconnected;
    AppLogger.info('Disconnected from peer $peerId');
  }

  /// Subscribes to connectivity changes and reconnects peers when the
  /// network is restored.
  void startNetworkMonitoring(Map<String, String> peers) {
    _connectivitySub = _connectivity.onConnectivityChanged.listen(
      (results) => _onNetworkChanged(results, peers),
    );
  }

  /// Unsubscribes from connectivity events.
  void stopNetworkMonitoring() {
    _connectivitySub?.cancel();
    _connectivitySub = null;
  }

  Future<void> _onNetworkChanged(
    List<ConnectivityResult> results,
    Map<String, String> peers,
  ) async {
    final hasNetwork = results.any((r) => r != ConnectivityResult.none);
    if (hasNetwork) {
      AppLogger.info('Network restored – reconnecting peers');
      for (final entry in peers.entries) {
        await _reconnectWithBackoff(entry.key, entry.value);
      }
    } else {
      AppLogger.warning('Network lost');
      for (final peerId in peers.keys) {
        _peerStatuses[peerId] = ConnectionStatus.disconnected;
      }
    }
  }

  Future<void> _reconnectWithBackoff(String peerId, String peerIp) async {
    for (var attempt = 0; attempt < _maxReconnectAttempts; attempt++) {
      try {
        await connect(peerId, peerIp);
        if (_peerStatuses[peerId] == ConnectionStatus.connected) return;
      } catch (e) {
        AppLogger.warning('Reconnect attempt ${attempt + 1} failed: $e');
      }
      final delay = _baseBackoff * (1 << attempt);
      await Future<void>.delayed(delay);
    }
    AppLogger.error(
      'Could not reconnect to peer $peerId after $_maxReconnectAttempts attempts. '
      'Check that the peer is online and network connectivity is stable.',
      null,
      null,
    );
  }

  void dispose() {
    stopNetworkMonitoring();
    _peerStatuses.clear();
  }
}

/// Riverpod provider for [ConnectionManager].
final connectionManagerProvider = Provider<ConnectionManager>((ref) {
  final manager = ConnectionManager();
  ref.onDispose(manager.dispose);
  return manager;
});
