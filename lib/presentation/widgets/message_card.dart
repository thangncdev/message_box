import 'package:flutter/material.dart';
import 'package:message_box/domain/entities/message.dart';

class MessageCard extends StatelessWidget {
  final Message message;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  const MessageCard({
    super.key,
    required this.message,
    this.onTap,
    this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      onLongPress: onLongPress,
      borderRadius: BorderRadius.circular(20),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  message.content,
                  maxLines: 4,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 16),
                ),
              ),
              const SizedBox(width: 8),
              if (message.pinned) const Icon(Icons.push_pin, size: 18),
            ],
          ),
        ),
      ),
    );
  }
}
