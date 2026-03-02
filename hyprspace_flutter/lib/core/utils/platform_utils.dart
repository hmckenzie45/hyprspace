import 'dart:io';

/// Utility helpers for platform detection.
class PlatformUtils {
  PlatformUtils._();

  /// Returns true when running on Linux desktop.
  static bool get isLinux => Platform.isLinux;

  /// Returns true when running on Windows desktop.
  static bool get isWindows => Platform.isWindows;

  /// Returns true when running on macOS desktop.
  static bool get isMacOS => Platform.isMacOS;

  /// Returns true when running on Android.
  static bool get isAndroid => Platform.isAndroid;

  /// Returns true when running on iOS.
  static bool get isIOS => Platform.isIOS;

  /// Returns true when running on a desktop operating system.
  static bool get isDesktop => isLinux || isWindows || isMacOS;

  /// Returns true when running on a mobile operating system.
  static bool get isMobile => isAndroid || isIOS;

  /// Returns a human-readable platform name.
  static String get platformName => Platform.operatingSystem;

  /// Returns true if the current platform supports native TUN devices
  /// via the Go FFI bridge (Linux, Windows, Android).
  static bool get supportsTunDevice => isLinux || isWindows || isAndroid;
}
