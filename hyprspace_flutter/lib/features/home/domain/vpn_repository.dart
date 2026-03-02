import '../../core/config/config_model.dart';

/// Abstract repository interface for VPN operations.
abstract class VpnRepository {
  /// Returns the current [HyprspaceConfig], or null if not configured.
  Future<HyprspaceConfig?> getConfig();

  /// Persists [config].
  Future<void> saveConfig(HyprspaceConfig config);

  /// Returns the latest [NetworkStats] snapshot.
  Future<NetworkStats> getStats();
}
