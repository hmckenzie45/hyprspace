// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// **************************************************************************
// DriftDatabaseGenerator
// **************************************************************************

// ignore_for_file: type=lint
class Peer extends DataClass implements Insertable<Peer> {
  final String id;
  final String? name;
  final String? publicKey;
  final String vpnIp;
  final DateTime? lastSeen;
  final String status;
  const Peer(
      {required this.id,
      this.name,
      this.publicKey,
      required this.vpnIp,
      this.lastSeen,
      required this.status});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    if (!nullToAbsent || name != null) {
      map['name'] = Variable<String>(name);
    }
    if (!nullToAbsent || publicKey != null) {
      map['public_key'] = Variable<String>(publicKey);
    }
    map['vpn_ip'] = Variable<String>(vpnIp);
    if (!nullToAbsent || lastSeen != null) {
      map['last_seen'] = Variable<DateTime>(lastSeen);
    }
    map['status'] = Variable<String>(status);
    return map;
  }

  PeersCompanion toCompanion(bool nullToAbsent) {
    return PeersCompanion(
      id: Value(id),
      name: name == null && nullToAbsent ? const Value.absent() : Value(name),
      publicKey: publicKey == null && nullToAbsent
          ? const Value.absent()
          : Value(publicKey),
      vpnIp: Value(vpnIp),
      lastSeen: lastSeen == null && nullToAbsent
          ? const Value.absent()
          : Value(lastSeen),
      status: Value(status),
    );
  }

  factory Peer.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Peer(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String?>(json['name']),
      publicKey: serializer.fromJson<String?>(json['publicKey']),
      vpnIp: serializer.fromJson<String>(json['vpnIp']),
      lastSeen: serializer.fromJson<DateTime?>(json['lastSeen']),
      status: serializer.fromJson<String>(json['status']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String?>(name),
      'publicKey': serializer.toJson<String?>(publicKey),
      'vpnIp': serializer.toJson<String>(vpnIp),
      'lastSeen': serializer.toJson<DateTime?>(lastSeen),
      'status': serializer.toJson<String>(status),
    };
  }

  Peer copyWith(
          {String? id,
          Value<String?> name = const Value.absent(),
          Value<String?> publicKey = const Value.absent(),
          String? vpnIp,
          Value<DateTime?> lastSeen = const Value.absent(),
          String? status}) =>
      Peer(
        id: id ?? this.id,
        name: name.present ? name.value : this.name,
        publicKey: publicKey.present ? publicKey.value : this.publicKey,
        vpnIp: vpnIp ?? this.vpnIp,
        lastSeen: lastSeen.present ? lastSeen.value : this.lastSeen,
        status: status ?? this.status,
      );
  @override
  String toString() {
    return (StringBuffer('Peer(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('publicKey: $publicKey, ')
          ..write('vpnIp: $vpnIp, ')
          ..write('lastSeen: $lastSeen, ')
          ..write('status: $status')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, name, publicKey, vpnIp, lastSeen, status);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Peer &&
          other.id == this.id &&
          other.name == this.name &&
          other.publicKey == this.publicKey &&
          other.vpnIp == this.vpnIp &&
          other.lastSeen == this.lastSeen &&
          other.status == this.status);
}

class PeersCompanion extends UpdateCompanion<Peer> {
  final Value<String> id;
  final Value<String?> name;
  final Value<String?> publicKey;
  final Value<String> vpnIp;
  final Value<DateTime?> lastSeen;
  final Value<String> status;
  const PeersCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.publicKey = const Value.absent(),
    this.vpnIp = const Value.absent(),
    this.lastSeen = const Value.absent(),
    this.status = const Value.absent(),
  });
  PeersCompanion.insert({
    required String id,
    this.name = const Value.absent(),
    this.publicKey = const Value.absent(),
    required String vpnIp,
    this.lastSeen = const Value.absent(),
    this.status = const Value.absent(),
  })  : id = Value(id),
        vpnIp = Value(vpnIp);
  static Insertable<Peer> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? publicKey,
    Expression<String>? vpnIp,
    Expression<DateTime>? lastSeen,
    Expression<String>? status,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (publicKey != null) 'public_key': publicKey,
      if (vpnIp != null) 'vpn_ip': vpnIp,
      if (lastSeen != null) 'last_seen': lastSeen,
      if (status != null) 'status': status,
    });
  }

  PeersCompanion copyWith(
      {Value<String>? id,
      Value<String?>? name,
      Value<String?>? publicKey,
      Value<String>? vpnIp,
      Value<DateTime?>? lastSeen,
      Value<String>? status}) {
    return PeersCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      publicKey: publicKey ?? this.publicKey,
      vpnIp: vpnIp ?? this.vpnIp,
      lastSeen: lastSeen ?? this.lastSeen,
      status: status ?? this.status,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (publicKey.present) {
      map['public_key'] = Variable<String>(publicKey.value);
    }
    if (vpnIp.present) {
      map['vpn_ip'] = Variable<String>(vpnIp.value);
    }
    if (lastSeen.present) {
      map['last_seen'] = Variable<DateTime>(lastSeen.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PeersCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('publicKey: $publicKey, ')
          ..write('vpnIp: $vpnIp, ')
          ..write('lastSeen: $lastSeen, ')
          ..write('status: $status')
          ..write(')'))
        .toString();
  }
}

