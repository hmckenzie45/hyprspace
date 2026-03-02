import 'package:flutter/material.dart';

/// A standardised error dialog.
class ErrorDialog extends StatelessWidget {
  final String title;
  final String message;
  final VoidCallback? onRetry;

  const ErrorDialog({
    super.key,
    this.title = 'Error',
    required this.message,
    this.onRetry,
  });

  /// Shows the error dialog above [context].
  static Future<void> show(
    BuildContext context, {
    String title = 'Error',
    required String message,
    VoidCallback? onRetry,
  }) {
    return showDialog<void>(
      context: context,
      builder: (_) => ErrorDialog(
        title: title,
        message: message,
        onRetry: onRetry,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      icon: const Icon(Icons.error_outline, size: 40),
      iconColor: Theme.of(context).colorScheme.error,
      title: Text(title),
      content: Text(message),
      actions: [
        if (onRetry != null)
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              onRetry!();
            },
            child: const Text('Retry'),
          ),
        FilledButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('OK'),
        ),
      ],
    );
  }
}
