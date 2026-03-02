// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'config_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$HyprspaceConfig {
  String get id => throw _privateConstructorUsedError;
  InterfaceConfig get interface => throw _privateConstructorUsedError;
  Map<String, PeerConfig> get peers => throw _privateConstructorUsedError;
  bool get autoReconnect => throw _privateConstructorUsedError;
  int get mtu => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $HyprspaceConfigCopyWith<HyprspaceConfig> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $HyprspaceConfigCopyWith<$Res> {
  factory $HyprspaceConfigCopyWith(
          HyprspaceConfig value, $Res Function(HyprspaceConfig) then) =
      _$HyprspaceConfigCopyWithImpl<$Res, HyprspaceConfig>;
  @useResult
  $Res call(
      {String id,
      InterfaceConfig interface,
      Map<String, PeerConfig> peers,
      bool autoReconnect,
      int mtu});

  $InterfaceConfigCopyWith<$Res> get interface;
}

/// @nodoc
class _$HyprspaceConfigCopyWithImpl<$Res, $Val extends HyprspaceConfig>
    implements $HyprspaceConfigCopyWith<$Res> {
  _$HyprspaceConfigCopyWithImpl(this._value, this._then);

  final $Val _value;
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? interface = null,
    Object? peers = null,
    Object? autoReconnect = null,
    Object? mtu = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      interface: null == interface
          ? _value.interface
          : interface // ignore: cast_nullable_to_non_nullable
              as InterfaceConfig,
      peers: null == peers
          ? _value.peers
          : peers // ignore: cast_nullable_to_non_nullable
              as Map<String, PeerConfig>,
      autoReconnect: null == autoReconnect
          ? _value.autoReconnect
          : autoReconnect // ignore: cast_nullable_to_non_nullable
              as bool,
      mtu: null == mtu
          ? _value.mtu
          : mtu // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $InterfaceConfigCopyWith<$Res> get interface {
    return $InterfaceConfigCopyWithImpl<$Res, InterfaceConfig>(
        _value.interface as InterfaceConfig, (value) {
      return _then(_value.copyWith(interface: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$HyprspaceConfigImplCopyWith<$Res>
    implements $HyprspaceConfigCopyWith<$Res> {
  factory _$$HyprspaceConfigImplCopyWith(_$HyprspaceConfigImpl value,
          $Res Function(_$HyprspaceConfigImpl) then) =
      __$$HyprspaceConfigImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      InterfaceConfig interface,
      Map<String, PeerConfig> peers,
      bool autoReconnect,
      int mtu});

  @override
  $InterfaceConfigCopyWith<$Res> get interface;
}

/// @nodoc
class __$$HyprspaceConfigImplCopyWithImpl<$Res>
    extends _$HyprspaceConfigCopyWithImpl<$Res, _$HyprspaceConfigImpl>
    implements _$$HyprspaceConfigImplCopyWith<$Res> {
  __$$HyprspaceConfigImplCopyWithImpl(
      _$HyprspaceConfigImpl _value, $Res Function(_$HyprspaceConfigImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? interface = null,
    Object? peers = null,
    Object? autoReconnect = null,
    Object? mtu = null,
  }) {
    return _then(_$HyprspaceConfigImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      interface: null == interface
          ? _value.interface
          : interface // ignore: cast_nullable_to_non_nullable
              as InterfaceConfig,
      peers: null == peers
          ? _value.peers
          : peers // ignore: cast_nullable_to_non_nullable
              as Map<String, PeerConfig>,
      autoReconnect: null == autoReconnect
          ? _value.autoReconnect
          : autoReconnect // ignore: cast_nullable_to_non_nullable
              as bool,
      mtu: null == mtu
          ? _value.mtu
          : mtu // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$HyprspaceConfigImpl implements _HyprspaceConfig {
  const _$HyprspaceConfigImpl(
      {required this.id,
      required this.interface,
      final Map<String, PeerConfig> peers = const {},
      this.autoReconnect = true,
      this.mtu = 1420})
      : _peers = peers;

  factory _$HyprspaceConfigImpl.fromJson(Map<String, dynamic> json) =>
      _$$HyprspaceConfigImplFromJson(json);

  @override
  final String id;
  @override
  final InterfaceConfig interface;
  final Map<String, PeerConfig> _peers;
  @override
  @JsonKey()
  Map<String, PeerConfig> get peers {
    if (_peers is EqualUnmodifiableMapView) return _peers;
    return EqualUnmodifiableMapView(_peers);
  }

  @override
  @JsonKey()
  final bool autoReconnect;
  @override
  @JsonKey()
  final int mtu;

  @override
  String toString() {
    return 'HyprspaceConfig(id: $id, interface: $interface, peers: $peers, autoReconnect: $autoReconnect, mtu: $mtu)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$HyprspaceConfigImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.interface, interface) ||
                other.interface == interface) &&
            const DeepCollectionEquality().equals(other._peers, _peers) &&
            (identical(other.autoReconnect, autoReconnect) ||
                other.autoReconnect == autoReconnect) &&
            (identical(other.mtu, mtu) || other.mtu == mtu));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, id, interface,
      const DeepCollectionEquality().hash(_peers), autoReconnect, mtu);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$HyprspaceConfigImplCopyWith<_$HyprspaceConfigImpl> get copyWith =>
      __$$HyprspaceConfigImplCopyWithImpl<_$HyprspaceConfigImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$HyprspaceConfigImplToJson(
      this,
    );
  }
}

abstract class _HyprspaceConfig implements HyprspaceConfig {
  const factory _HyprspaceConfig(
      {required final String id,
      required final InterfaceConfig interface,
      final Map<String, PeerConfig> peers,
      final bool autoReconnect,
      final int mtu}) = _$HyprspaceConfigImpl;

  factory _HyprspaceConfig.fromJson(Map<String, dynamic> json) =
      _$HyprspaceConfigImpl.fromJson;

  @override
  String get id;
  @override
  InterfaceConfig get interface;
  @override
  Map<String, PeerConfig> get peers;
  @override
  bool get autoReconnect;
  @override
  int get mtu;
  @override
  @JsonKey(ignore: true)
  _$$HyprspaceConfigImplCopyWith<_$HyprspaceConfigImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$InterfaceConfig {
  String get name => throw _privateConstructorUsedError;
  String get id => throw _privateConstructorUsedError;
  int get listenPort => throw _privateConstructorUsedError;
  String get address => throw _privateConstructorUsedError;
  String get privateKey => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $InterfaceConfigCopyWith<InterfaceConfig> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $InterfaceConfigCopyWith<$Res> {
  factory $InterfaceConfigCopyWith(
          InterfaceConfig value, $Res Function(InterfaceConfig) then) =
      _$InterfaceConfigCopyWithImpl<$Res, InterfaceConfig>;
  @useResult
  $Res call(
      {String name,
      String id,
      int listenPort,
      String address,
      String privateKey});
}

/// @nodoc
class _$InterfaceConfigCopyWithImpl<$Res, $Val extends InterfaceConfig>
    implements $InterfaceConfigCopyWith<$Res> {
  _$InterfaceConfigCopyWithImpl(this._value, this._then);

  final $Val _value;
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? id = null,
    Object? listenPort = null,
    Object? address = null,
    Object? privateKey = null,
  }) {
    return _then(_value.copyWith(
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      listenPort: null == listenPort
          ? _value.listenPort
          : listenPort // ignore: cast_nullable_to_non_nullable
              as int,
      address: null == address
          ? _value.address
          : address // ignore: cast_nullable_to_non_nullable
              as String,
      privateKey: null == privateKey
          ? _value.privateKey
          : privateKey // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$InterfaceConfigImplCopyWith<$Res>
    implements $InterfaceConfigCopyWith<$Res> {
  factory _$$InterfaceConfigImplCopyWith(_$InterfaceConfigImpl value,
          $Res Function(_$InterfaceConfigImpl) then) =
      __$$InterfaceConfigImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String name,
      String id,
      int listenPort,
      String address,
      String privateKey});
}

/// @nodoc
class __$$InterfaceConfigImplCopyWithImpl<$Res>
    extends _$InterfaceConfigCopyWithImpl<$Res, _$InterfaceConfigImpl>
    implements _$$InterfaceConfigImplCopyWith<$Res> {
  __$$InterfaceConfigImplCopyWithImpl(_$InterfaceConfigImpl _value,
      $Res Function(_$InterfaceConfigImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? id = null,
    Object? listenPort = null,
    Object? address = null,
    Object? privateKey = null,
  }) {
    return _then(_$InterfaceConfigImpl(
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      listenPort: null == listenPort
          ? _value.listenPort
          : listenPort // ignore: cast_nullable_to_non_nullable
              as int,
      address: null == address
          ? _value.address
          : address // ignore: cast_nullable_to_non_nullable
              as String,
      privateKey: null == privateKey
          ? _value.privateKey
          : privateKey // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$InterfaceConfigImpl implements _InterfaceConfig {
  const _$InterfaceConfigImpl(
      {this.name = 'hs0',
      required this.id,
      this.listenPort = 8001,
      this.address = '10.1.1.1/24',
      required this.privateKey});

  factory _$InterfaceConfigImpl.fromJson(Map<String, dynamic> json) =>
      _$$InterfaceConfigImplFromJson(json);

  @override
  @JsonKey()
  final String name;
  @override
  final String id;
  @override
  @JsonKey()
  final int listenPort;
  @override
  @JsonKey()
  final String address;
  @override
  final String privateKey;

  @override
  String toString() {
    return 'InterfaceConfig(name: $name, id: $id, listenPort: $listenPort, address: $address, privateKey: $privateKey)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$InterfaceConfigImpl &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.listenPort, listenPort) ||
                other.listenPort == listenPort) &&
            (identical(other.address, address) || other.address == address) &&
            (identical(other.privateKey, privateKey) ||
                other.privateKey == privateKey));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, name, id, listenPort, address, privateKey);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$InterfaceConfigImplCopyWith<_$InterfaceConfigImpl> get copyWith =>
      __$$InterfaceConfigImplCopyWithImpl<_$InterfaceConfigImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$InterfaceConfigImplToJson(
      this,
    );
  }
}

abstract class _InterfaceConfig implements InterfaceConfig {
  const factory _InterfaceConfig(
      {final String name,
      required final String id,
      final int listenPort,
      final String address,
      required final String privateKey}) = _$InterfaceConfigImpl;

  factory _InterfaceConfig.fromJson(Map<String, dynamic> json) =
      _$InterfaceConfigImpl.fromJson;

  @override
  String get name;
  @override
  String get id;
  @override
  int get listenPort;
  @override
  String get address;
  @override
  String get privateKey;
  @override
  @JsonKey(ignore: true)
  _$$InterfaceConfigImplCopyWith<_$InterfaceConfigImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$PeerConfig {
  String get id => throw _privateConstructorUsedError;
  String? get name => throw _privateConstructorUsedError;
  String? get publicKey => throw _privateConstructorUsedError;
  DateTime? get lastSeen => throw _privateConstructorUsedError;
  ConnectionStatus get status => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $PeerConfigCopyWith<PeerConfig> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PeerConfigCopyWith<$Res> {
  factory $PeerConfigCopyWith(
          PeerConfig value, $Res Function(PeerConfig) then) =
      _$PeerConfigCopyWithImpl<$Res, PeerConfig>;
  @useResult
  $Res call(
      {String id,
      String? name,
      String? publicKey,
      DateTime? lastSeen,
      ConnectionStatus status});
}

/// @nodoc
class _$PeerConfigCopyWithImpl<$Res, $Val extends PeerConfig>
    implements $PeerConfigCopyWith<$Res> {
  _$PeerConfigCopyWithImpl(this._value, this._then);

  final $Val _value;
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = freezed,
    Object? publicKey = freezed,
    Object? lastSeen = freezed,
    Object? status = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: freezed == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
      publicKey: freezed == publicKey
          ? _value.publicKey
          : publicKey // ignore: cast_nullable_to_non_nullable
              as String?,
      lastSeen: freezed == lastSeen
          ? _value.lastSeen
          : lastSeen // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as ConnectionStatus,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PeerConfigImplCopyWith<$Res>
    implements $PeerConfigCopyWith<$Res> {
  factory _$$PeerConfigImplCopyWith(
          _$PeerConfigImpl value, $Res Function(_$PeerConfigImpl) then) =
      __$$PeerConfigImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String? name,
      String? publicKey,
      DateTime? lastSeen,
      ConnectionStatus status});
}

/// @nodoc
class __$$PeerConfigImplCopyWithImpl<$Res>
    extends _$PeerConfigCopyWithImpl<$Res, _$PeerConfigImpl>
    implements _$$PeerConfigImplCopyWith<$Res> {
  __$$PeerConfigImplCopyWithImpl(
      _$PeerConfigImpl _value, $Res Function(_$PeerConfigImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = freezed,
    Object? publicKey = freezed,
    Object? lastSeen = freezed,
    Object? status = null,
  }) {
    return _then(_$PeerConfigImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: freezed == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
      publicKey: freezed == publicKey
          ? _value.publicKey
          : publicKey // ignore: cast_nullable_to_non_nullable
              as String?,
      lastSeen: freezed == lastSeen
          ? _value.lastSeen
          : lastSeen // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as ConnectionStatus,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PeerConfigImpl implements _PeerConfig {
  const _$PeerConfigImpl(
      {required this.id,
      this.name,
      this.publicKey,
      this.lastSeen,
      this.status = ConnectionStatus.disconnected});

  factory _$PeerConfigImpl.fromJson(Map<String, dynamic> json) =>
      _$$PeerConfigImplFromJson(json);

  @override
  final String id;
  @override
  final String? name;
  @override
  final String? publicKey;
  @override
  final DateTime? lastSeen;
  @override
  @JsonKey()
  final ConnectionStatus status;

  @override
  String toString() {
    return 'PeerConfig(id: $id, name: $name, publicKey: $publicKey, lastSeen: $lastSeen, status: $status)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PeerConfigImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.publicKey, publicKey) ||
                other.publicKey == publicKey) &&
            (identical(other.lastSeen, lastSeen) ||
                other.lastSeen == lastSeen) &&
            (identical(other.status, status) || other.status == status));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, name, publicKey, lastSeen, status);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$PeerConfigImplCopyWith<_$PeerConfigImpl> get copyWith =>
      __$$PeerConfigImplCopyWithImpl<_$PeerConfigImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PeerConfigImplToJson(
      this,
    );
  }
}

abstract class _PeerConfig implements PeerConfig {
  const factory _PeerConfig(
      {required final String id,
      final String? name,
      final String? publicKey,
      final DateTime? lastSeen,
      final ConnectionStatus status}) = _$PeerConfigImpl;

  factory _PeerConfig.fromJson(Map<String, dynamic> json) =
      _$PeerConfigImpl.fromJson;

  @override
  String get id;
  @override
  String? get name;
  @override
  String? get publicKey;
  @override
  DateTime? get lastSeen;
  @override
  ConnectionStatus get status;
  @override
  @JsonKey(ignore: true)
  _$$PeerConfigImplCopyWith<_$PeerConfigImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$NetworkStats {
  int get bytesSent => throw _privateConstructorUsedError;
  int get bytesReceived => throw _privateConstructorUsedError;
  int get packetsSent => throw _privateConstructorUsedError;
  int get packetsReceived => throw _privateConstructorUsedError;
  double get latencyMs => throw _privateConstructorUsedError;
  double get packetLossPercent => throw _privateConstructorUsedError;
  DateTime? get connectedSince => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $NetworkStatsCopyWith<NetworkStats> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $NetworkStatsCopyWith<$Res> {
  factory $NetworkStatsCopyWith(
          NetworkStats value, $Res Function(NetworkStats) then) =
      _$NetworkStatsCopyWithImpl<$Res, NetworkStats>;
  @useResult
  $Res call(
      {int bytesSent,
      int bytesReceived,
      int packetsSent,
      int packetsReceived,
      double latencyMs,
      double packetLossPercent,
      DateTime? connectedSince});
}

/// @nodoc
class _$NetworkStatsCopyWithImpl<$Res, $Val extends NetworkStats>
    implements $NetworkStatsCopyWith<$Res> {
  _$NetworkStatsCopyWithImpl(this._value, this._then);

  final $Val _value;
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? bytesSent = null,
    Object? bytesReceived = null,
    Object? packetsSent = null,
    Object? packetsReceived = null,
    Object? latencyMs = null,
    Object? packetLossPercent = null,
    Object? connectedSince = freezed,
  }) {
    return _then(_value.copyWith(
      bytesSent: null == bytesSent
          ? _value.bytesSent
          : bytesSent // ignore: cast_nullable_to_non_nullable
              as int,
      bytesReceived: null == bytesReceived
          ? _value.bytesReceived
          : bytesReceived // ignore: cast_nullable_to_non_nullable
              as int,
      packetsSent: null == packetsSent
          ? _value.packetsSent
          : packetsSent // ignore: cast_nullable_to_non_nullable
              as int,
      packetsReceived: null == packetsReceived
          ? _value.packetsReceived
          : packetsReceived // ignore: cast_nullable_to_non_nullable
              as int,
      latencyMs: null == latencyMs
          ? _value.latencyMs
          : latencyMs // ignore: cast_nullable_to_non_nullable
              as double,
      packetLossPercent: null == packetLossPercent
          ? _value.packetLossPercent
          : packetLossPercent // ignore: cast_nullable_to_non_nullable
              as double,
      connectedSince: freezed == connectedSince
          ? _value.connectedSince
          : connectedSince // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$NetworkStatsImplCopyWith<$Res>
    implements $NetworkStatsCopyWith<$Res> {
  factory _$$NetworkStatsImplCopyWith(
          _$NetworkStatsImpl value, $Res Function(_$NetworkStatsImpl) then) =
      __$$NetworkStatsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int bytesSent,
      int bytesReceived,
      int packetsSent,
      int packetsReceived,
      double latencyMs,
      double packetLossPercent,
      DateTime? connectedSince});
}

/// @nodoc
class __$$NetworkStatsImplCopyWithImpl<$Res>
    extends _$NetworkStatsCopyWithImpl<$Res, _$NetworkStatsImpl>
    implements _$$NetworkStatsImplCopyWith<$Res> {
  __$$NetworkStatsImplCopyWithImpl(
      _$NetworkStatsImpl _value, $Res Function(_$NetworkStatsImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? bytesSent = null,
    Object? bytesReceived = null,
    Object? packetsSent = null,
    Object? packetsReceived = null,
    Object? latencyMs = null,
    Object? packetLossPercent = null,
    Object? connectedSince = freezed,
  }) {
    return _then(_$NetworkStatsImpl(
      bytesSent: null == bytesSent
          ? _value.bytesSent
          : bytesSent // ignore: cast_nullable_to_non_nullable
              as int,
      bytesReceived: null == bytesReceived
          ? _value.bytesReceived
          : bytesReceived // ignore: cast_nullable_to_non_nullable
              as int,
      packetsSent: null == packetsSent
          ? _value.packetsSent
          : packetsSent // ignore: cast_nullable_to_non_nullable
              as int,
      packetsReceived: null == packetsReceived
          ? _value.packetsReceived
          : packetsReceived // ignore: cast_nullable_to_non_nullable
              as int,
      latencyMs: null == latencyMs
          ? _value.latencyMs
          : latencyMs // ignore: cast_nullable_to_non_nullable
              as double,
      packetLossPercent: null == packetLossPercent
          ? _value.packetLossPercent
          : packetLossPercent // ignore: cast_nullable_to_non_nullable
              as double,
      connectedSince: freezed == connectedSince
          ? _value.connectedSince
          : connectedSince // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$NetworkStatsImpl implements _NetworkStats {
  const _$NetworkStatsImpl(
      {this.bytesSent = 0,
      this.bytesReceived = 0,
      this.packetsSent = 0,
      this.packetsReceived = 0,
      this.latencyMs = 0,
      this.packetLossPercent = 0.0,
      this.connectedSince});

  factory _$NetworkStatsImpl.fromJson(Map<String, dynamic> json) =>
      _$$NetworkStatsImplFromJson(json);

  @override
  @JsonKey()
  final int bytesSent;
  @override
  @JsonKey()
  final int bytesReceived;
  @override
  @JsonKey()
  final int packetsSent;
  @override
  @JsonKey()
  final int packetsReceived;
  @override
  @JsonKey()
  final double latencyMs;
  @override
  @JsonKey()
  final double packetLossPercent;
  @override
  final DateTime? connectedSince;

  @override
  String toString() {
    return 'NetworkStats(bytesSent: $bytesSent, bytesReceived: $bytesReceived, packetsSent: $packetsSent, packetsReceived: $packetsReceived, latencyMs: $latencyMs, packetLossPercent: $packetLossPercent, connectedSince: $connectedSince)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$NetworkStatsImpl &&
            (identical(other.bytesSent, bytesSent) ||
                other.bytesSent == bytesSent) &&
            (identical(other.bytesReceived, bytesReceived) ||
                other.bytesReceived == bytesReceived) &&
            (identical(other.packetsSent, packetsSent) ||
                other.packetsSent == packetsSent) &&
            (identical(other.packetsReceived, packetsReceived) ||
                other.packetsReceived == packetsReceived) &&
            (identical(other.latencyMs, latencyMs) ||
                other.latencyMs == latencyMs) &&
            (identical(other.packetLossPercent, packetLossPercent) ||
                other.packetLossPercent == packetLossPercent) &&
            (identical(other.connectedSince, connectedSince) ||
                other.connectedSince == connectedSince));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, bytesSent, bytesReceived,
      packetsSent, packetsReceived, latencyMs, packetLossPercent, connectedSince);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$NetworkStatsImplCopyWith<_$NetworkStatsImpl> get copyWith =>
      __$$NetworkStatsImplCopyWithImpl<_$NetworkStatsImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$NetworkStatsImplToJson(
      this,
    );
  }
}

abstract class _NetworkStats implements NetworkStats {
  const factory _NetworkStats(
      {final int bytesSent,
      final int bytesReceived,
      final int packetsSent,
      final int packetsReceived,
      final double latencyMs,
      final double packetLossPercent,
      final DateTime? connectedSince}) = _$NetworkStatsImpl;

  factory _NetworkStats.fromJson(Map<String, dynamic> json) =
      _$NetworkStatsImpl.fromJson;

  @override
  int get bytesSent;
  @override
  int get bytesReceived;
  @override
  int get packetsSent;
  @override
  int get packetsReceived;
  @override
  double get latencyMs;
  @override
  double get packetLossPercent;
  @override
  DateTime? get connectedSince;
  @override
  @JsonKey(ignore: true)
  _$$NetworkStatsImplCopyWith<_$NetworkStatsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
