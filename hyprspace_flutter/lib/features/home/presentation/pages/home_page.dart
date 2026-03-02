import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/config/config_model.dart';
import '../../../../core/config/config_repository.dart';
import '../../../../core/network/vpn_service.dart';
import '../../../../shared/widgets/error_dialog.dart';
import '../../../../shared/widgets/loading_overlay.dart';
import '../widgets/peer_list_item.dart';
import '../widgets/vpn_status_card.dart';

/// Main home screen showing VPN status and active peers.
class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  HyprspaceConfig? _config;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadConfig();
  }

  Future<void> _loadConfig() async {
    final repo = ConfigRepository();
    final cfg = await repo.load();
    if (mounted) setState(() => _config = cfg);
  }

  Future<void> _toggleVpn() async {
    if (_config == null) {
      await ErrorDialog.show(
        context,
        title: 'No Configuration',
        message: 'Please configure the interface in Settings first.',
      );
      return;
    }

    final vpn = ref.read(vpnServiceProvider.notifier);
    final status = ref.read(vpnServiceProvider).status;

    setState(() => _isLoading = true);
    try {
      if (status == ConnectionStatus.connected) {
        await vpn.disconnect();
      } else {
        await vpn.connect(_config!);
      }
    } catch (e) {
      if (mounted) {
        await ErrorDialog.show(context, message: e.toString());
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final vpnState = ref.watch(vpnServiceProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Hyprspace'),
        actions: [
          IconButton(
            icon: const Icon(Icons.group),
            tooltip: 'Peers',
            onPressed: () => context.push('/peers'),
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            tooltip: 'Settings',
            onPressed: () => context.push('/settings'),
          ),
          IconButton(
            icon: const Icon(Icons.article_outlined),
            tooltip: 'Logs',
            onPressed: () => context.push('/logs'),
          ),
        ],
      ),
      body: Stack(
        children: [
          RefreshIndicator(
            onRefresh: _loadConfig,
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                VpnStatusCard(
                  status: vpnState.status,
                  stats: vpnState.stats,
                  onToggle: _toggleVpn,
                ),
                if (vpnState.errorMessage != null) ...[
                  const SizedBox(height: 8),
                  Card(
                    color: Theme.of(context).colorScheme.errorContainer,
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Text(
                        vpnState.errorMessage!,
                        style: TextStyle(
                          color:
                              Theme.of(context).colorScheme.onErrorContainer,
                        ),
                      ),
                    ),
                  ),
                ],
                const SizedBox(height: 16),
                if (_config != null && _config!.peers.isNotEmpty) ...[
                  Text(
                    'Peers',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  ..._config!.peers.entries.map(
                    (e) => PeerListItem(vpnIp: e.key, peer: e.value),
                  ),
                ] else ...[
                  const Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 32),
                      child: Text('No peers configured'),
                    ),
                  ),
                ],
              ],
            ),
          ),
          if (_isLoading) const LoadingOverlay(message: 'Please wait…'),
        ],
      ),
    );
  }
}
