import 'dart:io';

/// Input validation helpers used across the application.
class Validators {
  Validators._();

  /// Returns an error message if [ip] is not a valid IPv4 address, otherwise
  /// null.
  static String? validateIpAddress(String? ip) {
    if (ip == null || ip.isEmpty) return 'IP address is required';
    final parts = ip.split('.');
    if (parts.length != 4) return 'Invalid IPv4 address';
    for (final part in parts) {
      final n = int.tryParse(part);
      if (n == null || n < 0 || n > 255) return 'Invalid IPv4 address';
    }
    return null;
  }

  /// Returns an error message if [cidr] is not a valid CIDR notation (e.g.
  /// `10.1.1.1/24`), otherwise null.
  static String? validateCidr(String? cidr) {
    if (cidr == null || cidr.isEmpty) return 'CIDR address is required';
    final parts = cidr.split('/');
    if (parts.length != 2) return 'Invalid CIDR notation (expected x.x.x.x/n)';
    final ipError = validateIpAddress(parts[0]);
    if (ipError != null) return ipError;
    final prefix = int.tryParse(parts[1]);
    if (prefix == null || prefix < 0 || prefix > 32) {
      return 'Invalid prefix length (0–32)';
    }
    return null;
  }

  /// Returns an error message if [port] is outside the valid range 1–65535,
  /// otherwise null.
  static String? validatePort(int? port) {
    if (port == null) return 'Port is required';
    if (port < 1 || port > 65535) return 'Port must be between 1 and 65535';
    return null;
  }

  /// Returns an error message if [peerId] looks invalid (empty or too short),
  /// otherwise null.
  static String? validatePeerId(String? peerId) {
    if (peerId == null || peerId.trim().isEmpty) return 'Peer ID is required';
    if (peerId.trim().length < 10) {
      return 'Peer ID appears to be too short';
    }
    return null;
  }

  /// Returns an error message if [name] is empty, otherwise null.
  static String? validateInterfaceName(String? name) {
    if (name == null || name.trim().isEmpty) {
      return 'Interface name is required';
    }
    if (!RegExp(r'^[a-zA-Z0-9_\-]+$').hasMatch(name.trim())) {
      return 'Interface name may only contain letters, digits, _ and -';
    }
    return null;
  }

  /// Returns true if [key] is a non-empty base64-encoded string of at least
  /// 32 bytes when decoded.
  static bool isValidBase64Key(String? key) {
    if (key == null || key.isEmpty) return false;
    try {
      final decoded = _decodeBase64(key);
      return decoded.length >= 32;
    } catch (_) {
      return false;
    }
  }

  static List<int> _decodeBase64(String input) {
    const chars =
        'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/';
    final bytes = <int>[];
    final sanitized = input.replaceAll(RegExp(r'\s'), '');
    for (var i = 0; i < sanitized.length; i += 4) {
      if (i + 4 > sanitized.length) break;
      final c0 = chars.indexOf(sanitized[i]);
      final c1 = chars.indexOf(sanitized[i + 1]);
      final c2 =
          sanitized[i + 2] == '=' ? 0 : chars.indexOf(sanitized[i + 2]);
      final c3 =
          sanitized[i + 3] == '=' ? 0 : chars.indexOf(sanitized[i + 3]);
      bytes.add(((c0 << 2) | (c1 >> 4)) & 0xFF);
      if (sanitized[i + 2] != '=') bytes.add(((c1 << 4) | (c2 >> 2)) & 0xFF);
      if (sanitized[i + 3] != '=') bytes.add(((c2 << 6) | c3) & 0xFF);
    }
    return bytes;
  }
}
