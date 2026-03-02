import 'dart:typed_data';

import 'package:cryptography/cryptography.dart';

import '../utils/logger.dart';

/// Manages cryptographic key generation and operations for Hyprspace.
class CryptoManager {
  static final CryptoManager _instance = CryptoManager._internal();
  factory CryptoManager() => _instance;
  CryptoManager._internal();

  final _algorithm = Ed25519();

  /// Generates a new Ed25519 key pair.
  ///
  /// Returns a map with 'privateKey' and 'publicKey' as base64-encoded strings.
  Future<Map<String, String>> generateKeyPair() async {
    try {
      final keyPair = await _algorithm.newKeyPair();
      final privateKeyBytes = await keyPair.extractPrivateKeyBytes();
      final publicKey = await keyPair.extractPublicKey();
      final publicKeyBytes = publicKey.bytes;

      return {
        'privateKey': _bytesToBase64(Uint8List.fromList(privateKeyBytes)),
        'publicKey': _bytesToBase64(Uint8List.fromList(publicKeyBytes)),
      };
    } catch (e, st) {
      AppLogger.error('Key pair generation failed', e, st);
      rethrow;
    }
  }

  /// Signs [data] using the given base64-encoded [privateKeyBase64].
  Future<Uint8List> sign(Uint8List data, String privateKeyBase64) async {
    try {
      final privateKeyBytes = _base64ToBytes(privateKeyBase64);
      final keyPair = await _algorithm.newKeyPairFromSeed(privateKeyBytes);
      final signature = await _algorithm.sign(data, keyPair: keyPair);
      return Uint8List.fromList(signature.bytes);
    } catch (e, st) {
      AppLogger.error('Signing failed', e, st);
      rethrow;
    }
  }

  /// Verifies [signature] on [data] using the given base64-encoded [publicKeyBase64].
  Future<bool> verify(
    Uint8List data,
    Uint8List signature,
    String publicKeyBase64,
  ) async {
    try {
      final publicKeyBytes = _base64ToBytes(publicKeyBase64);
      final publicKey = SimplePublicKey(publicKeyBytes, type: KeyPairType.ed25519);
      final sig = Signature(signature, publicKey: publicKey);
      return await _algorithm.verify(data, signature: sig);
    } catch (e, st) {
      AppLogger.error('Verification failed', e, st);
      return false;
    }
  }

  /// Derives a peer ID string from a base64-encoded public key.
  String peerIdFromPublicKey(String publicKeyBase64) {
    final bytes = _base64ToBytes(publicKeyBase64);
    // Simple hex encoding of the public key as peer ID placeholder.
    return bytes.map((b) => b.toRadixString(16).padLeft(2, '0')).join();
  }

  String _bytesToBase64(Uint8List bytes) {
    const chars =
        'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/';
    final buffer = StringBuffer();
    for (var i = 0; i < bytes.length; i += 3) {
      final remaining = bytes.length - i;
      final b0 = bytes[i];
      final b1 = remaining > 1 ? bytes[i + 1] : 0;
      final b2 = remaining > 2 ? bytes[i + 2] : 0;
      buffer.write(chars[(b0 >> 2) & 0x3F]);
      buffer.write(chars[((b0 << 4) | (b1 >> 4)) & 0x3F]);
      buffer.write(remaining > 1 ? chars[((b1 << 2) | (b2 >> 6)) & 0x3F] : '=');
      buffer.write(remaining > 2 ? chars[b2 & 0x3F] : '=');
    }
    return buffer.toString();
  }

  Uint8List _base64ToBytes(String base64) {
    const chars =
        'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/';
    final bytes = <int>[];
    var padding = 0;
    for (var i = 0; i < base64.length; i += 4) {
      final c0 = chars.indexOf(base64[i]);
      final c1 = chars.indexOf(base64[i + 1]);
      final c2 = base64[i + 2] == '=' ? 0 : chars.indexOf(base64[i + 2]);
      final c3 = base64[i + 3] == '=' ? 0 : chars.indexOf(base64[i + 3]);
      if (base64[i + 2] == '=') padding++;
      if (base64[i + 3] == '=') padding++;
      bytes.add(((c0 << 2) | (c1 >> 4)) & 0xFF);
      if (base64[i + 2] != '=') bytes.add(((c1 << 4) | (c2 >> 2)) & 0xFF);
      if (base64[i + 3] != '=') bytes.add(((c2 << 6) | c3) & 0xFF);
    }
    return Uint8List.fromList(bytes);
  }
}
