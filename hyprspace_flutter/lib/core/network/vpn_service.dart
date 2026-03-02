import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../config/config_model.dart';
import '../utils/logger.dart';
import 'connection_manager.dart';
import 'packet_handler.dart';
import 'vpn_native_bridge.dart';

/// Represents the overall state of the VPN service.
class VpnState {
  final ConnectionStatus status;
  final NetworkStats stats;
  final String? errorMessage;

  const VpnState({
    this.status = ConnectionStatus.disconnected,
    this.stats = const NetworkStats(),
    this.errorMessage,
  });

  VpnState copyWith({
    ConnectionStatus? status,
    NetworkStats? stats,
    String? errorMessage,
  }) {
    return VpnState(
      status: status ?? this.status,
      stats: stats ?? this.stats,
      errorMessage: errorMessage,
    );
  }
}

/// Main VPN service that orchestrates the native bridge, TUN device,
/// peer connections and statistics collection.
class VpnService extends Notifier<VpnState> {
  VpnNativeBridge get _bridge => VpnNativeBridge.instance;
  late final PacketHandler _packetHandler = PacketHandler();
  late final ConnectionManager _connectionManager = ConnectionManager();

  Timer? _statsTimer;
  Timer? _healthTimer;

  @override
  VpnState build() => const VpnState();

  // --------------------------------------------------------------------------
  // Public API
  // --------------------------------------------------------------------------

  /// Connects to the VPN using [config].
  ///
  /// 1. Loads the native library.
  /// 2. Creates a TUN device.
  /// 3. Starts the libp2p node.
  /// 4. Connects to all configured peers.
  /// 5. Starts statistics and health-check timers.
  Future<void> connect(HyprspaceConfig config) async {
    if (state.status == ConnectionStatus.connected ||
        state.status == ConnectionStatus.connecting) {
      return;
    }
    state = state.copyWith(status: ConnectionStatus.connecting, errorMessage: null);
    AppLogger.info('VPN connect requested');

    try {
      // 1. Load native library
      _bridge.load();
      final initResult = _bridge.init();
      if (initResult != 0) {
        throw Exception('Native init failed with code $initResult');
      }

      // 2. Create TUN device
      final tunResult = _bridge.createTun(
        config.interface.name,
        config.interface.address,
        config.mtu,
      );
      if (tunResult != 0) {
        throw Exception('TUN creation failed with code $tunResult');
      }

      // 3. Start libp2p node
      final nodeResult = _bridge.startNode(
        config.interface.privateKey,
        config.interface.listenPort,
      );
      if (nodeResult != 0) {
        throw Exception('Node start failed with code $nodeResult');
      }

      // 4. Connect peers
      final peerIpMap = <String, String>{};
      for (final entry in config.peers.entries) {
        // key = VPN IP, value = PeerConfig
        await _connectionManager.connect(entry.value.id, entry.key);
        peerIpMap[entry.value.id] = entry.key;
      }

      // 5. Start packet handling
      _packetHandler.start();
      _connectionManager.startNetworkMonitoring(peerIpMap);

      // 6. Start background timers
      _startStatsTimer();
      _startHealthCheck();

      state = state.copyWith(
        status: ConnectionStatus.connected,
        stats: NetworkStats(connectedSince: DateTime.now()),
      );
      AppLogger.info('VPN connected');
    } catch (e, st) {
      AppLogger.error('VPN connect failed', e, st);
      state = state.copyWith(
        status: ConnectionStatus.error,
        errorMessage: e.toString(),
      );
      await _teardown();
    }
  }

  /// Disconnects from the VPN and releases all resources.
  Future<void> disconnect() async {
    if (state.status == ConnectionStatus.disconnected) return;
    AppLogger.info('VPN disconnect requested');
    await _teardown();
    state = const VpnState();
    AppLogger.info('VPN disconnected');
  }

  // --------------------------------------------------------------------------
  // Private helpers
  // --------------------------------------------------------------------------

  void _startStatsTimer() {
    _statsTimer?.cancel();
    _statsTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      try {
        final raw = _bridge.getStatsBytes();
        state = state.copyWith(
          stats: state.stats.copyWith(
            bytesSent: raw.bytesSent,
            bytesReceived: raw.bytesReceived,
          ),
        );
      } catch (_) {
        // Non-fatal; stats update failure does not affect tunnel.
      }
    });
  }

  void _startHealthCheck() {
    _healthTimer?.cancel();
    _healthTimer = Timer.periodic(const Duration(seconds: 30), (_) {
      if (state.status != ConnectionStatus.connected) return;
      AppLogger.debug('VPN health check: OK');
    });
  }

  Future<void> _teardown() async {
    _statsTimer?.cancel();
    _statsTimer = null;
    _healthTimer?.cancel();
    _healthTimer = null;
    _packetHandler.stop();
    _connectionManager.stopNetworkMonitoring();
    try {
      _bridge.stopNode();
    } catch (e) {
      AppLogger.warning('stopNode error during teardown: $e');
    }
  }
}

/// Riverpod [NotifierProvider] for [VpnService].
final vpnServiceProvider = NotifierProvider<VpnService, VpnState>(
  VpnService.new,
);