class $PeersTable extends Peers with TableInfo<$PeersTable, Peer> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PeersTable(this.attachedDatabase, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  final VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  final VerificationMeta _publicKeyMeta = const VerificationMeta('publicKey');
  @override
  late final GeneratedColumn<String> publicKey = GeneratedColumn<String>(
      'public_key', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  final VerificationMeta _vpnIpMeta = const VerificationMeta('vpnIp');
  @override
  late final GeneratedColumn<String> vpnIp = GeneratedColumn<String>(
      'vpn_ip', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  final VerificationMeta _lastSeenMeta = const VerificationMeta('lastSeen');
  @override
  late final GeneratedColumn<DateTime> lastSeen = GeneratedColumn<DateTime>(
      'last_seen', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  final VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
      'status', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('disconnected'));
  @override
  List<GeneratedColumn> get $columns =>
      [id, name, publicKey, vpnIp, lastSeen, status];
  @override
  String get aliasedName => _alias ?? 'peers';
  @override
  String get actualTableName => 'peers';
  @override
  VerificationContext validateIntegrity(Insertable<Peer> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    }
    if (data.containsKey('public_key')) {
      context.handle(_publicKeyMeta,
          publicKey.isAcceptableOrUnknown(data['public_key']!, _publicKeyMeta));
    }
    if (data.containsKey('vpn_ip')) {
      context.handle(
          _vpnIpMeta, vpnIp.isAcceptableOrUnknown(data['vpn_ip']!, _vpnIpMeta));
    } else if (isInserting) {
      context.missing(_vpnIpMeta);
    }
    if (data.containsKey('last_seen')) {
      context.handle(_lastSeenMeta,
          lastSeen.isAcceptableOrUnknown(data['last_seen']!, _lastSeenMeta));
    }
    if (data.containsKey('status')) {
      context.handle(
          _statusMeta, status.isAcceptableOrUnknown(data['status']!, _statusMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Peer map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Peer(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name']),
      publicKey: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}public_key']),
      vpnIp: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}vpn_ip'])!,
      lastSeen: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}last_seen']),
      status: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}status'])!,
    );
  }

  @override
  $PeersTable createAlias(String alias) {
    return $PeersTable(attachedDatabase, alias);
  }
}

class LogEntry extends DataClass implements Insertable<LogEntry> {
  final int rowId;
  final DateTime timestamp;
  final String level;
  final String message;
  final String? extra;
  const LogEntry(
      {required this.rowId,
      required this.timestamp,
      required this.level,
      required this.message,
      this.extra});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['row_id'] = Variable<int>(rowId);
    map['timestamp'] = Variable<DateTime>(timestamp);
    map['level'] = Variable<String>(level);
    map['message'] = Variable<String>(message);
    if (!nullToAbsent || extra != null) {
      map['extra'] = Variable<String>(extra);
    }
    return map;
  }

  LogEntriesCompanion toCompanion(bool nullToAbsent) {
    return LogEntriesCompanion(
      rowId: Value(rowId),
      timestamp: Value(timestamp),
      level: Value(level),
      message: Value(message),
      extra:
          extra == null && nullToAbsent ? const Value.absent() : Value(extra),
    );
  }

  factory LogEntry.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LogEntry(
      rowId: serializer.fromJson<int>(json['rowId']),
      timestamp: serializer.fromJson<DateTime>(json['timestamp']),
      level: serializer.fromJson<String>(json['level']),
      message: serializer.fromJson<String>(json['message']),
      extra: serializer.fromJson<String?>(json['extra']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'rowId': serializer.toJson<int>(rowId),
      'timestamp': serializer.toJson<DateTime>(timestamp),
      'level': serializer.toJson<String>(level),
      'message': serializer.toJson<String>(message),
      'extra': serializer.toJson<String?>(extra),
    };
  }

  LogEntry copyWith(
          {int? rowId,
          DateTime? timestamp,
          String? level,
          String? message,
          Value<String?> extra = const Value.absent()}) =>
      LogEntry(
        rowId: rowId ?? this.rowId,
        timestamp: timestamp ?? this.timestamp,
        level: level ?? this.level,
        message: message ?? this.message,
        extra: extra.present ? extra.value : this.extra,
      );
  @override
  String toString() {
    return (StringBuffer('LogEntry(')
          ..write('rowId: $rowId, ')
          ..write('timestamp: $timestamp, ')
          ..write('level: $level, ')
          ..write('message: $message, ')
          ..write('extra: $extra')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(rowId, timestamp, level, message, extra);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LogEntry &&
          other.rowId == this.rowId &&
          other.timestamp == this.timestamp &&
          other.level == this.level &&
          other.message == this.message &&
          other.extra == this.extra);
}

