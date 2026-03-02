import 'package:flutter/material.dart';

import '../../../../core/config/config_model.dart';
import '../../../../core/config/config_repository.dart';
import '../../../../core/config/crypto_manager.dart';
import '../../../../core/storage/secure_storage.dart';
import '../../../../core/utils/validators.dart';
import '../../../../shared/widgets/error_dialog.dart';

/// Settings page for interface configuration, network preferences and
/// security operations.
class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController(text: 'hs0');
  final _addressCtrl = TextEditingController(text: '10.1.1.1/24');
  final _portCtrl = TextEditingController(text: '8001');
  final _mtuCtrl = TextEditingController(text: '1420');
  bool _autoReconnect = true;
  bool _isSaving = false;
  bool _isGeneratingKey = false;
  String? _publicKeyDisplay;

  final _repo = ConfigRepository();
  final _secureStorage = SecureStorage();
  final _crypto = CryptoManager();

  @override
  void initState() {
    super.initState();
    _loadExistingConfig();
  }

  Future<void> _loadExistingConfig() async {
    final cfg = await _repo.load();
    if (cfg == null || !mounted) return;
    setState(() {
      _nameCtrl.text = cfg.interface.name;
      _addressCtrl.text = cfg.interface.address;
      _portCtrl.text = cfg.interface.listenPort.toString();
      _mtuCtrl.text = cfg.mtu.toString();
      _autoReconnect = cfg.autoReconnect;
    });
  }

  Future<void> _generateKeys() async {
    setState(() => _isGeneratingKey = true);
    try {
      final keys = await _crypto.generateKeyPair();
      await _secureStorage.writePrivateKey(keys['privateKey']!);
      setState(() => _publicKeyDisplay = keys['publicKey']);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('New key pair generated')),
      );
    } catch (e) {
      if (mounted) await ErrorDialog.show(context, message: e.toString());
    } finally {
      if (mounted) setState(() => _isGeneratingKey = false);
    }
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isSaving = true);
    try {
      final privateKey = await _secureStorage.readPrivateKey() ?? '';
      if (privateKey.isEmpty) {
        throw Exception('No private key found. Please generate a key pair first.');
      }
      final existing = await _repo.load();
      final iface = InterfaceConfig(
        name: _nameCtrl.text.trim(),
        id: existing?.interface.id ?? privateKey.substring(0, 20),
        listenPort: int.parse(_portCtrl.text.trim()),
        address: _addressCtrl.text.trim(),
        privateKey: privateKey,
      );
      final cfg = existing?.copyWith(
            interface: iface,
            autoReconnect: _autoReconnect,
            mtu: int.parse(_mtuCtrl.text.trim()),
          ) ??
          HyprspaceConfig(
            id: iface.id,
            interface: iface,
            autoReconnect: _autoReconnect,
            mtu: int.parse(_mtuCtrl.text.trim()),
          );
      await _repo.save(cfg);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Settings saved')),
        );
      }
    } catch (e) {
      if (mounted) await ErrorDialog.show(context, message: e.toString());
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _addressCtrl.dispose();
    _portCtrl.dispose();
    _mtuCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _SectionHeader('Interface'),
            TextFormField(
              controller: _nameCtrl,
              decoration:
                  const InputDecoration(labelText: 'Interface name'),
              validator: Validators.validateInterfaceName,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _addressCtrl,
              decoration:
                  const InputDecoration(labelText: 'IP address (CIDR)'),
              validator: Validators.validateCidr,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _portCtrl,
              decoration:
                  const InputDecoration(labelText: 'Listen port'),
              keyboardType: TextInputType.number,
              validator: (v) =>
                  Validators.validatePort(int.tryParse(v ?? '')),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _mtuCtrl,
              decoration: const InputDecoration(labelText: 'MTU'),
              keyboardType: TextInputType.number,
              validator: (v) {
                final n = int.tryParse(v ?? '');
                if (n == null || n < 576 || n > 9000) {
                  return 'MTU must be between 576 and 9000';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            SwitchListTile(
              title: const Text('Auto reconnect'),
              subtitle: const Text(
                  'Automatically reconnect when the network is restored'),
              value: _autoReconnect,
              onChanged: (v) => setState(() => _autoReconnect = v),
            ),
            const Divider(height: 32),
            _SectionHeader('Security'),
            if (_publicKeyDisplay != null) ...[
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Public key',
                        style: Theme.of(context).textTheme.labelSmall,
                      ),
                      const SizedBox(height: 4),
                      SelectableText(
                        _publicKeyDisplay!,
                        style:
                            const TextStyle(fontFamily: 'monospace', fontSize: 11),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 8),
            ],
            OutlinedButton.icon(
              onPressed: _isGeneratingKey ? null : _generateKeys,
              icon: _isGeneratingKey
                  ? const SizedBox.square(
                      dimension: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.vpn_key),
              label: Text(
                  _isGeneratingKey ? 'Generating…' : 'Generate new key pair'),
            ),
            const SizedBox(height: 32),
            FilledButton(
              onPressed: _isSaving ? null : _save,
              child: _isSaving
                  ? const SizedBox.square(
                      dimension: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('Save Settings'),
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader(this.title);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(title, style: Theme.of(context).textTheme.titleMedium),
    );
  }
}
