// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'config_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$HyprspaceConfigImpl _$HyprspaceConfigFromJson(Map<String, dynamic> json) =>
    _$$HyprspaceConfigImplFromJson(json);

_$InterfaceConfigImpl _$InterfaceConfigFromJson(Map<String, dynamic> json) =>
    _$$InterfaceConfigImplFromJson(json);

_$PeerConfigImpl _$PeerConfigFromJson(Map<String, dynamic> json) =>
    _$$PeerConfigImplFromJson(json);

_$NetworkStatsImpl _$NetworkStatsFromJson(Map<String, dynamic> json) =>
    _$$NetworkStatsImplFromJson(json);

_$HyprspaceConfigImpl _$$HyprspaceConfigImplFromJson(
        Map<String, dynamic> json) =>
    _$HyprspaceConfigImpl(
      id: json['id'] as String,
      interface: InterfaceConfig.fromJson(
          json['interface'] as Map<String, dynamic>),
      peers: (json['peers'] as Map<String, dynamic>?)?.map(
            (k, e) =>
                MapEntry(k, PeerConfig.fromJson(e as Map<String, dynamic>)),
          ) ??
          const {},
      autoReconnect: json['autoReconnect'] as bool? ?? true,
      mtu: json['mtu'] as int? ?? 1420,
    );

Map<String, dynamic> _$$HyprspaceConfigImplToJson(
        _$HyprspaceConfigImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'interface': instance.interface.toJson(),
      'peers': instance.peers.map((k, e) => MapEntry(k, e.toJson())),
      'autoReconnect': instance.autoReconnect,
      'mtu': instance.mtu,
    };

_$InterfaceConfigImpl _$$InterfaceConfigImplFromJson(
        Map<String, dynamic> json) =>
    _$InterfaceConfigImpl(
      name: json['name'] as String? ?? 'hs0',
      id: json['id'] as String,
      listenPort: json['listenPort'] as int? ?? 8001,
      address: json['address'] as String? ?? '10.1.1.1/24',
      privateKey: json['privateKey'] as String,
    );

Map<String, dynamic> _$$InterfaceConfigImplToJson(
        _$InterfaceConfigImpl instance) =>
    <String, dynamic>{
      'name': instance.name,
      'id': instance.id,
      'listenPort': instance.listenPort,
      'address': instance.address,
      'privateKey': instance.privateKey,
    };

_$PeerConfigImpl _$$PeerConfigImplFromJson(Map<String, dynamic> json) =>
    _$PeerConfigImpl(
      id: json['id'] as String,
      name: json['name'] as String?,
      publicKey: json['publicKey'] as String?,
      lastSeen: json['lastSeen'] == null
          ? null
          : DateTime.parse(json['lastSeen'] as String),
      status: $enumDecodeNullable(_$ConnectionStatusEnumMap, json['status']) ??
          ConnectionStatus.disconnected,
    );

Map<String, dynamic> _$$PeerConfigImplToJson(_$PeerConfigImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'publicKey': instance.publicKey,
      'lastSeen': instance.lastSeen?.toIso8601String(),
      'status': _$ConnectionStatusEnumMap[instance.status]!,
    };

const _$ConnectionStatusEnumMap = {
  ConnectionStatus.disconnected: 'disconnected',
  ConnectionStatus.connecting: 'connecting',
  ConnectionStatus.connected: 'connected',
  ConnectionStatus.error: 'error',
};

_$NetworkStatsImpl _$$NetworkStatsImplFromJson(Map<String, dynamic> json) =>
    _$NetworkStatsImpl(
      bytesSent: json['bytesSent'] as int? ?? 0,
      bytesReceived: json['bytesReceived'] as int? ?? 0,
      packetsSent: json['packetsSent'] as int? ?? 0,
      packetsReceived: json['packetsReceived'] as int? ?? 0,
      latencyMs: (json['latencyMs'] as num?)?.toDouble() ?? 0,
      packetLossPercent:
          (json['packetLossPercent'] as num?)?.toDouble() ?? 0.0,
      connectedSince: json['connectedSince'] == null
          ? null
          : DateTime.parse(json['connectedSince'] as String),
    );

Map<String, dynamic> _$$NetworkStatsImplToJson(_$NetworkStatsImpl instance) =>
    <String, dynamic>{
      'bytesSent': instance.bytesSent,
      'bytesReceived': instance.bytesReceived,
      'packetsSent': instance.packetsSent,
      'packetsReceived': instance.packetsReceived,
      'latencyMs': instance.latencyMs,
      'packetLossPercent': instance.packetLossPercent,
      'connectedSince': instance.connectedSince?.toIso8601String(),
    };
