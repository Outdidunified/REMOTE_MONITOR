import 'package:flutter/material.dart';
import 'package:remote_monotoring/utils/theme/app_theme.dart';

/// A reusable widget for displaying success or error messages
class MessageDisplay extends StatelessWidget {
  final String? message;
  final bool isSuccess;
  final VoidCallback? onDismiss;

  const MessageDisplay({
    super.key,
    required this.message,
    this.isSuccess = false,
    this.onDismiss,
  });

  @override
  Widget build(BuildContext context) {
    if (message == null || message!.isEmpty) {
      return const SizedBox.shrink();
    }

    final color = isSuccess ? AppTheme.success : AppTheme.error;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              message!,
              style: AppTheme.bodySmall(context).copyWith(color: color),
            ),
          ),
          if (onDismiss != null)
            IconButton(
              icon: Icon(Icons.close, color: color, size: 16),
              onPressed: onDismiss,
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(minWidth: 24, minHeight: 24),
            ),
        ],
      ),
    );
  }
}
