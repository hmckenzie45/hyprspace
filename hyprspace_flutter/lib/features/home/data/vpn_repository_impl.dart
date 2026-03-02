import '../../../core/config/config_model.dart';
import '../../../core/config/config_repository.dart';
import '../domain/vpn_repository.dart';

/// Concrete implementation of [VpnRepository] backed by [ConfigRepository].
class VpnRepositoryImpl implements VpnRepository {
  final ConfigRepository _configRepo;

  VpnRepositoryImpl({ConfigRepository? configRepo})
      : _configRepo = configRepo ?? ConfigRepository();

  @override
  Future<HyprspaceConfig?> getConfig() => _configRepo.load();

  @override
  Future<void> saveConfig(HyprspaceConfig config) => _configRepo.save(config);

  @override
  Future<NetworkStats> getStats() async => const NetworkStats();
}
