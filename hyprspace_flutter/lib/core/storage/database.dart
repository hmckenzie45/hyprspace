import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

part 'database.g.dart';

// --------------------------------------------------------------------------
// Tables
// --------------------------------------------------------------------------

/// Persisted peer entries.
class Peers extends Table {
  TextColumn get id => text()();
  TextColumn get name => text().nullable()();
  TextColumn get publicKey => text().nullable()();
  TextColumn get vpnIp => text()();
  DateTimeColumn get lastSeen => dateTime().nullable()();
  TextColumn get status => text().withDefault(const Constant('disconnected'))();

  @override
  Set<Column> get primaryKey => {id};
}

/// Structured log entries.
class LogEntries extends Table {
  IntColumn get rowId => integer().autoIncrement()();
  DateTimeColumn get timestamp => dateTime()();
  TextColumn get level => text()();
  TextColumn get message => text()();
  TextColumn get extra => text().nullable()();
}

// --------------------------------------------------------------------------
// Database
// --------------------------------------------------------------------------

@DriftDatabase(tables: [Peers, LogEntries])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  // -------- Peer operations --------

  /// Returns all stored peers.
  Future<List<Peer>> getAllPeers() => select(peers).get();

  /// Inserts or replaces a peer record.
  Future<void> upsertPeer(PeersCompanion companion) =>
      into(peers).insertOnConflictUpdate(companion);

  /// Removes a peer by [id].
  Future<int> deletePeer(String id) =>
      (delete(peers)..where((t) => t.id.equals(id))).go();

  // -------- Log operations --------

  /// Inserts a log entry.
  Future<void> insertLog(LogEntriesCompanion entry) =>
      into(logEntries).insert(entry);

  /// Returns the most recent [limit] log entries ordered by timestamp.
  Future<List<LogEntry>> getRecentLogs({int limit = 200}) {
    return (select(logEntries)
          ..orderBy([(t) => OrderingTerm.desc(t.timestamp)])
          ..limit(limit))
        .get();
  }

  /// Clears all log entries.
  Future<int> clearLogs() => delete(logEntries).go();
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dir = await getApplicationSupportDirectory();
    final file = File(p.join(dir.path, 'hyprspace.db'));
    return NativeDatabase.createInBackground(file);
  });
}
