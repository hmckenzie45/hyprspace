import 'package:flutter/material.dart';

import '../../../../core/config/config_model.dart';

/// A single row in the active-peers list on the home screen.
class PeerListItem extends StatelessWidget {
  final String vpnIp;
  final PeerConfig peer;

  const PeerListItem({super.key, required this.vpnIp, required this.peer});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final (statusColor, statusLabel) = _statusMeta(peer.status);

    return ListTile(
      leading: CircleAvatar(
        backgroundColor: statusColor.withOpacity(0.15),
        child: Icon(Icons.person, color: statusColor),
      ),
      title: Text(peer.name ?? peer.id,
          overflow: TextOverflow.ellipsis),
      subtitle: Text(
        vpnIp,
        style: theme.textTheme.bodySmall
            ?.copyWith(color: theme.colorScheme.outline),
      ),
      trailing: Chip(
        label: Text(statusLabel,
            style:
                theme.textTheme.labelSmall?.copyWith(color: statusColor)),
        side: BorderSide(color: statusColor),
        backgroundColor: statusColor.withOpacity(0.1),
        padding: EdgeInsets.zero,
      ),
    );
  }

  (Color, String) _statusMeta(ConnectionStatus s) => switch (s) {
        ConnectionStatus.connected => (Colors.green, 'Connected'),
        ConnectionStatus.connecting => (Colors.orange, 'Connecting'),
        ConnectionStatus.error => (Colors.red, 'Error'),
        ConnectionStatus.disconnected => (Colors.grey, 'Offline'),
      };
}
