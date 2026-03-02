import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';

import '../utils/logger.dart';
import 'config_model.dart';

/// Manages persistence and retrieval of [HyprspaceConfig].
class ConfigRepository {
  static const String _configFileName = 'hyprspace_config.json';

  /// Loads the configuration from disk. Returns null if none exists.
  Future<HyprspaceConfig?> load() async {
    try {
      final file = await _configFile();
      if (!file.existsSync()) return null;
      final contents = await file.readAsString();
      final json = jsonDecode(contents) as Map<String, dynamic>;
      return HyprspaceConfig.fromJson(json);
    } catch (e, st) {
      AppLogger.error('Failed to load config', e, st);
      return null;
    }
  }

  /// Persists [config] to disk.
  Future<void> save(HyprspaceConfig config) async {
    try {
      final file = await _configFile();
      await file.parent.create(recursive: true);
      await file.writeAsString(jsonEncode(config.toJson()), flush: true);
    } catch (e, st) {
      AppLogger.error('Failed to save config', e, st);
      rethrow;
    }
  }

  /// Deletes the persisted configuration file.
  Future<void> delete() async {
    final file = await _configFile();
    if (file.existsSync()) {
      await file.delete();
    }
  }

  Future<File> _configFile() async {
    final dir = await getApplicationSupportDirectory();
    return File('${dir.path}${Platform.pathSeparator}$_configFileName');
  }
}
