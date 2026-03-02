import 'package:flutter/material.dart';

import '../../../../core/config/config_model.dart';

/// Animated status card displayed at the top of the home screen.
class VpnStatusCard extends StatelessWidget {
  final ConnectionStatus status;
  final NetworkStats stats;
  final VoidCallback onToggle;

  const VpnStatusCard({
    super.key,
    required this.status,
    required this.stats,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final (label, color, icon) = _statusMeta(status, theme);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            // Animated power button
            GestureDetector(
              onTap: onToggle,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: color.withOpacity(0.15),
                  border: Border.all(color: color, width: 3),
                ),
                child: Icon(icon, size: 56, color: color),
              ),
            ),
            const SizedBox(height: 16),
            Text(label, style: theme.textTheme.headlineSmall),
            if (status == ConnectionStatus.connected) ...[
              const SizedBox(height: 12),
              _StatsRow(stats: stats),
            ],
          ],
        ),
      ),
    );
  }

  (String, Color, IconData) _statusMeta(
    ConnectionStatus s,
    ThemeData theme,
  ) {
    return switch (s) {
      ConnectionStatus.connected => (
          'Connected',
          Colors.green,
          Icons.vpn_lock,
        ),
      ConnectionStatus.connecting => (
          'Connecting…',
          Colors.orange,
          Icons.sync,
        ),
      ConnectionStatus.error => (
          'Error',
          theme.colorScheme.error,
          Icons.error_outline,
        ),
      ConnectionStatus.disconnected => (
          'Disconnected',
          theme.colorScheme.outline,
          Icons.power_settings_new,
        ),
    };
  }
}

class _StatsRow extends StatelessWidget {
  final NetworkStats stats;
  const _StatsRow({required this.stats});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _Stat(
          icon: Icons.arrow_upward,
          label: _formatBytes(stats.bytesSent),
          tooltip: 'Bytes sent',
        ),
        _Stat(
          icon: Icons.arrow_downward,
          label: _formatBytes(stats.bytesReceived),
          tooltip: 'Bytes received',
        ),
        _Stat(
          icon: Icons.timer_outlined,
          label: '${stats.latencyMs.toStringAsFixed(1)} ms',
          tooltip: 'Latency',
        ),
      ],
    );
  }

  String _formatBytes(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    return '${(bytes / (1024 * 1024)).toStringAsFixed(2)} MB';
  }
}

class _Stat extends StatelessWidget {
  final IconData icon;
  final String label;
  final String tooltip;
  const _Stat({required this.icon, required this.label, required this.tooltip});

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: Column(
        children: [
          Icon(icon, size: 18),
          const SizedBox(height: 4),
          Text(label, style: Theme.of(context).textTheme.bodySmall),
        ],
      ),
    );
  }
}