class LogEntriesCompanion extends UpdateCompanion<LogEntry> {
  final Value<int> rowId;
  final Value<DateTime> timestamp;
  final Value<String> level;
  final Value<String> message;
  final Value<String?> extra;
  const LogEntriesCompanion({
    this.rowId = const Value.absent(),
    this.timestamp = const Value.absent(),
    this.level = const Value.absent(),
    this.message = const Value.absent(),
    this.extra = const Value.absent(),
  });
  LogEntriesCompanion.insert({
    this.rowId = const Value.absent(),
    required DateTime timestamp,
    required String level,
    required String message,
    this.extra = const Value.absent(),
  })  : timestamp = Value(timestamp),
        level = Value(level),
        message = Value(message);
  static Insertable<LogEntry> custom({
    Expression<int>? rowId,
    Expression<DateTime>? timestamp,
    Expression<String>? level,
    Expression<String>? message,
    Expression<String>? extra,
  }) {
    return RawValuesInsertable({
      if (rowId != null) 'row_id': rowId,
      if (timestamp != null) 'timestamp': timestamp,
      if (level != null) 'level': level,
      if (message != null) 'message': message,
      if (extra != null) 'extra': extra,
    });
  }

  LogEntriesCompanion copyWith(
      {Value<int>? rowId,
      Value<DateTime>? timestamp,
      Value<String>? level,
      Value<String>? message,
      Value<String?>? extra}) {
    return LogEntriesCompanion(
      rowId: rowId ?? this.rowId,
      timestamp: timestamp ?? this.timestamp,
      level: level ?? this.level,
      message: message ?? this.message,
      extra: extra ?? this.extra,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (rowId.present) {
      map['row_id'] = Variable<int>(rowId.value);
    }
    if (timestamp.present) {
      map['timestamp'] = Variable<DateTime>(timestamp.value);
    }
    if (level.present) {
      map['level'] = Variable<String>(level.value);
    }
    if (message.present) {
      map['message'] = Variable<String>(message.value);
    }
    if (extra.present) {
      map['extra'] = Variable<String>(extra.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LogEntriesCompanion(')
          ..write('rowId: $rowId, ')
          ..write('timestamp: $timestamp, ')
          ..write('level: $level, ')
          ..write('message: $message, ')
          ..write('extra: $extra')
          ..write(')'))
        .toString();
  }
}

class $LogEntriesTable extends LogEntries
    with TableInfo<$LogEntriesTable, LogEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LogEntriesTable(this.attachedDatabase, [this._alias]);
  final VerificationMeta _rowIdMeta = const VerificationMeta('rowId');
  @override
  late final GeneratedColumn<int> rowId = GeneratedColumn<int>(
      'row_id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  final VerificationMeta _timestampMeta = const VerificationMeta('timestamp');
  @override
  late final GeneratedColumn<DateTime> timestamp = GeneratedColumn<DateTime>(
      'timestamp', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  final VerificationMeta _levelMeta = const VerificationMeta('level');
  @override
  late final GeneratedColumn<String> level = GeneratedColumn<String>(
      'level', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  final VerificationMeta _messageMeta = const VerificationMeta('message');
  @override
  late final GeneratedColumn<String> message = GeneratedColumn<String>(
      'message', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  final VerificationMeta _extraMeta = const VerificationMeta('extra');
  @override
  late final GeneratedColumn<String> extra = GeneratedColumn<String>(
      'extra', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns =>
      [rowId, timestamp, level, message, extra];
  @override
  String get aliasedName => _alias ?? 'log_entries';
  @override
  String get actualTableName => 'log_entries';
  @override
  VerificationContext validateIntegrity(Insertable<LogEntry> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('row_id')) {
      context.handle(
          _rowIdMeta, rowId.isAcceptableOrUnknown(data['row_id']!, _rowIdMeta));
    }
    if (data.containsKey('timestamp')) {
      context.handle(_timestampMeta,
          timestamp.isAcceptableOrUnknown(data['timestamp']!, _timestampMeta));
    } else if (isInserting) {
      context.missing(_timestampMeta);
    }
    if (data.containsKey('level')) {
      context.handle(
          _levelMeta, level.isAcceptableOrUnknown(data['level']!, _levelMeta));
    } else if (isInserting) {
      context.missing(_levelMeta);
    }
    if (data.containsKey('message')) {
      context.handle(_messageMeta,
          message.isAcceptableOrUnknown(data['message']!, _messageMeta));
    } else if (isInserting) {
      context.missing(_messageMeta);
    }
    if (data.containsKey('extra')) {
      context.handle(
          _extraMeta, extra.isAcceptableOrUnknown(data['extra']!, _extraMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {rowId};
  @override
  LogEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LogEntry(
      rowId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}row_id'])!,
      timestamp: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}timestamp'])!,
      level: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}level'])!,
      message: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}message'])!,
      extra: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}extra']),
    );
  }

  @override
  $LogEntriesTable createAlias(String alias) {
    return $LogEntriesTable(attachedDatabase, alias);
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  late final $PeersTable peers = $PeersTable(this);
  late final $LogEntriesTable logEntries = $LogEntriesTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [peers, logEntries];
}
