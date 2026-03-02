import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../utils/logger.dart';

/// Provides encrypted key/value storage backed by the platform's secure store.
///
/// On Linux/Windows this uses the OS credential store via flutter_secure_storage.
/// On Android it uses the Android Keystore.
class SecureStorage {
  static const String _privateKeyKey = 'hyprspace_private_key';
  static const String _configEncKeyKey = 'hyprspace_config_enc_key';

  final FlutterSecureStorage _storage;

  SecureStorage({FlutterSecureStorage? storage})
      : _storage = storage ?? const FlutterSecureStorage();

  /// Reads the stored private key, or null if none exists.
  Future<String?> readPrivateKey() async {
    try {
      return await _storage.read(key: _privateKeyKey);
    } catch (e, st) {
      AppLogger.error('SecureStorage.readPrivateKey failed', e, st);
      return null;
    }
  }

  /// Persists [privateKey] in secure storage.
  Future<void> writePrivateKey(String privateKey) async {
    try {
      await _storage.write(key: _privateKeyKey, value: privateKey);
    } catch (e, st) {
      AppLogger.error('SecureStorage.writePrivateKey failed', e, st);
      rethrow;
    }
  }

  /// Deletes the private key from secure storage.
  Future<void> deletePrivateKey() async {
    try {
      await _storage.delete(key: _privateKeyKey);
    } catch (e, st) {
      AppLogger.error('SecureStorage.deletePrivateKey failed', e, st);
    }
  }

  /// Reads the config encryption key, or null if none exists.
  Future<String?> readConfigEncKey() async {
    try {
      return await _storage.read(key: _configEncKeyKey);
    } catch (e, st) {
      AppLogger.error('SecureStorage.readConfigEncKey failed', e, st);
      return null;
    }
  }

  /// Persists [encKey] in secure storage.
  Future<void> writeConfigEncKey(String encKey) async {
    try {
      await _storage.write(key: _configEncKeyKey, value: encKey);
    } catch (e, st) {
      AppLogger.error('SecureStorage.writeConfigEncKey failed', e, st);
      rethrow;
    }
  }

  /// Deletes all Hyprspace-managed secure storage entries.
  Future<void> deleteAll() async {
    try {
      await _storage.deleteAll();
    } catch (e, st) {
      AppLogger.error('SecureStorage.deleteAll failed', e, st);
    }
  }
}
