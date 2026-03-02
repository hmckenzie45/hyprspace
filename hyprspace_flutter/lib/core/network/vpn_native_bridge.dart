import 'dart:ffi';
import 'dart:io';
import 'dart:typed_data';

import 'package:ffi/ffi.dart';

import '../utils/logger.dart';
import '../utils/platform_utils.dart';

// --------------------------------------------------------------------------
// Native function typedefs
// --------------------------------------------------------------------------

typedef _HyprspaceInitNative = Int32 Function();
typedef _HyprspaceInitDart = int Function();

typedef _HyprspaceStartNodeNative = Int32 Function(
  Pointer<Utf8> privateKey,
  Int32 listenPort,
);
typedef _HyprspaceStartNodeDart = int Function(
  Pointer<Utf8> privateKey,
  int listenPort,
);

typedef _HyprspaceStopNodeNative = Void Function();
typedef _HyprspaceStopNodeDart = void Function();

typedef _HyprspaceAddPeerNative = Int32 Function(
  Pointer<Utf8> peerId,
  Pointer<Utf8> peerIp,
);
typedef _HyprspaceAddPeerDart = int Function(
  Pointer<Utf8> peerId,
  Pointer<Utf8> peerIp,
);

typedef _HyprspaceRemovePeerNative = Int32 Function(Pointer<Utf8> peerId);
typedef _HyprspaceRemovePeerDart = int Function(Pointer<Utf8> peerId);

typedef _HyprspaceSendPacketNative = Int32 Function(
  Pointer<Uint8> data,
  Int32 length,
);
typedef _HyprspaceSendPacketDart = int Function(
  Pointer<Uint8> data,
  int length,
);

typedef _HyprspaceReceivePacketNative = Int32 Function(
  Pointer<Uint8> buffer,
  Int32 bufferSize,
);
typedef _HyprspaceReceivePacketDart = int Function(
  Pointer<Uint8> buffer,
  int bufferSize,
);

typedef _HyprspaceGetStatsBytesNative = Void Function(
  Pointer<Int64> bytesSent,
  Pointer<Int64> bytesReceived,
);
typedef _HyprspaceGetStatsBytesDart = void Function(
  Pointer<Int64> bytesSent,
  Pointer<Int64> bytesReceived,
);

typedef _HyprspaceCreateTunNative = Int32 Function(
  Pointer<Utf8> name,
  Pointer<Utf8> address,
  Int32 mtu,
);
typedef _HyprspaceCreateTunDart = int Function(
  Pointer<Utf8> name,
  Pointer<Utf8> address,
  int mtu,
);

// --------------------------------------------------------------------------
// VpnNativeBridge
// --------------------------------------------------------------------------

/// FFI bindings to the Go-compiled Hyprspace native library.
///
/// The shared library is compiled from `native/go/hyprspace_bridge.go` using
/// `go build -buildmode=c-shared`.
class VpnNativeBridge {
  static VpnNativeBridge? _instance;

  late final DynamicLibrary _lib;
  late final _HyprspaceInitDart _init;
  late final _HyprspaceStartNodeDart _startNode;
  late final _HyprspaceStopNodeDart _stopNode;
  late final _HyprspaceAddPeerDart _addPeer;
  late final _HyprspaceRemovePeerDart _removePeer;
  late final _HyprspaceSendPacketDart _sendPacket;
  late final _HyprspaceReceivePacketDart _receivePacket;
  late final _HyprspaceGetStatsBytesDart _getStatsBytes;
  late final _HyprspaceCreateTunDart _createTun;

  bool _initialized = false;

  VpnNativeBridge._();

  /// Returns the singleton instance of [VpnNativeBridge].
  static VpnNativeBridge get instance {
    _instance ??= VpnNativeBridge._();
    return _instance!;
  }

