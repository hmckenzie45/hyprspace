# Hyprspace Flutter

A production-ready cross-platform VPN application built with Flutter and Dart, powered by [libp2p](https://libp2p.io/) peer-to-peer networking.

## Platform Support

| Platform | Status | Notes |
|----------|--------|-------|
| Linux | ✅ | Native TUN device via netlink |
| Windows | ✅ | TUN adapter via Wintun/netsh |
| Android | ✅ | VpnService API (no root required) |

## Architecture

```
hyprspace_flutter/
├── lib/
│   ├── main.dart                     # App entry point
│   ├── app_router.dart               # GoRouter navigation
│   ├── core/
│   │   ├── network/
│   │   │   ├── vpn_service.dart      # Main VPN service (Riverpod Notifier)
│   │   │   ├── vpn_native_bridge.dart# FFI bindings to Go shared library
│   │   │   ├── connection_manager.dart# Peer lifecycle + reconnection
│   │   │   └── packet_handler.dart   # TUN ↔ libp2p packet I/O
│   │   ├── config/
│   │   │   ├── config_model.dart     # Immutable Freezed models
│   │   │   ├── config_repository.dart# JSON persistence
│   │   │   └── crypto_manager.dart   # Ed25519 key management
│   │   ├── storage/
│   │   │   ├── database.dart         # Drift SQLite database
│   │   │   └── secure_storage.dart   # Platform keystore integration
│   │   └── utils/
│   │       ├── logger.dart           # Structured logging
│   │       ├── validators.dart       # Input validation
│   │       └── platform_utils.dart   # Platform detection
│   ├── features/
│   │   ├── home/                     # Connection toggle & stats
│   │   ├── peers/                    # Peer management
│   │   ├── settings/                 # Interface & security configuration
│   │   └── logs/                     # Real-time log viewer
│   └── shared/                       # Reusable widgets & theme
├── native/
│   ├── go/
│   │   ├── hyprspace_bridge.go       # Go FFI shared library
│   │   ├── tun_linux.go              # Linux TUN (water + netlink)
│   │   └── tun_windows.go            # Windows TUN (netsh/Wintun)
│   ├── linux/CMakeLists.txt
│   ├── windows/CMakeLists.txt
│   └── android/src/main/kotlin/…/
│       └── HyprspaceVpnService.kt    # Android VpnService
└── test/
    ├── unit/                         # Business logic tests
    ├── widget/                       # Widget tests
    └── integration/                  # End-to-end smoke tests
```

## Getting Started

### Prerequisites

- Flutter SDK ≥ 3.16.0
- Go ≥ 1.20 (for native library compilation)
- Linux: `clang`, `cmake`, `libgtk-3-dev`
- Windows: Visual Studio Build Tools + Go toolchain
- Android: Android Studio + NDK

### Developer Setup

```bash
cd hyprspace_flutter

# Get Dart/Flutter dependencies
flutter pub get

# Run unit tests
flutter test test/unit/

# Run widget tests
flutter test test/widget/

# Analyze code
flutter analyze
```

### Building the Native Library

The Go shared library is built automatically by CMake during `flutter build`. For manual builds:

**Linux:**
```bash
cd native/go
CGO_ENABLED=1 GOOS=linux go build -buildmode=c-shared -o libhyprspace.so .
```

**Windows:**
```bash
cd native/go
CGO_ENABLED=1 GOOS=windows go build -buildmode=c-shared -o hyprspace.dll .
```

### Building the App

**Linux:**
```bash
flutter config --enable-linux-desktop
flutter build linux --release
```

**Windows:**
```bash
flutter config --enable-windows-desktop
flutter build windows --release
```

**Android:**
```bash
flutter build apk --release --split-per-abi
```

## Key Technical Decisions

### FFI Bridge (Go ↔ Dart)
The core networking is implemented in Go (`native/go/hyprspace_bridge.go`) and
compiled as a C shared library using `go build -buildmode=c-shared`.  Dart calls
into it via `dart:ffi` through `VpnNativeBridge`.

### State Management
Riverpod 2.x `Notifier` is used for the VPN service state.  Each feature page
`watch`es the relevant providers.

### Data Persistence
- **Configuration**: JSON file in the application support directory.
- **Peer metadata & logs**: Drift (SQLite) database.
- **Private keys**: Platform secure storage (`flutter_secure_storage`).

### Reconnection Strategy
`ConnectionManager` implements exponential back-off (base 2 s, up to 5 attempts)
and re-establishes all peer connections when network connectivity is restored.

## Security Notes

- Private keys are **never written to disk unencrypted**; they live in the
  platform keystore only.
- All libp2p connections use TLS by default.
- Input validation is enforced on all user-supplied values before they reach the
  native layer.

## Backward Compatibility

The Flutter app's Go FFI layer uses the same libp2p protocol ID
(`/hyprspace/1.0.0`) as the original CLI, enabling interoperability with
existing Go-based Hyprspace nodes.

## CI/CD

The GitHub Actions workflow `.github/workflows/flutter_build.yml` runs:
1. **Tests** on every PR touching `hyprspace_flutter/`.
2. **Linux release build** after tests pass.
3. **Windows release build** after tests pass.
4. **Android APK release build** after tests pass.

Build artifacts are uploaded for each platform.
