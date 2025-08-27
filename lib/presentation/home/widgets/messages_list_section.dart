import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:message_box/core/utils/date_format.dart';
import 'package:message_box/domain/entities/message.dart';

class MessagesListSection extends ConsumerWidget {
  final AsyncValue<List<Message>> list;
  final Future<bool> Function(BuildContext context)? onConfirmDelete;
  final Future<void> Function(Message m)? onTogglePin;
  final Future<void> Function(Message m)? onDeleted;

  const MessagesListSection({
    super.key,
    required this.list,
    this.onConfirmDelete,
    this.onTogglePin,
    this.onDeleted,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return list.when(
      loading: () => const Padding(
        padding: EdgeInsets.all(24),
        child: Center(child: CircularProgressIndicator()),
      ),
      error: (e, _) => Text('Error: $e'),
      data: (items) {
        if (items.isEmpty) return const SizedBox.shrink();
        return Column(
          children: [
            for (final m in items)
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: ListTile(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  tileColor: Colors.white,
                  title: Text(
                    m.content,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                  subtitle: Text(
                    formatRelative(m.updatedAt ?? m.createdAt, context),
                  ),
                  onTap: () => context.push('/detail/${m.id}'),
                  trailing: PopupMenuButton<String>(
                    onSelected: (v) async {
                      if (v == 'edit') context.push('/edit/${m.id}');
                      if (v == 'pin' && onTogglePin != null)
                        await onTogglePin!(m);
                      if (v == 'delete' && onConfirmDelete != null) {
                        final ok = await onConfirmDelete!(context);
                        if (ok && onDeleted != null) await onDeleted!(m);
                      }
                    },
                    itemBuilder: (context) => [
                      const PopupMenuItem(value: 'edit', child: Text('Edit')),
                      PopupMenuItem(
                        value: 'pin',
                        child: Text(m.pinned ? 'Unpin' : 'Pin'),
                      ),
                      const PopupMenuItem(
                        value: 'delete',
                        child: Text('Delete'),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}