  /// Loads the native library and binds function symbols.
  ///
  /// Must be called once before any other method.
  void load() {
    if (_initialized) return;
    try {
      _lib = _openLibrary();
      _init = _lib
          .lookupFunction<_HyprspaceInitNative, _HyprspaceInitDart>(
              'hyprspace_init');
      _startNode = _lib
          .lookupFunction<_HyprspaceStartNodeNative, _HyprspaceStartNodeDart>(
              'hyprspace_start_node');
      _stopNode = _lib
          .lookupFunction<_HyprspaceStopNodeNative, _HyprspaceStopNodeDart>(
              'hyprspace_stop_node');
      _addPeer = _lib
          .lookupFunction<_HyprspaceAddPeerNative, _HyprspaceAddPeerDart>(
              'hyprspace_add_peer');
      _removePeer = _lib
          .lookupFunction<_HyprspaceRemovePeerNative, _HyprspaceRemovePeerDart>(
              'hyprspace_remove_peer');
      _sendPacket = _lib
          .lookupFunction<_HyprspaceSendPacketNative, _HyprspaceSendPacketDart>(
              'hyprspace_send_packet');
      _receivePacket = _lib.lookupFunction<_HyprspaceReceivePacketNative,
          _HyprspaceReceivePacketDart>('hyprspace_receive_packet');
      _getStatsBytes = _lib.lookupFunction<_HyprspaceGetStatsBytesNative,
          _HyprspaceGetStatsBytesDart>('hyprspace_get_stats_bytes');
      _createTun = _lib
          .lookupFunction<_HyprspaceCreateTunNative, _HyprspaceCreateTunDart>(
              'hyprspace_create_tun');
      _initialized = true;
      AppLogger.info('Native library loaded successfully');
    } catch (e, st) {
      AppLogger.error('Failed to load native library', e, st);
      rethrow;
    }
  }

  /// Initializes the native library. Returns 0 on success.
  int init() => _init();

  /// Starts the libp2p node with the given private key and listen port.
  int startNode(String privateKey, int listenPort) {
    final pkPtr = privateKey.toNativeUtf8();
    try {
      return _startNode(pkPtr, listenPort);
    } finally {
      malloc.free(pkPtr);
    }
  }

  /// Stops the running libp2p node and releases resources.
  void stopNode() => _stopNode();

  /// Adds a peer to the routing table.
  ///
  /// Returns 0 on success, non-zero on error.
  int addPeer(String peerId, String peerIp) {
    final idPtr = peerId.toNativeUtf8();
    final ipPtr = peerIp.toNativeUtf8();
    try {
      return _addPeer(idPtr, ipPtr);
    } finally {
      malloc.free(idPtr);
      malloc.free(ipPtr);
    }
  }

  /// Removes a peer from the routing table.
  int removePeer(String peerId) {
    final idPtr = peerId.toNativeUtf8();
    try {
      return _removePeer(idPtr);
    } finally {
      malloc.free(idPtr);
    }
  }

  /// Sends a raw IP packet through the libp2p stream.
  int sendPacket(Uint8List data) {
    final ptr = malloc<Uint8>(data.length);
    try {
      ptr.asTypedList(data.length).setAll(0, data);
      return _sendPacket(ptr, data.length);
    } finally {
      malloc.free(ptr);
    }
  }

  /// Receives a raw IP packet from the libp2p stream into [buffer].
  ///
  /// Returns the number of bytes written, or -1 on error.
  int receivePacket(Uint8List buffer) {
    final ptr = malloc<Uint8>(buffer.length);
    try {
      final bytesRead = _receivePacket(ptr, buffer.length);
      if (bytesRead > 0) {
        buffer.setAll(0, ptr.asTypedList(bytesRead));
      }
      return bytesRead;
    } finally {
      malloc.free(ptr);
    }
  }

  /// Returns the number of bytes sent and received since node start.
  ({int bytesSent, int bytesReceived}) getStatsBytes() {
    final sentPtr = malloc<Int64>();
    final recvPtr = malloc<Int64>();
    try {
      _getStatsBytes(sentPtr, recvPtr);
      return (bytesSent: sentPtr.value, bytesReceived: recvPtr.value);
    } finally {
      malloc.free(sentPtr);
      malloc.free(recvPtr);
    }
  }

  /// Creates a TUN device with the given name, IP address and MTU.
  int createTun(String name, String address, int mtu) {
    final namePtr = name.toNativeUtf8();
    final addrPtr = address.toNativeUtf8();
    try {
      return _createTun(namePtr, addrPtr, mtu);
    } finally {
      malloc.free(namePtr);
      malloc.free(addrPtr);
    }
  }

  // -----------------------------------------------------------------------
  // Private helpers
  // -----------------------------------------------------------------------

  DynamicLibrary _openLibrary() {
    if (PlatformUtils.isLinux) {
      return DynamicLibrary.open('libhyprspace.so');
    } else if (PlatformUtils.isWindows) {
      return DynamicLibrary.open('hyprspace.dll');
    } else if (PlatformUtils.isAndroid) {
      return DynamicLibrary.open('libhyprspace.so');
    }
    throw UnsupportedError(
        'Unsupported platform: ${Platform.operatingSystem}');
  }
}
