// Create a new file: lib/widgets/common/status_message.dart

import 'package:flutter/material.dart';

class StatusMessage extends StatelessWidget {
  final String message;
  final bool isSuccess;
  final VoidCallback? onClose;

  const StatusMessage({
    Key? key,
    required this.message,
    required this.isSuccess,
    this.onClose,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final color = isSuccess ? Colors.green : Colors.red;
    final icon = isSuccess ? Icons.check_circle : Icons.error;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.shade100,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: color.shade800,
            size: 20,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              message,
              style: TextStyle(color: color.shade800),
            ),
          ),
          if (onClose != null)
            GestureDetector(
              onTap: onClose,
              child: Icon(
                Icons.close,
                color: color.shade800,
                size: 18,
              ),
            ),
        ],
      ),
    );
  }
}