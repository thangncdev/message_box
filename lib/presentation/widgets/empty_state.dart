import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:message_box/core/theme.dart';

class EmptyState extends StatelessWidget {
  final String text;
  final String? actionLabel;
  final String? route;
  const EmptyState({
    super.key,
    required this.text,
    this.actionLabel,
    this.route,
  });

  @override
  Widget build(BuildContext context) {
    final palette = Theme.of(context).extension<PastelPalette>()!;
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 40),
      alignment: Alignment.center,
      child: Column(
        children: [
          Icon(Icons.chat_bubble_outline, size: 56, color: palette.accent),
          const SizedBox(height: 12),
          Text(
            text,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.black54),
          ),
          if (actionLabel != null && route != null) ...[
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () => context.push(route!),
              child: Text(actionLabel!),
            ),
          ],
        ],
      ),
    );
  }
}
