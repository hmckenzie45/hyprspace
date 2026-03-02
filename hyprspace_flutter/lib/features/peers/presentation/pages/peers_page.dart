import 'package:flutter/material.dart';

import '../../../../core/config/config_model.dart';
import '../../../../core/config/config_repository.dart';
import '../../../../shared/widgets/error_dialog.dart';
import '../widgets/add_peer_dialog.dart';

/// Peers management screen.
class PeersPage extends StatefulWidget {
  const PeersPage({super.key});

  @override
  State<PeersPage> createState() => _PeersPageState();
}

class _PeersPageState extends State<PeersPage> {
  HyprspaceConfig? _config;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    final cfg = await ConfigRepository().load();
    if (mounted) {
      setState(() {
        _config = cfg;
        _loading = false;
      });
    }
  }

  Future<void> _addPeer() async {
    final added = await showDialog<bool>(
      context: context,
      builder: (_) => const AddPeerDialog(),
    );
    if (added == true) await _load();
  }

  Future<void> _removePeer(String ip) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Remove Peer'),
        content: Text('Remove peer at $ip?'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancel')),
          FilledButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Remove')),
        ],
      ),
    );
    if (confirm != true || _config == null) return;
    try {
      final updated = Map<String, PeerConfig>.from(_config!.peers)..remove(ip);
      await ConfigRepository().save(_config!.copyWith(peers: updated));
      await _load();
    } catch (e) {
      if (mounted) await ErrorDialog.show(context, message: e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Peers')),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _config == null || _config!.peers.isEmpty
              ? Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.group_off, size: 64),
                      const SizedBox(height: 16),
                      const Text('No peers configured'),
                      const SizedBox(height: 8),
                      FilledButton.icon(
                        onPressed: _addPeer,
                        icon: const Icon(Icons.add),
                        label: const Text('Add Peer'),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: _config!.peers.length,
                  itemBuilder: (ctx, i) {
                    final entry = _config!.peers.entries.elementAt(i);
                    final peer = entry.value;
                    return Card(
                      child: ListTile(
                        leading: const CircleAvatar(
                          child: Icon(Icons.person),
                        ),
                        title: Text(peer.name ?? peer.id,
                            overflow: TextOverflow.ellipsis),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(entry.key),
                            if (peer.lastSeen != null)
                              Text(
                                'Last seen: ${peer.lastSeen!.toLocal()}',
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                          ],
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete_outline),
                          onPressed: () => _removePeer(entry.key),
                          tooltip: 'Remove',
                        ),
                        isThreeLine: peer.lastSeen != null,
                      ),
                    );
                  },
                ),
      floatingActionButton: _config != null
          ? FloatingActionButton(
              onPressed: _addPeer,
              tooltip: 'Add peer',
              child: const Icon(Icons.add),
            )
          : null,
    );
  }
}
