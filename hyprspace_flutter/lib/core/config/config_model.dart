import 'package:freezed_annotation/freezed_annotation.dart';

part 'config_model.freezed.dart';
part 'config_model.g.dart';

/// Represents the overall configuration for a Hyprspace node.
@freezed
class HyprspaceConfig with _$HyprspaceConfig {
  const factory HyprspaceConfig({
    required String id,
    required InterfaceConfig interface,
    @Default({}) Map<String, PeerConfig> peers,
    @Default(true) bool autoReconnect,
    @Default(1420) int mtu,
  }) = _HyprspaceConfig;

  factory HyprspaceConfig.fromJson(Map<String, dynamic> json) =>
      _$HyprspaceConfigFromJson(json);
}

/// Interface (local node) configuration.
@freezed
class InterfaceConfig with _$InterfaceConfig {
  const factory InterfaceConfig({
    @Default('hs0') String name,
    required String id,
    @Default(8001) int listenPort,
    @Default('10.1.1.1/24') String address,
    required String privateKey,
  }) = _InterfaceConfig;

  factory InterfaceConfig.fromJson(Map<String, dynamic> json) =>
      _$InterfaceConfigFromJson(json);
}

/// Configuration for a single VPN peer.
@freezed
class PeerConfig with _$PeerConfig {
  const factory PeerConfig({
    required String id,
    String? name,
    String? publicKey,
    DateTime? lastSeen,
    @Default(ConnectionStatus.disconnected) ConnectionStatus status,
  }) = _PeerConfig;

  factory PeerConfig.fromJson(Map<String, dynamic> json) =>
      _$PeerConfigFromJson(json);
}

/// Represents the connection status of a peer or VPN tunnel.
enum ConnectionStatus {
  disconnected,
  connecting,
  connected,
  error,
}

/// Network statistics snapshot.
@freezed
class NetworkStats with _$NetworkStats {
  const factory NetworkStats({
    @Default(0) int bytesSent,
    @Default(0) int bytesReceived,
    @Default(0) int packetsSent,
    @Default(0) int packetsReceived,
    @Default(0) double latencyMs,
    @Default(0.0) double packetLossPercent,
    DateTime? connectedSince,
  }) = _NetworkStats;

  factory NetworkStats.fromJson(Map<String, dynamic> json) =>
      _$NetworkStatsFromJson(json);
}
