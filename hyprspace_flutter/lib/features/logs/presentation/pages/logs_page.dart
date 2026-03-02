import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../core/storage/database.dart';
import '../../../../main.dart';

/// Real-time log viewer with level filtering and search.
class LogsPage extends StatefulWidget {
  const LogsPage({super.key});

  @override
  State<LogsPage> createState() => _LogsPageState();
}

class _LogsPageState extends State<LogsPage> {
  List<LogEntry> _logs = [];
  String _levelFilter = 'ALL';
  String _searchQuery = '';
  final _searchCtrl = TextEditingController();

  static const _levels = ['ALL', 'debug', 'info', 'warning', 'error'];

  @override
  void initState() {
    super.initState();
    _loadLogs();
  }

  Future<void> _loadLogs() async {
    final db = getIt<AppDatabase>();
    final entries = await db.getRecentLogs(limit: 500);
    if (mounted) setState(() => _logs = entries);
  }

  Future<void> _clearLogs() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Clear Logs'),
        content: const Text('Delete all log entries?'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancel')),
          FilledButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Clear')),
        ],
      ),
    );
    if (confirm != true) return;
    final db = getIt<AppDatabase>();
    await db.clearLogs();
    await _loadLogs();
  }

  List<LogEntry> get _filteredLogs {
    return _logs.where((e) {
      final matchesLevel =
          _levelFilter == 'ALL' || e.level == _levelFilter;
      final matchesSearch = _searchQuery.isEmpty ||
          e.message.toLowerCase().contains(_searchQuery.toLowerCase());
      return matchesLevel && matchesSearch;
    }).toList();
  }

  Color _levelColor(String level, ColorScheme cs) => switch (level) {
        'debug' => cs.outline,
        'info' => cs.primary,
        'warning' => Colors.orange,
        'error' => cs.error,
        _ => cs.onSurface,
      };

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final filtered = _filteredLogs;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Logs'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadLogs,
            tooltip: 'Refresh',
          ),
          IconButton(
            icon: const Icon(Icons.delete_sweep_outlined),
            onPressed: _clearLogs,
            tooltip: 'Clear',
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(100),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(12, 0, 12, 8),
            child: Column(
              children: [
                TextField(
                  controller: _searchCtrl,
                  decoration: InputDecoration(
                    hintText: 'Search…',
                    prefixIcon: const Icon(Icons.search, size: 20),
                    suffixIcon: _searchQuery.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear, size: 18),
                            onPressed: () {
                              _searchCtrl.clear();
                              setState(() => _searchQuery = '');
                            },
                          )
                        : null,
                    isDense: true,
                  ),
                  onChanged: (v) => setState(() => _searchQuery = v),
                ),
                const SizedBox(height: 8),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: _levels.map((l) {
                      final selected = l == _levelFilter;
                      return Padding(
                        padding: const EdgeInsets.only(right: 6),
                        child: FilterChip(
                          label: Text(l),
                          selected: selected,
                          onSelected: (_) =>
                              setState(() => _levelFilter = l),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: filtered.isEmpty
          ? const Center(child: Text('No log entries'))
          : ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: filtered.length,
              itemBuilder: (ctx, i) {
                final entry = filtered[i];
                final color = _levelColor(entry.level, cs);
                return InkWell(
                  onLongPress: () {
                    Clipboard.setData(ClipboardData(
                        text:
                            '[${entry.timestamp.toLocal()}] [${entry.level}] ${entry.message}'));
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Copied to clipboard')),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 60,
                          child: Text(
                            _formatTime(entry.timestamp),
                            style: TextStyle(
                                fontFamily: 'monospace',
                                fontSize: 10,
                                color: cs.outline),
                          ),
                        ),
                        const SizedBox(width: 4),
                        SizedBox(
                          width: 52,
                          child: Text(
                            entry.level.toUpperCase(),
                            style: TextStyle(
                                fontFamily: 'monospace',
                                fontSize: 10,
                                color: color,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            entry.message,
                            style: const TextStyle(
                                fontFamily: 'monospace', fontSize: 11),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }

  String _formatTime(DateTime dt) {
    final local = dt.toLocal();
    return '${local.hour.toString().padLeft(2, '0')}:'
        '${local.minute.toString().padLeft(2, '0')}:'
        '${local.second.toString().padLeft(2, '0')}';
  }
}
