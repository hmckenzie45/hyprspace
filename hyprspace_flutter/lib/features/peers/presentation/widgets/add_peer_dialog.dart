import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/config/config_model.dart';
import '../../../../core/config/config_repository.dart';
import '../../../../core/utils/validators.dart';
import '../../../../shared/widgets/error_dialog.dart';

/// Dialog for adding a new peer by ID and VPN IP.
class AddPeerDialog extends ConsumerStatefulWidget {
  const AddPeerDialog({super.key});

  @override
  ConsumerState<AddPeerDialog> createState() => _AddPeerDialogState();
}

class _AddPeerDialogState extends ConsumerState<AddPeerDialog> {
  final _formKey = GlobalKey<FormState>();
  final _idController = TextEditingController();
  final _nameController = TextEditingController();
  final _ipController = TextEditingController();
  bool _isSaving = false;

  @override
  void dispose() {
    _idController.dispose();
    _nameController.dispose();
    _ipController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isSaving = true);
    try {
      final repo = ConfigRepository();
      final existing = await repo.load();
      if (existing == null) {
        throw Exception('No configuration found. Please configure the interface first.');
      }
      final updatedPeers = Map<String, PeerConfig>.from(existing.peers)
        ..[_ipController.text.trim()] = PeerConfig(
          id: _idController.text.trim(),
          name: _nameController.text.trim().isEmpty
              ? null
              : _nameController.text.trim(),
        );
      await repo.save(existing.copyWith(peers: updatedPeers));
      if (mounted) Navigator.of(context).pop(true);
    } catch (e) {
      if (mounted) {
        await ErrorDialog.show(context, message: e.toString());
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add Peer'),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _idController,
                decoration: const InputDecoration(
                  labelText: 'Peer ID',
                  hintText: 'libp2p peer ID (QmXxx…)',
                ),
                validator: Validators.validatePeerId,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Display name (optional)',
                ),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _ipController,
                decoration: const InputDecoration(
                  labelText: 'VPN IP address',
                  hintText: '10.1.1.x',
                ),
                validator: Validators.validateIpAddress,
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: _isSaving ? null : () => Navigator.of(context).pop(false),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: _isSaving ? null : _save,
          child: _isSaving
              ? const SizedBox.square(
                  dimension: 18,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Text('Add'),
        ),
      ],
    );
  }
}
